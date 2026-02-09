import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:chatapp_flutter/chat/screen/chat_screen/widgets/user_chat_profile.dart';
import 'package:chatapp_flutter/chat/screen/chat_screen/widgets/video_audio_call_button.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final UserModel otherUser;
  const ChatScreen({super.key, required this.chatId, required this.otherUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: UserChatProfile(widget: widget),

        // in appbar acitions: we will implemet video and audion call feature
        actions: [
          //audio call
          actionButton(false, widget.otherUser.uid, widget.otherUser.name),

          //video call
          actionButton(true, widget.otherUser.uid, widget.otherUser.name),
        ],
      ),
    );
  }
}
