import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;
  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      final googleAuth = await googleAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // store user in Firebase Authentication
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      print(userCredential.user?.email);
      print(userCredential.user?.displayName);
    } catch (e) {
      print(e);
    }
  }
}
