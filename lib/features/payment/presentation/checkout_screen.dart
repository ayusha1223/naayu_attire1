import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final shop = context.watch<ShopProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          // ================= PAYMENT GRID =================

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [

                paymentCard(context, "card", "Card Payment", Icons.credit_card),
                paymentCard(context, "cod", "Cash on Delivery", Icons.money),
                paymentCard(context, "esewa", "eSewa", Icons.account_balance_wallet),
                paymentCard(context, "paypal", "PayPal", Icons.payment),

              ],
            ),
          ),

          const SizedBox(height: 25),

          // ================= ORDER DETAILS =================

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [

                rowItem("Total Amount", shop.totalPrice),
                rowItem("Shipping", shop.shippingCharge),

                const Divider(),

                rowItem("Total Payment",
                    shop.finalTotal,
                    isBold: true),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),

      // ================= BOTTOM BUTTON =================

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {

            if (shop.paymentMethod == "cod") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Order placed with Cash on Delivery"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Proceeding with ${shop.paymentMethod.toUpperCase()}"),
                ),
              );
            }

          },
          child: Text(
            "Pay Rs.${shop.finalTotal.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  // ================= PAYMENT CARD =================

  Widget paymentCard(
      BuildContext context,
      String method,
      String title,
      IconData icon,
      ) {

    final shop = context.watch<ShopProvider>();
    bool isSelected = shop.paymentMethod == method;

    return GestureDetector(
      onTap: () {
        context.read<ShopProvider>().setPaymentMethod(method);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.pink : Colors.grey,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.pink : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowItem(String title, double amount,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight:
              isBold ? FontWeight.bold : null,
            ),
          ),
          Text(
            "Rs.${amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight:
              isBold ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
