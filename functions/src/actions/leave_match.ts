import * as admin from "firebase-admin";
import {GameEngine} from "../engine/game_engine";
import {
  ROOMS_COLLECTION,
  errorResponse,
  runGameTransaction,
  successResponse,
} from "./match_helpers";

export async function leaveMatch(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>,
  context?: any
): Promise<Record<string, unknown>> {
  const uid = context?.auth?.uid;
  if (!uid) {
    return errorResponse("unauthenticated", "User must be logged in.");
  }

  const matchId = data["matchId"] as string | undefined;
  // Handle fallback if frontend sends roomId as matchId
  const roomId = data["roomId"] as string | undefined;
  const targetId = matchId || roomId;

  if (!targetId || targetId.trim() === "") {
    return errorResponse("invalid-argument", "matchId or roomId is required.");
  }

  // 1. Try to leave a waiting room first
  const roomRef = db.collection(ROOMS_COLLECTION).doc(targetId);
  try {
    const leftRoom = await db.runTransaction(async (t) => {
      const doc = await t.get(roomRef);
      if (!doc.exists) {
        return false;
      }
      const roomData = doc.data()!;
      if (roomData["status"] !== "waiting") {
        return false; // Let it fall through to game engine logic if it's "playing"
      }

      let players = (roomData["players"] || []) as any[];
      const playerIndex = players.findIndex((p) => p.uid === uid);
      if (playerIndex === -1) {
        throw new Error("not-found:Player not in room.");
      }

      const isHost = players[playerIndex].isHost;
      players.splice(playerIndex, 1);

      if (players.length === 0 || isHost) {
        t.delete(roomRef);
        return true;
      }

      t.update(roomRef, { players });
      return true;
    });

    if (leftRoom) {
      return successResponse();
    }
  } catch (e: any) {
    const msg = e.message as string;
    if (msg.includes(":")) {
      const parts = msg.split(":");
      return errorResponse(parts[0], parts[1]);
    }
    return errorResponse("internal", msg);
  }

  // 2. If it wasn't a waiting room, it must be an active match
  try {
    const newState = await runGameTransaction(db, targetId, (gameState) => {
      return GameEngine.forfeitPlayer({
        state: gameState,
        playerId: uid, // We now use actual UIDs
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
      return errorResponse("internal", e.message);
    }
    return errorResponse("internal", `Unexpected error: ${e}`);
  }
}
