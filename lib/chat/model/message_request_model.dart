// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String senderEmail;
  final String status;
  final DateTime createdAt;
  final String? photoURL;
  MessageRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.senderEmail,
    required this.status,
    required this.createdAt,
    required this.photoURL,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'status': status,
      'createdAt': createdAt,
      'photoURL': photoURL,
    };
  }

  factory MessageRequestModel.fromMap(Map<String, dynamic> map) {
    return MessageRequestModel(
      id: map['id'] ?? "",
      senderId: map['senderId'] ?? "",
      receiverId: map['receiverId'] ?? "",
      senderName: map['senderName'] ?? "",
      senderEmail: map['senderEmail'] ?? "",
      status: map['status'] ?? "pending",
      createdAt: map["createdAt"]?.toDate() ?? DateTime.now(),
      photoURL: map['photoURL'] ?? "",
    );
  }
  // factory MessageRequestModel.fromMap(Map<String, dynamic> map) {
  //   return MessageRequestModel(
  //     id: map['id'] as String,
  //     senderId: map['senderId'] as String,
  //     receiverId: map['receiverId'] as String,
  //     senderEmail: map['senderEmail'] as String,
  //     status: map['status'] as String,
  //     createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
  //     photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
  //   );
  // }

  //   String toJson() => json.encode(toMap());

  //   factory MessageRequestModel.fromJson(String source) =>
  //       MessageRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
