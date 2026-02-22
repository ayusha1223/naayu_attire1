import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/admin/data/services/admin_service.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
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
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load orders")),
      );
    }
  }

  // ---------------- STATUS COLORS ----------------

  Color getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "processing":
        return Colors.orange;
      case "shipped":
        return Colors.blue;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Color getPaymentColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "failed":
        return Colors.red;
      case "refunded":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  // ---------------- ACTIONS ----------------

  Future<void> updateStatus(String orderId, String status) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Status Update"),
        content: Text("Mark this order as '$status'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _adminService.updateOrderStatus(orderId, status);
    await loadOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order marked as $status")),
    );
  }

  Future<void> refundOrder(String orderId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Refund"),
        content: const Text("Approve refund for this order now?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Refund"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _adminService.refundOrder(orderId);
    await loadOrders();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Refund approved ✅")),
    );
  }

  bool canRefund(bool refundRequested, String paymentStatus) {
    return refundRequested == true && paymentStatus == "paid";
  }

  bool canChangeStatus(String currentStatus) {
    return currentStatus != "delivered" && currentStatus != "cancelled";
  }

  Widget buildStatusButton({
    required String currentStatus,
    required String newStatus,
    required Color color,
    required String orderId,
    required bool locked,
  }) {
    final isCurrent = currentStatus == newStatus;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: (isCurrent || locked)
            ? null
            : () => updateStatus(orderId, newStatus),
        child: Text(newStatus.toUpperCase()),
      ),
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("No orders found"))
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      final String orderId =
                          order["_id"]?.toString() ?? "";

                      final String displayId =
                          orderId.length > 6
                              ? orderId.substring(orderId.length - 6)
                              : orderId;

                      final String status =
                          (order["orderStatus"] ?? "processing")
                              .toString();

                      final String paymentStatus =
                          (order["paymentStatus"] ?? "pending")
                              .toString();

                      final bool refundRequested =
                          order["refundRequested"] == true;

                      final bool locked = !canChangeStatus(status);

                      final String dateStr =
                          order["createdAt"] != null
                              ? order["createdAt"]
                                  .toString()
                                  .substring(0, 10)
                              : "";

                      return Card(
                        elevation: 3,
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16)),
                        child: ExpansionTile(
                          tilePadding:
                              const EdgeInsets.all(14),
                          childrenPadding:
                              const EdgeInsets.all(14),

                          title: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Order #$displayId",
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                              ),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  if (refundRequested)
                                    statusChip(
                                        "Refund Requested",
                                        Colors.purple),
                                  statusChip(
                                      status,
                                      getOrderStatusColor(
                                          status)),
                                ],
                              ),
                            ],
                          ),

                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "User: ${order["userId"]?["name"] ?? ""}"),
                                Text(
                                    "Email: ${order["userId"]?["email"] ?? ""}"),
                                Text(
                                    "Amount: Rs ${order["totalAmount"] ?? 0}"),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Text("Payment: "),
                                    Text(
                                      paymentStatus,
                                      style: TextStyle(
                                        color:
                                            getPaymentColor(
                                                paymentStatus),
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(dateStr,
                                        style:
                                            const TextStyle(
                                                color: Colors
                                                    .grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          children: [
                            const Divider(),

                            ...List.generate(
                                order["items"]?.length ?? 0,
                                (i) {
                              final item =
                                  order["items"][i];

                              return ListTile(
                                contentPadding:
                                    EdgeInsets.zero,
                                leading: item["image"] !=
                                        null
                                    ? (item["image"]
                                            .toString()
                                            .startsWith(
                                                "http")
                                        ? Image.network(
                                            item["image"],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit
                                                .cover)
                                        : Image.asset(
                                            item["image"],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit
                                                .cover))
                                    : const Icon(Icons
                                        .shopping_bag),
                                title: Text(
                                    item["name"] ?? ""),
                                subtitle: Text(
                                    "Qty: ${item["quantity"]}"),
                                trailing: Text(
                                    "Rs ${item["price"]}"),
                              );
                            }),

                            const SizedBox(height: 12),

                            SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal,
                              child: Row(
                                children: [
                                  buildStatusButton(
                                    currentStatus:
                                        status,
                                    newStatus:
                                        "processing",
                                    color:
                                        Colors.orange,
                                    orderId:
                                        orderId,
                                    locked: locked,
                                  ),
                                  buildStatusButton(
                                    currentStatus:
                                        status,
                                    newStatus:
                                        "shipped",
                                    color: Colors.blue,
                                    orderId:
                                        orderId,
                                    locked: locked,
                                  ),
                                  buildStatusButton(
                                    currentStatus:
                                        status,
                                    newStatus:
                                        "delivered",
                                    color:
                                        Colors.green,
                                    orderId:
                                        orderId,
                                    locked: locked,
                                  ),
                                  buildStatusButton(
                                    currentStatus:
                                        status,
                                    newStatus:
                                        "cancelled",
                                    color: Colors.red,
                                    orderId:
                                        orderId,
                                    locked: locked,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            if (canRefund(
                                refundRequested,
                                paymentStatus))
                              SizedBox(
                                width: double.infinity,
                                child:
                                    ElevatedButton.icon(
                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        Colors.purple,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  12),
                                    ),
                                  ),
                                  onPressed: () =>
                                      refundOrder(
                                          orderId),
                                  icon: const Icon(Icons
                                      .currency_exchange),
                                  label: const Text(
                                      "Approve Refund"),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}