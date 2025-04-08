class PriceSummaryTShopper {
  double totalPrice;
  double productsPrice;
  double deliveryFee;
  double tip;
  double discountAmount;
  double couponAmount;
  String couponUsed;
  double todosAmount;

  PriceSummaryTShopper({
    required this.totalPrice,
    required this.productsPrice,
    required this.deliveryFee,
    required this.tip,
    required this.discountAmount,
    required this.couponAmount,
    required this.couponUsed,
    required this.todosAmount,
  });

  factory PriceSummaryTShopper.fromJson(Map<String, dynamic> json) {
    return PriceSummaryTShopper(
      totalPrice: json['totalPrice'],
      productsPrice: json['productsPrice'],
      deliveryFee: json['deliveryFee'],
      tip: json['tip'],
      discountAmount: json['discountAmount'],
      couponAmount: json['couponAmount'],
      couponUsed: json['couponUsed'],
      todosAmount: json['todosAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPrice': totalPrice,
      'productsPrice': productsPrice,
      'deliveryFee': deliveryFee,
      'tip': tip,
      'discountAmount': discountAmount,
      'couponAmount': couponAmount,
      'couponUsed': couponUsed,
      'todosAmount': todosAmount,
    };
  }
}