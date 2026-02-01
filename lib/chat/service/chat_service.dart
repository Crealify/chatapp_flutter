import 'package:chatapp_flutter/chat/model/message_request_model.dart';
import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/utils/chat_id.dart';
import '../model/chat_model.dart';

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

  // ================ OnlineStatus =========================
  Future<void> updateUserOnlineStatus(bool isOnline) async {
    if (currentUserId.isEmpty) return;
    try {
      await _firestore.collection("users").doc(currentUserId).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {}
  }

  //================= Are Users Friends =======================
  Future<bool> areUsersFriends(String userID1, String userID2) async {
    final chatId = generateChatId(userID1, userID2);
    //only read from firestore if not cached
    final friendship = await _firestore
        .collection("friendships")
        .doc(chatId)
        .get();

    final exists = friendship.exists;
    return exists;
  }

  // now we have required a
  /*
  1. send messege request
  2. accept message request
  */

  //================= Message Request =======================
  Future<String> sendMessageRequest({
    required String receiverId,
    required String receiverName,
    required String receiverEmail,
  }) async {
    try {
      final currentUser = _auth.currentUser!;
      final requestId = "${currentUserId}_$receiverId";
      //get photo url from firestore user collection

      final userDoc = await _firestore
          .collection("users")
          .doc(currentUserId)
          .get();
      String? userPhotoURL;
      if (userDoc.exists) {
        final userModel = UserModel.fromMap(userDoc.data()!);
        userPhotoURL = userModel.photoURL;
      }

      final existingRequest = await _firestore
          .collection("messageRequests")
          .doc(requestId)
          .get();

      if (existingRequest.exists &&
          existingRequest.data()?["status"] == "pending") {
        return "Request already sent";
      }

      final request = MessageRequestModel(
        id: requestId,
        senderId: currentUserId,
        receiverId: receiverId,
        senderName: currentUser.displayName ?? "user",
        senderEmail: currentUser.email!,
        status: "pending",
        createdAt: DateTime.now(),
        // photoURL: currentUser.photoURL,
        // the error that we have face due to => we have display the image form auth user not from user collection
        //lets display the photoURL form user collection then the problem is solve and image is updated when user change it profile picture
        photoURL: userPhotoURL,
        //delete messageRequest documents then  good to do
      );

      await _firestore
          .collection("messageRequests")
          .doc(requestId)
          .set(request.toMap());

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<MessageRequestModel>> getPendingRequest() {
    if (currentUserId.isEmpty) return Stream.value([]);
    return _firestore
        .collection("messageRequests")
        .where("receiverId", isEqualTo: currentUserId)
        .where('status', isEqualTo: "pending")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageRequestModel.fromMap(doc.data()))
              .toList(),
        );
  }

  //================= Accept Message Request ==============
  Future<String> acceptMessageRequest(String requestId, String senderId) async {
    try {
      final batch = _firestore.batch();
      //update request status
      batch.update(_firestore.collection("messageRequests").doc(requestId), {
        "status": "accepted",
      });

      //====== create firendships
      final friendshipId = generateChatId(currentUserId, senderId);
      batch.set(_firestore.collection("friendships").doc(friendshipId), {
        'participants': [currentUserId, senderId],
        'createdAt': FieldValue.serverTimestamp(),
      });

      //create chat
      batch.set(_firestore.collection("chats").doc(friendshipId), {
        "chatId": friendshipId,
        'participants': [currentUserId, senderId],
        'lastMessage': "",
        "lastSenderId": "",
        "lastMessageTime": FieldValue.serverTimestamp(),
        "unreadCount": {currentUserId: 0, senderId: 0},
      });

      //================ SYSTEM MESSAGE ============

      // auto generate message when request is accept

      final messsageId = _firestore.collection("messages").doc().id;
      batch.set(_firestore.collection("messages").doc(messsageId), {
        'messageId': messsageId,
        'chatId': friendshipId,
        "senderId": 'system',
        'senderName': 'system',
        'message': "Request has been accepted. You can now start chatting!",
        "timestamp": FieldValue.serverTimestamp(),
        "type": "system",
      });
      await batch.commit();
      return 'sucess';
    } catch (e) {
      return e.toString();
    }
  }

  //================= REJECT MESSAGE REQUEST =======================
  Future<String> rejectMessageRequest(
    String requestId, {
    bool deleteRequest = true,
  }) async {
    try {
      if (deleteRequest) {
        await _firestore.collection("messageRequests").doc(requestId).delete();
      } else {
        await _firestore.collection("messageRequests").doc(requestId).update({
          'status': "rejected",
        });
      }
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
  // ====================== CHAT ============
  // Add CACHING FOR CHATS

  final Map<String, List<ChatModel>> _chatsCache = {};

  Stream<List<ChatModel>> getUserChats() {
    if (currentUserId.isEmpty) return Stream.value([]);
    return _firestore
            //if you have user orderBt and where on same collection then you need to add a indexing
        .collection("chats")
        .where("participants", arrayContains: currentUserId)


        .orderBy('lastMessageTime', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshots) {
          final docs = snapshots.docs
              .map((doc) => ChatModel.fromMap(doc.data()))
              .toList();
          return docs;
        });
  }
   // Add CACHING FOR MESSAGES

  Stream<List<MessageRequestModel>> getChatMessage(
    String chatId, {
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) {
    Query query = _firestore
    //if you have user orderBt and where on same collection then you need to add a indexing
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy(" ", descending: true)
        .limit(limit);
  }
}
