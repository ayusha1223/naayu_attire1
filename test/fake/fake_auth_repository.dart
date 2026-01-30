import 'package:dartz/dartz.dart';
import 'package:naayu_attire1/core/error/failure.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    // fake success
    return const Right(true);
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    return Right(
      AuthEntity(
        id: '1',
        fullName: 'Test User',
        email: email,
        password: password,
        token: 'fake-token',
      ),
    );
  }
}
