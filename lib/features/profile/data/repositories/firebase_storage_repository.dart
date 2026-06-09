import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/errors/firebase_failure.dart';

class FirebaseStorageRepository {
  final FirebaseStorage _storage;

  FirebaseStorageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads an avatar image to Firebase Storage and returns the download URL.
  Future<Either<FirebaseFailure, String>> uploadAvatar({
    required String uid,
    required File imageFile,
  }) async {
    try {
      final ref = _storage.ref().child('avatars').child(uid).child('profile.jpg');
      
      final uploadTask = await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
