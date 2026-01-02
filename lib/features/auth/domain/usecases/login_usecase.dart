import 'package:dartz/dartz.dart';
import 'package:naayu_attire1/core/error/failure.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final IAuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, AuthEntity>> call(
    String email,
    String password,
  ) {
    return repository.login(email, password);
  }
}
