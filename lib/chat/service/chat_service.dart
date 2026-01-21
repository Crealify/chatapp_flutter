import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? "";

  //================= USERS =======================
  Stream<List<UserModel>> getAllUers() {
    if (currentUserId.isEmpty) return Stream.value([]);

    return _firestore
        .collection("users")
        .where("uid", isNotEqualTo: currentUserId)
        .snapshots()
        .map(
          (snapshots) => snapshots.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .where((user) => user.uid != currentUserId)
              .toList(),
        );
  }

  //================= Are Users Friends =======================
  Future<bool> areUsersFriends(String userID1, String userID2) async {
    final chatId = _generateChatId(userID1, userID2);
    //only read from firestore if not cached
    final friendship = await _firestore
        .collection("friendships")
        .doc(chatId)
        .get();

    final exists = friendship.exists;
    return exists;
  }
  //================= UTILS =======================

  String _generateChatId(String userID1, String userID2) {
    final ids = [userID1, userID2]..sort();
    return "${ids[0]}_${ids[1]}";
  }
}
