import 'package:dartz/dartz.dart';

import '../errors/firebase_failure.dart';
import '../services/firestore_service.dart';
import 'game_repository.dart';

/// Concrete [GameRepository] backed by Firestore via [FirestoreService].
///
/// All reads/writes target the `games` collection. The collection name is
/// kept as a private constant so it can be changed in one place.
class FirestoreGameRepository implements GameRepository {
  static const _collection = 'games';

  final FirestoreService _firestoreService;

  FirestoreGameRepository({required FirestoreService firestoreService})
      // ignore: prefer_initializing_formals
      : _firestoreService = firestoreService;

  @override
  Future<Either<FirebaseFailure, void>> createGame(
    String gameId,
    Map<String, dynamic> data,
  ) {
    return _firestoreService.setDocument(_collection, gameId, data);
  }

  @override
  Future<Either<FirebaseFailure, Map<String, dynamic>>> getGame(String gameId) {
    return _firestoreService.getDocument(_collection, gameId);
  }

  @override
  Future<Either<FirebaseFailure, void>> updateGame(
    String gameId,
    Map<String, dynamic> data,
  ) {
    return _firestoreService.updateDocument(_collection, gameId, data);
  }

  @override
  Future<Either<FirebaseFailure, void>> deleteGame(String gameId) {
    return _firestoreService.deleteDocument(_collection, gameId);
  }

  @override
  Stream<Either<FirebaseFailure, Map<String, dynamic>>> streamGame(
    String gameId,
  ) {
    return _firestoreService.streamDocument(_collection, gameId);
  }
}
