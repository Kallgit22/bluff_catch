import 'package:dartz/dartz.dart';

import '../errors/firebase_failure.dart';

/// Abstract repository for game-related Firestore operations.
///
/// This contract contains no Firebase imports — it is purely domain-facing.
/// Concrete implementations (e.g. [FirestoreGameRepository]) handle the
/// actual data source interaction.
abstract class GameRepository {
  /// Persists a new game document.
  Future<Either<FirebaseFailure, void>> createGame(
    String gameId,
    Map<String, dynamic> data,
  );

  /// Retrieves a game document by its [gameId].
  Future<Either<FirebaseFailure, Map<String, dynamic>>> getGame(String gameId);

  /// Merges updated fields into an existing game document.
  Future<Either<FirebaseFailure, void>> updateGame(
    String gameId,
    Map<String, dynamic> data,
  );

  /// Deletes a game document.
  Future<Either<FirebaseFailure, void>> deleteGame(String gameId);

  /// Streams real-time updates for a single game document.
  Stream<Either<FirebaseFailure, Map<String, dynamic>>> streamGame(String gameId);
}
