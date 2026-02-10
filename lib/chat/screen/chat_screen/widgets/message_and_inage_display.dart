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
      ),
    );
  }
}
