// Server-side game state model â€” TypeScript port of game_state.dart.
// JSON keys match the client's freezed-generated serialization exactly.

import {Player, PlayerJson} from "./player";
import {PlayingCard, PlayingCardJson, Rank} from "./card";

/** Lifecycle status of a game session. */
export enum GameStatus {
  waiting = "waiting",
  playing = "playing",
  finished = "finished",
}

/** Animation trigger event emitted at the end of each state transition. */
export enum AnimationEvent {
  none = "none",
  cardsThrown = "cardsThrown",
  challengeTruth = "challengeTruth",
  challengeLie = "challengeLie",
  roundPassed = "roundPassed",
  gameOver = "gameOver",
}

/** JSON shape for a GameState object. */
export interface GameStateJson {
  players?: PlayerJson[];
  pool?: PlayingCardJson[];
  discardPile?: PlayingCardJson[];
  currentClaimedRank?: string | null;
  lastPlayerId?: string | null;
  lastPlayedCards?: PlayingCardJson[];
  passCount?: number;
  activePlayerIndex?: number;
  status?: string;
  lastEvent?: string;
}

// Sentinel symbol to distinguish "not provided" from explicit null â€”
// mirrors Dart's private _sentinel pattern for nullable copyWith fields.
const _sentinel = Symbol("sentinel");

/** Immutable server-side game state model. */
export class GameState {
  readonly players: Player[];
  readonly pool: PlayingCard[];
  readonly discardPile: PlayingCard[];
  readonly currentClaimedRank: Rank | null;
  readonly lastPlayerId: string | null;
  readonly lastPlayedCards: PlayingCard[];
  readonly passCount: number;
  readonly activePlayerIndex: number;
  readonly status: GameStatus;
  readonly lastEvent: AnimationEvent;

  /**
   * Constructs a GameState. All fields are optional with sensible defaults.
   * @param {object} [params] - GameState fields.
   * @param {Player[]} [params.players] - List of players.
   * @param {PlayingCard[]} [params.pool] - Cards in the current pool.
   * @param {PlayingCard[]} [params.discardPile] - Discarded cards.
   * @param {Rank|null} [params.currentClaimedRank] - Claimed rank.
   * @param {string|null} [params.lastPlayerId] - Last player who played.
   * @param {PlayingCard[]} [params.lastPlayedCards] - Last played cards.
   * @param {number} [params.passCount] - Number of passes this round.
   * @param {number} [params.activePlayerIndex] - Index of active player.
   * @param {GameStatus} [params.status] - Game lifecycle status.
   * @param {AnimationEvent} [params.lastEvent] - Last animation event.
   */
  constructor({
    players = [],
    pool = [],
    discardPile = [],
    currentClaimedRank = null,
    lastPlayerId = null,
    lastPlayedCards = [],
    passCount = 0,
    activePlayerIndex = 0,
    status = GameStatus.waiting,
    lastEvent = AnimationEvent.none,
  }: {
    players?: Player[];
    pool?: PlayingCard[];
    discardPile?: PlayingCard[];
    currentClaimedRank?: Rank | null;
    lastPlayerId?: string | null;
    lastPlayedCards?: PlayingCard[];
    passCount?: number;
    activePlayerIndex?: number;
    status?: GameStatus;
    lastEvent?: AnimationEvent;
  } = {}) {
    this.players = players;
    this.pool = pool;
    this.discardPile = discardPile;
    this.currentClaimedRank = currentClaimedRank;
    this.lastPlayerId = lastPlayerId;
    this.lastPlayedCards = lastPlayedCards;
    this.passCount = passCount;
    this.activePlayerIndex = activePlayerIndex;
    this.status = status;
    this.lastEvent = lastEvent;
  }

  /**
   * Returns a new GameState with the given fields replaced.
   * Mirrors Dart's sentinel-based nullable handling: pass `null` explicitly
   * to clear currentClaimedRank/lastPlayerId; omit to keep current values.
   * @param {object} [params] - Fields to override.
   * @return {GameState} New immutable GameState instance.
   */
  copyWith({
    players,
    pool,
    discardPile,
    currentClaimedRank = _sentinel as unknown as Rank | null,
    lastPlayerId = _sentinel as unknown as string | null,
    lastPlayedCards,
    passCount,
    activePlayerIndex,
    status,
    lastEvent,
  }: {
    players?: Player[];
    pool?: PlayingCard[];
    discardPile?: PlayingCard[];
    currentClaimedRank?: Rank | null | typeof _sentinel;
    lastPlayerId?: string | null | typeof _sentinel;
    lastPlayedCards?: PlayingCard[];
    passCount?: number;
    activePlayerIndex?: number;
    status?: GameStatus;
    lastEvent?: AnimationEvent;
  } = {}): GameState {
    return new GameState({
      players: players ?? this.players,
      pool: pool ?? this.pool,
      discardPile: discardPile ?? this.discardPile,
      currentClaimedRank: currentClaimedRank === _sentinel ?
        this.currentClaimedRank :
        (currentClaimedRank as Rank | null),
      lastPlayerId: lastPlayerId === _sentinel ?
        this.lastPlayerId :
        (lastPlayerId as string | null),
      lastPlayedCards: lastPlayedCards ?? this.lastPlayedCards,
      passCount: passCount ?? this.passCount,
      activePlayerIndex: activePlayerIndex ?? this.activePlayerIndex,
      status: status ?? this.status,
      lastEvent: lastEvent ?? this.lastEvent,
    });
  }

  /**
   * Deserializes a GameState from its JSON representation.
   * @param {GameStateJson} json - Raw JSON object.
   * @return {GameState} Deserialized state.
   */
  static fromJson(json: GameStateJson): GameState {
    return new GameState({
      players: (json.players ?? []).map((e) => Player.fromJson(e)),
      pool: (json.pool ?? []).map((e) => PlayingCard.fromJson(e)),
      discardPile: (json.discardPile ?? []).map(
        (e) => PlayingCard.fromJson(e)
      ),
      currentClaimedRank: json.currentClaimedRank != null ?
        (json.currentClaimedRank as Rank) :
        null,
      lastPlayerId: json.lastPlayerId ?? null,
      lastPlayedCards: (json.lastPlayedCards ?? []).map(
        (e) => PlayingCard.fromJson(e)
      ),
      passCount: json.passCount ?? 0,
      activePlayerIndex: json.activePlayerIndex ?? 0,
      status: json.status != null ?
        (json.status as GameStatus) :
        GameStatus.waiting,
      lastEvent: json.lastEvent != null ?
        (json.lastEvent as AnimationEvent) :
        AnimationEvent.none,
    });
  }

  /**
   * Serializes this state to its JSON representation.
   * @return {GameStateJson} JSON object.
   */
  toJson(): GameStateJson {
    return {
      players: this.players.map((p) => p.toJson()),
      pool: this.pool.map((c) => c.toJson()),
      discardPile: this.discardPile.map((c) => c.toJson()),
      currentClaimedRank: this.currentClaimedRank ?? null,
      lastPlayerId: this.lastPlayerId,
      lastPlayedCards: this.lastPlayedCards.map((c) => c.toJson()),
      passCount: this.passCount,
      activePlayerIndex: this.activePlayerIndex,
      status: this.status,
      lastEvent: this.lastEvent,
    };
  }
}
