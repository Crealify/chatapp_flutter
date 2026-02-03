import 'package:chatapp_flutter/chat/provider/user_status_provider.dart';
import 'package:chatapp_flutter/chat/screen/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserChatProfile extends StatelessWidget {
  final ChatScreen widget;
  const UserChatProfile({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final statusAsync = ref.watch(userStatusProvider(widget.otherUser.uid));

        return statusAsync.when(
          data: (isOnline) => Row(
            children: [
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
              // SizedBox(height: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.otherUser.name, style: TextStyle(fontSize: 16)),

                    // for typing indicator we well work some time later
                  ],
                ),
              ),
            ],
          ),
          loading: () => Text(widget.otherUser.name),
          error: (error, stackTrace) => Text(widget.otherUser.name),
        );
      },
    );
  }
}
