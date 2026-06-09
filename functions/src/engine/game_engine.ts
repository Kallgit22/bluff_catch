// Server-side game engine â€” exact logic copy from the client.
// Only import paths have been adjusted to use server-side models.
// NO logic changes from lib/features/game/domain/engine/game_engine.dart.

import {PlayingCard, Rank, sortHand} from "../models/card";
import {Player} from "../models/player";
import {GameState, GameStatus, AnimationEvent} from "../models/game_state";

/** Server-side game engine. All methods are pure (return new state). */
export class GameEngine {
  /**
   * Initializes a new game with the given players.
   * @param {Player[]} players - Players joining the game.
   * @return {GameState} Initial game state.
   */
  static initializeGame(players: Player[]): GameState {
    if (players.length === 0) return new GameState();
    const newState = new GameState({
      players,
      status: GameStatus.playing,
      lastEvent: AnimationEvent.none,
    });
    return GameEngine._assignTurn(newState, 0); // Start with player 0
  }

  /**
   * Called when a player makes a move by placing cards face down
   * and claiming a specific rank.
   * @param {object} params - Method parameters.
   * @param {GameState} params.state - Current game state.
   * @param {string} params.playerId - Acting player ID.
   * @param {PlayingCard[]} params.cards - Cards being played.
   * @param {Rank} params.claimedRank - Rank being claimed.
   * @return {GameState} Updated game state.
   */
  static playCards({
    state,
    playerId,
    cards,
    claimedRank,
  }: {
    state: GameState;
    playerId: string;
    cards: PlayingCard[];
    claimedRank: Rank;
  }): GameState {
    if (state.status !== GameStatus.playing) {
      throw new Error("Game is not active.");
    }
    if (cards.length === 0 || cards.length > 4) {
      throw new Error("Must play 1 to 4 cards.");
    }

    const playerIndex = state.players.findIndex(
      (p) => p.playerId === playerId
    );
    if (playerIndex === -1) throw new Error("Player not found.");
    if (playerIndex !== state.activePlayerIndex) {
      throw new Error("Not your turn.");
    }

    if (
      state.currentClaimedRank !== null &&
      claimedRank !== state.currentClaimedRank
    ) {
      throw new Error("Must claim the same rank as the current chain.");
    }

    let player = state.players[playerIndex];
    const newHand: PlayingCard[] = [...player.handCards];
    for (const card of cards) {
      const idx = newHand.findIndex((c) => c.equals(card));
      if (idx === -1) {
        throw new Error("Player does not have the played cards.");
      }
      newHand.splice(idx, 1);
    }

    player = player.copyWith({handCards: newHand});

    const newPlayers = [...state.players];
    newPlayers[playerIndex] = player;

    const newPool = [...state.pool, ...cards];

    let newState = state.copyWith({
      players: newPlayers,
      pool: newPool,
      currentClaimedRank: claimedRank,
      lastPlayerId: playerId,
      lastPlayedCards: cards,
      passCount: 0,
      lastEvent: AnimationEvent.cardsThrown,
    });

    newState = GameEngine._resetPassStatuses(newState);
    newState = GameEngine._evaluateRankings(newState);
    newState = GameEngine._checkGameEnd(newState);

    if (newState.status === GameStatus.finished) return newState;
    return GameEngine._advanceTurn(newState);
  }

