import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/signup_page.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:naayu_attire1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_datasource.dart';
import 'package:naayu_attire1/features/auth/data/models/auth_remote_model.dart';

/// ================= TEST-ONLY DATASOURCE =================
/// No API calls
class TestAuthDatasource implements IAuthDatasource {
  @override
  Future<bool> register(String name, String email, String password) async {
    return true;
  }

  @override
  Future<AuthRemoteModel> login(String email, String password) async {
    return AuthRemoteModel(
      id: '1',
      name: 'Test User',
      email: email,
      token: 'test-token', role: '',
    );
  }
}

/// ================= TEST-ONLY SHARED PREFERENCES =================
class FakeSharedPreferences implements SharedPreferences {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// ================= TEST-ONLY TOKEN SERVICE =================
class TestTokenService extends TokenService {
  TestTokenService() : super(FakeSharedPreferences());
}

void main() {
  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        AuthRepositoryImpl(TestAuthDatasource()),
        TestTokenService(), // ✅ VALID
      ),
      child: const MaterialApp(
        home: RegisterScreen(),
      ),
    );
  }

  testWidgets('Signup page renders correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.textContaining('Create'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);
  });

  testWidgets(
    'Signup page has name, email, password and confirm password fields',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextField), findsNWidgets(4));
    },
  );
}
