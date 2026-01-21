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

}
