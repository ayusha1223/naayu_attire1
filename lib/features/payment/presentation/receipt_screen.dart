import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ReceiptScreen extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String email;
  final String phone;
  final String address;
  final DateTime orderDate;
  final double totalAmount;
  final String paymentMethod;
  final List<Map<String, dynamic>> items;

  const ReceiptScreen({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.orderDate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.items,
  });
  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMM yyyy | hh:mm a').format(orderDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Receipt"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text("Date: $formattedDate"),
              Text("Payment: ${paymentMethod.toUpperCase()}"),

              const SizedBox(height: 8),

              const SizedBox(height: 20),

              /// CUSTOMER INFO CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer Information",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(customerName),
                    Text(phone),
                    Text(email),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// DELIVERY ADDRESS CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Delivery Address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(address),
                    
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Items",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              const Divider(),

              ...items.map((item) => ListTile(
                    title: Text(item["name"]),
                    subtitle: Text("Qty: ${item["quantity"]}"),
                    trailing: Text(
                        "Rs. ${(item["price"] * item["quantity"]).toStringAsFixed(0)}"),
                  )),

              const Divider(),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total: Rs. ${totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download PDF Invoice"),
                  onPressed: generateReceipt,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generateReceipt() async {
    final pdf = pw.Document();

    final formattedDate =
        DateFormat('dd MMM yyyy | hh:mm a').format(orderDate);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Text("Naayu Attire",
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold)),

              pw.SizedBox(height: 20),

              pw.Text("INVOICE",
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold)),

              pw.SizedBox(height: 10),

              pw.Text("Order ID: $orderId"),
              pw.Text("Date: $formattedDate"),
              pw.Text("Payment Method: ${paymentMethod.toUpperCase()}"),
             

              pw.SizedBox(height: 20),

              pw.Text("Customer Information",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(customerName),
              pw.Text(phone),
              pw.Text(email),

              pw.SizedBox(height: 15),

              pw.Text("Delivery Address",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(address),
              

              pw.SizedBox(height: 20),

              pw.Text("Items",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: ['Item', 'Qty', 'Price'],
                data: items.map((item) {
                  return [
                    item["name"],
                    item["quantity"].toString(),
                    "Rs. ${(item["price"] * item["quantity"]).toStringAsFixed(0)}"
                  ];
                }).toList(),
              ),

              pw.SizedBox(height: 20),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: Rs. ${totalAmount.toStringAsFixed(0)}",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold),
                ),
              ),

              pw.SizedBox(height: 40),

              pw.Text("Thank you for shopping with Naayu Attire "),
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