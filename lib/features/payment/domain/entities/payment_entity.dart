class PaymentEntity {

  final String orderId;
  final String paymentMethod;
  final String transactionId;

  PaymentEntity({
    required this.orderId,
    required this.paymentMethod,
    required this.transactionId,
  });

}