import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/firebase_failure.dart';

abstract class AuthRepository {
  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges;

  /// Get the current logged-in user.
  User? get currentUser;

  /// Sign in with Email and Password.
  Future<Either<FirebaseFailure, User>> signInWithEmailAndPassword(
      String email, String password);

  /// Register a new account with Email and Password.
  Future<Either<FirebaseFailure, User>> registerWithEmailAndPassword(
      String email, String password);

  /// Send a password reset email.
  Future<Either<FirebaseFailure, void>> sendPasswordResetEmail(String email);

  /// Sign in with Google.
  Future<Either<FirebaseFailure, User>> signInWithGoogle();

  /// Sign in with Apple.
  Future<Either<FirebaseFailure, User>> signInWithApple();

  /// Start Phone Number verification.
  /// This will trigger the verification flow and emit events to the callbacks.
  Future<Either<FirebaseFailure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  });

  /// Sign in with a phone credential (after getting the SMS code).
  Future<Either<FirebaseFailure, User>> signInWithCredential(
      AuthCredential credential);

  /// Sign out the current user.
  Future<Either<FirebaseFailure, void>> signOut();
}
