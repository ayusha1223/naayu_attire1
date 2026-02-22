class ApiEndpoints {
  ApiEndpoints._();

  // ================= Base URL =================
  // Android Emulator
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

  // Physical Device (example)
   static const String baseUrl = 'http://192.168.1.74:3000/api/v1';

  // ================= Auth Endpoints =================
  static const String studentRegister = '/students/register';
  static const String studentLogin = '/students/login';
  static const String forgotPassword = "/students/forgot-password";
  static const String resetPassword = "/students/reset-password";
  static const String verifyOtp = "/students/verify-otp";

  // ================= Other Endpoints (future) =================
  static const String students = '/students';
}
