import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/core/services/order_service.dart';
import 'package:naayu_attire1/core/services/payment_service.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

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

      final token = tokenService.getToken();

      print("🔐 TOKEN: $token");

      if (token == null) {
        throw Exception("Token missing. Please login again.");
      }

      final orderService = OrderService();
      final paymentService = PaymentService();

      print("📦 Creating Order...");

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

      print("✅ ORDER SAVED IN MONGODB: $order");

      // 🔥 Only process payment for non-COD
      if (widget.paymentMethod != "cod") {
        print("💳 Processing Online Payment...");

        await paymentService.processPayment(
          orderId: order["_id"],
          paymentMethod: widget.paymentMethod,
          token: token,
        );

        print("✅ ONLINE PAYMENT SUCCESS");
      } else {
        print("🚚 COD ORDER — Payment will be collected on delivery");
      }

      shop.clearCart();

      setState(() {
        isLoading = false;
      });

    } catch (e) {
      print("🔥 COMPLETE ORDER ERROR: $e");

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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 80, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  "Something went wrong",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage ?? "Unknown error",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Go Back"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.check_circle,
              size: 100,
              color: Color(0xFF60BB46),
            ),

            const SizedBox(height: 20),

            const Text(
              "Order Placed Successfully!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Rs. ${widget.amount.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Payment Method: ${widget.paymentMethod.toUpperCase()}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF60BB46),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.popUntil(
                    context,
                    (route) => route.isFirst);
              },
              child: const Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}
