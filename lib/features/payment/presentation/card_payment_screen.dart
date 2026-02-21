import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/presentation/payment_success_screen.dart';

class CardPaymentScreen extends StatefulWidget {
  final double amount;

  const CardPaymentScreen({
    super.key,
    required this.amount,
  });

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final cardController = TextEditingController();
  final cvvController = TextEditingController();

  String? selectedMonth;
  String? selectedYear;

  int currentStep = 0;

  final List<String> months =
      List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> years =
      List.generate(15, (i) => (DateTime.now().year + i).toString());

  @override
  void dispose() {
    nameController.dispose();
    cardController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  // ===================== HELPERS =====================

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  /// Makes "1234123412341234" => "1234 1234 1234 1234"
  String _formatIntoGroupsOf4(String digits) {
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i != digits.length - 1) buffer.write(" ");
    }
    return buffer.toString();
  }

  /// Always show 16 positions grouped by 4.
  /// Example:
  /// input "12" => "12** **** **** ****"
  /// input ""   => "**** **** **** ****"
  String maskedCardDisplay(String rawInput) {
    final digits = _digitsOnly(rawInput);
    final padded = (digits + ("*" * 16)).substring(0, 16);

    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      buffer.write(padded[i]);
      if ((i + 1) % 4 == 0 && i != 15) buffer.write(" ");
    }
    return buffer.toString();
  }

  String expiryDisplay() {
    final mm = selectedMonth ?? "MM";
    final yy = selectedYear != null ? selectedYear!.substring(2) : "YY";
    return "$mm/$yy";
  }

  // ===================== CARD PREVIEW =====================

  Widget cardPreview() {
    final holderName = nameController.text.trim().isEmpty
        ? "CARD HOLDER"
        : nameController.text.trim().toUpperCase();

    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 51, 85, 57), Color.fromARGB(255, 48, 80, 63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Text(
              "VISA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),

          const Spacer(),

          // CARD NUMBER (masked realistic)
          Text(
            maskedCardDisplay(cardController.text),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // HOLDER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CARD HOLDER",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 170,
                    child: Text(
                      holderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              // EXPIRES + CVV (CVV always ***)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "EXPIRES",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${expiryDisplay()}   CVV: ***",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Secure Card Payment"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // tighter
        child: Column(
          children: [
            // TOTAL CARD (less tall)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 251, 250, 250), Color.fromARGB(255, 253, 253, 253)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(color: Color.fromARGB(179, 5, 5, 5)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rs. ${widget.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 7, 7, 7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _buildStepIndicator(),
            const SizedBox(height: 16),

            if (currentStep == 0) paymentStep(),
            if (currentStep == 1) reviewStep(),
            if (currentStep == 2) receiptStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stepChip("Payment", currentStep == 0),
        _stepChip("Review", currentStep == 1),
        _stepChip("Receipt", currentStep == 2),
      ],
    );
  }

  Widget _stepChip(String title, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color.fromARGB(255, 147, 146, 150) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // ===================== PAYMENT STEP =====================

  Widget paymentStep() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          cardPreview(),
          const SizedBox(height: 14),

          // Add Card container like screenshot
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 173, 171, 171).withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Card",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _softField(
                  label: "Cardholder Name",
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  suffixIcon: Icons.person_outline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Enter name";
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 12),

                _softField(
                  label: "Card Number",
                  controller: cardController,
                  keyboardType: TextInputType.number,
                  suffixIcon: Icons.credit_card,
                  highlightBorder: true, // green like screenshot
                  maxLength: 19, // "1234 1234 1234 1234"
                  onChanged: (val) {
                    final digits = _digitsOnly(val);
                    final formatted = _formatIntoGroupsOf4(digits);

                    if (formatted != val) {
                      cardController.value = TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                    setState(() {});
                  },
                  validator: (v) {
                    final digits = _digitsOnly(v ?? "");
                    if (digits.length != 16) return "Enter 16 digit card number";
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _dropdownField(
                        label: "Expiry Date",
                        hint: "MM",
                        value: selectedMonth,
                        items: months,
                        icon: Icons.calendar_month_outlined,
                        onChanged: (val) => setState(() => selectedMonth = val),
                        validator: (val) => val == null ? "Select" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdownField(
                        label: "",
                        hint: "YY",
                        value: selectedYear != null ? selectedYear!.substring(2) : null,
                        items: years.map((y) => y.substring(2)).toList(),
                        icon: Icons.calendar_today_outlined,
                        onChanged: (val) {
                          final full = years.firstWhere((y) => y.endsWith(val ?? ""));
                          setState(() => selectedYear = full);
                        },
                        validator: (val) => val == null ? "Select" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _softField(
                  label: "Security Code",
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  suffixIcon: Icons.info_outline,
                  maxLength: 3,
                  obscure: true,
                  validator: (v) {
                    if (v == null || v.length != 3) return "Enter 3 digit CVV";
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 100, 111, 186),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => currentStep = 1);
                      }
                    },
                    child: const Text("Proceed to Review"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== REVIEW STEP =====================

  Widget reviewStep() {
    final digits = _digitsOnly(cardController.text);
    final last4 = digits.length >= 4 ? digits.substring(digits.length - 4) : "----";

    return Column(
      children: [
        const Icon(Icons.credit_card, size: 70, color: Color(0xFFff3f6c)),
        const SizedBox(height: 12),
        Text(
          "**** **** **** $last4",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          "Expiry: ${expiryDisplay()}   |   CVV: ***",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 100, 111, 186),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: () => setState(() => currentStep = 2),
            child: const Text("Confirm Payment"),
          ),
        ),
      ],
    );
  }

  // ===================== RECEIPT STEP =====================

  Widget receiptStep() {
    return Column(
      children: [
        const Icon(Icons.check_circle, size: 90, color: Colors.green),
        const SizedBox(height: 12),
        const Text(
          "Payment Successful 🎉",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 100, 111, 186),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
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
        ),
      ],
    );
  }

  // ===================== FIELDS UI =====================

  Widget _softField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    IconData? suffixIcon,
    bool highlightBorder = false,
    int? maxLength,
    bool obscure = false,
    Function(String)? onChanged,
  }) {
    final radius = BorderRadius.circular(14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          obscureText: obscure,
          onChanged: onChanged,
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: const Color(0xFFF7F7FB),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.grey)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                color: highlightBorder
                    ? const Color(0xFF60BB46)
                    : Colors.transparent,
                width: highlightBorder ? 1.6 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                color: highlightBorder
                    ? const Color(0xFF60BB46)
                    : const Color(0xFF7065E5),
                width: 1.8,
              ),
            ),
            border: OutlineInputBorder(borderRadius: radius),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    final radius = BorderRadius.circular(14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(label, style: const TextStyle(color: Colors.grey)),
        if (label.isNotEmpty) const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F7FB),
            hintText: hint,
            suffixIcon: Icon(icon, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(color: Color.fromARGB(255, 244, 244, 245), width: 1.8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
          items: items
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}