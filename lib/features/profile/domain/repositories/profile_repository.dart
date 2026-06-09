import 'package:dartz/dartz.dart';
import '../../../../core/errors/firebase_failure.dart';
import '../models/user_profile.dart';

abstract class ProfileRepository {
  /// Stream of a user's profile updates.
  Stream<UserProfile?> streamProfile(String uid);

  /// Fetch a user's profile by their UID.
  Future<Either<FirebaseFailure, UserProfile?>> getProfile(String uid);

  /// Create a new profile or return existing one.
  Future<Either<FirebaseFailure, UserProfile>> getOrCreateProfile(String uid, {String? email, String? name});

  /// Update specific fields in a user's profile.
  Future<Either<FirebaseFailure, void>> updateProfile(String uid, Map<String, dynamic> data);

  /// Update the user's selected theme.
  Future<Either<FirebaseFailure, void>> updateTheme(String uid, String themeId);
}
