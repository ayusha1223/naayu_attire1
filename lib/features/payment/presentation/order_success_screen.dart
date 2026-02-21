import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/presentation/order_tracking_screen.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrderSuccessScreen extends StatelessWidget {
  final double amount;
  final String paymentMethod;

  const OrderSuccessScreen({
    super.key,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {

    final String orderId =
        "NA${DateTime.now().millisecondsSinceEpoch}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Order Placed"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Icon(Icons.check_circle,
                size: 90, color: Colors.green),

            const SizedBox(height: 20),

            const Text(
              "Order Placed Successfully 🎉",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("Payment Method: $paymentMethod"),
            Text("Amount: Rs.${amount.toStringAsFixed(0)}"),

            const SizedBox(height: 30),

            // ===== TRACK ORDER =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(
                        currentStage: 0,
                        orderId: orderId,
                        estimatedDelivery: "3-5 Days",
                      ),
                    ),
                  );
                },
                child: const Text("Track My Order"),
              ),
            ),

            const SizedBox(height: 15),

            // ===== DOWNLOAD RECEIPT =====
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.download),
                onPressed: () {
                  generateReceipt(
                    orderId,
                    amount,
                    paymentMethod,
                  );
                },
                label: const Text("View / Download Receipt"),
              ),
            ),

            const SizedBox(height: 15),

            // ===== CONTINUE SHOPPING =====
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, (route) => route.isFirst);
                },
                child: const Text("Continue Shopping"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PDF =================

  Future<void> generateReceipt(
      String orderId,
      double amount,
      String paymentMethod) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment:
                pw.CrossAxisAlignment.start,
            children: [

              pw.Text("Naayu Attire",
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight:
                          pw.FontWeight.bold)),

              pw.SizedBox(height: 15),

              pw.Text("Order Receipt"),
              pw.SizedBox(height: 10),

              pw.Text("Order ID: $orderId"),
              pw.Text("Payment Method: $paymentMethod"),
              pw.Text(
                  "Amount: Rs.${amount.toStringAsFixed(0)}"),

              pw.SizedBox(height: 20),

              pw.Text("Status: Confirmed"),

              pw.SizedBox(height: 40),

              pw.Text(
                  "Thank you for shopping with Naayu Attire!"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}