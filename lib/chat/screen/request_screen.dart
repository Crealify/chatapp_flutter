import 'package:chatapp_flutter/chat/provider/provider.dart';
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
        data: (requestList) {},

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
        loading: ()=> Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
