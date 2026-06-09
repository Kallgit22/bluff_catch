// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/firestore_service.dart';
import '../../../../core/services/functions_service.dart';
import '../entities/card.dart';
import '../entities/game_state.dart';
import 'game_transport.dart';

/// Firebase-backed [GameTransport] implementation.
///
/// **Actions** are sent to Cloud Functions via [FunctionsService].
/// **State** is streamed in real-time from Firestore via [FirestoreService].
///
/// Requires a [matchId] (which Firestore document to operate on) and a
/// [localPlayerId] (which seat this client occupies).
class FirebaseGameTransport implements GameTransport {
  final FunctionsService _functionsService;
  final String matchId;
  final String localPlayerId;

  /// Optional callback invoked whenever a log-worthy event occurs.
  /// Used by the test harness for debug logging.
  final void Function(String direction, String message)? onLog;

  final _stateController = StreamController<GameState>.broadcast();
  StreamSubscription? _firestoreSubscription;
  GameState _currentState = const GameState();

  FirebaseGameTransport({
    required FunctionsService functionsService,
    required this.matchId,
    required this.localPlayerId,
    this.onLog,
  })  : _functionsService = functionsService;

  @override
  Stream<GameState> get gameStateStream => _stateController.stream;

  @override
  GameState get currentState => _currentState;

  // ---------------------------------------------------------------------------
  // Connection lifecycle
  // ---------------------------------------------------------------------------

  /// Subscribes to the Firestore match document for real-time state updates.
  void connect() {
    _firestoreSubscription?.cancel();
    _log('→', 'Subscribing to matches/$matchId');

    _firestoreSubscription = FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .snapshots()
        .listen(
      (snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          _log('←', 'Document does not exist yet');
          return;
        }

        final data = snapshot.data()!;
        final gameStateMap = data['gameState'];
        if (gameStateMap == null) {
          _log('←', 'Document exists but gameState is null (status: ${data['status']})');
          return;
        }

        try {
          final newState = GameState.fromJson(
            Map<String, dynamic>.from(gameStateMap as Map),
          );
          _currentState = newState;
          _stateController.add(newState);
          _log('←', 'State update: status=${newState.status.name}, '
              'active=p_${newState.activePlayerIndex}, '
              'pool=${newState.pool.length}, '
              'event=${newState.lastEvent.name}');
        } catch (e) {
          _log('⚠', 'Failed to parse gameState: $e');
        }
      },
      onError: (Object e) {
        _log('⚠', 'Stream error: $e');
      },
    );
  }

  /// Disconnects the Firestore listener. Call [connect] to re-subscribe.
  void disconnect() {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = null;
    _log('→', 'Disconnected from matches/$matchId');
  }

  // ---------------------------------------------------------------------------
  // Match lifecycle (Cloud Function calls)
  // ---------------------------------------------------------------------------

  /// Creates a new match document in Firestore via Cloud Function.
  Future<Map<String, dynamic>> createMatch(List<String> playerNames) async {
    _log('→', 'createMatch(matchId=$matchId, players=$playerNames)');
    final result = await _functionsService.callFunction(
      'createMatch',
      parameters: {
        'matchId': matchId,
        'playerNames': playerNames,
      },
    );
    return result.fold(
      (failure) {
        _log('⚠', 'createMatch failed: ${failure.message}');
        return {'success': false, 'error': failure.message};
      },
      (data) {
        final response = Map<String, dynamic>.from(data as Map);
        _log('←', 'createMatch response: $response');
        return response;
      },
    );
  }

  @override
  Future<void> startGame(List<String> playerNames) async {
    _log('→', 'startMatch(matchId=$matchId)');
    final result = await _functionsService.callFunction(
      'startMatch',
      parameters: {'matchId': matchId},
    );
    result.fold(
      (failure) => _log('⚠', 'startMatch failed: ${failure.message}'),
      (data) => _log('←', 'startMatch response: $data'),
    );
  }

  // ---------------------------------------------------------------------------
  // Game actions (Cloud Function calls)
  // ---------------------------------------------------------------------------

  @override
  Future<void> throwCards(
    String playerId,
    List<PlayingCard> cards,
    Rank claimedRank,
  ) async {
    _log('→', 'throwCards(player=$playerId, '
        'cards=${cards.length}, rank=${claimedRank.name})');
    final result = await _functionsService.callFunction(
      'throwCards',
      parameters: {
        'matchId': matchId,
        'playerId': playerId,
        'cards': cards.map((c) => c.toJson()).toList(),
        'claimedRank': claimedRank.name,
      },
    );
    result.fold(
      (failure) => _log('⚠', 'throwCards failed: ${failure.message}'),
      (data) => _log('←', 'throwCards response: $data'),
    );
  }

  @override
  Future<void> addCards(
    String playerId,
    List<PlayingCard> cards,
    Rank claimedRank,
  ) async {
    // addCards uses the same Cloud Function as throwCards
    await throwCards(playerId, cards, claimedRank);
  }

  @override
  Future<void> passTurn(String playerId) async {
    _log('→', 'passTurn(player=$playerId)');
    final result = await _functionsService.callFunction(
      'passTurn',
      parameters: {
        'matchId': matchId,
        'playerId': playerId,
      },
    );
    result.fold(
      (failure) => _log('⚠', 'passTurn failed: ${failure.message}'),
      (data) => _log('←', 'passTurn response: $data'),
    );
  }

  @override
  Future<void> challenge(String challengerId) async {
    _log('→', 'challenge(challenger=$challengerId)');
    final result = await _functionsService.callFunction(
      'challenge',
      parameters: {
        'matchId': matchId,
        'playerId': challengerId,
      },
    );
    result.fold(
      (failure) => _log('⚠', 'challenge failed: ${failure.message}'),
      (data) => _log('←', 'challenge response: $data'),
    );
  }

  @override
  Future<void> exitGame(String playerId) async {
    _log('→', 'leaveMatch(player=$playerId)');
    final result = await _functionsService.callFunction(
      'leaveMatch',
      parameters: {
        'matchId': matchId,
        'playerId': playerId,
      },
    );
    result.fold(
      (failure) => _log('⚠', 'leaveMatch failed: ${failure.message}'),
      (data) => _log('←', 'leaveMatch response: $data'),
    );
  }

  @override
  Future<void> replayGame() async {
    // For test harness: not implemented (create a new match instead)
    _log('⚠', 'replayGame not available in Firebase transport — create a new match');
  }

  @override
  Future<void> resetGame() async {
    _log('→', 'resetGame — disconnecting');
    disconnect();
    _currentState = const GameState();
    _stateController.add(_currentState);
  }

  @override
  void dispose() {
    disconnect();
    _stateController.close();
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  void _log(String direction, String message) {
    debugPrint('[FirebaseTransport] $direction $message');
    onLog?.call(direction, message);
  }
}
