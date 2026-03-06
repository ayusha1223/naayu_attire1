import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';
import 'package:naayu_attire1/core/error/server_failure.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockTokenService extends Mock implements TokenService {}

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late AuthViewModel viewModel;
  late MockAuthRepository repository;
  late MockTokenService tokenService;

   setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    repository = MockAuthRepository();
    tokenService = MockTokenService();

    SharedPreferences.setMockInitialValues({});

    viewModel = AuthViewModel(repository, tokenService);
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

  group("AuthViewModel Tests", () {

    test("login success should update role and return true", () async {

      when(() => repository.login(email, password))
          .thenAnswer((_) async => Right(user));

      when(() => tokenService.saveToken(any()))
          .thenAnswer((_) async {});

      final result = await viewModel.login(
        email: email,
        password: password,
      );

      expect(result, true);
      expect(viewModel.role, "user");

      verify(() => repository.login(email, password)).called(1);
    });

    test("login failure should set error message", () async {

      when(() => repository.login(email, password))
          .thenAnswer((_) async => Left(ServerFailure("Login failed")));

      final result = await viewModel.login(
        email: email,
        password: password,
      );

      expect(result, false);
      expect(viewModel.errorMessage, "Login failed");
    });

    test("register success should return true", () async {

      when(() => repository.register(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await viewModel.register(
        "Ayusha",
        email,
        password,
      );

      expect(result, true);

      verify(() => repository.register(any())).called(1);
    });

    test("forgotPassword success should return true", () async {

      when(() => repository.forgotPassword(email))
          .thenAnswer((_) async => const Right(null));

      final result = await viewModel.forgotPassword(email);

      expect(result, true);
    });

    test("verifyOtp success should return true", () async {

      when(() => repository.verifyOtp(email, "1234"))
          .thenAnswer((_) async => const Right(null));

      final result = await viewModel.verifyOtp(email, "1234");

      expect(result, true);
    });

    test("resetPassword success should return true", () async {

      when(() => repository.resetPassword(email, "newpass"))
          .thenAnswer((_) async => const Right(null));

      final result = await viewModel.resetPassword(email, "newpass");

      expect(result, true);
    });

  });
}