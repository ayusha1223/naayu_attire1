import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Simulated current order stage (0-4)
    int currentStage = 2; 
    // 0 = Processing
    // 1 = Processed
    // 2 = Packed
    // 3 = On The Way
    // 4 = Delivered

    final List<String> steps = [
      "Processing",
      "Processed",
      "Packed",
      "On The Way",
      "Delivered"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 10),

            const Text(
              "Estimated Delivery: 3-5 Days",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  bool isCompleted = index <= currentStage;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isCompleted
                                ? Colors.green
                                : Colors.grey,
                          ),
                          if (index != steps.length - 1)
                            Container(
                              width: 2,
                              height: 40,
                              color: isCompleted
                                  ? Colors.green
                                  : Colors.grey.shade300,
                            ),
                        ],
                      ),

                      const SizedBox(width: 12),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          steps[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isCompleted
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCompleted
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
