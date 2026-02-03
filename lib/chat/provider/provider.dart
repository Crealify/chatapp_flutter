import 'dart:async';

import 'package:chatapp_flutter/chat/model/message_request_model.dart';
import 'package:chatapp_flutter/chat/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/chat_model.dart';
import '../model/user_model.dart';

//==================== Auth State ===================
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
  // to make keep user login until logout
});

//==================== CHAT SERVICE ===================
final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

//==================== USER ===================
class UserNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final ChatService _chatService;
  StreamSubscription<List<UserModel>>? _subscription;
  UserNotifier(this._chatService) : super(AsyncValue.loading()) {
    _init();
  }
  void _init() {
    _subscription?.cancel();
    _subscription = _chatService.getAllUers().listen(
      (users) => state = AsyncValue.data(users),
      onError: (error, stackTrace) =>
          state = AsyncValue.error(error, stackTrace),
    );
  }

  void refresh() => _init();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final usersProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<UserModel>>>((ref) {
      final service = ref.watch(chatServiceProvider);
      return UserNotifier(service);
    });

//==================== Request ===================
class RequestNotifier
    extends StateNotifier<AsyncValue<List<MessageRequestModel>>> {
  final ChatService _chatService;
  StreamSubscription<List<MessageRequestModel>>? _subscription;
  RequestNotifier(this._chatService) : super(AsyncValue.loading()) {
    _init();
  }
  void _init() {
    _subscription?.cancel();
    _subscription = _chatService.getPendingRequest().listen(
      (requests) => state = AsyncValue.data(requests),
      onError: (error, stackTrace) =>
          state = AsyncValue.error(error, stackTrace),
    );
  }

  Future<void> acceptRequest(String requestId, String senderId) async {
    await _chatService.acceptMessageRequest(requestId, senderId);
    _init();
  }

  Future<void> rejectRequest(String requestId) async {
    await _chatService.rejectMessageRequest(requestId);
    _init();
  }

  void refresh() => _init();
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final requestsProvider =
    StateNotifierProvider<
      RequestNotifier,
      AsyncValue<List<MessageRequestModel>>
    >((ref) {
      final service = ref.watch(chatServiceProvider);
      return RequestNotifier(service);
    });

//==================== Auto refresh on Auth Change ===================
final autoRefreshProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
    next.whenData((user) {
      if (user != null) {
        Future.delayed(Duration(milliseconds: 500), () {
          ref.invalidate(usersProvider);
          ref.invalidate(requestsProvider);
          // ref.invalidate();
        });
      }
    });
  });
});

//=================== CHAT =================
class ChatsNotifier extends StateNotifier<AsyncValue<List<ChatModel>>> {
  final ChatService _chatService;
  StreamSubscription<List<ChatModel>>? _subscription;

  ChatsNotifier(this._chatService) : super(AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _subscription?.cancel();
    _subscription = _chatService.getUserChats().listen(
      (chats) => state = AsyncValue.data(chats),
      onError: (error, stackTrace) =>
          state = AsyncValue.error(error, stackTrace),
    );
  }

  void refresh() => _init();
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final chatsProvider =
    StateNotifierProvider<ChatsNotifier, AsyncValue<List<ChatModel>>>((ref) {
      final service = ref.watch(chatServiceProvider);
      return ChatsNotifier(service);
    });

//==================== SEARCH ===================
final searchQueryProvider = StateProvider<String>((ref) => '');
final filteredUsersProvider = Provider<AsyncValue<List<UserModel>>>((ref) {
  final users = ref.watch(usersProvider);
  final query = ref.watch(searchQueryProvider);
  return users.when(
    data: (list) {
      if (query.isEmpty) return AsyncValue.data(list);
      return AsyncValue.data(
        list
            .where(
              (u) =>
                  u.name.toLowerCase().contains(query.toLowerCase()) ||
                  u.email.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    },
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    loading: () => AsyncValue.loading(),
  );
});
