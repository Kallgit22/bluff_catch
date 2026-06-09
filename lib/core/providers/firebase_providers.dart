import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/firestore_game_repository.dart';
import '../repositories/game_repository.dart';
import '../services/firestore_service.dart';
import '../services/functions_service.dart';

/// Provides a singleton [FirestoreService] instance.
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

/// Provides a singleton [FunctionsService] instance.
final functionsServiceProvider = Provider<FunctionsService>((ref) {
  return FunctionsService();
});

/// Provides a [GameRepository] backed by Firestore.
///
/// Consumers depend on the abstract [GameRepository] type, so swapping
/// the concrete implementation (e.g. for testing) requires only changing
/// this single provider.
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FirestoreGameRepository(firestoreService: firestoreService);
});
