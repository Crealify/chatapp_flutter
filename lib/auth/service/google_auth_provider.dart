// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:youtube_clone/features/auth/model/user_model.dart';
// import 'package:youtube_clone/features/auth/repository/user_data_service.dart';

// final currentUserProvider = FutureProvider<UserModel>((ref) async {
//   final UserModel user = await ref
//       .watch(userDataServiceProvider)
//       .fetchCurrentUserData();
//   return user;
// });

// //here simple provider is not userful so we need family provider
// final anyUserDataProvider = FutureProvider.family((ref, userId) async {
//   final UserModel user = await ref
//       .watch(userDataServiceProvider)
//       .fetchAnyUserData(userId);
//   return user;
// });

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:youtube_clone/features/auth/model/user_model.dart';

// final userDataServiceProvider = Provider(
//   (ref) => UserDataService(
//     auth: FirebaseAuth.instance,
//     firestore: FirebaseFirestore.instance,
//   ),
// );

// class UserDataService {
//   FirebaseAuth auth;
//   FirebaseFirestore firestore;
//   UserDataService({required this.auth, required this.firestore});
//   addUserDataToFirestore({
//     required String displayName,
//     required String username,
//     required String email,
//     required String profilePic,
//     required String description,
//   }) async {
//     UserModel user = UserModel(
//       displayName: displayName,
//       username: username,
//       email: email,
//       profilePic: profilePic,
//       subscriptions: [],
//       videos: 0,
//       userId: auth.currentUser!.uid,
//       description: description,
//       type: "user",
//     );

//     await firestore
//         .collection("users")
//         .doc(auth.currentUser!.uid)
//         .set(user.toMap());
//   }

//   Future<UserModel> fetchCurrentUserData() async {
//     final currentUserMap = await firestore
//         .collection("users")
//         .doc(auth.currentUser!.uid)
//         .get();
//     UserModel user = UserModel.fromMap(currentUserMap.data()!);
//     return user;
//   }

//   Future<UserModel> fetchAnyUserData(userId) async {
//     final currentUserMap = await firestore
//         .collection("users")
//         .doc(userId)
//         .get();
//     UserModel user = UserModel.fromMap(currentUserMap.data()!);
//     return user;
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// // Google Sign-In Service Class
// class GoogleSignInService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//   static bool isInitialize = false;
//   static Future<void> initSignIn() async {
//     if (!isInitialize) {
//       await _googleSignIn.initialize(
//         serverClientId:
//             '745796263660-23s0nr69rk2c26c13i76qo5dtvt6abdp.apps.googleusercontent.com',
//       );
//     }
//     //Google-service.json ko oAuth ko
//     //  {
//     //       "client_id": "745796263660-23s0nr69rk2c26c13i76qo5dtvt6abdp.apps.googleusercontent.com",
//     //       "client_type": 3
//     //     }

//     isInitialize = true;
//   }

//   // Sign in with Google
//   static Future<UserCredential?> signInWithGoogle() async {
//     try {
//       initSignIn();
//       final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
//       final idToken = googleUser.authentication.idToken;
//       final authorizationClient = googleUser.authorizationClient;
//       GoogleSignInClientAuthorization? authorization = await authorizationClient
//           .authorizationForScopes(['email', 'profile']);
//       final accessToken = authorization?.accessToken;
//       if (accessToken == null) {
//         final authorization2 = await authorizationClient.authorizationForScopes(
//           ['email', 'profile'],
//         );
//         if (authorization2?.accessToken == null) {
//           throw FirebaseAuthException(code: "error", message: "error");
//         }
//         authorization = authorization2;
//       }
//       final credential = GoogleAuthProvider.credential(
//         accessToken: accessToken,
//         idToken: idToken,
//       );
//       final UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithCredential(credential);
//       final User? user = userCredential.user;
//       if (user != null) {
//         final userDoc = FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid);
//         final docSnapshot = await userDoc.get();
//         if (!docSnapshot.exists) {
//           await userDoc.set({
//             'uid': user.uid,
//             'name': user.displayName ?? '',
//             'email': user.email ?? '',
//             'photoURL': user.photoURL ?? '',
//             'provider': 'google',
//             'isOnline': true, // set online when signing in
//             'lastSeen': FieldValue.serverTimestamp(),
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         } else {
//           //update online Status for existing user
//           await userDoc.update({
//             'isOnline': false,
//             "lastSeen": FieldValue.serverTimestamp(),
//           });
//         }
//       }
//       return userCredential;
//     } catch (e) {
//       print('Error: $e');
//       rethrow;
//     }
//   }

//   // Sign out
//   static Future<void> signOut() async {
//     try {
//       //Set offine before sigining out
//       if (_auth.currentUser != null) {
//         await FirebaseFirestore.instance
//             .collection('user')
//             .doc(_auth.currentUser!.uid)
//             .update({
//               'isOnline': false,
//               "lastSeen": FieldValue.serverTimestamp(),
//             });
//       }
//       // Uninitialize ZegoCloud before signin out
//       // await CallService.unitializeZego();
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//     } catch (e) {
//       print('Error signing out: $e');
//       // throw e;
//       rethrow;
//     }
//   }

//   // // Get current user
//   // static User? getCurrentUser() {
//   //   return _auth.currentUser;
//   // }
// }
