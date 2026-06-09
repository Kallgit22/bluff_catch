// Server-side deck manager - TypeScript port of deck.dart.
// Pure logic, no Flutter dependencies.

import {PlayingCard, Rank, Suit, sortHand} from "./card";

/** Manages deck generation, shuffling, and dealing. */
export class DeckManager {
  /**
   * Generates a standard 52-card deck without Jokers.
   * @return {Array<PlayingCard>} Full unshuffled deck.
   */
  static generateStandardDeck(): PlayingCard[] {
    const deck: PlayingCard[] = [];
    for (const suit of Object.values(Suit)) {
      for (const rank of Object.values(Rank)) {
        deck.push(new PlayingCard(suit, rank));
      }
    }
    return deck;
  }

  /**
   * Shuffles a deck in-place using Fisher-Yates algorithm.
   * @param {Array<PlayingCard>} deck - Deck to shuffle.
   */
  static shuffleDeck(deck: PlayingCard[]): void {
    for (let i = deck.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [deck[i], deck[j]] = [deck[j], deck[i]];
    }
  }

  /**
   * Deals the deck as evenly as possible to numPlayers.
   * Remainder cards are distributed to the first players.
   * @param {Array<PlayingCard>} deck - Shuffled deck to deal from.
   * @param {number} numPlayers - Number of players (2 to 10).
   * @return {Array<Array<PlayingCard>>} Array of hands, one per player.
   */
  static dealCards(
    deck: PlayingCard[],
    numPlayers: number
  ): PlayingCard[][] {
    const hands: PlayingCard[][] = Array.from(
      {length: numPlayers}, () => [] as PlayingCard[]
    );
    const cardsPerPlayer = Math.floor(deck.length / numPlayers);

    for (let i = 0; i < numPlayers; i++) {
      hands[i] = deck.slice(
        i * cardsPerPlayer,
        (i + 1) * cardsPerPlayer
      );
      sortHand(hands[i]);
    }

    return hands;
  }
}
