import * as admin from "firebase-admin";
import {
  ROOMS_COLLECTION,
  errorResponse,
  successResponse,
} from "./match_helpers";

function generateRoomId(): string {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let result = "";
  for (let i = 0; i < 6; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

export async function createRoom(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>,
  context?: any
): Promise<Record<string, unknown>> {
  const uid = context?.auth?.uid;
  if (!uid) {
    return errorResponse("unauthenticated", "User must be logged in.");
  }

  // Read user profile
  const userDoc = await db.collection("users").doc(uid).get();
  const userData = userDoc.data() || {};
  const displayName = userData["displayName"] || "Player";
  const avatarUrl = userData["avatarUrl"] || "avatar_1";
  const points = userData["points"] || 0;

  let roomId = generateRoomId();
  let roomRef = db.collection(ROOMS_COLLECTION).doc(roomId);

  // Simple collision check
  let exists = (await roomRef.get()).exists;
  let attempts = 0;
  while (exists && attempts < 5) {
    roomId = generateRoomId();
    roomRef = db.collection(ROOMS_COLLECTION).doc(roomId);
    exists = (await roomRef.get()).exists;
    attempts++;
  }

  if (exists) {
    return errorResponse("internal", "Failed to generate unique room ID.");
  }

  const now = admin.firestore.FieldValue.serverTimestamp();
  const arrayNow = admin.firestore.Timestamp.now();

  await roomRef.set({
    roomId,
    status: "waiting",
    hostUid: uid,
    maxPlayers: 10,
    createdAt: now,
    players: [
      {
        uid,
        displayName,
        avatarUrl,
        points,
        isHost: true,
        isReady: true,
        joinedAt: arrayNow,
        lastSeen: arrayNow,
        isOnline: true,
      },
    ],
  });

  console.log(JSON.stringify({
    event: "room_creation",
    roomId,
    hostUid: uid,
    status: "success",
  }));

  return successResponse(undefined, { roomId });
}
