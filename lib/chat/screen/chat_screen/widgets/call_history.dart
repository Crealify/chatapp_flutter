// import 'package:chatapp_flutter/chat/model/message_model.dart';
// import 'package:chatapp_flutter/core/utils/time_format.dart';
// import 'package:flutter/material.dart';

// import '../chat_screen.dart';

// class CallHistory extends StatelessWidget {
//   final bool isMe;
//   final ChatScreen widget;
//   final bool isMissed;
//   final bool isVideo;
//   final MessageModel message;
//   const CallHistory({
//     super.key,
//     required this.isMe,
//     required this.widget,
//     required this.isMissed,
//     required this.isVideo,
//     required this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Row(
//         mainAxisAlignment: isMe
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start,
//         children: [
//           if (!isMe) ...[
//             CircleAvatar(
//               // radius: 60,
//               backgroundImage: widget.otherUser.photoURL != null
//                   ? NetworkImage(widget.otherUser.photoURL!)
//                   : null,
//               child: widget.otherUser.photoURL == null
//                   ? Text(
//                       widget.otherUser.name.isNotEmpty
//                           ? widget.otherUser.name[0].toLowerCase()
//                           : "U",
//                     )
//                   : null,
//             ),
//             SizedBox(width: 8),
//           ],
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.green.withAlpha(10),
//               border: Border.all(color: Colors.green, width: 1),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   isVideo ? Icons.videocam : Icons.call,
//                   color: Colors.green,
//                 ),
//                 SizedBox(width: 6),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       isMissed
//                           ? (isMe ? "Call not Answered" : "Miss Call")
//                           : "${isVideo ? 'Video' : 'Audio'} call",
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12,
//                       ),
//                     ),
//                     Text(
//                       formatedMessageTime(message.timestamp),
//                       style: TextStyle(
//                         color: Colors.green.withOpacity(0.7),
//                         fontSize: 10,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (isMe) SizedBox(width: 8),
//         ],
//       ),
//     );
//   }
// }
import 'package:chatapp_flutter/chat/model/message_model.dart';
import 'package:chatapp_flutter/core/utils/time_format.dart';
import 'package:flutter/material.dart';

import '../chat_screen.dart';

class CallHistory extends StatelessWidget {
  final bool isMe;
  final ChatScreen widget;
  final bool isMissed;
  final bool isVideo;
  final MessageModel message;

  const CallHistory({
    super.key,
    required this.isMe,
    required this.widget,
    required this.isMissed,
    required this.isVideo,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: widget.otherUser.photoURL != null
                  ? NetworkImage(widget.otherUser.photoURL!)
                  : null,
              child: widget.otherUser.photoURL == null
                  ? Text(
                      widget.otherUser.name.isNotEmpty
                          ? widget.otherUser.name[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? Colors.green.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isMe
                    ? const Radius.circular(18)
                    : const Radius.circular(4),
                bottomRight: isMe
                    ? const Radius.circular(4)
                    : const Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isMissed
                      ? Colors.red.shade100
                      : Colors.green.shade100,
                  child: Icon(
                    isVideo ? Icons.videocam : Icons.call,
                    size: 16,
                    color: isMissed ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMissed
                          ? (isMe ? "Call not answered" : "Missed call")
                          : "${isVideo ? 'Video' : 'Audio'} call",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isMissed ? Colors.red : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatedMessageTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
