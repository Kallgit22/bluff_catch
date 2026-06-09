import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

/// Represents a domain-level failure originating from Firebase operations.
///
/// Uses [Equatable] for value-based equality, making it easy to compare
/// and test failures.
class FirebaseFailure extends Equatable {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const FirebaseFailure({
    required this.message,
    this.code,
    this.stackTrace,
  });

  // ---------------------------------------------------------------------------
  // Named constructors for common failure types
  // ---------------------------------------------------------------------------

  /// The caller does not have permission to execute the operation.
  factory FirebaseFailure.permissionDenied({String? details}) {
    return FirebaseFailure(
      message: details ?? 'You do not have permission to perform this action.',
      code: 'permission-denied',
    );
  }

  /// The requested document or resource was not found.
  factory FirebaseFailure.notFound({String? details}) {
    return FirebaseFailure(
      message: details ?? 'The requested resource was not found.',
      code: 'not-found',
    );
  }

  /// The Firebase service is currently unavailable (network issues, etc.).
  factory FirebaseFailure.unavailable({String? details}) {
    return FirebaseFailure(
      message: details ?? 'Service is currently unavailable. Please try again later.',
      code: 'unavailable',
    );
  }

  /// The operation exceeded its deadline / timed out.
  factory FirebaseFailure.timeout({String? details}) {
    return FirebaseFailure(
      message: details ?? 'The operation timed out. Please try again.',
      code: 'deadline-exceeded',
    );
  }

  /// The caller has already performed this operation (duplicate write, etc.).
  factory FirebaseFailure.alreadyExists({String? details}) {
    return FirebaseFailure(
      message: details ?? 'The resource already exists.',
      code: 'already-exists',
    );
  }

  /// A catch-all for unrecognised errors.
  factory FirebaseFailure.unknown({String? details, StackTrace? stackTrace}) {
    return FirebaseFailure(
      message: details ?? 'An unknown error occurred.',
      code: 'unknown',
      stackTrace: stackTrace,
    );
  }

  // ---------------------------------------------------------------------------
  // Converter
  // ---------------------------------------------------------------------------

  /// Converts a raw [FirebaseException] into a typed [FirebaseFailure].
  static FirebaseFailure fromException(Object error, [StackTrace? stackTrace]) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return FirebaseFailure.permissionDenied(details: error.message);
        case 'not-found':
          return FirebaseFailure.notFound(details: error.message);
        case 'unavailable':
          return FirebaseFailure.unavailable(details: error.message);
        case 'deadline-exceeded':
          return FirebaseFailure.timeout(details: error.message);
        case 'already-exists':
          return FirebaseFailure.alreadyExists(details: error.message);
        default:
          return FirebaseFailure(
            message: error.message ?? 'Firebase error: ${error.code}',
            code: error.code,
            stackTrace: stackTrace,
          );
      }
    }

    return FirebaseFailure.unknown(
      details: error.toString(),
      stackTrace: stackTrace,
    );
  }

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'FirebaseFailure(code: $code, message: $message)';
}
