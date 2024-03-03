import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String username;
  final String email;
  final String profilPic;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profilPic,
  });

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? profilPic,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        email: email ?? this.email,
        profilPic: profilPic ?? this.profilPic,
      );

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        profilPic: json["profilPic"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "username": username,
        "email": email,
        "profilPic": profilPic,
      };

  @override
  List<Object?> get props => [uid, username, email, profilPic];
}
