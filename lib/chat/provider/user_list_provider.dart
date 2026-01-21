import 'package:chatapp_flutter/chat/provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/user_list_model.dart';
import '../model/user_model.dart';

class UsertListNotifier extends StateNotifier<UserListTileState> {
  final Ref ref;
  final UserModel user;
  UsertListNotifier(this.ref, this.user) : super(UserListTileState()) {
    _checkRelationship();
  }
  //========== CHECK THE STATUS =============
  Future<void> _checkRelationship() async {
    final chatService = ref.read(chatServiceProvider);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final friends = await chatService.areUsersFriends(currentUserId, user.uid);
    if (friends) {
      state = state.copyWith(
        areFriends: true,
        requestStatus: null,
        isRequestsender: false,
        pendingRequestId: null,
      );
      return;
    }

    final sentRequestID = "${currentUserId}_${user.uid}";
    final receiverRequestID = "${user.uid}_$currentUserId"; //note no{}

    final senderRequestDoc = await FirebaseFirestore.instance
        .collection("messageRequests")
        .doc(sentRequestID)
        .get();

    final receiverRequestDoc = await FirebaseFirestore.instance
        .collection("messageRequests")
        .doc(receiverRequestID)
        .get();

    String? finalStatus;
    bool isSender = false;
    String? requestId;

    if (senderRequestDoc.exists) {
      final sentStatus = senderRequestDoc["status"];
      if (sentStatus == "pending") {
        finalStatus = "pending";
        isSender = true;
        requestId = sentRequestID;
      }
    }

    if (receiverRequestDoc.exists && finalStatus == null) {
      final receivedStatus = receiverRequestDoc["status"];
      if (receivedStatus == "pending") {
        finalStatus = "pending";
        isSender = false;
        requestId = receiverRequestID;
      }
    }

    state = state.copyWith(
      areFriends: false,
      requestStatus: finalStatus,
      isRequestsender: isSender,
      pendingRequestId: requestId,
    );
  }

  Future<String> sendRequest() async {
    state = state.copyWith(isLoading: true);
    final chatservice = ref.read(chatServiceProvider);
    final result = await chatservice.sendMessageRequest(
      receiverId: user.uid,
      receiverName: user.name,
      receiverEmail: user.email,
    );
    if (result == 'success') {
      state = state.copyWith(
        isLoading: false,
        requestStatus: 'pending',
        isRequestsender: true,
        pendingRequestId:
            '${FirebaseAuth.instance.currentUser!.uid}_${user.uid}',
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
    return result;
  }

  Future<String> acceptRequest() async {
    if (state.pendingRequestId == null) return 'no-request';
    state = state.copyWith(isLoading: true);
    final chatService = ref.read(chatServiceProvider);
    final result = await chatService.acceptMessageRequest(
      state.pendingRequestId!,
      user.uid,
    );
    if (result == 'success') {
      state = state.copyWith(
        isLoading: false,
        areFriends: true,
        requestStatus: null,
        isRequestsender: false,
        pendingRequestId: null,
      );
      //refresh provbiders
      //ref.invalidate();
      ref.invalidate(requestsProvider);
    } else {
      state = state.copyWith(isLoading: false);
    }
    return result;
  }
}

final userListProvider =
    StateNotifierProvider.family<
      UsertListNotifier,
      UserListTileState,
      UserModel
    >((ref, user) => UsertListNotifier(ref, user));
