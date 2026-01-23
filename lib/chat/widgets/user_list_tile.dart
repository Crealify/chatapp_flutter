import 'package:chatapp_flutter/chat/model/user_list_model.dart';
import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:chatapp_flutter/chat/provider/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListTile extends ConsumerWidget {
  final UserModel user;
  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userListProvider(user));
    final notifier = ref.read(userListProvider(user).notifier);
    return ListTile(
      // profile picture or fallback(first letter of name)
      leading: CircleAvatar(
        // radius: 60,
        backgroundImage: user.photoURL != null
            ? NetworkImage(user.photoURL!)
            : null,
        child: user.photoURL == null
            ? Text(user.name.isNotEmpty ? user.name[0].toLowerCase() : "U")
            : null,
      ),
      title: Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      //all userwill be display excepted itself
      //=========== show online / offline in sattuss
      subtitle: Text("Offline"), // we will fuction it sometime later
      // === Right-side action button(chat, add friend, accept request m etc)
      trailing: _buildTrailingWidget(context, ref, state, notifier),
    );
  }

  Widget _buildTrailingWidget(
    BuildContext context,
    WidgetRef ref,
    UserListTileState state,
    UsertListNotifier notifer,
  ) {
    if (state.isLoading) {
      //show loading spinner while checking status

      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    // =========== already friend  -> show 'chat' button =======
    if (state.areFriends) {
      return MaterialButton(onPressed: () {});
    }
  }

  SizedBox buttonName(IconData icon, String name) {
    return SizedBox(
      width: 100,
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),

          SizedBox(width: 5),
          Text(name, style: TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  //Navigator to  child screenwhen "Chat botton clicked"
}
