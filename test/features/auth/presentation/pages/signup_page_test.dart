import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/signup_page.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

import '../../../../fake/fake_auth_repository.dart';

void main() {
  late AuthViewModel authViewModel;

  Widget createSignupTestWidget() {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: authViewModel,
      child: const MaterialApp(
        home: RegisterScreen(),
      ),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    authViewModel = AuthViewModel(
      FakeAuthRepository(),
      TokenService(prefs),
    );
  });

  /// ✅ Test 3
  testWidgets('Signup page loads', (tester) async {
    await tester.pumpWidget(createSignupTestWidget());
    await tester.pumpAndSettle();

    expect(find.textContaining('Create'), findsOneWidget);
  });

  /// ✅ Test 4
  testWidgets('Signup page has input fields', (tester) async {
    await tester.pumpWidget(createSignupTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsWidgets);
  });

  /// ✅ Test 5
  testWidgets('Signup button exists', (tester) async {
    await tester.pumpWidget(createSignupTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('SIGN UP'), findsOneWidget);
  });
}
