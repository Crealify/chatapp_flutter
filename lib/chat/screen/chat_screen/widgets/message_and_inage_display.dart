import 'package:chatapp_flutter/core/utils/time_format.dart';
import 'package:flutter/material.dart';

import '../../../model/message_model.dart';
import '../chat_screen.dart';

class MessageAndInageDisplay extends StatelessWidget {
  const MessageAndInageDisplay({
    super.key,
    required this.isMe,
    required this.widget,
    required this.message,
  });

  final bool isMe;
  final ChatScreen widget;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
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
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: message.type == "image" ? 8 : 10,
                vertical: message.type == "image" ? 4 : 10,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.white : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Image to display
                  //Text message(for regular message or image capitons)
                  if (message.message.isNotEmpty)
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),

                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatedMessageTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                      if(isMe)...[
                        SizedBox(
                          width:4
                        )
                        //======= Message Status Icons
                        
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
