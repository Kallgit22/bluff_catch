import 'card.dart';

class DeckManager {
  /// Generates a standard 52-card deck without Jokers.
  static List<PlayingCard> generateStandardDeck() {
    final deck = <PlayingCard>[];
    for (final suit in Suit.values) {
      for (final rank in Rank.values) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }
    return deck;
  }

  /// Shuffles a given list of cards in-place.
  static void shuffleDeck(List<PlayingCard> deck) {
    deck.shuffle();
  }

  /// Deals the provided [deck] as evenly as possible to [numPlayers].
  /// Returns a list of hands (each hand is a List of PlayingCard).
  ///
  /// Any remainder cards are distributed to the first players.
  static List<List<PlayingCard>> dealCards(List<PlayingCard> deck, int numPlayers) {
    assert(numPlayers >= 2 && numPlayers <= 10, 'Player count must be between 2 and 10');
    
    final hands = List.generate(numPlayers, (_) => <PlayingCard>[]);
    final cardsPerPlayer = deck.length ~/ numPlayers;
    
    for (int i = 0; i < numPlayers; i++) {
      hands[i].addAll(deck.skip(i * cardsPerPlayer).take(cardsPerPlayer));
    }

    return hands;
  }
}