  /**
   * Called when a player passes their turn.
   * @param {object} params - Method parameters.
   * @param {GameState} params.state - Current game state.
   * @param {string} params.playerId - Acting player ID.
   * @return {GameState} Updated game state.
   */
  static passTurn({
    state,
    playerId,
  }: {
    state: GameState;
    playerId: string;
  }): GameState {
    if (state.status !== GameStatus.playing) {
      throw new Error("Game is not active.");
    }
    if (state.pool.length === 0) {
      throw new Error("Cannot pass on the first turn of a round.");
    }

    const playerIndex = state.players.findIndex(
      (p) => p.playerId === playerId
    );
    if (playerIndex === -1) throw new Error("Player not found.");
    if (playerIndex !== state.activePlayerIndex) {
      throw new Error("Not your turn.");
    }

    const newPlayers = [...state.players];
    newPlayers[playerIndex] =
      newPlayers[playerIndex].copyWith({hasPassed: true});

    let newState = state.copyWith({
      players: newPlayers,
      passCount: state.passCount + 1,
      lastEvent: AnimationEvent.none,
    });

    const activePlayersCount = newState.players.filter(
      (p) => !p.isEliminated && !p.hasPendingVictory
    ).length;

    // Check passCount >= activePlayersCount without -1.
    // The player who threw last can still 'Add Cards' or 'Pass'.
    const requiredPasses = activePlayersCount;

    if (newState.passCount >= requiredPasses) {
      const lastPlayerId = newState.lastPlayerId;
      newState = GameEngine._endRound(newState, true);

      if (lastPlayerId !== null) {
        const lastPlayerIndex = newState.players.findIndex(
          (p) => p.playerId === lastPlayerId
        );
        if (lastPlayerIndex !== -1) {
          newState = GameEngine._assignTurn(newState, lastPlayerIndex);
          if (newState.players[lastPlayerIndex].isEliminated) {
            newState = GameEngine._advanceTurn(newState);
          }
        }
      }
      return newState.copyWith({lastEvent: AnimationEvent.roundPassed});
    }

    return GameEngine._advanceTurn(newState);
  }

  /**
   * Called when a player challenges the previous move.
   * @param {object} params - Method parameters.
   * @param {GameState} params.state - Current game state.
   * @param {string} params.challengerId - Challenging player ID.
   * @return {GameState} Updated game state.
   */
  static challenge({
    state,
    challengerId,
  }: {
    state: GameState;
    challengerId: string;
  }): GameState {
    if (state.status !== GameStatus.playing) {
      throw new Error("Game is not active.");
    }
    if (
      state.lastPlayerId === null ||
      state.lastPlayedCards.length === 0
    ) {
      throw new Error("No previous play to challenge.");
    }

    const challengerIndex = state.players.findIndex(
      (p) => p.playerId === challengerId
    );
    if (challengerIndex === -1) throw new Error("Player not found.");
    if (challengerIndex !== state.activePlayerIndex) {
      throw new Error("Only the current player can challenge.");
    }

    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const claimedRank = state.currentClaimedRank!;
    const wasTruth = state.lastPlayedCards.every(
      (card) => card.rank === claimedRank
    );

    const previousPlayerIndex = state.players.findIndex(
      (p) => p.playerId === state.lastPlayerId
    );

    const loserIndex = wasTruth ? challengerIndex : previousPlayerIndex;
    const winnerIndex =
      wasTruth ? previousPlayerIndex : challengerIndex;

    const newPlayers = [...state.players];
    let loser = newPlayers[loserIndex];
    let winner = newPlayers[winnerIndex];

    // Update stats
    const poolSize = state.pool.length;
    const loserNewHand = [...loser.handCards, ...state.pool];
    sortHand(loserNewHand);
    loser = loser.copyWith({
      handCards: loserNewHand,
      cardsConsumed: loser.cardsConsumed + poolSize,
    });

    if (wasTruth) {
      winner = winner.copyWith(
        {successfulBluffs: winner.successfulBluffs + 1}
      );
    } else {
      winner = winner.copyWith({
        liesCaught: winner.liesCaught + 1,
        challengesWon: winner.challengesWon + 1,
      });
    }

    newPlayers[loserIndex] = loser;
    newPlayers[winnerIndex] = winner;

    let newState = state.copyWith({
      players: newPlayers,
      lastEvent: wasTruth ?
        AnimationEvent.challengeTruth :
        AnimationEvent.challengeLie,
    });
    newState = GameEngine._endRound(newState, false);

    newState = GameEngine._evaluateRankings(newState);
    newState = GameEngine._checkGameEnd(newState);

    if (newState.status === GameStatus.finished) return newState;

    const finalWinnerIndex = newState.players.findIndex(
      (p) => p.playerId === state.players[winnerIndex].playerId
    );
    if (finalWinnerIndex !== -1) {
      newState = GameEngine._assignTurn(newState, finalWinnerIndex);
      if (newState.players[finalWinnerIndex].isEliminated) {
        newState = GameEngine._advanceTurn(newState);
      }
    }

    return newState;
  }

