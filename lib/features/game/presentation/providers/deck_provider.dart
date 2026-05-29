import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/card.dart';
import '../../domain/entities/deck.dart';

part 'deck_provider.g.dart';

@riverpod
class DeckNotifier extends _$DeckNotifier {
  @override
  List<PlayingCard> build() {
    return [];
  }

  /// Generates a new standard 52-card deck and shuffles it.
  void generateAndShuffleDeck() {
    final deck = DeckManager.generateStandardDeck();
    DeckManager.shuffleDeck(deck);
    state = deck;
  }

  /// Deals cards from the current deck to the specified number of players.
  /// Removes the dealt cards from the current state (returns empty state since all cards are usually dealt).
  /// Returns a list of hands.
  List<List<PlayingCard>> dealCards(int numPlayers) {
    if (state.isEmpty) {
      throw StateError('Cannot deal from an empty deck.');
    }
    
    final hands = DeckManager.dealCards(List.from(state), numPlayers);
    
    // In Bluff Catch, all cards are dealt to players.
    // The deck state should become empty.
    state = [];
    
    return hands;
  }
}
