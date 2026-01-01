import 'package:dartz/dartz.dart';
import 'package:naayu_attire1/core/error/cache_failure.dart';
import 'package:naayu_attire1/core/error/failure.dart';
import 'package:naayu_attire1/features/auth/data/datasources/auth_datasource.dart';
import 'package:naayu_attire1/features/auth/data/models/auth_hive_model.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      final model = AuthHiveModel.fromEntity(entity);
      final result = await datasource.register(model);
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure('Registration failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await datasource.login(email, password);

      if (user == null) {
        return const Left(CacheFailure('Invalid email or password'));
      }

      return Right(user.toEntity());
    } catch (e) {
      return const Left(CacheFailure('Login failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await datasource.getCurrentUser();

      if (user == null) {
        return const Left(CacheFailure('No user logged in'));
      }

      return Right(user.toEntity());
    } catch (e) {
      return const Left(CacheFailure('Failed to fetch user'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await datasource.logout();
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure('Logout failed'));
    }
  }
}
