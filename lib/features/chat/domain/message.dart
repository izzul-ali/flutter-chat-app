import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// enum MessageType { video, image, file, text }

class Message extends Equatable {
  final dynamic type;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  const Message({
    required this.type,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Message copyWith({
    dynamic type,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
  }) =>
      Message(
        type: type ?? this.type,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
      );

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        type: json["type"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        message: json["message"],
        timestamp: (json["timestamp"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "timestamp": timestamp,
      };

  @override
  List<Object?> get props => [
        type,
        senderId,
        receiverId,
        message,
        timestamp,
      ];
}
