import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';

/// Mock ViewModel
class MockAuthViewModel extends Mock implements AuthViewModel {}

void main() {

  late MockAuthViewModel mockAuthVM;

   setUpAll(() {
  registerFallbackValue('');
});

  setUp(() {
    mockAuthVM = MockAuthViewModel();
   

    when(() => mockAuthVM.addListener(any())).thenReturn(null);
    when(() => mockAuthVM.removeListener(any())).thenReturn(null);
  });

  Widget createWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthViewModel>.value(
        value: mockAuthVM,
        child: const ForgotPasswordScreen(),
      ),
    );
  }

  /// ===============================
  /// TEST 1 : UI loads
  /// ===============================
  testWidgets("forgot password screen loads", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidget());

    expect(find.text("Forgot\nPassword?"), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text("SEND RESET TOKEN"), findsOneWidget);
  });

  /// ===============================
  /// TEST 2 : Enter email
  /// ===============================
  testWidgets("user can enter email", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidget());

    await tester.enterText(find.byType(TextField), "test@email.com");

    expect(find.text("test@email.com"), findsOneWidget);
  });

  /// ===============================
  /// TEST 3 : Button tap calls forgotPassword
  /// ===============================
  testWidgets("tap send reset token calls forgotPassword", (tester) async {

    when(() => mockAuthVM.isLoading).thenReturn(false);
    when(() => mockAuthVM.errorMessage).thenReturn(null);

when(() => mockAuthVM.forgotPassword(any()))
    .thenAnswer((_) async => false);

    await tester.pumpWidget(createWidget());

    await tester.enterText(find.byType(TextField), "test@email.com");

    await tester.tap(find.text("SEND RESET TOKEN"));
   await tester.pumpAndSettle(const Duration(milliseconds: 100));

    verify(() => mockAuthVM.forgotPassword("test@email.com")).called(1);
  });
}