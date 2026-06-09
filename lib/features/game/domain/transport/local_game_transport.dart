import 'dart:async';

import '../entities/card.dart';
import '../entities/deck.dart';
import '../entities/game_state.dart';
import '../entities/player.dart';
import '../engine/game_engine.dart';
import 'game_transport.dart';

class LocalGameTransport implements GameTransport {
  final _stateController = StreamController<GameState>.broadcast();
  GameState _currentState = const GameState();

  @override
  Stream<GameState> get gameStateStream => _stateController.stream;

  @override
  GameState get currentState => _currentState;

  void _updateState(GameState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  @override
  Future<void> startGame(List<String> playerNames) async {
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
    
    _updateState(initialState.copyWith(players: newPlayers));
  }

  @override
  Future<void> throwCards(String playerId, List<PlayingCard> cards, Rank claimedRank) async {
    _play(playerId, cards, claimedRank);
  }

  @override
  Future<void> addCards(String playerId, List<PlayingCard> cards, Rank claimedRank) async {
    _play(playerId, cards, claimedRank);
  }

  void _play(String playerId, List<PlayingCard> cards, Rank claimedRank) {
    try {
      final newState = GameEngine.playCards(
        state: _currentState,
        playerId: playerId,
        cards: cards,
        claimedRank: claimedRank,
      );
      _updateState(newState);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> passTurn(String playerId) async {
    final newState = GameEngine.passTurn(
      state: _currentState,
      playerId: playerId,
    );
    _updateState(newState);
  }

  @override
  Future<void> challenge(String challengerId) async {
    final newState = GameEngine.challenge(
      state: _currentState,
      challengerId: challengerId,
    );
    _updateState(newState);
  }

  @override
  Future<void> exitGame(String playerId) async {
    final newState = GameEngine.forfeitPlayer(
      state: _currentState,
      playerId: playerId,
    );
    _updateState(newState);
  }

  @override
  Future<void> replayGame() async {
    if (_currentState.players.isEmpty) return;
    final playerNames = _currentState.players.map((p) => p.playerName).toList();
    await startGame(playerNames);
  }

  @override
  Future<void> resetGame() async {
    _updateState(const GameState());
  }

  @override
  void dispose() {
    _stateController.close();
  }
}
