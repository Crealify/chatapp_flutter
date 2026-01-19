import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Google Sign-In Service Class
class GoogleSignInService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool isInitialize = false;
  static Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(
        serverClientId:
            '745796263660-23s0nr69rk2c26c13i76qo5dtvt6abdp.apps.googleusercontent.com',
      );
    }
    //Google-service.json ko oAuth ko
    //  {
    //       "client_id": "745796263660-23s0nr69rk2c26c13i76qo5dtvt6abdp.apps.googleusercontent.com",
    //       "client_type": 3
    //     }

    isInitialize = true;
  }

  // Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      initSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final accessToken = authorization?.accessToken;
      if (accessToken == null) {
        final authorization2 = await authorizationClient.authorizationForScopes(
          ['email', 'profile'],
        );
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(code: "error", message: "error");
        }
        authorization = authorization2;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'photoURL': user.photoURL ?? '',
            'provider': 'google',
            'isOnline': true, // set online when signing in
            'lastSeen': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          //update online Status for existing user
          await userDoc.update({
            'isOnline': false,
            "lastSeen": FieldValue.serverTimestamp(),
          });
        }
      }
      return userCredential;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      //Set offine before sigining out
      if (_auth.currentUser != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(_auth.currentUser!.uid)
            .update({
              'isOnline': false,
              "lastSeen": FieldValue.serverTimestamp(),
            });
      }
      // Uninitialize ZegoCloud before signin out
      // await CallService.unitializeZego();
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      // throw e;
      rethrow;
    }
  }

  // // Get current user
  // static User? getCurrentUser() {
  //   return _auth.currentUser;
  // }
}
