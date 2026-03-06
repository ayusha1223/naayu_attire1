import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/new_password_screen.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';

class MockAuthViewModel extends Mock implements AuthViewModel {}

void main() {

  late MockAuthViewModel mockAuthVM;

  setUp(() {
    mockAuthVM = MockAuthViewModel();

    when(() => mockAuthVM.addListener(any())).thenReturn(null);
    when(() => mockAuthVM.removeListener(any())).thenReturn(null);
  });

  Widget createWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthViewModel>.value(
        value: mockAuthVM,
        child: const NewPasswordScreen(email: "test@email.com"),
      ),
    );
  }

  /// ===============================
  /// TEST 1 : Screen loads
  /// ===============================
  testWidgets("new password screen loads", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidget());

    expect(find.text("Create\nNew Password"), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text("RESET PASSWORD"), findsOneWidget);
  });

  /// ===============================
  /// TEST 2 : Password mismatch
  /// ===============================
  testWidgets("shows snackbar when passwords do not match", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidget());

    await tester.enterText(find.byType(TextField).first, "123456");
    await tester.enterText(find.byType(TextField).last, "654321");

    await tester.tap(find.text("RESET PASSWORD"));
    await tester.pump();

    expect(find.text("Passwords do not match"), findsOneWidget);
  });

  /// ===============================
  /// TEST 3 : Reset password called
  /// ===============================
  testWidgets("calls resetPassword when passwords match", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    when(() => mockAuthVM.resetPassword(any(), any()))
        .thenAnswer((_) async => false); // avoid navigation

    await tester.pumpWidget(createWidget());

    await tester.enterText(find.byType(TextField).first, "123456");
    await tester.enterText(find.byType(TextField).last, "123456");

    await tester.tap(find.text("RESET PASSWORD"));
    await tester.pump();

    verify(() => mockAuthVM.resetPassword("test@email.com", "123456")).called(1);
  });

}