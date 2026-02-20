import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/admin/data/services/admin_service.dart';


class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() =>
      _AdminOrdersPageState();
}

class _AdminOrdersPageState
    extends State<AdminOrdersPage> {
  final AdminService _adminService = AdminService();

  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data = await _adminService.getOrders();

      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
      print("Order Load Error: $e");
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load orders")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("No orders found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return Card(
                      elevation: 4,
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        title: Text(
                          "Order #${order["_id"].toString().substring(18)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                                "User: ${order["userId"]?["name"] ?? ""}"),
                            Text(
                                "Email: ${order["userId"]?["email"] ?? ""}"),
                            Text(
                                "Amount: Rs ${order["totalAmount"] ?? 0}"),
                            Text(
                                "Payment: ${order["paymentStatus"]}"),
                            Text(
                                "Status: ${order["orderStatus"]}"),
                          ],
                        ),
                        trailing: Text(
                          order["createdAt"] != null
                              ? order["createdAt"]
                                  .toString()
                                  .substring(0, 10)
                              : "",
                        ),
                        children: [
                          const Divider(),
                          ...List.generate(
                            order["items"]?.length ?? 0,
                            (i) {
                              final item =
                                  order["items"][i];

                              return ListTile(
                               leading: item["image"] != null
    ? (item["image"].toString().startsWith("http")
        ? Image.network(
            item["image"],
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          )
        : Image.asset(
            item["image"],
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ))
    : const Icon(Icons.shopping_bag),
                                title: Text(
                                    item["name"] ?? ""),
                                subtitle: Text(
                                    "Qty: ${item["quantity"]}"),
                                trailing: Text(
                                    "Rs ${item["price"]}"),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}