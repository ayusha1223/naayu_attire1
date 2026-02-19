import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'esewa_otp_screen.dart';

class EsewaWebviewScreen extends StatefulWidget {
  final double amount;

  const EsewaWebviewScreen({
    super.key,
    required this.amount,
  });

  @override
  State<EsewaWebviewScreen> createState() =>
      _EsewaWebviewScreenState();
}

class _EsewaWebviewScreenState
    extends State<EsewaWebviewScreen> {

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {

            // 🔥 When fake login button triggers redirect
            if (request.url.contains("success")) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EsewaOtpScreen(
                        amount: widget.amount,
                      ),
                ),
              );

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(_fakeEsewaHtml());
  }

  String _fakeEsewaHtml() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          font-family: Arial;
          background: white;
          padding: 20px;
        }
        .logo {
          color: #60BB46;
          font-size: 32px;
          font-weight: bold;
          margin-bottom: 30px;
        }
        input {
          width: 100%;
          padding: 12px;
          margin-top: 10px;
          margin-bottom: 20px;
          border: 1px solid #ccc;
          border-radius: 5px;
          font-size: 16px;
        }
        button {
          width: 100%;
          padding: 15px;
          background: #60BB46;
          color: white;
          border: none;
          border-radius: 5px;
          font-size: 18px;
        }
        .welcome {
          font-size: 22px;
          margin-bottom: 10px;
        }
      </style>
    </head>

    <body>

      <div class="logo">eSewa</div>

      <div class="welcome">Welcome,</div>
      <div>Sign in to continue</div>

      <input type="text" placeholder="eSewa ID (10 digit number)" maxlength="10">
      <input type="password" placeholder="Password">

      <button onclick="window.location.href='https://success'">
        Login
      </button>

      <div style="margin-top:20px; color:#60BB46;">
        REGISTER FOR FREE
      </div>

    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eSewa Payment"),
        backgroundColor: const Color(0xFF60BB46),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