  // --- Helpers ---

  /**
   * Advances the turn to the next eligible player.
   * @param {GameState} state - Current state.
   * @return {GameState} State with updated active player.
   */
  private static _advanceTurn(state: GameState): GameState {
    if (state.players.length === 0) return state;
    let nextIndex =
      (state.activePlayerIndex + 1) % state.players.length;

    let loopCount = 0;
    while (
      state.players[nextIndex].isEliminated ||
      state.players[nextIndex].hasPassed ||
      state.players[nextIndex].hasPendingVictory
    ) {
      nextIndex = (nextIndex + 1) % state.players.length;
      loopCount++;
      if (loopCount > state.players.length) break;
    }

    return GameEngine._assignTurn(state, nextIndex);
  }

  /**
   * Sets currentTurn on exactly the player at the given index.
   * @param {GameState} state - Current state.
   * @param {number} index - Target player index.
   * @return {GameState} State with updated currentTurn flags.
   */
  private static _assignTurn(
    state: GameState,
    index: number
  ): GameState {
    const newPlayers = state.players.map((p, i) =>
      p.copyWith({currentTurn: i === index})
    );
    return state.copyWith({
      players: newPlayers,
      activePlayerIndex: index,
    });
  }

  /**
   * Clears hasPassed on all players.
   * @param {GameState} state - Current state.
   * @return {GameState} State with all pass flags cleared.
   */
  private static _resetPassStatuses(state: GameState): GameState {
    const newPlayers = state.players.map(
      (p) => p.copyWith({hasPassed: false})
    );
    return state.copyWith({players: newPlayers});
  }

  /**
   * Ends the current round, optionally discarding the pool.
   * @param {GameState} state - Current state.
   * @param {boolean} toDiscard - Whether to move pool to discard pile.
   * @return {GameState} State with pool cleared and rankings updated.
   */
  private static _endRound(
    state: GameState,
    toDiscard: boolean
  ): GameState {
    let newState = state;

    if (toDiscard) {
      const newDiscard = [...state.discardPile, ...state.pool];
      newState = newState.copyWith({discardPile: newDiscard});
    }

    newState = GameEngine._resetPassStatuses(newState);

    // Finalize pending victories since pool is safely flushing.
    let currentRank = 1;
    for (const p of newState.players) {
      if (p.rankPosition !== null &&
          // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
          p.rankPosition! >= currentRank) {
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        currentRank = p.rankPosition! + 1;
      }
    }

    const finalPlayers = newState.players.map((p) => {
      if (p.hasPendingVictory && !p.isEliminated && p.hasEmptyHand) {
        return p.copyWith({
          isEliminated: true,
          hasPendingVictory: false,
          rankPosition: currentRank++,
          currentTurn: false,
          hasPassed: false,
        });
      }
      return p;
    });

    return newState.copyWith({
      players: finalPlayers,
      pool: [],
      currentClaimedRank: null,
      lastPlayerId: null,
      lastPlayedCards: [],
      passCount: 0,
    });
  }

