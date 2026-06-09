import * as admin from "firebase-admin";
import {
  ROOMS_COLLECTION,
  errorResponse,
  successResponse,
} from "./match_helpers";

export async function joinRoom(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>,
  context?: any
): Promise<Record<string, unknown>> {
  const uid = context?.auth?.uid;
  if (!uid) {
    return errorResponse("unauthenticated", "User must be logged in.");
  }

  let roomId = data["roomId"] as string | undefined;
  if (!roomId || roomId.trim() === "") {
    return errorResponse("invalid-argument", "roomId is required.");
  }
  roomId = roomId.toUpperCase().trim();

  // Use a transaction to ensure atomic join
  const roomRef = db.collection(ROOMS_COLLECTION).doc(roomId);

  return await db.runTransaction(async (t) => {
    const doc = await t.get(roomRef);
    if (!doc.exists) {
      throw new Error("not-found:Room not found.");
    }

    const roomData = doc.data()!;
    if (roomData["status"] !== "waiting") {
      throw new Error("failed-precondition:Room is no longer waiting for players.");
    }

    const players = (roomData["players"] || []) as any[];
    if (players.length >= (roomData["maxPlayers"] || 10)) {
      throw new Error("failed-precondition:Room is full.");
    }

    // Check if player is already in room
    const existingPlayerIndex = players.findIndex((p) => p.uid === uid);
    if (existingPlayerIndex !== -1) {
      // Reconnect/update last seen
      players[existingPlayerIndex].isOnline = true;
      players[existingPlayerIndex].lastSeen = admin.firestore.Timestamp.now();
      t.update(roomRef, { players });
      return successResponse();
    }

    // Read user profile
    const userDoc = await t.get(db.collection("users").doc(uid));
    const userData = userDoc.data() || {};
    const displayName = userData["displayName"] || "Player";
    const avatarUrl = userData["avatarUrl"] || "avatar_1";
    const points = userData["points"] || 0;

    const arrayNow = admin.firestore.Timestamp.now();

    players.push({
      uid,
      displayName,
      avatarUrl,
      points,
      isHost: false,
      isReady: false,
      joinedAt: arrayNow,
      lastSeen: arrayNow,
      isOnline: true,
    });

    t.update(roomRef, { players });

    console.log(JSON.stringify({
      event: "player_insertion",
      roomId,
      playerUid: uid,
      status: "success",
    }));

    return successResponse();
  }).catch((e) => {
    const msg = e.message as string;
    if (msg.includes(":")) {
      const parts = msg.split(":");
      return errorResponse(parts[0], parts[1]);
    }
    return errorResponse("internal", msg);
  });
}
