import * as admin from "firebase-admin";
import {GameEngine} from "../engine/game_engine";
import {Player} from "../models/player";
import {DeckManager} from "../models/deck";
import {
  ROOMS_COLLECTION,
  errorResponse,
  successResponse,
} from "./match_helpers";

export async function startMatch(
  db: admin.firestore.Firestore,
  data: Record<string, unknown>,
  context?: any
): Promise<Record<string, unknown>> {
  const uid = context?.auth?.uid;
  if (!uid) {
    return errorResponse("unauthenticated", "User must be logged in.");
  }

  const matchId = data["matchId"] as string | undefined;
  if (!matchId || matchId.trim() === "") {
    return errorResponse("invalid-argument", "matchId is required.");
  }

  // Use transaction to atomically move from room -> match
  const roomRef = db.collection(ROOMS_COLLECTION).doc(matchId);
  
  return await db.runTransaction(async (t) => {
    const doc = await t.get(roomRef);
    if (!doc.exists) {
      throw new Error("not-found:Room not found.");
    }

    const roomData = doc.data()!;
    if (roomData["status"] !== "waiting") {
      throw new Error("failed-precondition:Room is not waiting.");
    }

    if (roomData["hostUid"] !== uid) {
      throw new Error("permission-denied:Only host can start match.");
    }

    const playersData = (roomData["players"] || []) as any[];
    if (playersData.length < 2) {
      throw new Error("failed-precondition:Need at least 2 players.");
    }

    const allReady = playersData.every((p) => p.isReady);
    if (!allReady) {
      throw new Error("failed-precondition:Not all players are ready.");
    }

    // Sort players by join order (optional but good for consistent seating)
    playersData.sort((a, b) => {
      const tA = a.joinedAt?.toMillis() || 0;
      const tB = b.joinedAt?.toMillis() || 0;
      return tA - tB;
    });

    const players: Player[] = [];
    for (let i = 0; i < playersData.length; i++) {
      players.push(new Player({
        playerId: playersData[i].uid, // ACTUALLY USE UID!
        playerName: playersData[i].displayName,
        avatarColor: 0xFF0000FF, // Could derive from avatar string
      }));
    }

    // --- Initialise game engine ---
    let gameState = GameEngine.initializeGame(players);

    // --- Generate and deal cards ---
    const deck = DeckManager.generateStandardDeck();
    DeckManager.shuffleDeck(deck);
    const hands = DeckManager.dealCards(deck, players.length);

    const newPlayers = gameState.players.map((p, i) =>
      p.copyWith({handCards: hands[i]})
    );

    gameState = gameState.copyWith({players: newPlayers});

    // Create match doc (using same ID as room, or we could update room)
    // Actually the design states matches/{matchId} holds the active game.
    // writeGameState already targets matches/{matchId}.
    // We cannot use writeGameState inside a transaction safely without t.set.
    
    // Instead of using the helper, we perform the writes here atomically:
    const matchRef = db.collection("matches").doc(matchId);
    t.set(matchRef, {
      gameState: gameState.toJson(),
      status: "playing",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Update room status
    t.update(roomRef, {
      status: "playing",
    });

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
