import 'package:chatapp_flutter/chat/model/user_list_model.dart';
import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:chatapp_flutter/chat/provider/user_list_provider.dart';
import 'package:chatapp_flutter/chat/screen/chat_screen/chat_screen.dart';
import 'package:chatapp_flutter/core/utils/chat_id.dart';
import 'package:chatapp_flutter/core/utils/snackbar.dart';
import 'package:chatapp_flutter/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      return MaterialButton(
        color: Colors.green,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        onPressed: () => _navigateToChat(context),
        child: buttonName(Icons.chat, "chat"),
      );
    }
    //current users sent the request -> show "pending "
    if (state.requestStatus == "pending") {
      if (state.isRequestsender) {
        return ElevatedButton(
          onPressed: null,
          child: SizedBox(
            width: 100,
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pending_actions, color: Colors.black, size: 20),
                SizedBox(width: 5),
                Text(
                  "Pending",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // current user received the request -> show accept button
        return MaterialButton(
          color: Colors.orange,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
          onPressed: () async {
            final result = await notifer.acceptRequest();
            if (result == "success" && context.mounted) {
              showAppSnackbar(
                context: context,
                type: SnackbarType.success,
                description: "Request Accept!",
              );
            } else {
              if (context.mounted) {
                showAppSnackbar(
                  context: context,
                  type: SnackbarType.error,
                  description: "Failed: $result",
                );
              }
            }
          },
          child: buttonName(Icons.done, "Accept"),
        );
      }
    }
    // ==== default-> not friends ter -> show "add friend" button
    return MaterialButton(
      color: Colors.blueAccent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),

      onPressed: () async {
        final result = await notifer.sendRequest();
        if (result == "success" && context.mounted) {
          showAppSnackbar(
            context: context,
            type: SnackbarType.success,
            description: "Request Send Sucessfully!",
          );
        } else {
          if (context.mounted) {
            showAppSnackbar(
              context: context,
              type: SnackbarType.error,
              description: result,
            );
          }
        }
      },
      child: buttonName(Icons.person, "Add Friend"),
    );
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
  Future<void> _navigateToChat(BuildContext context) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = generateChatId(currentUserId, user.uid);
    NavigationHelper.push(context, ChatScreen(chatId: chatId, otherUser: user));
  }
}
