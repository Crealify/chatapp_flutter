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
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          if (!isMe) ...[
            CircleAvatar(
              // radius: 60,
              backgroundImage: widget.otherUser.photoURL != null
                  ? NetworkImage(widget.otherUser.photoURL!)
                  : null,
              child: widget.otherUser.photoURL == null
                  ? Text(
                      widget.otherUser.name.isNotEmpty
                          ? widget.otherUser.name[0].toLowerCase()
                          : "U",
                    )
                  : null,
            ),
            SizedBox(width: 8),
          ],
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(100),
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isVideo ? Icons.videocam : Icons.call),
                SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMissed
                          ? (isMe ? "Call not Answered" : "Missed Call")
                          : "${isVideo ? 'Video' : 'Audio'} call",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      formatedMessageTime(message.timestamp),
                      style: TextStyle(
                        color: Colors.green.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isMe) SizedBox(width: 8),
        ],
      ),
    );
  }
}
