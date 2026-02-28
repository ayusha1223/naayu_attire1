// import 'package:esewa_flutter_sdk/esewa_config.dart';
// import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
// import 'package:esewa_flutter_sdk/esewa_payment.dart';

// class EsewaPaymentService {
//   static void pay({
//     required double amount,
//     required String orderId,
//     required Function onSuccess,
//     required Function onFailure,
//   }) {
//     try {
//       EsewaFlutterSdk.initPayment(
//         esewaConfig: EsewaConfig(
//           environment: Environment.test,
//           clientId: "YOUR_MERCHANT_ID",
//           secretId: "YOUR_SECRET_KEY",
//         ),
//         esewaPayment: EsewaPayment(
//           productId: orderId,
//           productName: "Naayu Attire Order",
//           productPrice: amount.toString(),
//           callbackUrl: "http://192.168.1.5:5000/api/esewa/verify",
//         ),
//         onPaymentSuccess: (data) {
//           onSuccess(data);
//         },
//         onPaymentFailure: (data) {
//           onFailure(data);
//         },
//         onPaymentCancellation: () {
//           onFailure("Cancelled");
//         },
//       );
//     } catch (e) {
//       print("eSewa Error: $e");
//     }
//   }
// }