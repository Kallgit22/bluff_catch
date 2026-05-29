import 'package:flutter_test/flutter_test.dart';
import 'package:bluff_catch/features/game/domain/entities/card.dart';
import 'package:bluff_catch/features/game/domain/entities/deck.dart';

void main() {
  group('Card System Tests', () {
    test('Rank extension returns correct label', () {
      expect(Rank.ace.label, 'A');
      expect(Rank.two.label, '2');
      expect(Rank.ten.label, '10');
      expect(Rank.jack.label, 'J');
      expect(Rank.king.label, 'K');
    });

    test('Rank compareValue works correctly', () {
      expect(Rank.two.compareValue(Rank.two), 0);
      expect(Rank.two.compareValue(Rank.three), lessThan(0));
      expect(Rank.ace.compareValue(Rank.king), greaterThan(0));
    });

    test('DeckManager generates standard 52-card deck', () {
      final deck = DeckManager.generateStandardDeck();
      expect(deck.length, 52);

      // Verify there are 4 of each rank
      for (final rank in Rank.values) {
        final rankCards = deck.where((c) => c.rank == rank).toList();
        expect(rankCards.length, 4);
      }

      // Verify there are 13 of each suit
      for (final suit in Suit.values) {
        final suitCards = deck.where((c) => c.suit == suit).toList();
        expect(suitCards.length, 13);
      }
    });

    test('DeckManager dealCards distributes evenly to 2 players', () {
      final deck = DeckManager.generateStandardDeck();
      final hands = DeckManager.dealCards(deck, 2);

      expect(hands.length, 2);
      expect(hands[0].length, 26);
      expect(hands[1].length, 26);
    });

    test('DeckManager dealCards distributes remainders properly to 3 players', () {
      final deck = DeckManager.generateStandardDeck();
      final hands = DeckManager.dealCards(deck, 3);

      expect(hands.length, 3);
      expect(hands[0].length, 17);
      expect(hands[1].length, 17);
      expect(hands[2].length, 17);
      
      final totalDealt = hands[0].length + hands[1].length + hands[2].length;
      expect(totalDealt, 51); // 1 card discarded
    });
    
    test('DeckManager throws assertion error for invalid player count', () {
      final deck = DeckManager.generateStandardDeck();
      expect(() => DeckManager.dealCards(deck, 1), throwsAssertionError);
      expect(() => DeckManager.dealCards(deck, 11), throwsAssertionError);
    });
  });
}
