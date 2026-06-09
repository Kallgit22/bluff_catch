import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // Uncomment when fully tested

import '../../../../core/errors/firebase_failure.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<Either<FirebaseFailure, User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return Right(userCredential.user!);
      } else {
        return const Left(FirebaseFailure(message: 'User is null after sign in.'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, User>> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return Right(userCredential.user!);
      } else {
        return const Left(FirebaseFailure(message: 'User is null after registration.'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Left(FirebaseFailure(message: 'Google sign in aborted by user.'));
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        return Right(userCredential.user!);
      } else {
        return const Left(FirebaseFailure(message: 'User is null after Google sign in.'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, User>> signInWithApple() async {
    try {
      // NOTE: sign_in_with_apple requires iOS/macOS setup. Using Firebase's built-in provider for web/generic support.
      final appleProvider = AppleAuthProvider();
      final userCredential = await _firebaseAuth.signInWithProvider(appleProvider);
      
      if (userCredential.user != null) {
        return Right(userCredential.user!);
      } else {
        return const Left(FirebaseFailure(message: 'User is null after Apple sign in.'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, User>> signInWithCredential(
      AuthCredential credential) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        return Right(userCredential.user!);
      } else {
        return const Left(FirebaseFailure(message: 'User is null after credential sign in.'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
