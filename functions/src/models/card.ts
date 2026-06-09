// Server-side card model â€” TypeScript port of card.dart.
// JSON keys match the client's freezed-generated serialization exactly.

/** Playing card suit. */
export enum Suit {
  hearts = "hearts",
  diamonds = "diamonds",
  clubs = "clubs",
  spades = "spades",
}

/** Playing card rank. */
export enum Rank {
  two = "two",
  three = "three",
  four = "four",
  five = "five",
  six = "six",
  seven = "seven",
  eight = "eight",
  nine = "nine",
  ten = "ten",
  jack = "jack",
  queen = "queen",
  king = "king",
  ace = "ace",
}

// Ordered list used to derive index (position = rank value).
const RANK_ORDER: Rank[] = [
  Rank.two, Rank.three, Rank.four, Rank.five, Rank.six,
  Rank.seven, Rank.eight, Rank.nine, Rank.ten,
  Rank.jack, Rank.queen, Rank.king, Rank.ace,
];

const SUIT_ORDER: Suit[] = [
  Suit.hearts, Suit.diamonds, Suit.clubs, Suit.spades,
];

/**
 * Returns the numeric index of a rank (mirrors Dart's Rank.index).
 * @param {Rank} rank - The rank to look up.
 * @return {number} Zero-based index.
 */
export function rankIndex(rank: Rank): number {
  return RANK_ORDER.indexOf(rank);
}

/**
 * Returns the numeric index of a suit (mirrors Dart's Suit.index).
 * @param {Suit} suit - The suit to look up.
 * @return {number} Zero-based index.
 */
export function suitIndex(suit: Suit): number {
  return SUIT_ORDER.indexOf(suit);
}

/**
 * Mirrors Dart's RankExtension.compareValue.
 * @param {Rank} a - First rank.
 * @param {Rank} b - Second rank.
 * @return {number} Negative, zero, or positive.
 */
export function compareRankValue(a: Rank, b: Rank): number {
  return rankIndex(a) - rankIndex(b);
}

/**
 * Mirrors Dart's RankExtension.label.
 * @param {Rank} rank - The rank to label.
 * @return {string} Human-readable label (e.g. "A", "K", "2").
 */
export function rankLabel(rank: Rank): string {
  switch (rank) {
  case Rank.two: return "2";
  case Rank.three: return "3";
  case Rank.four: return "4";
  case Rank.five: return "5";
  case Rank.six: return "6";
  case Rank.seven: return "7";
  case Rank.eight: return "8";
  case Rank.nine: return "9";
  case Rank.ten: return "10";
  case Rank.jack: return "J";
  case Rank.queen: return "Q";
  case Rank.king: return "K";
  case Rank.ace: return "A";
  }
}

/** JSON shape for a PlayingCard. */
export interface PlayingCardJson {
  suit: string;
  rank: string;
}

/** Immutable value-type representing a single playing card. */
export class PlayingCard {
  readonly suit: Suit;
  readonly rank: Rank;

  /**
   * Constructs a PlayingCard with the given suit and rank.
   * @param {Suit} suit - Card suit.
   * @param {Rank} rank - Card rank.
   */
  constructor(suit: Suit, rank: Rank) {
    this.suit = suit;
    this.rank = rank;
  }

  /**
   * Deserializes a PlayingCard from its JSON representation.
   * @param {PlayingCardJson} json - Raw JSON object.
   * @return {PlayingCard} Deserialized card.
   */
  static fromJson(json: PlayingCardJson): PlayingCard {
    return new PlayingCard(json.suit as Suit, json.rank as Rank);
  }

  /**
   * Serializes this card to its JSON representation.
   * @return {PlayingCardJson} JSON object.
   */
  toJson(): PlayingCardJson {
    return {suit: this.suit, rank: this.rank};
  }

  /**
   * Returns true when suit and rank both match the other card.
   * @param {PlayingCard} other - Card to compare against.
   * @return {boolean} True if equal.
   */
  equals(other: PlayingCard): boolean {
    return this.suit === other.suit && this.rank === other.rank;
  }

  /**
   * Human-readable string representation.
   * @return {string} Description string.
   */
  toString(): string {
    return `PlayingCard(${this.rank} of ${this.suit})`;
  }
}

/**
 * Mirrors Dart's PlayingCardListExtension.sortHand â€” sorts in place.
 * @param {PlayingCard[]} cards - Array to sort in place.
 */
export function sortHand(cards: PlayingCard[]): void {
  cards.sort((a, b) => {
    const rankCompare = compareRankValue(a.rank, b.rank);
    if (rankCompare !== 0) return rankCompare;
    return suitIndex(a.suit) - suitIndex(b.suit);
  });
}
