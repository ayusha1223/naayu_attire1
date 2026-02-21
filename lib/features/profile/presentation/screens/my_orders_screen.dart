import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:naayu_attire1/core/services/order_service.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() =>
      _MyOrdersScreenState();
}

class _MyOrdersScreenState
    extends State<MyOrdersScreen> {

  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<dynamic>> fetchOrders() async {
    try {
      final tokenService =
          Provider.of<TokenService>(context,
              listen: false);

      final token = await tokenService.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      final orderService = OrderService();

      return await orderService.getOrders(token);
    } on DioException catch (e) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");

      throw Exception("Server error. Please try again.");
    } catch (e) {
      print("GENERAL ERROR: $e");
      rethrow;
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                "No orders yet",
                style:
                    TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin:
                    const EdgeInsets.only(
                        bottom: 15),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                          15),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [

                      /// ORDER ID
                      Text(
                        "Order ID: ${order["_id"] ?? "N/A"}",
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// TOTAL
                      Text(
                        "Total: \$${order["totalAmount"] ?? 0}",
                      ),

                      const SizedBox(height: 6),

                      /// ORDER STATUS (FIXED)
                      Text(
                        "Order Status: ${order["orderStatus"] ?? "processing"}",
                      ),

                      const SizedBox(height: 6),

                      /// PAYMENT STATUS (FIXED)
                      Text(
                        "Payment Status: ${order["paymentStatus"] ?? "pending"}",
                      ),

                      const SizedBox(height: 6),

                      /// DATE
                      Text(
                        "Date: ${formatDate(order["createdAt"])}",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}