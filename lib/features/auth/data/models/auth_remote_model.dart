import '../../domain/entities/auth_entity.dart';

class AuthRemoteModel {
  final String id;
  final String name;
  final String email;
  final String token;
  final String role;   // 🔥 ADD

  AuthRemoteModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
  });

  // ================= FROM JSON (Login Response) =================
 factory AuthRemoteModel.fromJson(Map<String, dynamic> json) {
  return AuthRemoteModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    token: json['token'] ?? '',
    role: json['role'] ?? 'user',
  );
}

  // ================= TO ENTITY =================
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      fullName: name,
      email: email,
      password: '',
      token: token,
      role: role,
    );
  }

  // ================= FROM ENTITY (Signup Request) =================
  factory AuthRemoteModel.fromEntity(AuthEntity entity) {
    return AuthRemoteModel(
      id: '',
      name: entity.fullName,
      email: entity.email,
      token: '',
      role: entity.role,
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