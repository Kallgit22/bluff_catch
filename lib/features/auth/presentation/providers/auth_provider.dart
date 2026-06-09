import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';

/// Provides the instance of FirebaseAuth.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provides the instance of GoogleSignIn.
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

/// Provides the AuthRepository implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

/// Stream provider for the authentication state.
/// Emits [User] when logged in, null when logged out.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Provider for the currently logged in user. 
/// Can be used synchronously when the stream has already emitted a value.
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});
