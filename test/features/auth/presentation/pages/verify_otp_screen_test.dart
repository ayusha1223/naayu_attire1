import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/verify_otp_screen.dart';
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
        child: const VerifyOtpScreen(email: "test@email.com"),
      ),
    );
  }

  /// ===============================
  /// TEST 1 : Screen loads
  /// ===============================
  testWidgets("verify otp screen loads", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidget());

    expect(find.text("Verify\nCode"), findsOneWidget);
    expect(find.text("VERIFY"), findsOneWidget);
  });

  /// ===============================
  /// TEST 2 : Invalid OTP
  /// ===============================
  testWidgets("shows snackbar for invalid OTP", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidget());

    await tester.tap(find.text("VERIFY"));
    await tester.pump();

    expect(find.text("Enter valid 6-digit code"), findsOneWidget);
  });

  /// ===============================
  /// TEST 3 : verifyOtp called
  /// ===============================
  testWidgets("calls verifyOtp when OTP entered", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    when(() => mockAuthVM.verifyOtp(any(), any()))
        .thenAnswer((_) async => false); // avoid navigation

    await tester.pumpWidget(createWidget());

    /// enter OTP
    await tester.enterText(find.byType(TextField), "123456");

    await tester.tap(find.text("VERIFY"));
    await tester.pump();

    verify(() => mockAuthVM.verifyOtp("test@email.com", "123456")).called(1);
  });

}