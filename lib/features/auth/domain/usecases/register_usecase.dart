import 'package:dartz/dartz.dart';
import 'package:naayu_attire1/core/error/failure.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final IAuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, bool>> call(AuthEntity entity) {
    return repository.register(entity);
  }
}
