import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:chatapp_flutter/chat/provider/provider.dart';
import 'package:chatapp_flutter/chat/screen/request_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../route.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  void initState() {
    // when screen loads, refresh chat and request providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(requestsProvider);
      // ref.invalidate(provider)
    });
    super.initState();
  }

  // manual refresh (pull-to-refresh action)
  Future<void> _onRefresh() async {
    ref.invalidate(requestsProvider);
    ref.invalidate(chatsProvider);

    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final pendingrequest = ref.watch(requestsProvider);
    final chats = ref.watch(chatsProvider);

    // count pending requests
    final requestCount = pendingrequest.when(
      data: (requests) => requests.length,
      loading: () => 0,
      error: (error, stackTrace) => 0,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text("Chats", style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          //Notification icon (only if there are pending request)
          if (requestCount > 0)
            IconButton(
              onPressed: () => NavigationHelper.push(context, RequestScreen()),
              icon: Stack(
                children: [
                  Icon(Icons.notifications),
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "$requestCount",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        //pull-to-refresh + chat list display
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: chats.when(
          //case 1; chats loaded sucessfully
          data: (chatsList) {
            if (chatsList.isEmpty) {
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 2000),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No chats yet",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            // if chats exists -> show chat list

            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: chatsList.length,
              itemBuilder: (context, index) {
                final chat = chatsList[index];

                //fetch other user details
                return FutureBuilder<UserModel?>(
                  future: _getOtherUser(chat.participants),
                  builder: (context, snaphot) {
                    if (!snaphot.hasData) return SizedBox();

                    final otherUser = snaphot.data!;
                    final currentUserId =
                        FirebaseAuth.instance.currentUser?.uid;
                    if (currentUserId == null) return SizedBox();
                    // count unread message

                    // show unread higlight if other user sent message

                    return ListView(
                      // user profile+ onlline offline status
                    );
                  },
                );
              },
            );
          },

          //case 2 : loading state
          loading: () => const Center(child: CircularProgressIndicator()),

          //case 3: error state
          error: (error, stackTrace) => ListView(
            children: [
              SizedBox(height: 200),
              Center(
                child: Column(
                  children: [
                    Text("Error: $error"),
                    SizedBox(height: 16),
                    ElevatedButton(onPressed: _onRefresh, child: Text("Retry")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///// ================ HELPER METHODS -> GET DETAILS OF OF OTHER IN THE CHATS ===========
  Future<UserModel?> _getOtherUser(List<String> participants) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return null;
    final otherUserId = participants.firstWhere((id) => id != currentUserId);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .get();
      // return doc
      return doc.exists ? UserModel.fromMap(doc.data()!) : null;
    } catch (e) {
      print("Error getting other user: $e");
      return null;
    }
  }
}
