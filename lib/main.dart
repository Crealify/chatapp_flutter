import 'package:chatapp_flutter/auth/screen/user_login_screen.dart';
import 'package:chatapp_flutter/core/wrapper%20state/auth_wrapper.dart';
import 'package:chatapp_flutter/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'chat/provider/provider.dart';

/// 1.1.1 define a navigator key
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();//r_dotenv does NOT automatically know the file name.
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await requestPermission();

  //  /// 1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  final user = FirebaseAuth.instance.currentUser;
  final String userId = user?.uid ?? "000";
  final String userName = user?.displayName ?? "Guest";
  // call the useSystemCallingUI
  await ZegoUIKit().initLog().then((value) async {
    await ZegoUIKitPrebuiltCallInvitationService()
        .init(
          appID: int.parse(dotenv.env['appID']!),
          appSign: dotenv.env['appSign']!,
          // appID: ZegoConfig.appID,
          // appSign: ZegoConfig.appSign,
          //user id must be currently login id so
          userID: userId,
          userName: userName,
          plugins: [ZegoUIKitSignalingPlugin()],
          invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(),
        )
        .catchError((error) {
          print("Zego initialization error $error");
        });
  });

  runApp(ProviderScope(child: ChatApp()));
}

Future<void> requestPermission() async {
  await [
    Permission.camera,
    Permission.microphone,
    Permission.notification,
  ].request();
}

class ChatApp extends ConsumerStatefulWidget {
  const ChatApp({super.key});

  @override
  ConsumerState<ChatApp> createState() => _ChatappState();
}

class _ChatappState extends ConsumerState<ChatApp> {
  @override
  Widget build(BuildContext context) {
    // watching authStateProvider -> listens to firebase auth changes
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,

      home: authState.when(
        data: (User) {
          // if user is logged in, go to AuthenticationWrapper
          if (User != null) {
            return AuthenticationWrapper();
          } else {
            //if not logged in, goo to login screen
            return UserLoginScreen();
          }
        },
        error: (error, _) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text("Error: $error"),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(authStateProvider),
                  child: Text("Retry"),
                ),
              ],
            ),
          ),
        ),
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      // AuthenticationWrapper(),
      // home: UserLoginScreen(),
      // home: GoogleLoginScreen(),
    );
  }
}
