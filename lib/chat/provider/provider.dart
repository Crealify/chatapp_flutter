import 'dart:async';

import 'package:chatapp_flutter/chat/model/message_request_model.dart';
import 'package:chatapp_flutter/chat/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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
