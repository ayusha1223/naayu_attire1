import 'package:flutter/material.dart';
import 'card_payment_screen.dart';
import 'esewa_payment_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

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

                  _paymentCard(
                    context,
                    title: "Card",
                    icon: Icons.credit_card,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CardPaymentScreen(),
                        ),
                      );
                    },
                  ),

                  _paymentCard(
                    context,
                    title: "Cash on Delivery",
                    icon: Icons.money,
                    onTap: () {
                      _showCODDialog(context);
                    },
                  ),

                  _paymentCard(
                    context,
                    title: "eSewa",
                    icon: Icons.account_balance_wallet,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EsewaPaymentScreen(),
                        ),
                      );
                    },
                  ),

                  _paymentCard(
                    context,
                    title: "PayPal",
                    icon: Icons.payment,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EsewaPaymentScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== ORDER DETAILS =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: const [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Payment",
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text("Rs. 1,418",
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Get reward points on this purchase 🎁",
                    style: TextStyle(color: Colors.pink),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),

      // ===== BOTTOM CHECKOUT BAR =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [

            const Text(
              "Rs. 1,418",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text("Checkout"),
            )
          ],
        ),
      ),
    );
  }

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
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content:
                      Text("Order Placed Successfully!"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
