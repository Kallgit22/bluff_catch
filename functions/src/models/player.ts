// Server-side player model â€” TypeScript port of player.dart.
// JSON keys match the client's freezed-generated serialization exactly.

import {PlayingCard, PlayingCardJson, sortHand} from "./card";

/** JSON shape for a Player object. */
export interface PlayerJson {
  playerId: string;
  playerName: string;
  avatarColor: number;
  handCards?: PlayingCardJson[];
  rankPosition?: number | null;
  isEliminated?: boolean;
  currentTurn?: boolean;
  hasPassed?: boolean;
  hasPendingVictory?: boolean;
  liesCaught?: number;
  successfulBluffs?: number;
  challengesWon?: number;
  cardsConsumed?: number;
}

// Sentinel symbol used to distinguish "not provided" from explicit null,
// mirroring Dart's private _sentinel pattern for nullable copyWith fields.
const _sentinel = Symbol("sentinel");

/** Immutable server-side player model. */
export class Player {
  readonly playerId: string;
  readonly playerName: string;
  readonly avatarColor: number;
  readonly handCards: PlayingCard[];
  readonly rankPosition: number | null;
  readonly isEliminated: boolean;
  readonly currentTurn: boolean;
  readonly hasPassed: boolean;
  readonly hasPendingVictory: boolean;

  // Statistics
  readonly liesCaught: number;
  readonly successfulBluffs: number;
  readonly challengesWon: number;
  readonly cardsConsumed: number;

  /**
   * Constructs a Player with all fields.
   * Nullable fields default to null/false/0.
   * @param {object} params - Player fields.
   * @param {string} params.playerId - Unique player ID.
   * @param {string} params.playerName - Display name.
   * @param {number} params.avatarColor - Avatar colour value.
   * @param {PlayingCard[]} [params.handCards] - Cards in hand.
   * @param {number|null} [params.rankPosition] - Finish position.
   * @param {boolean} [params.isEliminated] - Whether eliminated.
   * @param {boolean} [params.currentTurn] - Whether it is this player's turn.
   * @param {boolean} [params.hasPassed] - Whether passed this round.
   * @param {boolean} [params.hasPendingVictory] - Pending victory flag.
   * @param {number} [params.liesCaught] - Stat: lies caught.
   * @param {number} [params.successfulBluffs] - Stat: successful bluffs.
   * @param {number} [params.challengesWon] - Stat: challenges won.
   * @param {number} [params.cardsConsumed] - Stat: cards consumed.
   */
  constructor({
    playerId,
    playerName,
    avatarColor,
    handCards = [],
    rankPosition = null,
    isEliminated = false,
    currentTurn = false,
    hasPassed = false,
    hasPendingVictory = false,
    liesCaught = 0,
    successfulBluffs = 0,
    challengesWon = 0,
    cardsConsumed = 0,
  }: {
    playerId: string;
    playerName: string;
    avatarColor: number;
    handCards?: PlayingCard[];
    rankPosition?: number | null;
    isEliminated?: boolean;
    currentTurn?: boolean;
    hasPassed?: boolean;
    hasPendingVictory?: boolean;
    liesCaught?: number;
    successfulBluffs?: number;
    challengesWon?: number;
    cardsConsumed?: number;
  }) {
    this.playerId = playerId;
    this.playerName = playerName;
    this.avatarColor = avatarColor;
    this.handCards = handCards;
    this.rankPosition = rankPosition;
    this.isEliminated = isEliminated;
    this.currentTurn = currentTurn;
    this.hasPassed = hasPassed;
    this.hasPendingVictory = hasPendingVictory;
    this.liesCaught = liesCaught;
    this.successfulBluffs = successfulBluffs;
    this.challengesWon = challengesWon;
    this.cardsConsumed = cardsConsumed;
  }

  /** Total number of cards in hand. */
  get totalCards(): number {
    return this.handCards.length;
  }

