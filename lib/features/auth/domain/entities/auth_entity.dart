

import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const AuthEntity({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
      ];
}
