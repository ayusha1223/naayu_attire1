import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:naayu_attire1/core/services/order_service.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late Future<List<dynamic>> _ordersFuture;

  String? cancellingOrderId;

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  // ---------------- FETCH ORDERS ----------------

  Future<List<dynamic>> fetchOrders() async {
    final tokenService = Provider.of<TokenService>(context, listen: false);
    final token = await tokenService.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    return await OrderService().getOrders(token);
  }

  Future<void> refreshOrders() async {
    setState(() {
      _ordersFuture = fetchOrders();
    });
    await _ordersFuture;
  }

  // ---------------- DATE FORMAT ----------------

  String formatDate(String? dateString) {
    if (dateString == null) return "";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (_) {
      return dateString;
    }
  }

  // ---------------- STATUS COLORS ----------------

  Color getOrderStatusColor(String? status) {
    switch (status?.toLowerCase()) {
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

  Color getPaymentColor(String? status) {
    switch (status?.toLowerCase()) {
      case "paid":
        return Colors.green;
      case "refunded":
        return Colors.purple;
      case "pending":
        return Colors.orange;
      case "failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ---------------- CHIP ----------------

  Widget chip({
    required String text,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- IMAGE ----------------

  Widget buildItemImage(dynamic imageValue) {
    final img = (imageValue ?? "").toString().trim();

    if (img.isEmpty) {
      return const Icon(Icons.image_not_supported);
    }

    if (img.startsWith("http")) {
      return Image.network(
        img,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported),
      );
    }

    return Image.asset(
      img,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.image_not_supported),
    );
  }

  // ---------------- CANCEL ORDER ----------------

  Future<void> cancelOrder(String orderId) async {
    try {
      setState(() => cancellingOrderId = orderId);

      final tokenService =
          Provider.of<TokenService>(context, listen: false);
      final token = await tokenService.getToken();

      if (token == null) {
        throw Exception("Token missing. Please login again.");
      }

      await OrderService().cancelOrder(
        orderId: orderId,
        token: token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Refund request submitted. Admin will approve refund."),
        ),
      );

      await refreshOrders();
    } on DioException catch (e) {
      final String msg =
          (e.response?.data is Map &&
                  e.response?.data["message"] != null)
              ? e.response!.data["message"].toString()
              : "Unable to cancel order";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => cancellingOrderId = null);
    }
  }

  // ---------------- CANCEL RULE ----------------

  bool canCancelOrder({
    required String orderStatus,
    required bool refundRequested,
  }) {
    return orderStatus.toLowerCase() == "processing" &&
        refundRequested == false;
  }

  // ---------------- CANCEL BUTTON ----------------

  Widget buildCancelButton({
    required Map order,
    required String orderStatus,
    required bool refundRequested,
  }) {
    final String orderId = order["_id"]?.toString() ?? "";
    final bool loading = cancellingOrderId == orderId;

    final bool canCancel = canCancelOrder(
      orderStatus: orderStatus,
      refundRequested: refundRequested,
    );

    String label;
    if (refundRequested) {
      label = "Refund Requested";
    } else if (!canCancel) {
      label = "Cannot Cancel";
    } else {
      label = "Cancel Order";
    }

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canCancel ? Colors.red : Colors.grey.shade300,
          foregroundColor:
              canCancel ? Colors.white : Colors.grey.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: (!canCancel || loading)
            ? null
            : () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Cancel Order"),
                    content: const Text(
                        "This will submit a refund request. Continue?"),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false),
                        child: const Text("No"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, true),
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await cancelOrder(orderId);
                }
              },
        child: loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
                child: Text("No orders yet"));
          }

          return RefreshIndicator(
            onRefresh: refreshOrders,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final items = order["items"] as List? ?? [];

                final String orderId =
                    order["_id"]?.toString() ?? "";

                final String displayId =
                    orderId.length > 6
                        ? orderId.substring(orderId.length - 6)
                        : orderId;

                final String orderStatus =
                    (order["orderStatus"] ?? "processing")
                        .toString();

                final String paymentStatus =
                    (order["paymentStatus"] ?? "pending")
                        .toString();

                final bool refundRequested =
                    order["refundRequested"] == true;

                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 18),
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.05),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            "Order #$displayId",
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          chip(
                            text: orderStatus,
                            color:
                                getOrderStatusColor(
                                    orderStatus),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Date: ${formatDate(order["createdAt"])}"),
                      const SizedBox(height: 10),
                      Text(
                          "Total: Rs ${order["totalAmount"] ?? 0}"),
                      const SizedBox(height: 14),
                      buildCancelButton(
                        order: order,
                        orderStatus:
                            orderStatus,
                        refundRequested:
                            refundRequested,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}