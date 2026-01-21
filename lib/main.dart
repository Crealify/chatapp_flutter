import 'package:chatapp_flutter/auth/screen/user_login_screen.dart';
import 'package:chatapp_flutter/core/wrapper%20state/auth_wrapper.dart';
import 'package:chatapp_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat/provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();//r_dotenv does NOT automatically know the file name.
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: ChatApp()));
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
