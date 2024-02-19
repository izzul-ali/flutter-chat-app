import 'dart:convert';

import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  final String username;
  final String email;
  final String password;

  const AuthModel({
    required this.username,
    required this.email,
    required this.password,
  });

  AuthModel copyWith({
    String? username,
    String? email,
    String? password,
  }) =>
      AuthModel(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory AuthModel.fromJson(String str) => AuthModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthModel.fromMap(Map<String, dynamic> json) => AuthModel(
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "email": email,
        "password": password,
      };

  @override
  List<Object?> get props => [username, email, password];
}
