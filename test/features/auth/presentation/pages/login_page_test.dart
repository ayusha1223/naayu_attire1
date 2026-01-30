import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

import '../../../../fake/fake_auth_repository.dart';


void main() {
  late AuthViewModel authViewModel;

  Widget createLoginTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
      ],
      child: const MaterialApp(
        home: LoginPage(),
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

  /// ✅ Test 1
  testWidgets('Login page loads', (tester) async {
    await tester.pumpWidget(createLoginTestWidget());
    await tester.pumpAndSettle();

    expect(find.textContaining('Log into'), findsOneWidget);
  });

  /// ✅ Test 2
  testWidgets('Login page has email and password fields', (tester) async {
    await tester.pumpWidget(createLoginTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsWidgets);
  });
}
