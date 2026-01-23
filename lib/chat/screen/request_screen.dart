import 'package:chatapp_flutter/chat/provider/provider.dart';
import 'package:chatapp_flutter/core/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  @override
  void initState() {
    // refresh request list as soon as screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(requestsProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(requestsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Requests"),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(requestsProvider),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),

      // =============== handle provider status(date, loading error)
      body: requests.when(
        //case 1 sucessfully loaded requests
        data: (requestList) {
          if (requestList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 16, color: Colors.white),
                  SizedBox(height: 15),
                  Text(
                    "No pending request",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          // if requests exists -> show List of requests
          return ListView.builder(
            itemBuilder: (context, index) {
              final request = requestList[index];
              return Card(
                elevation: 0,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: request.photoURL != null
                        ? NetworkImage(request.photoURL!)
                        : null,

                    child: request.photoURL == null ? Icon(Icons.person) : null,
                  ),
                  title: Text(request.senderName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //ACCEPT REQUEST
                      GestureDetector(
                        onTap: () async {
                          await ref
                              .read(requestsProvider.notifier)
                              .acceptRequest(request.id, request.senderId);
                          if (context.mounted) {
                            showAppSnackbar(
                              context: context,
                              type: SnackbarType.success,
                              description: "Request accepted!",
                            );
                            //=========== Refresh all Provider after accepting
                            ref.invalidate(usersProvider);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      //reject request
                      GestureDetector(
                        onTap: () async {
                          await ref
                              .read(requestsProvider.notifier)
                              .rejectRequest(request.id);
                          if (context.mounted) {
                            showAppSnackbar(
                              context: context,
                              type: SnackbarType.error,
                              description: "Request rejected!",
                            );
                            //=========== Refresh all Provider after rejecting
                            // ref.invalidate(usersProvider);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },

        // case 2 error state
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Error: $error"),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(requestsProvider),
                child: Text("Retry"),
              ),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
