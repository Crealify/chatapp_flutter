import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  }
  //===== load user data form firestore ===========

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
          photoUrl:
              doc['photoURL'], // if one of filed name is incorrect then  this imformation is faield to reterive then user infomation is not shown on ui.
          name:
              doc['name'], // if photoURL in firebse doesnot have date it doesnot cause any problem just picture is not shown
          email: doc['email'],
          createdAt: (doc['createdAt'] as Timestamp?)?.toDate(),
          userId: currentUser.uid,
          // userId: doc['userId'],
          isLoading: false,
        );
      } else {
        state = ProfileState(userId: currentUser.uid, isLoading: false);
      }
    } catch (e) {
      print('Profile error: $e');
      state = ProfileState(userId: currentUser.uid, isLoading: false);
    }
  }

  //force refresh user data
  void refresh() {
    loadUserData();
  }

  // pick and upload new profile image
  // Future<bool> updateProfilePicture() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return false;

  //   final picker = ImagePicker();
  //   final pickerFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickerFile == null) return false;
  //   state = state.copyWith(isUploading: true);
  //   File file = File(pickerFile.path);
  //   try {
  //     // upload to firebase storage
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child("profile_picture")
  //         .child("${user.uid}.jpg");
  //     await storageRef.putFile(file);
  //     final newUrl = await storageRef.getDownloadURL();

  //     //update firestore
  //     await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
  //       {"photoURL": newUrl},
  //     );

  //     //update state
  //     state = state.copyWith(photoUrl: newUrl, isLoading: false);
  //     return true; //success
  //   } catch (e) {
  //     state = state.copyWith(isUploading: false);
  //     return false; // failed
  //   }
  // }

  // Future<String> updateProfilePicture(File file, String folder) async {
  //   try {
  //     final cloudinary = CloudinaryPublic('dsytr6bft', folder, cache: false);

  //     CloudinaryResponse response = await cloudinary.uploadFile(
  //       CloudinaryFile.fromFile(
  //         file.path,
  //         resourceType: folder == 'chatapp_flutter_images'
  //             ? CloudinaryResourceType.Video
  //             : CloudinaryResourceType.Image,
  //       ),
  //     );
  //     //this securedUrl is used to store the code in firebase document in  safe way in firestore of cloundniary
  //     return response.secureUrl;
  //   } catch (e) {
  //     throw Exception('Failed to upload file: $e');
  //   }
  // }
  Future<bool> updateProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickerFile == null) return false;

    state = state.copyWith(isUploading: true);

    try {
      final file = File(pickerFile.path);

      final cloudinaryImages = CloudinaryPublic(
        dotenv.env['CLOUDINARY_CLOUD_NAME']!,
        dotenv.env['CLOUDINARY_UPLOAD_PRESET']!,
      //go to cloudindary setting -> then upload -> create preset 
      //preset name: chatapp_flutter , unsigned and assests name: chatapp_flutter/images
        cache: false,
      );

      // 🔹 Upload image to Cloudinary
      final response = await cloudinaryImages.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
          folder: "chatapp_flutter/images", // ✅ REAL folder
        ),
      );

      final newUrl = response.secureUrl;

      // 🔹 Update Firestore (same as before)
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
        {"photoURL": newUrl},
      );

      // 🔹 Update local state
      state = state.copyWith(photoUrl: newUrl, isUploading: false);

      return true;
    } catch (e) {
      print("Cloudinary upload error: $e");
      state = state.copyWith(isUploading: false);
      return false;
    }
  }
  //   Future<File> pickImage() async {
  //   XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   File image = File(file!.path);
  //   return image;
  // }

  // Future pickVideo(context) async {
  //   XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);
  //   File video = File(file!.path);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return VideoDetailsPage(video: video);
  //       },
  //     ),
  //   );
  // }

  // Future pickShortVideo(context) async {
  //   XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);
  //   File video = File(file!.path);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return ShortVideoScreen(shortVideo: video);
  //       },
  //     ),
  //   );
  // }

  // Future<String> updateProfilePicture(File file, String folder) async {
  //   try {
  //     final cloudinary = CloudinaryPublic('dsytr6bft', folder, cache: false);

  //     CloudinaryResponse response = await cloudinary.uploadFile(
  //       CloudinaryFile.fromFile(
  //         file.path,
  //         resourceType: folder == 'youtube_clone_videos'
  //             ? CloudinaryResourceType.Video
  //             : CloudinaryResourceType.Image,
  //       ),
  //     );
  //     //this securedUrl is used to store the code in firebase document in  safe way in firestore of cloundniary
  //     return response.secureUrl;
  //   } catch (e) {
  //     throw Exception('Failed to upload file: $e');
  //   }
  // }

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
