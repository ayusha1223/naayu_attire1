import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/presentation/web_view_screen.dart';
import 'package:naayu_attire1/features/payment/presentation/payment_success_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;

  // ✅ Delivery details coming from Checkout screen
  final String customerName;
  final String email;
  final String phone;
  final String address;
 

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,

  });

  @override
  State<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState
    extends State<PaymentMethodScreen> {

  String selectedMethod = "esewa";

  static const Color kPrimary =
      Color.fromARGB(255, 110, 82, 188);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.black),
        title: const Text(
          "Payment Method",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              "Select your payment method.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            paymentTile(
                "esewa",
                "eSewa",
                Icons.account_balance_wallet),
            paymentTile(
                "cod",
                "Cash on Delivery",
                Icons.money),

            const Spacer(),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Payment",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  "Rs. ${widget.totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 100, 111, 186),
            padding:
                const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30),
            ),
          ),
          onPressed: proceedPayment,
          child: const Text(
            "Place Order",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentTile(
      String method,
      String title,
      IconData icon) {

    bool isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
      },
      child: Container(
        margin:
            const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? kPrimary
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? kPrimary
                  : Colors.grey,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w500,
                  color: isSelected
                      ? kPrimary
                      : Colors.black,
                ),
              ),
            ),
            Radio<String>(
              value: method,
              groupValue: selectedMethod,
              activeColor: kPrimary,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void proceedPayment() {
    switch (selectedMethod) {
      case "cod":
        _showCODDialog(context);
        break;

      case "esewa":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EsewaWebviewScreen(
  amount: widget.totalAmount,
  customerName: widget.customerName,
  email: widget.email,
  phone: widget.phone,
  address: widget.address,
),
          ),
        );
        break;
    }
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
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(
                      255, 100, 111, 186),
              foregroundColor: Colors.white,
            ),
            child: const Text("Confirm"),
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PaymentSuccessScreen(
                    amount: widget.totalAmount,
                    paymentMethod: selectedMethod,
                    customerName:
                        widget.customerName,
                    email: widget.email,
                    phone: widget.phone,
                    address: widget.address,
                    
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