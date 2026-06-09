import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/firebase_failure.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class FirestoreProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore;

  FirestoreProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  @override
  Stream<UserProfile?> streamProfile(String uid) {
    return _usersCol.doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['uid'] = doc.id;
        return UserProfile.fromJson(data);
      }
      return null;
    });
  }

  @override
  Future<Either<FirebaseFailure, UserProfile?>> getProfile(String uid) async {
    try {
      final doc = await _usersCol.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['uid'] = doc.id;
        return Right(UserProfile.fromJson(data));
      }
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, UserProfile>> getOrCreateProfile(
    String uid, {
    String? email,
    String? name,
  }) async {
    try {
      final docRef = _usersCol.doc(uid);
      
      return await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists && snapshot.data() != null) {
          final currentData = snapshot.data()!;
          currentData['uid'] = docRef.id;
          // Just update lastLogin
          transaction.update(docRef, {
            'lastLogin': FieldValue.serverTimestamp(),
          });
          
          // Return the parsed profile (note: lastLogin in the returned object will be slightly stale, but it's fine)
          return Right(UserProfile.fromJson(currentData));
        } else {
          // Create new profile
          final newProfile = UserProfile.empty(uid, email: email, name: name);
          
          final data = newProfile.toJson();
          // Use server timestamp for precision in DB
          data['createdAt'] = FieldValue.serverTimestamp();
          data['lastLogin'] = FieldValue.serverTimestamp();
          
          transaction.set(docRef, data);
          return Right(newProfile);
        }
      });
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> updateProfile(
      String uid, Map<String, dynamic> data) async {
    try {
      await _usersCol.doc(uid).set(data, SetOptions(merge: true));
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> updateTheme(
      String uid, String themeId) async {
    return updateProfile(uid, {'theme': themeId});
  }
}