  /** True when the player's hand is empty. */
  get hasEmptyHand(): boolean {
    return this.handCards.length === 0;
  }

  /**
   * Returns a new Player with the given fields replaced.
   * Mirrors Dart's sentinel-based nullable handling: pass `null` explicitly
   * to clear rankPosition; omit it to keep the current value.
   * @param {object} params - Fields to override.
   * @return {Player} New immutable Player instance.
   */
  copyWith({
    playerId,
    playerName,
    avatarColor,
    handCards,
    rankPosition = _sentinel as unknown as number | null,
    isEliminated,
    currentTurn,
    hasPassed,
    hasPendingVictory,
    liesCaught,
    successfulBluffs,
    challengesWon,
    cardsConsumed,
  }: {
    playerId?: string;
    playerName?: string;
    avatarColor?: number;
    handCards?: PlayingCard[];
    rankPosition?: number | null | typeof _sentinel;
    isEliminated?: boolean;
    currentTurn?: boolean;
    hasPassed?: boolean;
    hasPendingVictory?: boolean;
    liesCaught?: number;
    successfulBluffs?: number;
    challengesWon?: number;
    cardsConsumed?: number;
  }): Player {
    return new Player({
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      avatarColor: avatarColor ?? this.avatarColor,
      handCards: handCards ?? this.handCards,
      rankPosition: rankPosition === _sentinel ?
        this.rankPosition :
        (rankPosition as number | null),
      isEliminated: isEliminated ?? this.isEliminated,
      currentTurn: currentTurn ?? this.currentTurn,
      hasPassed: hasPassed ?? this.hasPassed,
      hasPendingVictory: hasPendingVictory ?? this.hasPendingVictory,
      liesCaught: liesCaught ?? this.liesCaught,
      successfulBluffs: successfulBluffs ?? this.successfulBluffs,
      challengesWon: challengesWon ?? this.challengesWon,
      cardsConsumed: cardsConsumed ?? this.cardsConsumed,
    });
  }

  /**
   * Deserializes a Player from its JSON representation.
   * @param {PlayerJson} json - Raw JSON object.
   * @return {Player} Deserialized player.
   */
  static fromJson(json: PlayerJson): Player {
    return new Player({
      playerId: json.playerId,
      playerName: json.playerName,
      avatarColor: json.avatarColor,
      handCards: (json.handCards ?? []).map(
        (e) => PlayingCard.fromJson(e)
      ),
      rankPosition: json.rankPosition ?? null,
      isEliminated: json.isEliminated ?? false,
      currentTurn: json.currentTurn ?? false,
      hasPassed: json.hasPassed ?? false,
      hasPendingVictory: json.hasPendingVictory ?? false,
      liesCaught: json.liesCaught ?? 0,
      successfulBluffs: json.successfulBluffs ?? 0,
      challengesWon: json.challengesWon ?? 0,
      cardsConsumed: json.cardsConsumed ?? 0,
    });
  }

  /**
   * Serializes this player to its JSON representation.
   * @return {PlayerJson} JSON object.
   */
  toJson(): PlayerJson {
    return {
      playerId: this.playerId,
      playerName: this.playerName,
      avatarColor: this.avatarColor,
      handCards: this.handCards.map((c) => c.toJson()),
      rankPosition: this.rankPosition,
      isEliminated: this.isEliminated,
      currentTurn: this.currentTurn,
      hasPassed: this.hasPassed,
      hasPendingVictory: this.hasPendingVictory,
      liesCaught: this.liesCaught,
      successfulBluffs: this.successfulBluffs,
      challengesWon: this.challengesWon,
      cardsConsumed: this.cardsConsumed,
    };
  }

  /**
   * Human-readable string representation.
   * @return {string} Description string.
   */
  toString(): string {
    return `Player(${this.playerName}, cards: ${this.totalCards})`;
  }
}

// Re-export sortHand for convenience when sorting a Player's hand array.
export {sortHand};
