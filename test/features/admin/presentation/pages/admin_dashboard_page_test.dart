import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:naayu_attire1/features/admin/presentation/pages/admin_dashboard_page.dart';

void main() {

  Widget createWidget() {
    return const MaterialApp(
      home: AdminDashboardPage(),
    );
  }

  /// ===============================
  /// TEST 1 : Loading indicator
  /// ===============================
  testWidgets("shows loading indicator initially", (tester) async {

    await tester.pumpWidget(createWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

testWidgets("dashboard page builds without crashing", (tester) async {

  await tester.pumpWidget(createWidget());

  expect(find.byType(AdminDashboardPage), findsOneWidget);

});

testWidgets("safe area exists in dashboard page", (tester) async {

  await tester.pumpWidget(createWidget());

  expect(find.byType(SafeArea), findsOneWidget);

});

}