import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/presentation/web_view_screen.dart';
import 'package:naayu_attire1/features/payment/presentation/payment_success_screen.dart';
import 'card_payment_screen.dart';
import 'paypal_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  final double totalAmount;

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.pink),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ===== PAYMENT OPTIONS GRID =====
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [

                  // CARD
                  _paymentCard(
                    context,
                    title: "Card",
                    icon: Icons.credit_card,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CardPaymentScreen(
                                amount: totalAmount,
                              ),
                        ),
                      );
                    },
                  ),

                  // COD
                  _paymentCard(
                    context,
                    title: "Cash on Delivery",
                    icon: Icons.money,
                    onTap: () {
                      _showCODDialog(context);
                    },
                  ),

                  // ESEWA
                  _paymentCard(
                    context,
                    title: "eSewa",
                    icon: Icons.account_balance_wallet,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EsewaWebviewScreen(
                                amount: totalAmount,
                              ),
                        ),
                      );
                    },
                  ),

                  // PAYPAL
                  _paymentCard(
                    context,
                    title: "PayPal",
                    icon: Icons.payment,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaypalScreen(
                                amount: totalAmount,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== ORDER SUMMARY =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Payment",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rs. ${totalAmount.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // ================= PAYMENT CARD WIDGET =================

  Widget _paymentCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 45, color: Colors.pink),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COD DIALOG =================

  void _showCODDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Order"),
        content: const Text(
            "Place order with Cash on Delivery?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () =>
                Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Confirm"),
            onPressed: () {
              Navigator.pop(context);

              // 🔥 Go directly to success screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PaymentSuccessScreen(
                        amount: totalAmount,
                        paymentMethod: "cod",
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
