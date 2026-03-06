import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/data/datasource/payment_remote_datasource.dart';
import 'package:naayu_attire1/features/payment/domain/entities/payment_entity.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/features/cart/presentation/provider/cart_provider.dart';
import 'package:naayu_attire1/core/services/order_service.dart';

import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'order_tracking_screen.dart';
import 'receipt_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;
  final String customerName;
  final String email;
  final String phone;
  final String address;
  final bool testMode;

  const PaymentSuccessScreen({
  super.key,
  required this.amount,
  required this.paymentMethod,
  required this.customerName,
  required this.email,
  required this.phone,
  required this.address,
  this.testMode = false,
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

  List<Map<String, dynamic>> orderedItems = [];
  DateTime orderDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _completeOrder();
  }

  Future<void> _completeOrder() async {
    try {
      final shop = context.read<CartProvider>();
      final tokenService =
          Provider.of<TokenService>(context, listen: false);

      final token = await tokenService.getToken();

      if (token == null) {
        throw Exception("Token missing. Please login again.");
      }

      // Save cart items
      orderedItems = shop.cart.map((item) => {
            "name": item.name,
            "price": item.price,
            "quantity": item.quantity,
          }).toList();

      final orderService = OrderService();

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
  customerName: widget.customerName,
  email: widget.email,
  phone: widget.phone,
  address: widget.address,
  token: token,
);

      orderId = order["_id"];

    final dio = Dio(
  BaseOptions(
    baseUrl: "http://192.168.1.74:3000/api/v1",
  ),
);

final datasource = PaymentRemoteDatasource(dio);

if (widget.paymentMethod != "cod") {
  final payment = PaymentEntity(
    orderId: orderId!,
    paymentMethod: widget.paymentMethod,
    transactionId: "TXN${DateTime.now().millisecondsSinceEpoch}",
  );

  await datasource.processPayment(payment, token);
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

            const Icon(
              Icons.check_circle,
              size: 110,
              color: Color(0xFF60BB46),
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

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.local_shipping),
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

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.receipt_long),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReceiptScreen(
                        orderId: orderId!,
                        customerName: widget.customerName,
                        orderDate: orderDate,
                        totalAmount: widget.amount,
                        paymentMethod: widget.paymentMethod,
                        items: orderedItems,
                        email: widget.email,
                        phone: widget.phone,
                        address: widget.address,
                      ),
                    ),
                  );
                },
                label: const Text("View / Download Receipt"),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
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