import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String fullName;     // ✅ renamed
  final String email;
  final String password;

  const AuthEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        password,
      ];
}
