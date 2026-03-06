import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:naayu_attire1/core/error/server_failure.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';
import 'package:naayu_attire1/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LoginUsecase(repository);
  });

  const email = "test@test.com";
  const password = "123456";

  final user = AuthEntity(
    id: "1",
    fullName: "Ayusha",
    email: email,
    password: password,
    token: "token123",
    role: "user",
  );

  group("LoginUsecase", () {

    test('should return AuthEntity when login successful', () async {

      when(() => repository.login(email, password))
          .thenAnswer((_) async => Right(user));

      final result = await usecase.call(email, password);

      expect(result, Right(user));

      verify(() => repository.login(email, password)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return failure when login fails', () async {

      when(() => repository.login(email, password))
          .thenAnswer((_) async => Left(ServerFailure("Login Failed")));

      final result = await usecase.call(email, password);

      expect(result, Left(ServerFailure("Login Failed")));

      verify(() => repository.login(email, password)).called(1);
    });

  });
}