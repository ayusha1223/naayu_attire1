import '../../domain/entities/auth_entity.dart';

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

  // ================= FROM JSON (Login Response) =================
  factory AuthRemoteModel.fromJson(Map<String, dynamic> json) {
    return AuthRemoteModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  // ================= TO ENTITY =================
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      fullName: name,
      email: email,
      password: '', 
      token: token
    );
  }

  // ================= FROM ENTITY (Signup Request) =================
  factory AuthRemoteModel.fromEntity(AuthEntity entity) {
    return AuthRemoteModel(
      id: '',
      name: entity.fullName,
      email: entity.email,
      token: '',
    );
  }

  // ================= TO JSON (Signup Request Body) =================
  Map<String, dynamic> toJson(String password) {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
