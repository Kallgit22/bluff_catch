import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  const db = admin.firestore();
  const uid = user.uid;
  const userRef = db.collection("users").doc(uid);

  // Use a transaction or simply set with merge to create if not exists
  await userRef.set(
    {
      uid: uid,
      email: user.email || null,
      displayName: user.displayName || "Player",
      avatarUrl: user.photoURL || "avatar_1",
      points: 1000, // starting points? The fallback was 0. I will just set 0 if they don't have it.
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true }
  );

  console.log(`User metadata created for: ${uid}`);
});
