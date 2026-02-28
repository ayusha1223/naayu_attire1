import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'payment_success_screen.dart';

class EsewaWebviewScreen extends StatefulWidget {
  final double amount;

  final String customerName;
  final String email;
  final String phone;
  final String address;

  const EsewaWebviewScreen({
    super.key,
    required this.amount,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,
  });
  @override
  State<EsewaWebviewScreen> createState() => _EsewaWebviewScreenState();
}

class _EsewaWebviewScreenState extends State<EsewaWebviewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  // 🔴 IMPORTANT: Change if your IP changes
  final String backendUrl =
      "http://192.168.1.74:3000/api/esewa/create-esewa-payment";

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // 1️⃣ Call backend to get signed data
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": widget.amount}),
      );

      if (response.statusCode != 200) {
        throw Exception("Server responded with ${response.statusCode}");
      }

      final decoded = jsonDecode(response.body);

      if (decoded["success"] != true) {
        throw Exception("Backend returned failure");
      }

      final Map<String, dynamic> paymentData =
          Map<String, dynamic>.from(decoded["payment"]);

      // 2️⃣ Convert map to form body
      final String postBody = paymentData.entries
          .map((e) =>
              "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}")
          .join("&");

      // 3️⃣ Setup WebView safely
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (_) {
              setState(() => _isLoading = false);
            },
            onWebResourceError: (error) {
              print("WebView Error: ${error.description}");
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            },
            onNavigationRequest: (request) {
              final url = request.url;

              print("Redirected URL: $url");

              // SUCCESS
             if (url.contains("/api/esewa/success")) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => PaymentSuccessScreen(
        amount: widget.amount,
        paymentMethod: "esewa",
        customerName: widget.customerName,
        email: widget.email,
        phone: widget.phone,
        address: widget.address,
      ),
    ),
  );
  return NavigationDecision.prevent;
}

              // FAILURE
              if (url.contains("/api/esewa/failure")) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment Failed")),
                );
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(
          Uri.parse(
            "https://rc-epay.esewa.com.np/api/epay/main/v2/form",
          ),
          method: LoadRequestMethod.post,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: Uint8List.fromList(utf8.encode(postBody)),
        );

      setState(() {
        _controller = controller;
      });
    } catch (e) {
      print("Payment Initialization Error: $e");

      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment initialization failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eSewa Payment"),
        backgroundColor: const Color(0xFF6E52BC),
      ),
      body: Stack(
        children: [
          if (_controller != null)
            WebViewWidget(controller: _controller!),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (_hasError)
            const Center(
              child: Text(
                "Something went wrong.\nPlease try again.",
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}