import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/signup_page.dart';

void main() {
  /// Test 1: Signup screen loads
  testWidgets('Signup page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.text('Sign Up'), findsOneWidget);
  });

  /// Test 2: Signup page has input fields
  testWidgets('Signup page has text fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.byType(TextFormField), findsWidgets);
  });

  /// Test 3: Signup button exists
  testWidgets('Signup button is visible',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.text('Sign Up'), findsOneWidget);
  });
}
