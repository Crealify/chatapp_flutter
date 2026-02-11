import 'dart:io';

import 'package:chatapp_flutter/chat/model/message_model.dart';
import 'package:chatapp_flutter/chat/model/message_request_model.dart';
import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  //================= UNFRIEND Name =======================
  Future<String> unfriendUser(String chatId, String friendId) async {
    try {
      final batch = _firestore.batch();
      // delete friendship
      batch.delete(_firestore.collection("friendships").doc(chatId));
      // delete chat
      batch.delete(_firestore.collection("chats").doc(chatId));

      //dekete message in the chats
      final messages = await _firestore
          .collection("messages")
          .where('chatId', isEqualTo: chatId)
          .get();

      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

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

  // final Map<String, List<ChatModel>> _chatsCache = {};

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

  Stream<List<MessageModel>> getChatMessages(
    String chatId, {
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) {
    Query query = _firestore
        //if you have user orderBt and where on same collection then you need to add a indexing
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy("timestamp", descending: true)
        .limit(limit);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    return query.snapshots().map((snapshot) {
      final docs = snapshot.docs
          .map(
            (doc) => MessageModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
      print('sizeofDocs2 ${docs.length}');
      return docs;
    });
  }

  //====== send chat messgae ==============
  Future<String> sendMessage({
    required String chatId,
    required String message,
  }) async {
    try {
      final currentUser = _auth.currentUser!;
      final messageId = _firestore.collection("messages").doc().id;
      final batch = _firestore.batch();

      //==========user Server timestamp for cconsistency across devices =========
      batch.set(_firestore.collection("messages").doc(messageId), {
        'messageId': messageId,
        'senderId': currentUserId,
        'senderName': currentUser.displayName ?? "User",
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'readBy': {},
        'chatId': chatId,
        'type': 'user',
      });

      final chatDoc = await _firestore.collection("chats").doc(chatId).get();
      if (!chatDoc.exists) {
        return "Chat not found";
      }
      final chatData = chatDoc.data()!;
      final participants = List<String>.from(chatData['participants']);
      final otherUserId = participants.firstWhere((id) => id != currentUserId);

      batch.update(_firestore.collection("chats").doc(chatId), {
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSenderId': currentUserId,
        'unreadCount.$otherUserId': FieldValue.increment(1),
        'unreadCount.$otherUserId': 0,
      });

      await batch.commit();
      return 'success';
    } catch (e) {
      print("Error Sending message: $e");
      return e.toString();
    }
  }

  // //================= iMAGE MESSAGE =======================
  // Future<String> uploadImage(File imageFile, String ChatId) async {
  //   try {
  //     final fileName =
  //         '${DateTime.now().millisecondsSinceEpoch}_$currentUserId.jpg';
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('chat_images')
  //         .child(ChatId)
  //         .child(fileName);
  //     final uploadTask = storageRef.putFile(imageFile);
  //     final snapshot = await uploadTask.whenComplete(() {});
  //     final downloadUrl = await snapshot.ref.getDownloadURL();
  //     return downloadUrl;
  //   } catch (e) {
  //     print('Error uploading image :$e');
  //     return '';
  //   }
  // }
  //================= IMAGE MESSAGE (Cloudinary) =======================
  Future<String> uploadImage(File imageFile, String chatId) async {
    try {
      final cloudinary = CloudinaryPublic(
        dotenv.env['CLOUDINARY_CLOUD_NAME']!,
        dotenv.env['CLOUDINARY_UPLOAD_PRESET_CHAT_IMAGS']!,
        cache: false,
      );

      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: "chatapp_flutter/chat_images/$chatId",
        ),
      );

      return response.secureUrl;
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return '';
    }
  }

  //send image Message
  Future<String> sendImageMessage({
    required String chatId,
    required String imageUrl,
    String? caption,
  }) async {
    try {
      final currentUser = _auth.currentUser!;
      final messageId = _firestore.collection('messages').doc().id;
      final batch = _firestore.batch();

      //create image messages
      batch.set(_firestore.collection("messages").doc(messageId), {
        'messageId': messageId,
        'senderId': currentUserId,
        'senderName': currentUser.displayName ?? "User",
        'message': caption ?? "",
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'readBy': {},
        'chatId': chatId,
        'type': 'image',
      });
      //============ Update Chat with latest message==========
      final chatDoc = await _firestore.collection("chats").doc(chatId).get();
      if (!chatDoc.exists) {
        return "Chat not found";
      }
      final chatData = chatDoc.data()!;
      final participants = List<String>.from(chatData['participants']);
      final otherUserId = participants.firstWhere((id) => id != currentUserId);

      batch.update(_firestore.collection("chats").doc(chatId), {
        'lastMessage': caption?.isNotEmpty == true ? caption : 'Photo',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSenderId': currentUserId,
        'unreadCount.$otherUserId': FieldValue.increment(1),
        'unreadCount.$otherUserId': 0,
      });

      await batch.commit();
      return 'success';
    } catch (e) {
      print('Error sending image message: $e');
      return e.toString();
    }
  }

  Future<String> sendImageWithUpload({
    required String chatId,
    required File imageFile,
    String? caption,
  }) async {
    // upload image first
    final imageUrl = await uploadImage(imageFile, chatId);
    if (imageUrl.isEmpty) {
      return 'Failed to upload image';
    }

    //========== Send image message ===================
    return await sendImageMessage(
      chatId: chatId,
      imageUrl: imageUrl,
      caption: caption,
    );
  }
}
