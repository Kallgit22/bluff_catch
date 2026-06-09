import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/game_state.dart';
import '../../domain/entities/card.dart';
import 'transport_provider.dart';

part 'game_state_provider.g.dart';

@Riverpod(keepAlive: true)
class GameStateNotifier extends _$GameStateNotifier {
  StreamSubscription<GameState>? _subscription;

  @override
  GameState build() {
    final transport = ref.watch(gameTransportProvider);
    
    _subscription?.cancel();
    _subscription = transport.gameStateStream.listen((newState) {
      state = newState;
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return transport.currentState;
  }

  /// Initializes the game with the given player names.
  void startGame(List<String> playerNames) {
    ref.read(gameTransportProvider).startGame(playerNames);
  }

  /// Plays cards on behalf of a player to start a new chain.
  void throwCards(String playerId, List<PlayingCard> cards, Rank claimedRank) {
    ref.read(gameTransportProvider).throwCards(playerId, cards, claimedRank);
  }

  /// Adds cards to an existing chain.
  void addCards(String playerId, List<PlayingCard> cards, Rank claimedRank) {
    ref.read(gameTransportProvider).addCards(playerId, cards, claimedRank);
  }

  /// Passes the turn for a player.
  void passTurn(String playerId) {
    ref.read(gameTransportProvider).passTurn(playerId);
  }

  /// Challenges the last play.
  void challenge(String challengerId) {
    ref.read(gameTransportProvider).challenge(challengerId);
  }

  /// Manually advances the turn if needed (handled automatically by engine usually).
  void nextTurn() {
    // Engine handles next turn internally on valid actions.
    // Exposing here per requirement if manual skipping is ever needed.
  }

  /// Resets the game to empty waiting state.
  void resetGame() {
    ref.read(gameTransportProvider).resetGame();
  }

  /// Exits the game for a specific player (forfeit)
  void exitGame(String playerId) {
    ref.read(gameTransportProvider).exitGame(playerId);
  }

  /// Replays the game with the same players.
  void replayGame() {
    ref.read(gameTransportProvider).replayGame();
  }
}
