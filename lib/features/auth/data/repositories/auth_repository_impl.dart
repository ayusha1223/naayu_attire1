import 'package:dartz/dartz.dart';
import 'package:naayu_attire1/core/error/server_failure.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_datasource.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  // ================= REGISTER =================
  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      final result = await datasource.register(
        entity.fullName,
        entity.email,
        entity.password,
      );

      if (!result) {
        return const Left(ServerFailure('Email already exists'));
      }

      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Server error'));
    }
  }

  // ================= LOGIN =================
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

  // ================= FORGOT PASSWORD =================
  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      final result = await datasource.forgotPassword(email);

      if (!result) {
        return const Left(ServerFailure('Email not found'));
      }

      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Server error'));
    }
  }

  // ================= VERIFY OTP =================
  @override
  Future<Either<Failure, bool>> verifyOtp(
    String email,
    String otp,
  ) async {
    try {
      final result = await datasource.verifyOtp(email, otp);

      if (!result) {
        return const Left(ServerFailure('Invalid or expired OTP'));
      }

      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('OTP verification failed'));
    }
  }

  // ================= RESET PASSWORD =================
  @override
  Future<Either<Failure, bool>> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      final result =
          await datasource.resetPassword(email, newPassword);

      if (!result) {
        return const Left(ServerFailure('Password reset failed'));
      }

      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Server error'));
    }
  }
}