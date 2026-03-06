import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:naayu_attire1/core/error/server_failure.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';
import 'package:naayu_attire1/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = RegisterUsecase(repository);
  });

  final user = AuthEntity(
    id: "1",
    fullName: "Ayusha",
    email: "test@test.com",
    password: "123456",
    token: "",
    role: "user",
  );

  group("RegisterUsecase", () {

    test('should return true when register successful', () async {

      when(() => repository.register(user))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase.call(user);

      expect(result, const Right(true));

      verify(() => repository.register(user)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return failure when register fails', () async {

      when(() => repository.register(user))
          .thenAnswer((_) async => Left(ServerFailure("Register Failed")));

      final result = await usecase.call(user);

      expect(result, Left(ServerFailure("Register Failed")));

      verify(() => repository.register(user)).called(1);
    });

  });
}