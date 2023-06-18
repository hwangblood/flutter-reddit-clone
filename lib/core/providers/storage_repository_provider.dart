import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';

final storageRepositoryProvider = Provider<StorageRepository>(
  (ref) => StorageRepository(
    storage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _storage;

  StorageRepository({
    required FirebaseStorage storage,
  }) : _storage = storage;

  /// upload the image to firebase storage, and get the remote file url
  ///
  /// [path] folder path in firebase storage
  /// [id] id of the file
  ///
  /// Example: /users/banner/123asd123
  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _storage.ref().child(path).child(id);

      // TODO: using putData for web platform
      UploadTask uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      return right(url);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
