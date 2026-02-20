import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String fullName;     // ✅ renamed
  final String email;
  final String password;
  final String token;
   final String role;

  const AuthEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.token,
    required this.role,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        password,
      ];
}
