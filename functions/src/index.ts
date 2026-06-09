/**
 * Bluff Catch â€” Cloud Functions entry point.
 *
 * Registers all HTTPS callable functions using the Firebase Functions v2 API.
 * Each function:
 *   1. Receives a JSON data payload from the Flutter client.
 *   2. Delegates to an action handler in src/actions/.
 *   3. Returns a standardised success/error response.
 */

import {setGlobalOptions} from "firebase-functions";
import {
  onCall,
  HttpsError,
  FunctionsErrorCode,
} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

import {createRoom as createRoomAction} from "./actions/create_room";
import {joinRoom as joinRoomAction} from "./actions/join_room";
import {toggleReady as toggleReadyAction} from "./actions/toggle_ready";
import {startMatch as startMatchAction} from "./actions/start_match";
import {throwCards as throwCardsAction} from "./actions/throw_cards";
import {challenge as challengeAction} from "./actions/challenge";
import {passTurn as passTurnAction} from "./actions/pass_turn";
import {leaveMatch as leaveMatchAction} from "./actions/leave_match";

// Initialise Firebase Admin SDK once.
if (!admin.apps.length) {
  admin.initializeApp();
}

/**
 * Convenience getter for the Firestore instance.
 * @return {admin.firestore.Firestore} Firestore singleton.
 */
function db(): admin.firestore.Firestore {
  return admin.firestore();
}

setGlobalOptions({maxInstances: 10});

// ---------------------------------------------------------------------------
// Callable function registrations
//
// Each wraps an action handler, passing the Firestore instance and the
// decoded request data. Errors thrown by action handlers are caught and
// re-thrown as HttpsError so the Flutter SDK receives proper error codes.
// ---------------------------------------------------------------------------

/** Creates a new room document in Firestore. */
export const createRoom = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await createRoomAction(db(), data, { auth: request.auth });
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(err["code"] as FunctionsErrorCode, err["message"]);
  }
  return result;
});

/** Joins an existing room. */
export const joinRoom = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await joinRoomAction(db(), data, { auth: request.auth });
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(err["code"] as FunctionsErrorCode, err["message"]);
  }
  return result;
});

/** Toggles the ready state for a player in a room. */
export const toggleReady = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await toggleReadyAction(db(), data, { auth: request.auth });
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(err["code"] as FunctionsErrorCode, err["message"]);
  }
  return result;
});

/** Starts a waiting match: deals cards and sets state to playing. */
export const startMatch = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await startMatchAction(db(), data, { auth: request.auth });
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(
      err["code"] as FunctionsErrorCode,
      err["message"]
    );
  }
  return result;
});

/** Plays cards from a player's hand onto the pool. */
export const throwCards = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await throwCardsAction(db(), data);
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(
      err["code"] as FunctionsErrorCode,
      err["message"]
    );
  }
  return result;
});

/** Challenges the previous player's claimed rank. */
export const challenge = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await challengeAction(db(), data);
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(
      err["code"] as FunctionsErrorCode,
      err["message"]
    );
  }
  return result;
});

/** Passes the current player's turn. */
export const passTurn = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await passTurnAction(db(), data);
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(
      err["code"] as FunctionsErrorCode,
      err["message"]
    );
  }
  return result;
});

/** Forfeits a player and removes them from the active game. */
export const leaveMatch = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be logged in.");
  }
  const data = (request.data ?? {}) as Record<string, unknown>;
  const result = await leaveMatchAction(db(), data, { auth: request.auth });
  if (result["success"] === false) {
    const err = result["error"] as Record<string, string>;
    throw new HttpsError(
      err["code"] as FunctionsErrorCode,
      err["message"]
    );
  }
  return result;
});

export { onUserCreated } from "./actions/on_user_created";
