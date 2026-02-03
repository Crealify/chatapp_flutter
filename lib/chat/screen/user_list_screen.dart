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
  @override
  void InitState() {
    super.initState();
    //force refresh when screen is  first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(usersProvider);
      ref.invalidate(chatsProvider);
    });
  }

  Future<void> onRefresh() async {
    //clear friendship cache before refreshing
    ref.invalidate(usersProvider);
    ref.invalidate(requestsProvider);
    // ref.invalidate(chatsProvider);

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
        automaticallyImplyActions: false,
        title: Text("All Users", style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextField(
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: "Search user by name or email...",
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isEmpty
                    ? IconButton(
                        onPressed: () =>
                            ref.read(searchQueryProvider.notifier).state = "",
                        icon: Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ),
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
