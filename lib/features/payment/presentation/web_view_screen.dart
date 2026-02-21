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
  State<EsewaWebviewScreen> createState() => _EsewaWebviewScreenState();
}

class _EsewaWebviewScreenState extends State<EsewaWebviewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            // ✅ Only navigate when success happens
            if (request.url.contains("success")) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => EsewaOtpScreen(
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
  width: 90%;              /* 👈 smaller width */
  padding: 10px;           /* 👈 slightly smaller height */
  margin: 10px auto 18px;  /* 👈 center them */
  display: block;          /* 👈 needed for centering */
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 15px;
  outline: none;
}
    input:focus {
      border: 1px solid #60BB46;
    }
    button {
      width: 100%;
      padding: 15px;
      background: #60BB46;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 18px;
      cursor: pointer;
      opacity: 0.55;   /* disabled look */
    }
    button.enabled {
      opacity: 1;
    }
    .welcome {
      font-size: 22px;
      margin-bottom: 10px;
    }

    /* ✅ Register right side */
    .registerRow {
      margin-top: 20px;
      display: flex;
      justify-content: flex-end;
    }
    .register {
      color: #60BB46;
      font-size: 14px;
      cursor: pointer;
    }
  </style>
</head>

<body>

  <div class="logo">eSewa</div>

  <div class="welcome">Welcome,</div>
  <div>Sign in to continue</div>

  <!-- ✅ eSewa ID must be exactly 10 digits -->
  <input id="esewaId" type="text" placeholder="eSewa ID (10 digit number)" maxlength="10" inputmode="numeric">

  <input id="password" type="password" placeholder="Password">

  <!-- ✅ Disabled until valid -->
  <button id="loginBtn" onclick="attemptLogin()" disabled>
    Login
  </button>

  <div class="registerRow">
    <div class="register" onclick="alert('This is a demo page')">
      REGISTER FOR FREE
    </div>
  </div>

<script>
  const esewaId = document.getElementById("esewaId");
  const password = document.getElementById("password");
  const loginBtn = document.getElementById("loginBtn");

  // Allow only digits in eSewa ID
  esewaId.addEventListener("input", () => {
    esewaId.value = esewaId.value.replace(/[^0-9]/g, "");
    validateForm();
  });

  password.addEventListener("input", validateForm);

  function validateForm() {
    const idOk = esewaId.value.length === 10;
    const passOk = password.value.trim().length > 0;

    if (idOk && passOk) {
      loginBtn.disabled = false;
      loginBtn.classList.add("enabled");
    } else {
      loginBtn.disabled = true;
      loginBtn.classList.remove("enabled");
    }
  }

  function attemptLogin() {
    const idOk = esewaId.value.length === 10;
    const passOk = password.value.trim().length > 0;

    if (!idOk) {
      alert("eSewa ID must be exactly 10 digits.");
      return;
    }
    if (!passOk) {
      alert("Please enter your password.");
      return;
    }

    // ✅ Only now redirect to success
    window.location.href = "https://success";
  }
</script>

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