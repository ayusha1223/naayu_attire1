import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:naayu_attire1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_datasource.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        AuthRepositoryImpl(AuthDatasource()),
        TokenService(),
      ),
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  testWidgets('Login page renders', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.textContaining('Log into'), findsOneWidget);
  });

  testWidgets('Login page has email and password fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Login button exists', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('LOG IN'), findsOneWidget);
  });
}
