import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/transport/firebase_game_transport.dart';

// ---------------------------------------------------------------------------
// Log entry
// ---------------------------------------------------------------------------

class DebugLogEntry {
  final DateTime timestamp;
  final String direction; // → sent, ← received, ⚠ error
  final String message;

  const DebugLogEntry({
    required this.timestamp,
    required this.direction,
    required this.message,
  });

  String get formatted =>
      '${timestamp.hour.toString().padLeft(2, '0')}:'
      '${timestamp.minute.toString().padLeft(2, '0')}:'
      '${timestamp.second.toString().padLeft(2, '0')} '
      '$direction $message';
}

// ---------------------------------------------------------------------------
// Connection status
// ---------------------------------------------------------------------------

enum ConnectionStatus { disconnected, connecting, connected, error }

// ---------------------------------------------------------------------------
// Harness state
// ---------------------------------------------------------------------------

class TestHarnessState {
  final String matchId;
  final String playerId;
  final List<String> playerNames;
  final ConnectionStatus connectionStatus;
  final GameState? gameState;
  final List<DebugLogEntry> logs;
  final String? lastError;

  const TestHarnessState({
    this.matchId = '',
    this.playerId = 'p_0',
    this.playerNames = const ['Debug_A', 'Debug_B'],
    this.connectionStatus = ConnectionStatus.disconnected,
    this.gameState,
    this.logs = const [],
    this.lastError,
  });

  TestHarnessState copyWith({
    String? matchId,
    String? playerId,
    List<String>? playerNames,
    ConnectionStatus? connectionStatus,
    GameState? Function()? gameState,
    List<DebugLogEntry>? logs,
    String? Function()? lastError,
  }) {
    return TestHarnessState(
      matchId: matchId ?? this.matchId,
      playerId: playerId ?? this.playerId,
      playerNames: playerNames ?? this.playerNames,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      gameState: gameState != null ? gameState() : this.gameState,
      logs: logs ?? this.logs,
      lastError: lastError != null ? lastError() : this.lastError,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class TestHarnessNotifier extends Notifier<TestHarnessState> {
  FirebaseGameTransport? _transport;
  StreamSubscription<GameState>? _stateSubscription;

  @override
  TestHarnessState build() {
    // Generate a default match ID
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final defaultMatchId = 'test_$timestamp';

    ref.onDispose(() {
      _stateSubscription?.cancel();
      _transport?.dispose();
    });

    return TestHarnessState(matchId: defaultMatchId);
  }

  // --- Configuration ---

  void setMatchId(String id) {
    state = state.copyWith(matchId: id);
  }

  void setPlayerId(String id) {
    state = state.copyWith(playerId: id);
  }

  void setPlayerNames(List<String> names) {
    state = state.copyWith(playerNames: names);
  }

  // --- Logging ---

  void _addLog(String direction, String message) {
    final entry = DebugLogEntry(
      timestamp: DateTime.now(),
      direction: direction,
      message: message,
    );
    state = state.copyWith(logs: [...state.logs, entry]);
  }

  void clearLogs() {
    state = state.copyWith(logs: []);
  }

  // --- Transport lifecycle ---

  FirebaseGameTransport _createTransport() {
    _stateSubscription?.cancel();
    _transport?.dispose();

    final functionsService = ref.read(functionsServiceProvider);
    final transport = FirebaseGameTransport(
      functionsService: functionsService,
      matchId: state.matchId,
      localPlayerId: state.playerId,
      onLog: _addLog,
    );

    _transport = transport;

    // Listen to game state updates
    _stateSubscription = transport.gameStateStream.listen(
      (newState) {
        state = state.copyWith(
          gameState: () => newState,
          connectionStatus: ConnectionStatus.connected,
        );
      },
      onError: (Object e) {
        _addLog('⚠', 'Stream error: $e');
        state = state.copyWith(
          connectionStatus: ConnectionStatus.error,
          lastError: () => e.toString(),
        );
      },
    );

    return transport;
  }

  // --- Match lifecycle ---

  Future<void> createMatch() async {
    if (state.matchId.isEmpty) {
      _addLog('⚠', 'Match ID is empty');
      return;
    }

    state = state.copyWith(connectionStatus: ConnectionStatus.connecting);
    final transport = _createTransport();

    final result = await transport.createMatch(state.playerNames);
    if (result['success'] == true) {
      _addLog('✓', 'Match created successfully');
    } else {
      state = state.copyWith(
        connectionStatus: ConnectionStatus.error,
        lastError: () => result['error']?.toString(),
      );
    }
  }

  Future<void> startMatch() async {
    if (_transport == null) {
      _addLog('⚠', 'No transport — create a match first');
      return;
    }

    await _transport!.startGame(state.playerNames);
    _addLog('✓', 'Start match requested');
  }

  void connectToMatch() {
    if (state.matchId.isEmpty) {
      _addLog('⚠', 'Match ID is empty');
      return;
    }

    state = state.copyWith(connectionStatus: ConnectionStatus.connecting);

    if (_transport == null ||
        _transport!.matchId != state.matchId ||
        _transport!.localPlayerId != state.playerId) {
      _createTransport();
    }

    _transport!.connect();
    _addLog('✓', 'Connected to Firestore listener');
  }

  void disconnect() {
    _transport?.disconnect();
    state = state.copyWith(connectionStatus: ConnectionStatus.disconnected);
    _addLog('✓', 'Disconnected');
  }

  // --- Reconnect test ---

  Future<void> testReconnect() async {
    _addLog('🔄', 'Testing reconnect...');
    disconnect();
    await Future.delayed(const Duration(seconds: 2));
    connectToMatch();
    _addLog('🔄', 'Reconnect complete — state should reload from Firestore');
  }

  // --- Game actions ---

  Future<void> throwFirstCards() async {
    final gs = state.gameState;
    if (gs == null) {
      _addLog('⚠', 'No game state available');
      return;
    }

    final playerIndex = gs.players.indexWhere((p) => p.playerId == state.playerId);
    if (playerIndex == -1) {
      _addLog('⚠', 'Player ${state.playerId} not found in game state');
      return;
    }

    final player = gs.players[playerIndex];
    if (player.handCards.isEmpty) {
      _addLog('⚠', 'Player has no cards');
      return;
    }

    // Pick first card, claim its actual rank (truth) for simple testing
    final card = player.handCards.first;
    final claimedRank = gs.currentClaimedRank ?? card.rank;

    await _transport?.throwCards(state.playerId, [card], claimedRank);
  }

  Future<void> throwBluff() async {
    final gs = state.gameState;
    if (gs == null) return;

    final playerIndex = gs.players.indexWhere((p) => p.playerId == state.playerId);
    if (playerIndex == -1) return;

    final player = gs.players[playerIndex];
    if (player.handCards.isEmpty) return;

    // Pick first card but claim a DIFFERENT rank (bluff)
    final card = player.handCards.first;
    final actualRank = card.rank;
    // Pick a rank that's different from the actual card rank
    final bluffRank = Rank.values.firstWhere(
      (r) => r != actualRank,
      orElse: () => Rank.ace,
    );
    final claimedRank = gs.currentClaimedRank ?? bluffRank;

    await _transport?.throwCards(state.playerId, [card], claimedRank);
  }

  Future<void> passTurn() async {
    await _transport?.passTurn(state.playerId);
  }

  Future<void> challenge() async {
    await _transport?.challenge(state.playerId);
  }

  Future<void> leaveMatch() async {
    await _transport?.exitGame(state.playerId);
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final testHarnessProvider =
    NotifierProvider<TestHarnessNotifier, TestHarnessState>(
  () => TestHarnessNotifier(),
);
