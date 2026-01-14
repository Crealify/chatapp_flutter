import 'package:chatapp_flutter/auth/screen/user_login_screen.dart';
import 'package:chatapp_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserLoginScreen(),
      // home: GoogleLoginScreen(),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const ChatApp());
// }

// class ChatApp extends StatelessWidget {
//   const ChatApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Chat UI',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF0F172A),
//       ),
//       home: const ChatScreen(),
//     );
//   }
// }

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF020617),
//         title: Row(
//           children: [
//             const CircleAvatar(
//               backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=3"),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   "Alex Johnson",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Online",
//                   style: TextStyle(fontSize: 12, color: Colors.green),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: const [
//                 ChatBubble(message: "Hey! How’s your day going?", isMe: false),
//                 ChatBubble(
//                   message: "Pretty good 😊 Just working on my Flutter app!",
//                   isMe: true,
//                 ),
//                 ChatBubble(
//                   message: "Wow nice! Flutter UIs look amazing.",
//                   isMe: false,
//                 ),
//                 ChatBubble(
//                   message: "Yes! I’m building a beautiful chat app UI 😍",
//                   isMe: true,
//                 ),
//               ],
//             ),
//           ),
//           const MessageInputField(),
//         ],
//       ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String message;
//   final bool isMe;

//   const ChatBubble({super.key, required this.message, required this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.all(14),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         decoration: BoxDecoration(
//           gradient: isMe
//               ? const LinearGradient(
//                   colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                 )
//               : null,
//           color: isMe ? null : const Color(0xFF1E293B),
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: Radius.circular(isMe ? 18 : 0),
//             bottomRight: Radius.circular(isMe ? 0 : 18),
//           ),
//         ),
//         child: Text(message, style: const TextStyle(fontSize: 15)),
//       ),
//     );
//   }
// }

// class MessageInputField extends StatelessWidget {
//   const MessageInputField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       color: const Color(0xFF020617),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.add, color: Colors.white54),
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E293B),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: const TextField(
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: "Type a message...",
//                   hintStyle: TextStyle(color: Colors.white54),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Container(
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//               ),
//             ),
//             child: IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.send, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
