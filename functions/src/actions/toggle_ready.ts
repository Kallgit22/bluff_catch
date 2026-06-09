import * as admin from "firebase-admin";
import {
  ROOMS_COLLECTION,
  errorResponse,
  successResponse,
} from "./match_helpers";

export async function toggleReady(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>,
  context?: any
): Promise<Record<string, unknown>> {
  const uid = context?.auth?.uid;
  if (!uid) {
    return errorResponse("unauthenticated", "User must be logged in.");
  }

  const roomId = data["roomId"] as string | undefined;
  if (!roomId || roomId.trim() === "") {
    return errorResponse("invalid-argument", "roomId is required.");
  }

  const roomRef = db.collection(ROOMS_COLLECTION).doc(roomId);

  return await db.runTransaction(async (t) => {
    const doc = await t.get(roomRef);
    if (!doc.exists) {
      throw new Error("not-found:Room not found.");
    }

    const roomData = doc.data()!;
    if (roomData["status"] !== "waiting") {
      throw new Error("failed-precondition:Room is no longer waiting.");
    }

    const players = (roomData["players"] || []) as any[];
    const playerIndex = players.findIndex((p) => p.uid === uid);
    
    if (playerIndex === -1) {
      throw new Error("not-found:Player not in room.");
    }

    const newState = !players[playerIndex].isReady;
    players[playerIndex].isReady = newState;
    players[playerIndex].lastSeen = admin.firestore.Timestamp.now();

    t.update(roomRef, { players });
    
    return successResponse(undefined, { isReady: newState });
  }).catch((e) => {
    const msg = e.message as string;
    if (msg.includes(":")) {
      const parts = msg.split(":");
      return errorResponse(parts[0], parts[1]);
    }
    return errorResponse("internal", msg);
  });
}
