import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/game_state.dart';
import '../../domain/engine/game_engine.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/deck.dart';

part 'game_state_provider.g.dart';

@Riverpod(keepAlive: true)
class GameStateNotifier extends _$GameStateNotifier {
  @override
  GameState build() {
    return const GameState();
  }

  /// Initializes the game with the given player names.
  void startGame(List<String> playerNames) {
    if (playerNames.length < 2 || playerNames.length > 10) return;

    final players = <Player>[];
    for (int i = 0; i < playerNames.length; i++) {
      players.add(Player(
        playerId: 'p_$i',
        playerName: playerNames[i],
        avatarColor: 0xFF0000FF, // default color
      ));
    }
    
    var initialState = GameEngine.initializeGame(players);
    
    // Generate and deal cards
    final deck = DeckManager.generateStandardDeck();
    DeckManager.shuffleDeck(deck);
    final hands = DeckManager.dealCards(deck, players.length);
    
    var newPlayers = List<Player>.from(initialState.players);
    for (int i = 0; i < newPlayers.length; i++) {
      final sortedHand = List<PlayingCard>.from(hands[i])..sortHand();
      newPlayers[i] = newPlayers[i].copyWith(handCards: sortedHand);
    }
    
    state = initialState.copyWith(players: newPlayers);
  }

  /// Plays cards on behalf of a player to start a new chain.
  void throwCards(String playerId, List<PlayingCard> cards, Rank claimedRank) {
    _play(playerId, cards, claimedRank);
  }

  /// Adds cards to an existing chain.
  void addCards(String playerId, List<PlayingCard> cards, Rank claimedRank) {
    _play(playerId, cards, claimedRank);
  }

  /// Internal play logic.
  void _play(String playerId, List<PlayingCard> cards, Rank claimedRank) {
    state = GameEngine.playCards(
      state: state,
      playerId: playerId,
      cards: cards,
      claimedRank: claimedRank,
    );
  }

  /// Passes the turn for a player.
  void passTurn(String playerId) {
    state = GameEngine.passTurn(
      state: state,
      playerId: playerId,
    );
  }

  /// Challenges the last play.
  void challenge(String challengerId) {
    state = GameEngine.challenge(
      state: state,
      challengerId: challengerId,
    );
  }

  /// Manually advances the turn if needed (handled automatically by engine usually).
  void nextTurn() {
    // Engine handles next turn internally on valid actions.
    // Exposing here per requirement if manual skipping is ever needed.
  }

  /// Resets the game to empty waiting state.
  void resetGame() {
    state = const GameState();
  }

  /// Exits the game for a specific player (forfeit)
  void exitGame(String playerId) {
    state = GameEngine.forfeitPlayer(
      state: state,
      playerId: playerId,
    );
  }

  /// Replays the game with the same players.
  void replayGame() {
    if (state.players.isEmpty) return;
    final playerNames = state.players.map((p) => p.playerName).toList();
    // Start game shuffles deck and re-assigns
    startGame(playerNames);
  }
}
