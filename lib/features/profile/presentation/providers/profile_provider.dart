import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/firestore_profile_repository.dart';
import '../../data/repositories/firebase_storage_repository.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Provides the ProfileRepository instance.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return FirestoreProfileRepository();
});

/// Provides the FirebaseStorageRepository instance.
final storageRepositoryProvider = Provider<FirebaseStorageRepository>((ref) {
  return FirebaseStorageRepository();
});

/// A StreamProvider that listens to the current user's profile from Firestore.
final profileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream.value(null);
  }

  final repo = ref.watch(profileRepositoryProvider);
  return repo.streamProfile(user.uid);
});
