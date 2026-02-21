import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int currentStage; // 0 = Processing, 1 = Shipped, 2 = Delivered
  final String orderId;
  final String estimatedDelivery;

  const OrderTrackingScreen({
    super.key,
    required this.currentStage,
    required this.orderId,
    required this.estimatedDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Track Order"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// ORDER SUMMARY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF60BB46), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order ID",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    orderId,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Estimated Delivery",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    estimatedDelivery,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// TRACKING STEPS
            _buildStep(
              icon: Icons.inventory_2,
              title: "Order Processing",
              subtitle: "Your order is being prepared",
              isCompleted: currentStage >= 0,
              isActive: currentStage == 0,
            ),

            _buildLine(),

            _buildStep(
              icon: Icons.local_shipping,
              title: "Shipped",
              subtitle: "Your package is on the way",
              isCompleted: currentStage >= 1,
              isActive: currentStage == 1,
            ),

            _buildLine(),

            _buildStep(
              icon: Icons.home,
              title: "Delivered",
              subtitle: "Package delivered successfully",
              isCompleted: currentStage >= 2,
              isActive: currentStage == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// ICON CIRCLE
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF60BB46)
                : Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF60BB46)
                          .withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 26,
          ),
        ),

        const SizedBox(width: 20),

        /// TEXT SECTION
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? const Color(0xFF60BB46)
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLine() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, top: 10, bottom: 10),
      child: Container(
        width: 3,
        height: 40,
        color: Colors.grey.shade300,
      ),
    );
  }
}