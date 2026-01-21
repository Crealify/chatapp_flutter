import 'package:chatapp_flutter/chat/provider/provider.dart';
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
  }
}
