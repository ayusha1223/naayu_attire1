import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/core/services/order_service.dart';
import 'package:naayu_attire1/core/services/payment_service.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'order_tracking_screen.dart';
import 'receipt_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;

  const PaymentSuccessScreen({
    super.key,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  State<PaymentSuccessScreen> createState() =>
      _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState
    extends State<PaymentSuccessScreen> {

  bool isLoading = true;
  bool isError = false;
  String? errorMessage;
  String? orderId;

  @override
  void initState() {
    super.initState();
    _completeOrder();
  }

  Future<void> _completeOrder() async {
    try {
      final shop = context.read<ShopProvider>();
      final tokenService =
          Provider.of<TokenService>(context, listen: false);

      final token = await tokenService.getToken();

      if (token == null) {
        throw Exception("Token missing. Please login again.");
      }

      final orderService = OrderService();
      final paymentService = PaymentService();

      final order = await orderService.createOrder(
        items: shop.cart.map((item) => {
              "productId": item.id,
              "name": item.name,
              "price": item.price,
              "quantity": item.quantity,
              "image": item.image,
            }).toList(),
        totalAmount: shop.finalTotal,
        paymentMethod: widget.paymentMethod,
        token: token,
      );

      orderId = order["_id"];

      if (widget.paymentMethod != "cod") {
        await paymentService.processPayment(
          orderId: orderId!,
          paymentMethod: widget.paymentMethod,
          token: token,
        );
      }

      shop.clearCart();

      setState(() {
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isError) {
      return Scaffold(
        body: Center(
          child: Text(errorMessage ?? "Error"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// SUCCESS ICON WITH GLOW
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF60BB46)
                        .withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                size: 110,
                color: Color(0xFF60BB46),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Order Placed Successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Order ID: $orderId",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Rs. ${widget.amount.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 50),

            /// TRACK ORDER BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.local_shipping),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 100, 111, 186),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(
                        currentStage: 0,
                        orderId: orderId!,
                        estimatedDelivery: "3-5 Days",
                      ),
                    ),
                  );
                },
                label: const Text("Track My Order"),
              ),
            ),

            const SizedBox(height: 15),

            /// RECEIPT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.receipt_long),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFF60BB46)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReceiptScreen(
                        orderId: orderId!,
                        amount: widget.amount,
                        paymentMethod:
                            widget.paymentMethod,
                      ),
                    ),
                  );
                },
                label: const Text("View / Download Receipt"),
              ),
            ),

            const SizedBox(height: 15),

            /// CONTINUE SHOPPING
            SizedBox(
              width: double.infinity,
              height: 55,
              child: TextButton(
                onPressed: () {
                  Navigator.popUntil(
                      context,
                      (route) => route.isFirst);
                },
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}