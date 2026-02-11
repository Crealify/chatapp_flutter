import 'package:chatapp_flutter/chat/provider/provider.dart';
import 'package:chatapp_flutter/chat/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

ZegoSendCallInvitationButton actionButton(
  bool isVideo,
  String receiverId,
  String receiverName,
  WidgetRef ref,
  String chatId,
) => ZegoSendCallInvitationButton(
  invitees: [ZegoUIKitUser(id: receiverId, name: receiverName)],
  isVideoCall: isVideo,
  iconSize: Size(30, 30),
  buttonSize: Size(40, 40),
  resourceID: "zego_call",
  onPressed: (code, message, errorInvitees) {
    final chatService = ref.read(chatServiceProvider);
    chatService.addCallHistory(
      chatId: chatId,
      isVideoCall: isVideo,
      callStatus: '_',
    );
  },
);
