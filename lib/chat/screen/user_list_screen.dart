//======== now lets display all available user on the app  ==========

import 'package:chatapp_flutter/chat/widgets/user_list_tile.dart';
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
      body: RefreshIndicator(
        //enable push to refresh
        backgroundColor: Colors.white,
        onRefresh: onRefresh,
        child: users.when(
          data: (userList) {
            if (userList.isEmpty && searchQuery.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: 200),
                  Center(child: Text("No users found matching your search")),
                ],
              );
            }
            if (userList.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: 200),
                  Center(child: Text("No other user found")),
                ],
              );
            }
            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: userList.length,

              itemBuilder: (context, index) {
                final user = userList[index];
                return UserListTile(user: user);
              },
            );
          },
          error: (error, _) => ListView(
            children: [
              SizedBox(height: 200),
              Center(
                child: Column(
                  children: [
                    Text("Error: $error"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(usersProvider),
                      child: Text("Retry"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
