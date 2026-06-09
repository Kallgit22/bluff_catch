import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../errors/firebase_failure.dart';

/// A thin wrapper around [FirebaseFirestore] that provides generic CRUD
/// operations and returns [Either<FirebaseFailure, T>] for all results.
///
/// This service owns no domain knowledge — it simply moves maps in and out
/// of Firestore. Domain-specific logic belongs in repositories.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // Single document operations
  // ---------------------------------------------------------------------------

  /// Fetches a single document by [collection] and [docId].
  ///
  /// Returns [Right] with the document data map, or [Left] with a
  /// [FirebaseFailure] if the document doesn't exist or the call fails.
  Future<Either<FirebaseFailure, Map<String, dynamic>>> getDocument(
    String collection,
    String docId,
  ) async {
    try {
      final snapshot = await _firestore.collection(collection).doc(docId).get();

      if (!snapshot.exists || snapshot.data() == null) {
        return Left(FirebaseFailure.notFound(
          details: 'Document "$docId" not found in "$collection".',
        ));
      }

      return Right(snapshot.data()!);
    } catch (e, st) {
      debugPrint('FirestoreService.getDocument error: $e');
      return Left(FirebaseFailure.fromException(e, st));
    }
  }

  /// Creates or overwrites a document. Uses `set` with merge disabled so the
  /// document is fully replaced.
  Future<Either<FirebaseFailure, void>> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
      return const Right(null);
    } catch (e, st) {
      debugPrint('FirestoreService.setDocument error: $e');
      return Left(FirebaseFailure.fromException(e, st));
    }
  }

  /// Merges fields into an existing document without overwriting the whole doc.
  Future<Either<FirebaseFailure, void>> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
      return const Right(null);
    } catch (e, st) {
      debugPrint('FirestoreService.updateDocument error: $e');
      return Left(FirebaseFailure.fromException(e, st));
    }
  }

  /// Deletes a document.
  Future<Either<FirebaseFailure, void>> deleteDocument(
    String collection,
    String docId,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      return const Right(null);
    } catch (e, st) {
      debugPrint('FirestoreService.deleteDocument error: $e');
      return Left(FirebaseFailure.fromException(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // Collection queries
  // ---------------------------------------------------------------------------

  /// Queries a collection with an optional [queryBuilder] callback that
  /// receives the base [CollectionReference] and returns a refined [Query].
  ///
  /// Example:
  /// ```dart
  /// firestoreService.queryCollection(
  ///   'games',
  ///   queryBuilder: (ref) => ref.where('status', isEqualTo: 'active'),
  /// );
  /// ```
  Future<Either<FirebaseFailure, List<Map<String, dynamic>>>> queryCollection(
    String collection, {
    Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>>)?
        queryBuilder,
  }) async {
    try {
      final collectionRef = _firestore.collection(collection);
      final query = queryBuilder != null ? queryBuilder(collectionRef) : collectionRef;
      final snapshot = await query.get();

      final results = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      return Right(results);
    } catch (e, st) {
      debugPrint('FirestoreService.queryCollection error: $e');
      return Left(FirebaseFailure.fromException(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // Real-time streams
  // ---------------------------------------------------------------------------

  /// Streams a single document. Emits [Right] with the data on each snapshot,
  /// or [Left] if the document is missing / an error occurs.
  Stream<Either<FirebaseFailure, Map<String, dynamic>>> streamDocument(
    String collection,
    String docId,
  ) async* {
    try {
      await for (final snapshot in _firestore.collection(collection).doc(docId).snapshots()) {
        if (!snapshot.exists || snapshot.data() == null) {
          yield Left(FirebaseFailure.notFound(
            details: 'Document "$docId" not found in "$collection".',
          ));
        } else {
          yield Right(snapshot.data()!);
        }
      }
    } catch (e, st) {
      debugPrint('FirestoreService.streamDocument error: $e');
      yield Left(FirebaseFailure.fromException(e, st));
    }
  }

  /// Streams a collection query. Each emission contains all matching documents.
  Stream<Either<FirebaseFailure, List<Map<String, dynamic>>>> streamCollection(
    String collection, {
    Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>>)?
        queryBuilder,
  }) async* {
    final collectionRef = _firestore.collection(collection);
    final query = queryBuilder != null ? queryBuilder(collectionRef) : collectionRef;

    try {
      await for (final snapshot in query.snapshots()) {
        final results = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
        yield Right(results);
      }
    } catch (e, st) {
      debugPrint('FirestoreService.streamCollection error: $e');
      yield Left(FirebaseFailure.fromException(e, st));
    }
  }
}
