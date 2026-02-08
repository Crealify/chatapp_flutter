import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

ZegoSendCallInvitationButton actionButton(
  bool isVideo,
  String receiverId,
  String receiverName,
) => ZegoSendCallInvitationButton(
  invitees: [ZegoUIKitUser(id: receiverId, name: receiverName)],
  isVideoCall: isVideo,
  iconSize: Size(30, 30),
  buttonSize: Size(40, 40),
  resourceID: "zego_call",
);
