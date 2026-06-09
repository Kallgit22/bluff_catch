import 'dart:async';

import '../entities/card.dart';
import '../entities/game_state.dart';

abstract class GameTransport {
  /// Stream of game state updates.
  Stream<GameState> get gameStateStream;

  /// The most recent game state.
  GameState get currentState;

  Future<void> startGame(List<String> playerNames);
  Future<void> throwCards(String playerId, List<PlayingCard> cards, Rank claimedRank);
  Future<void> addCards(String playerId, List<PlayingCard> cards, Rank claimedRank);
  Future<void> passTurn(String playerId);
  Future<void> challenge(String challengerId);
  Future<void> exitGame(String playerId);
  Future<void> replayGame();
  Future<void> resetGame();
  
  /// Cleans up resources.
  void dispose();
}
