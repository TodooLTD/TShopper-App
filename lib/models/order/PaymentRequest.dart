class PaymentRequest {
  int id;
  String requestCreated;
  String paidAt;
  String rejectedAt;
  String cancelledAt;
  String failedAt;
  String reason;
  double verifyPrice;
  double forcePrice;
  double deliveryFeePrice;
  double todoCommission;
  double productsPrice;
  String status;

  PaymentRequest({
    required this.id,
    required this.requestCreated,
    required this.paidAt,
    required this.rejectedAt,
    required this.cancelledAt,
    required this.failedAt,
    required this.reason,
    required this.verifyPrice,
    required this.forcePrice,
    required this.deliveryFeePrice,
    required this.todoCommission,
    required this.productsPrice,
    required this.status,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      id: json['id'] ?? 0,
      requestCreated: json['requestCreated'] ?? '',
      paidAt: json['paidAt'] ?? '',
      rejectedAt: json['rejectedAt'] ?? '',
      cancelledAt: json['cancelledAt'] ?? '',
      failedAt: json['failedAt'] ?? '',
      reason: json['reason'] ?? '',
      verifyPrice: json['verifyPrice'] ?? 0.0,
      forcePrice: json['forcePrice'] ?? 0.0,
      deliveryFeePrice: json['deliveryFeePrice'] ?? 0.0,
      productsPrice: json['productsPrice'] ?? 0.0,
      todoCommission: json['todoCommission'] ?? 0.0,
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'requestCreated': requestCreated,
      'verifyPrice':verifyPrice,
      'forcePrice': forcePrice,
      'deliveryFeePrice': deliveryFeePrice,
      'status': 'WAITING',
    };
  }
}