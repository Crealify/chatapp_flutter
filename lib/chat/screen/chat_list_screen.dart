import 'package:chatapp_flutter/chat/provider/provider.dart';
import 'package:chatapp_flutter/chat/screen/request_screen.dart';
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
  Future<void> _getRefresh() async {
    ref.invalidate(requestsProvider);
    // rf.invalidate(provider)
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final pendingrequest = ref.watch(requestsProvider);
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
      ),
    );
  }
}
