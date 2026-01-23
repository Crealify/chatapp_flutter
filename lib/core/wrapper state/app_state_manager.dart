import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// class AppStateManager extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isInitialized = false;
//   AppStateManager() {
//     // Initialized session when class is created
//     Future<void> initializeUserSession() async {
//       if (_isInitialized) return;

//       final user = _auth.currentUser;
//       if (user == null) return;

//       try {
//         final userDoc = _firestore.collection("user").doc(user.uid);
//         final snapshot = await userDoc.get();
//         // if user doc doesn't exist => create new
//         if (!snapshot.exists) {
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
//           //if exists -> just update online status + lastSeen
//           await userDoc.update({
//             'isOnline': false,
//             "lastSeen": FieldValue.serverTimestamp(),
//           });
//         }
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//   }
// }

final AppStateManagerProvider = ChangeNotifierProvider<AppStateManager>((ref) {
  return AppStateManager();
});

class AppStateManager extends ChangeNotifier with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isInitialized = false;

  AppStateManager() {
    //listen to app lifecycle change(remuse, pause, etc )
    WidgetsBinding.instance.addObserver(this);
    // initialize session when class is created
    initializeUserSession(); //  CALL IT
  }
  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    _setOnlineStatus(false); //mark userr offline on dispose

    super.dispose();
  }

  // ===== handle app lifecycle to update online/offline
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _setOnlineStatus(true); // mark online when resumed
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _setOnlineStatus(false); //mark online otherwise
        break;
      default:
        break;
    }
  }

  //Initialize user session(runs once per app start)

  Future<void> initializeUserSession() async {
    if (_isInitialized) return;

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userDoc = _firestore.collection("users").doc(user.uid);
      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoURL': user.photoURL ?? '',
          // 'provider': 'google',
          'provider': _getProvider(user),
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await userDoc.update({
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print("Error initializing session: $e");
      _isInitialized = true;
      // debugPrint('Firestore error: $e');
    }
  }

  // set user online/offline
  Future<void> _setOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await _firestore.collection("users").doc(user.uid).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating online status : $e");
      // return e.toString()
    }
  }

  //public method to manually set online status
  Future<void> updateOnlinestatus(bool isOnline) async {
    await _setOnlineStatus(isOnline);
  }

  // detects which provider user used (google or email)
  String _getProvider(User user) {
    for (final info in user.providerData) {
      if (info.providerId == "google.com") return 'google';
      if (info.providerId == "password") return 'email';
    }
    return 'email';
  }

  bool get isInitialized => _isInitialized;
}
