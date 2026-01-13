

import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';

class AuthRemoteModel {
  final String id;
  final String name;
  final String email;
  final String token;

  AuthRemoteModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory AuthRemoteModel.fromJson(Map<String, dynamic> json) {
    return AuthRemoteModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

AuthEntity toEntity() {
  return AuthEntity(
    id: id,
    name: name,
    email: email,
    password: '',
  );
}
 }
