import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptScreen extends StatelessWidget {
  final String orderId;
  final double amount;
  final String paymentMethod;

  const ReceiptScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: Icon(Icons.receipt_long,
                  size: 80, color: Colors.green),
            ),

            const SizedBox(height: 20),

            Text(
              "Order ID: $orderId",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Amount: Rs. ${amount.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Text(
              "Payment Method: ${paymentMethod.toUpperCase()}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download PDF Receipt"),
                onPressed: generateReceipt,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateReceipt() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment:
                pw.CrossAxisAlignment.start,
            children: [

              pw.Text("Naayu Attire",
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight:
                          pw.FontWeight.bold)),

              pw.SizedBox(height: 20),

              pw.Text("Receipt"),
              pw.SizedBox(height: 10),

              pw.Text("Order ID: $orderId"),
              pw.Text("Amount: Rs. ${amount.toStringAsFixed(0)}"),
              pw.Text(
                  "Payment Method: ${paymentMethod.toUpperCase()}"),

              pw.SizedBox(height: 20),
              pw.Text("Status: Successful"),

              pw.SizedBox(height: 40),
              pw.Text("Thank you for shopping ❤️"),
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