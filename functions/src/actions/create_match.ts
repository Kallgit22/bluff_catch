/**
 * Cloud Function: createMatch
 *
 * Creates a new match document in Firestore with `waiting` status.
 * Does NOT deal cards â€” that is handled by startMatch.
 *
 * Request: { matchId: string, playerNames: string[] }
 * Response: { success: true, matchId: string }
 */

import * as admin from "firebase-admin";
import {
  MATCHES_COLLECTION,
  errorResponse,
  readMatchDoc,
  successResponse,
} from "./match_helpers";

/**
 * Handler for the createMatch callable function.
 * @param {admin.firestore.Firestore} db - Firestore instance.
 * @param {Record<string,unknown>} data - Request payload.
 * @return {Promise<Record<string,unknown>>} Response object.
 */
export async function createMatch(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>
): Promise<Record<string, unknown>> {
  // --- Validate request ---
  const matchId = data["matchId"] as string | undefined;
  if (!matchId || matchId.trim() === "") {
    return errorResponse("invalid-argument", "matchId is required.");
  }

  const playerNames = data["playerNames"] as unknown[] | undefined;
  if (
    !Array.isArray(playerNames) ||
    playerNames.length < 2 ||
    playerNames.length > 10
  ) {
    return errorResponse(
      "invalid-argument",
      "playerNames must have 2â€“10 entries."
    );
  }

  // --- Check for duplicates ---
  const existing = await readMatchDoc(db, matchId);
  if (existing !== null) {
    return errorResponse(
      "already-exists",
      `Match "${matchId}" already exists.`
    );
  }

  // --- Create document ---
  const docRef = db.collection(MATCHES_COLLECTION).doc(matchId);
  await docRef.set({
    status: "waiting",
    playerNames: playerNames as string[],
    gameState: null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return successResponse(undefined, {matchId});
}
