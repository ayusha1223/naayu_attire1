import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('Login page renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginPage()),
    );

    expect(find.text('Log into'), findsOneWidget);
  });
}
