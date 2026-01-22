import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListTile extends ConsumerWidget {
  final UserModel user;
  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      // profile picture or fallback(first letter of name)
      leading: CircleAvatar(
        radius: 60,
        backgroundImage: user.photoURL != null
            ? NetworkImage(user.photoURL!)
            : null,
        child: user.photoURL == null
            ? Text(user.name.isNotEmpty ? user.name[0].toLowerCase() : "U")
            : null,
      ),
      title: Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
