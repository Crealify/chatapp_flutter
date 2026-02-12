// //Builds the "message status" icon( online check)
// // depending on:
// // -who  sent the messae
// // whether receiver is online
// // - whether the message was read

import 'package:chatapp_flutter/chat/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildMessagesStatusIcon(MessageModel message, String uid) {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  // Only show status for messages sent by current user
  if (message.senderId != currentUserId) {
    return const SizedBox();
  }

  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
    builder: (context, userSnapshot) {
      bool isReceiverOnline = false;

      // Check if user document exists
      if (userSnapshot.hasData && userSnapshot.data!.exists) {
        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        isReceiverOnline = userData["isOnline"] ?? false;
      }

      // Check if receiver has read the message
      final isMessageRead = message.readyBy?.containsKey(uid) ?? false;

      if (isMessageRead) {
        // ✅ Message read → blue double tick
        return const Icon(Icons.done_all, size: 16, color: Colors.white);
      } else if (isReceiverOnline) {
        // ✅ Delivered (receiver online) → grey double tick
        return const Icon(Icons.done_all, size: 16, color: Colors.black54);
      } else {
        // ✅ Sent (receiver offline) → single tick
        return const Icon(Icons.check, size: 16, color: Colors.black54);
      }
    },
  );
}

// import 'package:chatapp_flutter/chat/model/message_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// Widget buildMessagesStatusIcon(MessageModel message, uid) {
//   final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//   //only show status for messages sent by current user
//   if (message.senderId != currentUserId) {
//     return SizedBox();
//   }
//   // listen to the receiver's (chat patner's ) user document
//   return StreamBuilder(
//     stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
//     builder: (context, userSnapshot) {
//       bool isReceiverOnline = false;
//       //check if user document exists and fetch 'isOnline' field
//       if (userSnapshot.hasData && userSnapshot.data!.exists) {
//         final userData = userSnapshot.data!.data() as Map<String, dynamic>;
//         isReceiverOnline = userData["isOnline"] ?? false;
//       }
//       //check if the receiver has read this message
//       final isMessageRead = message.readyBy?.containsKey(uid) ?? false;
//       if (isMessageRead) {
//         //message was ready by receiver that show two tick incon
//         return Icon(Icons.done_all, size: 16, color: Colors.white);
//       } else if (isReceiverOnline) {
//         // receiver is online but hasn't read then show two black tick icon
//         return Icon(Icons.done_all, size: 16, color: Colors.white);
//       } else {
//         // message deliverd but reciever  offline then show singel tick
//         return Icon(Icons.check, size: 16, color: Colors.black54);
//       }
//     },
//   );
// }
