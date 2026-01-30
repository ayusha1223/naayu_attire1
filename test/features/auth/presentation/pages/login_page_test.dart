import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';

void main() {
  /// Test 1: Login screen loads
  testWidgets('Login page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
  });

  /// Test 2: Email and Password fields exist
  testWidgets('Login page has email and password fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    expect(find.byType(TextFormField), findsWidgets);
  });
}
