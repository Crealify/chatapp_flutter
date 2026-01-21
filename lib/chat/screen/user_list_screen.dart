//======== now lets display all available user on the app  ==========

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  Future<void> onRefresh() async {
    //clear friendship cache before refreshing
    ref.invalidate(usersProvider);
    ref.invalidate(requestsProvider);

    // wait a vit for the provider to refresh
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    //watch the auto-refresh provider to trigger refreshes
    ref.watch(autoRefreshProvider);
    final users = ref.watch(filteredUsersProvider);
    final searchQuery = ref.watch(searchQueryProvider);
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
