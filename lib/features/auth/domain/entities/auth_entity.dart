import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String name;     // ✅ renamed
  final String email;
  final String password;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
      ];
}
