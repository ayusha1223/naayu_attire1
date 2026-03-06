import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/presentation/payment_method_screen.dart';

void main() {

  testWidgets("Payment options appear", (tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: PaymentMethodScreen(
          totalAmount: 1000,
          customerName: "Test",
          email: "test@test.com",
          phone: "9800000000",
          address: "Kathmandu",
        ),
      ),
    );

    expect(find.text("Payment Method"), findsOneWidget);
    expect(find.text("Cash on Delivery"), findsOneWidget);
    expect(find.text("eSewa"), findsOneWidget);
  });

}