/**
 * Cloud Function: challenge
 *
 * Validates the request, reads current game state from Firestore,
 * runs GameEngine.challenge(), and writes the result back.
 *
 * Request: { matchId, playerId }
 * Response: { success: true, event: "challengeTruth" | "challengeLie" }
 */

import * as admin from "firebase-admin";
import {GameEngine} from "../engine/game_engine";
import {
  errorResponse,
  runGameTransaction,
  successResponse,
} from "./match_helpers";

/**
 * Handler for the challenge callable function.
 * @param {admin.firestore.Firestore} db - Firestore instance.
 * @param {Record<string,unknown>} data - Request payload.
 * @return {Promise<Record<string,unknown>>} Response object.
 */
export async function challenge(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>
): Promise<Record<string, unknown>> {
  // --- Validate request ---
  const matchId = data["matchId"] as string | undefined;
  const playerId = data["playerId"] as string | undefined;

  if (!matchId || matchId.trim() === "") {
    return errorResponse("invalid-argument", "matchId is required.");
  }
  if (!playerId || playerId.trim() === "") {
    return errorResponse("invalid-argument", "playerId is required.");
  }

  // --- Run engine in transaction ---
  try {
    const newState = await runGameTransaction(db, matchId, (gameState) => {
      return GameEngine.challenge({
        state: gameState,
        challengerId: playerId,
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
