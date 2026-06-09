/**
 * Cloud Function: throwCards
 *
 * Validates the request, reads current game state from Firestore,
 * runs GameEngine.playCards(), and writes the result back.
 *
 * Request: { matchId, playerId, cards: [{suit, rank}], claimedRank }
 * Response: { success: true, event: "cardsThrown" }
 */

import * as admin from "firebase-admin";
import {GameEngine} from "../engine/game_engine";
import {PlayingCard, PlayingCardJson, Rank} from "../models/card";
import {
  errorResponse,
  runGameTransaction,
  successResponse,
} from "./match_helpers";

/**
 * Handler for the throwCards callable function.
 * @param {admin.firestore.Firestore} db - Firestore instance.
 * @param {Record<string,unknown>} data - Request payload.
 * @return {Promise<Record<string,unknown>>} Response object.
 */
export async function throwCards(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>
): Promise<Record<string, unknown>> {
  // --- Validate request ---
  const matchId = data["matchId"] as string | undefined;
  const playerId = data["playerId"] as string | undefined;
  const cardsRaw = data["cards"] as unknown[] | undefined;
  const claimedRankStr = data["claimedRank"] as string | undefined;

  if (!matchId || matchId.trim() === "") {
    return errorResponse("invalid-argument", "matchId is required.");
  }
  if (!playerId || playerId.trim() === "") {
    return errorResponse("invalid-argument", "playerId is required.");
  }
  if (
    !Array.isArray(cardsRaw) ||
    cardsRaw.length === 0 ||
    cardsRaw.length > 4
  ) {
    return errorResponse("invalid-argument", "Must play 1 to 4 cards.");
  }
  if (!claimedRankStr) {
    return errorResponse("invalid-argument", "claimedRank is required.");
  }

  // --- Parse cards and rank ---
  const claimedRank = claimedRankStr as Rank;
  if (!Object.values(Rank).includes(claimedRank)) {
    return errorResponse(
      "invalid-argument",
      `Invalid claimedRank: ${claimedRankStr}`
    );
  }

  let cards: PlayingCard[];
  try {
    cards = cardsRaw.map((e) =>
      PlayingCard.fromJson(e as PlayingCardJson)
    );
  } catch (e) {
    return errorResponse(
      "invalid-argument", `Invalid card format: ${e}`
    );
  }

  // --- Run engine in transaction ---
  try {
    const newState = await runGameTransaction(db, matchId, (gameState) => {
      return GameEngine.playCards({
        state: gameState,
        playerId,
        cards,
        claimedRank,
      });
    });

    return successResponse(newState.lastEvent);
  } catch (e) {
    if (e instanceof Error) {
      if (
        e.message.includes("not found") ||
        e.message.includes("no game state")
      ) {
        return errorResponse("not-found", e.message);
      }
      return errorResponse("failed-precondition", e.message);
    }
    return errorResponse("internal", `Unexpected error: ${e}`);
  }
}
