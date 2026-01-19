import 'dart:async';

import 'package:chatapp_flutter/chat/screen/app_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_state_manager.dart';

class AuthenticationWrapper extends ConsumerStatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  ConsumerState<AuthenticationWrapper> createState() =>
      _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends ConsumerState<AuthenticationWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    _initializedSession();
    super.initState();
  }

  Future<void> _initializedSession() async {
    //after appstate manager is created then do try catch

    try {
      final appManager = ref.read(AppStateManagerProvider);

      // run session initialization with timeout(max 10s)
      await Future.any([
        appManager.initializeUserSession(),
        Future.delayed(
          const Duration(seconds: 10),
          () => throw TimeoutException('Session init time out'),
        ),
      ]);
      if (mounted) {
        setState(() {
          _isInitialized = true; // move to home screen after init
        });
      }
    } catch (e) {
      print("Error initialization session : $e");
      if (mounted) {
        //still allow moving forward even if init fails
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      //show loader untils user session is intialized
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Setting up your account..."),
            ],
          ),
        ),
      );
    }
    // once initialized ->go to main home screen
    return const MainHomeScreen();
  }
}
 //========= now keep user login function is working =======
// ========= it will login until logout after one time login ====