  /**
   * Marks players with empty hands as having a pending victory.
   * @param {GameState} state - Current state.
   * @return {GameState} State with updated pending victory flags.
   */
  private static _evaluateRankings(state: GameState): GameState {
    let currentRank = 1;
    for (const p of state.players) {
      if (p.rankPosition !== null &&
          // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
          p.rankPosition! >= currentRank) {
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        currentRank = p.rankPosition! + 1;
      }
    }

    const newPlayers = state.players.map((p) => {
      if (p.hasEmptyHand && !p.isEliminated && !p.hasPendingVictory) {
        return p.copyWith({hasPendingVictory: true});
      }
      // If a player got cards back (lost a challenge) after being in
      // pending victory, they rejoin.
      if (!p.hasEmptyHand && p.hasPendingVictory) {
        return p.copyWith({hasPendingVictory: false});
      }
      return p;
    });

    return state.copyWith({players: newPlayers});
  }

  /**
   * Checks whether the game is over and transitions to finished if so.
   * @param {GameState} state - Current state.
   * @return {GameState} Finished state or unchanged state.
   */
  private static _checkGameEnd(state: GameState): GameState {
    const activeCount = state.players.filter(
      (p) => !p.isEliminated
    ).length;
    if (activeCount <= 1) {
      const newState = GameEngine._evaluateRankings(state);
      const finalPlayers = newState.players.map((p) => {
        if (!p.isEliminated) {
          let maxRank = 0;
          /* eslint-disable @typescript-eslint/no-non-null-assertion */
          for (const op of newState.players) {
            if (op.rankPosition !== null && op.rankPosition! > maxRank) {
              maxRank = op.rankPosition!;
            }
          }
          /* eslint-enable @typescript-eslint/no-non-null-assertion */
          return p.copyWith({
            isEliminated: true,
            rankPosition: maxRank + 1,
            currentTurn: false,
          });
        }
        return p;
      });

      return newState.copyWith({
        players: finalPlayers,
        status: GameStatus.finished,
        activePlayerIndex: -1,
        lastEvent: AnimationEvent.gameOver,
      });
    }
    return state;
  }

  /**
   * Called when a player exits the game.
   * @param {object} params - Method parameters.
   * @param {GameState} params.state - Current game state.
   * @param {string} params.playerId - ID of the forfeiting player.
   * @return {GameState} Updated game state.
   */
  static forfeitPlayer({
    state,
    playerId,
  }: {
    state: GameState;
    playerId: string;
  }): GameState {
    if (state.status !== GameStatus.playing) return state;

    const playerIndex = state.players.findIndex(
      (p) => p.playerId === playerId
    );
    if (playerIndex === -1) return state;
    if (state.players[playerIndex].isEliminated) return state;

    const newPlayers = [...state.players];

    // Calculate maximum rank currently assigned + active players left.
    let maxRank = 0;
    let uneliminatedCount = 0;
    for (const p of state.players) {
      if (p.rankPosition !== null &&
          // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
          p.rankPosition! > maxRank) {
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        maxRank = p.rankPosition!;
      }
      if (!p.isEliminated && !p.hasPendingVictory) uneliminatedCount++;
    }

    // Force eliminate with highest rank.
    const player = newPlayers[playerIndex].copyWith({
      isEliminated: true,
      handCards: [],
      hasPendingVictory: false,
      rankPosition: maxRank + uneliminatedCount,
      currentTurn: false,
      hasPassed: false,
    });
    newPlayers[playerIndex] = player;

    let newState = state.copyWith({players: newPlayers});

    // Prevent unfair challenge if they threw the last cards.
    if (newState.lastPlayerId === playerId) {
      newState = newState.copyWith({
        lastPlayerId: null,
        pool: [],
        discardPile: [...state.discardPile, ...state.pool],
        lastPlayedCards: [],
        currentClaimedRank: null,
        passCount: 0,
      });
      newState = GameEngine._resetPassStatuses(newState);
    }

    if (state.activePlayerIndex === playerIndex) {
      newState = GameEngine._advanceTurn(newState);
    }

    return GameEngine._checkGameEnd(newState);
  }
}
