import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String chatRoomId;
  final List<String> members;
  final String lastMessage;
  final bool viewed;
  final String type;
  final DateTime timestamp;
  final DateTime createdAt;

  ChatRoom({
    required this.chatRoomId,
    required this.members,
    required this.lastMessage,
    required this.viewed,
    required this.type,
    required this.timestamp,
    required this.createdAt,
  });

  ChatRoom copyWith({
    String? chatRoomId,
    List<String>? members,
    String? lastMessage,
    bool? viewed,
    dynamic type,
    DateTime? timestamp,
    DateTime? createdAt,
  }) =>
      ChatRoom(
        chatRoomId: chatRoomId ?? this.chatRoomId,
        members: members ?? this.members,
        lastMessage: lastMessage ?? this.lastMessage,
        viewed: viewed ?? this.viewed,
        type: type ?? this.type,
        timestamp: timestamp ?? this.timestamp,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ChatRoom.fromMap(Map<String, dynamic> json) => ChatRoom(
        chatRoomId: json["chatRoomId"],
        members: List<String>.from(json["members"].map((x) => x)),
        lastMessage: json["lastMessage"],
        viewed: json["viewed"],
        type: json["type"],
        timestamp: (json["timestamp"] as Timestamp).toDate(),
        createdAt: (json["createdAt"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        "chatRoomId": chatRoomId,
        "members": List<dynamic>.from(members.map((x) => x)),
        "lastMessage": lastMessage,
        "viewed": viewed,
        "type": type,
        "timestamp": timestamp,
        "createdAt": createdAt,
      };
}
