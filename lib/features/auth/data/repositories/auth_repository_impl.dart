import 'package:dartz/dartz.dart';
import 'package:naayu_attire1/core/error/server_failure.dart';
import 'package:naayu_attire1/features/auth/data/datasources/auth_datasource.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      final result = await datasource.register(
        entity.name,
        entity.email,
        entity.password,
      );
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Registration failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await datasource.login(email, password);
      return Right(user.toEntity());
    } catch (e) {
      return const Left(ServerFailure('Invalid email or password'));
    }
  }
}
