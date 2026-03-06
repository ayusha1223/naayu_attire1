import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:naayu_attire1/core/error/server_failure.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';
import 'package:naayu_attire1/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {

  late LogoutUsecase usecase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LogoutUsecase(repository);
  });

  group("LogoutUsecase", () {

    test('should return true when logout successful', () async {

      when(() => repository.logout())
          .thenAnswer((_) async => const Right(true));

      final result = await usecase.call();

      expect(result, const Right(true));

      verify(() => repository.logout()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return failure when logout fails', () async {

      when(() => repository.logout())
          .thenAnswer((_) async => Left(ServerFailure("Logout Failed")));

      final result = await usecase.call();

      expect(result, Left(ServerFailure("Logout Failed")));

      verify(() => repository.logout()).called(1);
    });

  });
}