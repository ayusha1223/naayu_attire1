import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/auth/domain/repositories/auth_repository.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockTokenService extends Mock implements TokenService {}

void main() {

  late MockAuthRepository repository;
  late MockTokenService tokenService;
  late AuthViewModel viewModel;

  setUp(() {
    repository = MockAuthRepository();
    tokenService = MockTokenService();
    viewModel = AuthViewModel(repository, tokenService);
  });

  Widget createWidget() {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: viewModel,
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  testWidgets("Email field exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets("Password field exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Password"), findsOneWidget);
  });

  testWidgets("Login button exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("LOG IN"), findsOneWidget);
  });

  testWidgets("Forgot password text exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Forgot password?"), findsOneWidget);
  });

  testWidgets("Sign up navigation text exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Sign Up"), findsOneWidget);
  });

}