import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/presentation/payment_success_screen.dart';

class CardPaymentScreen extends StatefulWidget {
  final double amount;

  const CardPaymentScreen({
    super.key,
    required this.amount,
  });

  @override
  State<CardPaymentScreen> createState() =>
      _CardPaymentScreenState();
}

class _CardPaymentScreenState
    extends State<CardPaymentScreen> {

  final _formKey = GlobalKey<FormState>();

  final cardController = TextEditingController();
  final cvvController = TextEditingController();

  String? selectedMonth;
  String? selectedYear;

  int currentStep = 0;

  List<String> months = List.generate(
      12, (index) => (index + 1).toString().padLeft(2, '0'));

  List<String> years = List.generate(
      15,
      (index) =>
          (DateTime.now().year + index).toString());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Card Payment"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ===== TOTAL =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Text(
                "Rs. ${widget.amount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ===== STEP BAR =====
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                stepChip("Payment", currentStep == 0),
                stepChip("Review", currentStep == 1),
                stepChip("Receipt", currentStep == 2),
              ],
            ),

            const SizedBox(height: 25),

            if (currentStep == 0) paymentStep(),
            if (currentStep == 1) reviewStep(),
            if (currentStep == 2) receiptStep(),
          ],
        ),
      ),
    );
  }

  // ================= PAYMENT STEP =================

  Widget paymentStep() {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          TextFormField(
            controller: cardController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Card Number",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.length < 16) {
                return "Enter valid card number";
              }
              return null;
            },
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: DropdownButtonFormField(
                  value: selectedMonth,
                  decoration: const InputDecoration(
                    labelText: "Month",
                    border: OutlineInputBorder(),
                  ),
                  items: months
                      .map((m) =>
                          DropdownMenuItem(
                            value: m,
                            child: Text(m),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: DropdownButtonFormField(
                  value: selectedYear,
                  decoration: const InputDecoration(
                    labelText: "Year",
                    border: OutlineInputBorder(),
                  ),
                  items: years
                      .map((y) =>
                          DropdownMenuItem(
                            value: y,
                            child: Text(y),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          TextFormField(
            controller: cvvController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "CVV",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.length < 3) {
                return "Enter valid CVV";
              }
              return null;
            },
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!
                    .validate()) {

                  setState(() {
                    currentStep = 1;
                  });
                }
              },
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  // ================= REVIEW STEP =================

  Widget reviewStep() {
    return Column(
      children: [

        const Icon(Icons.credit_card,
            size: 60, color: Colors.green),

        const SizedBox(height: 10),

        const Text(
          "Review Payment Details",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Text(
            "Card: **** **** **** ${cardController.text.substring(cardController.text.length - 4)}"),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            setState(() {
              currentStep = 2;
            });
          },
          child: const Text("Confirm Payment"),
        ),
      ],
    );
  }

  // ================= RECEIPT STEP =================

  Widget receiptStep() {
    return Column(
      children: [

        const Icon(Icons.check_circle,
            size: 80, color: Colors.green),

        const SizedBox(height: 15),

        const Text(
          "Payment Successful 🎉",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        const Text(
            "Thank you for shopping with Naayu Attire"),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentSuccessScreen(
                  amount: widget.amount,
                  paymentMethod: "card",
                ),
              ),
            );
          },
          child: const Text("Continue"),
        ),
      ],
    );
  }
}

// ================= STEP CHIP =================

class stepChip extends StatelessWidget {
  final String title;
  final bool active;

  const stepChip(this.title, this.active,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color:
            active ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color:
              active ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
