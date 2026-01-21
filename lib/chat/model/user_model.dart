
// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoURL;
  final bool isOnline;
  final DateTime? lastSeen;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoURL,
    required this.isOnline,
    this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      photoURL: map['photoURL'],
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen']?.toDate(),
    );
  }
  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     uid: map['uid'] as String,
  //     name: map['name'] as String,
  //     email: map['email'] as String,
  //     photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
  //     isOnline: map['isOnline'] as bool,
  //     lastSeen: map['lastSeen'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int) : null,
  //   );
  // }
}
