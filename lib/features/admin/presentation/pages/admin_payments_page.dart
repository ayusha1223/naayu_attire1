import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/admin/data/services/admin_service.dart';


class AdminPaymentsPage extends StatefulWidget {
  const AdminPaymentsPage({super.key});

  @override
  State<AdminPaymentsPage> createState() =>
      _AdminPaymentsPageState();
}

class _AdminPaymentsPageState
    extends State<AdminPaymentsPage> {
  final AdminService _adminService = AdminService();

  List payments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      final data = await _adminService.getPayments();

      setState(() {
        payments = data;
        isLoading = false;
      });
    } catch (e) {
      print("Payment Load Error: $e");
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load payments")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payments")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
              ? const Center(child: Text("No payments found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];

                    return Card(
                      elevation: 4,
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          "Rs ${payment["amount"] ?? 0}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                      Text("User: ${payment["userId"]?["name"] ?? ""}"),
Text("Email: ${payment["userId"]?["email"] ?? ""}"),
Text("Method: ${payment["paymentMethod"] ?? ""}"),
                            Text(
                                "Status: ${payment["status"] ?? ""}"),
                          ],
                        ),
                        trailing: Text(
                          payment["createdAt"] != null
                              ? payment["createdAt"]
                                  .toString()
                                  .substring(0, 10)
                              : "",
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}