import 'package:dartz/dartz.dart';
import 'package:naayu_attire1/core/error/failure.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);

  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  );
}
