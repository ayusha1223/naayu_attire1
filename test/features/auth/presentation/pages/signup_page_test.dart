import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/signup_page.dart';
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
        home: RegisterScreen(),
      ),
    );
  }

  testWidgets("Name field exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Enter your name"), findsOneWidget);
  });

  testWidgets("Email field exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Email address"), findsOneWidget);
  });

  testWidgets("Password field exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Password"), findsOneWidget);
  });

  testWidgets("Confirm password field exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Confirm password"), findsOneWidget);
  });

  testWidgets("Signup button exists", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("SIGN UP"), findsOneWidget);
  });

}