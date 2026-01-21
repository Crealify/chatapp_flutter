//======== now lets display all available user on the app  ==========

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  Future<void> onRefresh() async {
    //clear friendship cache before refreshing
    // wait a vit for the provider to refresh
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: true,
        title: Text("All Users"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      // body: RefreshIndicator(child: child, onRefresh: onRefresh),
    );
  }
}
