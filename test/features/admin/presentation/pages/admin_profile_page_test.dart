import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naayu_attire1/features/admin/presentation/pages/admin_profile_page.dart';

void main() {

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createWidget() {
    return const MaterialApp(
      home: AdminProfilePage(),
    );
  }

  /// ===============================
  /// TEST 1 : Loading indicator
  /// ===============================
  testWidgets("shows loading indicator initially", (tester) async {

    await tester.pumpWidget(createWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  /// ===============================
  /// TEST 2 : AppBar title appears
  /// ===============================
  testWidgets("admin profile title appears", (tester) async {

    await tester.pumpWidget(createWidget());
    await tester.pump();

    expect(find.text("Admin Profile"), findsOneWidget);
  });

  /// ===============================
  /// TEST 3 : Logout button exists
  /// ===============================
  testWidgets("logout button appears", (tester) async {

    await tester.pumpWidget(createWidget());
    await tester.pump();

    expect(find.text("Logout"), findsOneWidget);
  });

}