import 'package:flutter_test/flutter_test.dart';
import 'package:bluff_catch/features/game/domain/engine/game_engine.dart';
import 'package:bluff_catch/features/game/domain/entities/game_state.dart';
import 'package:bluff_catch/features/game/domain/entities/player.dart';
import 'package:bluff_catch/features/game/domain/entities/card.dart';

void main() {
  group('GameEngine Logic Tests', () {
    late GameState initialState;

    setUp(() {
      initialState = GameEngine.initializeGame([
        const Player(playerId: 'p1', playerName: 'P1', avatarColor: 0, handCards: [
          PlayingCard(suit: Suit.hearts, rank: Rank.ace),
          PlayingCard(suit: Suit.diamonds, rank: Rank.two),
        ]),
        const Player(playerId: 'p2', playerName: 'P2', avatarColor: 0, handCards: [
          PlayingCard(suit: Suit.spades, rank: Rank.three),
          PlayingCard(suit: Suit.clubs, rank: Rank.four),
        ]),
        const Player(playerId: 'p3', playerName: 'P3', avatarColor: 0, handCards: [
          PlayingCard(suit: Suit.hearts, rank: Rank.five),
          PlayingCard(suit: Suit.diamonds, rank: Rank.six),
        ]),
      ]);
    });

    test('Initializes correctly', () {
      expect(initialState.players.length, 3);
      expect(initialState.status, GameStatus.playing);
      expect(initialState.activePlayerIndex, 0);
      expect(initialState.players[0].currentTurn, isTrue);
    });

    test('Play valid cards advances turn and updates pool', () {
      final nextState = GameEngine.playCards(
        state: initialState,
        playerId: 'p1',
        cards: const [PlayingCard(suit: Suit.hearts, rank: Rank.ace)],
        claimedRank: Rank.ace,
      );

      expect(nextState.pool.length, 1);
      expect(nextState.lastPlayerId, 'p1');
      expect(nextState.currentClaimedRank, Rank.ace);
      expect(nextState.activePlayerIndex, 1);
      expect(nextState.players[1].currentTurn, isTrue);
      expect(nextState.players[0].totalCards, 1);
    });

    test('Pass turn logic and resetting round when everyone passes', () {
      var state = GameEngine.playCards(
        state: initialState,
        playerId: 'p1',
        cards: const [PlayingCard(suit: Suit.hearts, rank: Rank.ace)],
        claimedRank: Rank.ace,
      );

      // p2 passes
      state = GameEngine.passTurn(state: state, playerId: 'p2');
      expect(state.passCount, 1);
      expect(state.activePlayerIndex, 2);

      // p3 passes
      state = GameEngine.passTurn(state: state, playerId: 'p3');
      
      // Under new rules, turn goes back to P1 who must make the final decision.
      expect(state.pool.length, 1); // Pool not flushed yet
      expect(state.activePlayerIndex, 0); // Turn is P1
      expect(state.passCount, 2);
      
      // p1 passes
      state = GameEngine.passTurn(state: state, playerId: 'p1');
      
      // Now everyone has passed (3 passes out of 3 players). Round should end.
      expect(state.pool.length, 0);
      expect(state.discardPile.length, 1);
      expect(state.currentClaimedRank, isNull);
      expect(state.passCount, 0);
      expect(state.activePlayerIndex, 0); // turn goes back to p1
    });

    test('Challenge truth assigns pool to challenger', () {
      var state = GameEngine.playCards(
        state: initialState,
        playerId: 'p1',
        cards: const [PlayingCard(suit: Suit.hearts, rank: Rank.ace)],
        claimedRank: Rank.ace, // TRUTH
      );

      state = GameEngine.challenge(state: state, challengerId: 'p2');

      // Challenger (p2) gets the pool
      expect(state.players[1].totalCards, 3); // started with 2 + 1 from pool
      expect(state.pool.isEmpty, isTrue);
      
      // Winner (p1) starts next round
      expect(state.activePlayerIndex, 0);
    });

    test('Challenge lie assigns pool to previous player', () {
      var state = GameEngine.playCards(
        state: initialState,
        playerId: 'p1',
        cards: const [PlayingCard(suit: Suit.diamonds, rank: Rank.two)], // Actual card is Two
        claimedRank: Rank.ace, // LIE
      );

      state = GameEngine.challenge(state: state, challengerId: 'p2');

      // Previous player (p1) gets the pool (they lied)
      expect(state.players[0].totalCards, 2); // 2 original - 1 played + 1 from pool = 2
      expect(state.pool.isEmpty, isTrue);
      
      // Winner (challenger p2) starts next round
      expect(state.activePlayerIndex, 1);
    });
    
    test('Winning the game when cards empty', () {
      var state = GameEngine.playCards(
        state: initialState,
        playerId: 'p1',
        cards: const [
          PlayingCard(suit: Suit.hearts, rank: Rank.ace),
          PlayingCard(suit: Suit.diamonds, rank: Rank.two),
        ], // Plays all cards
        claimedRank: Rank.ace, 
      );
      
      // p2 passes
      state = GameEngine.passTurn(state: state, playerId: 'p2');
      // p3 passes
      state = GameEngine.passTurn(state: state, playerId: 'p3');
      
      // Round ends because everyone passed. P1 is evaluated for ranking.
      expect(state.players[0].isEliminated, isTrue);
      expect(state.players[0].rankPosition, 1);
      
      // Turn goes to next active player (p2) since p1 is eliminated.
      expect(state.activePlayerIndex, 1);
    });
  });
}
