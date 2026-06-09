// Shared utilities for all Cloud Function action handlers.
// Provides Firestore read/write helpers and standardised response builders.

import * as admin from "firebase-admin";
import {GameState} from "../models/game_state";

/** The Firestore collection name for match documents. */
export const MATCHES_COLLECTION = "matches";

/** The Firestore collection name for room documents. */
export const ROOMS_COLLECTION = "rooms";

/**
 * Reads and deserialises the GameState from a match document.
 * Returns null if the document does not exist or has no gameState field.
 * @param {admin.firestore.Firestore} db - Firestore instance.
 * @param {string} matchId - Match document ID.
 * @return {Promise<GameState|null>} Parsed GameState or null.
 */
export async function readGameState(
  db: admin.firestore.Firestore,
  matchId: string
): Promise<GameState | null> {
  const docRef = db.collection(MATCHES_COLLECTION).doc(matchId);
  const snapshot = await docRef.get();

  if (!snapshot.exists) return null;

  const data = snapshot.data();
  if (!data) return null;

  const gameStateMap = data["gameState"];
  if (!gameStateMap) return null;

  return GameState.fromJson(
    gameStateMap as Record<string, unknown>
  );
}

/**
 * Reads the raw match document data.
 * Returns null if the document does not exist.
 * @param {admin.firestore.Firestore} db - Firestore instance.
 * @param {string} matchId - Match document ID.
 * @return {Promise<Record<string,unknown>|null>} Raw data or null.
 */
export async function readMatchDoc(
  db: admin.firestore.Firestore,
  matchId: string
): Promise<Record<string, unknown> | null> {
  const docRef = db.collection(MATCHES_COLLECTION).doc(matchId);
  const snapshot = await docRef.get();

  if (!snapshot.exists) return null;
  return snapshot.data() as Record<string, unknown> ?? null;
}

/**
 * Writes the serialised GameState back to the match document.
 * @param {admin.firestore.Firestore} db - Firestore instance.
 * @param {string} matchId - Match document ID.
 * @param {GameState} gameState - State to persist.
 * @param {string} [statusOverride] - Override the status field.
 */
export async function writeGameState(
  db: admin.firestore.Firestore,
  matchId: string,
  gameState: GameState,
  statusOverride?: string
): Promise<void> {
  const docRef = db.collection(MATCHES_COLLECTION).doc(matchId);
  await docRef.update({
    gameState: gameState.toJson(),
    status: statusOverride ?? gameState.status,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

/**
 * Builds a standardised success response.
 * @param {string} [event] - Optional event name to include.
 * @param {Record<string,unknown>} [extra] - Extra fields to merge.
 * @return {Record<string,unknown>} Success response.
 */
export function successResponse(
  event?: string,
  extra?: Record<string, unknown>
): Record<string, unknown> {
  return {
    success: true,
    ...(event ? {event} : {}),
    ...(extra ?? {}),
  };
}

/**
 * Builds a standardised error response.
 * @param {string} code - Error code string.
 * @param {string} message - Human-readable error message.
 * @return {Record<string,unknown>} Error response.
 */
export function errorResponse(
  code: string,
  message: string
): Record<string, unknown> {
  return {
    success: false,
    error: {code, message},
  };
}

/**
 * Runs a transactional read-modify-write on a match's GameState.
 * Prevents race conditions and desync in multiplayer actions.
 * @param {admin.firestore.Firestore} db - Firestore instance.
 * @param {string} matchId - Match document ID.
 * @param {Function} handler - The mutation logic.
 * @return {Promise<GameState>} The newly saved GameState.
 */
export async function runGameTransaction(
  db: admin.firestore.Firestore,
  matchId: string,
  handler: (state: GameState) => GameState
): Promise<GameState> {
  const docRef = db.collection(MATCHES_COLLECTION).doc(matchId);
  return await db.runTransaction(async (t) => {
    const snapshot = await t.get(docRef);
    if (!snapshot.exists) {
      throw new Error(`Match "${matchId}" not found.`);
    }

    const data = snapshot.data();
    if (!data || !data["gameState"]) {
      throw new Error(`Match "${matchId}" has no game state.`);
    }

    const gameState = GameState.fromJson(
      data["gameState"] as Record<string, unknown>
    );

    const newState = handler(gameState);

    t.update(docRef, {
      gameState: newState.toJson(),
      status: newState.status,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return newState;
  });
}
