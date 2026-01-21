import 'package:chatapp_flutter/auth/screen/user_login_screen.dart';
import 'package:chatapp_flutter/auth/service/google_auth_service.dart';
import 'package:chatapp_flutter/chat/provider/user_profile_provider.dart';
import 'package:chatapp_flutter/core/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? lastUserId;
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final currentUser = FirebaseAuth.instance.currentUser;

    // check if user has changed and refresh if needed
    if (currentUser?.uid != lastUserId) {
      lastUserId = currentUser?.uid;
      //user addPostFrameCallBack to avoid  setstate during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          notifier.refresh();
        }
      });
    }
    if (profile.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () => notifier.refresh(),
            tooltip: "Refresh Profile",
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profile.photoUrl != null
                        ? NetworkImage(profile.photoUrl!)
                        : null,
                    child: profile.photoUrl == null
                        ? Icon(Icons.person, size: 30)
                        : null,
                  ),

                  Positioned(
                    bottom: 5,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        final success = await notifier.updateProfilePicture();
                        if (success && context.mounted) {
                          showAppSnackbar(
                            context: context,
                            type: SnackbarType.success,
                            description: "Profile picture change sucessfully!",
                          );
                        } else if (context.mounted) {
                          showAppSnackbar(
                            context: context,
                            type: SnackbarType.error,
                            description: "Failed to update profile pic",
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  if (profile.isUploading)
                    Positioned.fill(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                profile.name ?? "No Name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                profile.email ?? "Email",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              // Text(
              //   "Joined ${profile.createdAt != null ? DateTime("MM d,y").format(profile.createdAt!): "Joined data not availavble"},
              //   style: TextStyle(fontSize: 16, color: Colors.black54),
              // ),
              Text(
                profile.createdAt != null
                    ? "Joined ${DateFormat('MM d, y').format(profile.createdAt!)}"
                    : "Joined date not available",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),

              SizedBox(height: 20),
              MaterialButton(
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () async {
                  //show confirmation dialog begfore logging out
                  final shouldLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Logout"),
                      content: Text("Are you sure you want to LogOut?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Logout"),
                        ),
                      ],
                    ),
                  );
                  if (shouldLogout == true) {
                    //perform Logout //add google_auth_service
                    await FirebaseServices().signOut();
                    // Invalidate all provider
                    ref.invalidate(profileProvider);
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserLoginScreen(),
                        ),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
