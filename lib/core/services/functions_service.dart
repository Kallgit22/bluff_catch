import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../errors/firebase_failure.dart';

/// A thin wrapper around [FirebaseFunctions] that calls HTTPS callable
/// functions and returns [Either<FirebaseFailure, dynamic>].
class FunctionsService {
  final FirebaseFunctions _functions;

  FunctionsService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  /// Calls a named HTTPS callable Cloud Function.
  ///
  /// [name] — the function name as deployed.
  /// [parameters] — optional data payload sent to the function.
  /// [timeout] — optional per-call timeout override.
  ///
  /// Returns [Right] with the response data on success, or [Left] with a
  /// [FirebaseFailure] on error.
  Future<Either<FirebaseFailure, dynamic>> callFunction(
    String name, {
    Map<String, dynamic>? parameters,
    Duration? timeout,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        name,
        options: timeout != null ? HttpsCallableOptions(timeout: timeout) : null,
      );

      final result = await callable.call<dynamic>(parameters);
      return Right(result.data);
    } on FirebaseFunctionsException catch (e, st) {
      debugPrint('FunctionsService.callFunction($name) error: ${e.code} — ${e.message}');
      return Left(_mapFunctionsException(e, st));
    } catch (e, st) {
      debugPrint('FunctionsService.callFunction($name) unexpected error: $e');
      return Left(FirebaseFailure.fromException(e, st));
    }
  }

  /// Maps a [FirebaseFunctionsException] to a [FirebaseFailure] using its
  /// gRPC-style status code.
  FirebaseFailure _mapFunctionsException(
    FirebaseFunctionsException e,
    StackTrace st,
  ) {
    switch (e.code) {
      case 'permission-denied':
      case 'unauthenticated':
        return FirebaseFailure.permissionDenied(details: e.message);
      case 'not-found':
        return FirebaseFailure.notFound(details: e.message);
      case 'unavailable':
        return FirebaseFailure.unavailable(details: e.message);
      case 'deadline-exceeded':
        return FirebaseFailure.timeout(details: e.message);
      case 'already-exists':
        return FirebaseFailure.alreadyExists(details: e.message);
      default:
        return FirebaseFailure(
          message: e.message ?? 'Cloud Function error: ${e.code}',
          code: e.code,
          stackTrace: st,
        );
    }
  }
}
