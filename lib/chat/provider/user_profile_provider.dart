import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_profile_model.dart';

// ================ provider  =================
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  late final StreamSubscription<User?> _authSubscription;

  ProfileNotifier() : super(ProfileState(isLoading: true)) {
    _listenToAuthChange();
  }
  //listen to firebase auth  state changes
  void _listenToAuthChange() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        //user loggen in load their data
        if (state.userId != user.uid) {
          //only reaload if it's a different user
          loadUserData();
        }
      } else {
        //user logged out_clear state
        state = ProfileState(isLoading: false);
      }
    });
  } // load user data form firestore

  Future<void> loadUserData([User? user]) async {
    final currentUser = user ?? FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      state = ProfileState(isLoading: false);
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        state = ProfileState(
          photoUrl: doc['photoURL'],
          name: doc['name'],
          email: doc['email'],
          createdAt: (doc['createdAt'] as Timestamp?)?.toDate(),
          userId: doc['userId'],
          isLoading: false,
        );
      } else {
        state = ProfileState(userId: currentUser.uid, isLoading: false);
      }
    } catch (e) {
      state = ProfileState(userId: currentUser.uid, isLoading: false);
    }
  }

  //force refresh user data
  void refresh() {
    loadUserData();
  }

  //pick and upload new profile image
  Future<bool> updateProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickerFile == null) return false;
    state = state.copyWith(isUploading: true);
    File file = File(pickerFile.path);
    try {
      // upload to firebase storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_picture")
          .child("${user.uid}.jpg");
      await storageRef.putFile(file);
      final newUrl = await storageRef.getDownloadURL();

      //update firestore
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
        {"photoURL": newUrl},
      );

      //update state
      state = state.copyWith(photoUrl: newUrl, isLoading: false);
      return true; //success
    } catch (e) {
      state = state.copyWith(isUploading: false);
      return false; // failed
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

// Future<void> getLostData() async {
//   final ImagePicker picker = ImagePicker();
//   final LostDataResponse response = await picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   final List<XFile>? files = response.files;
//   if (files != null) {
//     _handleLostFiles(files);
//   } else {
//     _handleError(response.exception);
//   }
// }
