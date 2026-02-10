// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime? timestamp; // NULLABLE NOW
  final String type;
  final Map<String, DateTime>? readyBy;
  final String? imageUrl; //ADD THIS FIELD FOR IMAGE
  final String? callType; // AUDIO CALL OR VIDEO CALL
  final String? callStatus;
  // final int? duration;
  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.message,
    this.timestamp, // ALLOW NULL
    this.type = 'text',
    this.readyBy,
    this.imageUrl,
    this.callType,
    this.callStatus,
    // this.duration,
  });

  /// CONVERT BACK TO FIRESTORE MAP
  Map<String, dynamic> toMap() {
    // return<String, dynamic>{
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,

      // if timestamp is null, use Fieldvalue.serverTimeStamp()
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp!)
          : FieldValue.serverTimestamp(),
      'type': type,
      'readyBy': readyBy?.map((k, v) => MapEntry(k, Timestamp.fromDate(v))),
      'imageUrl': imageUrl,
      if (callType != null) 'callType': callType,
      if (callStatus != null) 'callStatus': callStatus,
      // if (duration != null) 'duration': duration,
    };
  }
  //   Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'messageId': messageId,
  //     'senderId': senderId,
  //     'senderName': senderName,
  //     'message': message,
  //     'timestamp': timestamp?.millisecondsSinceEpoch,
  //     'type': type,
  //     'readyBy': readyBy,
  //     'imageUrl': imageUrl,
  //     'callType': callType,
  //     'callStatus': callStatus,
  //     'duration': duration,
  //   };
  // }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is Timestamp
                ? (map['timestamp'] as Timestamp).toDate()
                : map['timestamp'] is DateTime
                ? map['timestamp'] as DateTime
                : null) //keep as null instead of DateTime.now
          : null, //keep as null

      readyBy: Map<String, DateTime>.from(
        (map['readyBy'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                value is Timestamp
                    ? value.toDate()
                    : value is DateTime
                    ? value
                    : DateTime.now(),
              ),
            ) ??
            {},
      ),
      type: map['type'] ?? 'user',
      imageUrl: map['imageUrl'],
      callType: map['callType'],
      callStatus: map['callStatus'],
      // duration: map['duration'],
    );
  }
  // factory MessageModel.fromMap(Map<String, dynamic> map) {
  //   return MessageModel(
  //     messageId: map['messageId'] ?? '',
  //     senderId: map['senderId'] ?? '',
  //     senderName: map['senderName'] ?? '',
  //     message: map['message'] ?? '' ,
  //     timestamp: map['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int) : null,
  //     type: map['type'] as String,
  //     readyBy: map['readyBy'] != null ? Map<String, DateTime>.from((map['readyBy'] as Map<String, DateTime>) : null,
  //     imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
  //     callType: map['callType'] != null ? map['callType'] as String : null,
  //     callStatus: map['callStatus'] != null ? map['callStatus'] as String : null,
  //     duration: map['duration'] != null ? map['duration'] as int : null,
  //   );
  // }
  // String toJson() => json.encode(toMap());

  // factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
