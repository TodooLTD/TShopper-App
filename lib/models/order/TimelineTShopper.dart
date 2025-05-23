class TimelineTShopper {
  String? orderPlaced;
  String? orderSeenByShopper;
  String? shopperIdSeenBy;
  String? shopperNameSeenBy;
  String? orderConfirmedByShopper;
  String? shopperIdConfirmedBy;
  String? shopperNameConfirmedBy;
  String? orderAssignToShopper;
  String? startWorkingOnOrder;
  String? doneCollecting;
  String? donePaymentProcess;
  String? orderDeliveryMission;
  String? orderPickedUp;
  String? enRouteToCustomer;
  String? estimatedDeliveryTime;
  String? courierArrivedToCustomer;
  String? actualDeliveryTime;
  String? orderDelivered;
  String? orderCancelled;
  String? issueReported;
  String? paymentProcessed;
  String? lastUpdated;
  String? orderRefused;
  String? courierAssigned;
  String? cancelReason;


  TimelineTShopper({
    this.orderPlaced,
    this.orderSeenByShopper,
    this.orderConfirmedByShopper,
    this.orderAssignToShopper,
    this.startWorkingOnOrder,
    this.doneCollecting,
    this.donePaymentProcess,
    this.orderDeliveryMission,
    this.enRouteToCustomer,
    this.estimatedDeliveryTime,
    this.courierArrivedToCustomer,
    this.actualDeliveryTime,
    this.orderDelivered,
    this.orderCancelled,
    this.issueReported,
    this.paymentProcessed,
    this.lastUpdated,
    this.orderRefused,
    this.courierAssigned,
    this.cancelReason,
    this.shopperIdSeenBy,
    this.shopperNameSeenBy,
    this.shopperIdConfirmedBy,
    this.shopperNameConfirmedBy,
  });

  factory TimelineTShopper.fromJson(Map<String, dynamic> json) {

    return TimelineTShopper(
      orderPlaced: json['orderPlaced'] ?? "",
      orderSeenByShopper: json['orderSeenByShopper'] ?? "",
      orderConfirmedByShopper: json['orderConfirmedByShopper'] ?? "",
      orderAssignToShopper: json['orderAssignToShopper'] ?? "",
      startWorkingOnOrder: json['startWorkingOnOrder'] ?? "",
      doneCollecting: json['doneCollecting'] ?? "",
      donePaymentProcess: json['donePaymentProcess'] ?? "",
      orderDeliveryMission: json['orderDeliveryMission'] ?? "",
      enRouteToCustomer: json['enRouteToCustomer'] ?? "",
      estimatedDeliveryTime: json['estimatedDeliveryTime'] ?? "",
      courierArrivedToCustomer: json['courierArrivedToCustomer'] ?? "",
      actualDeliveryTime: json['actualDeliveryTime'] ?? "",
      orderDelivered: json['orderDelivered'] ?? "",
      orderCancelled: json['orderCancelled'] ?? "",
      issueReported: json['issueReported'] ?? "",
      paymentProcessed: json['paymentProcessed'] ?? "",
      lastUpdated: json['lastUpdated'] ?? "",
      orderRefused: json['orderRefused'] ?? "",
      courierAssigned: json['courierAssigned'] ?? "",
      cancelReason: json['cancelReason'] ?? "",
      shopperNameSeenBy: json['shopperNameSeenBy'] ?? "",
      shopperNameConfirmedBy: json['shopperNameConfirmedBy'] ?? "",
      shopperIdSeenBy: json['shopperIdSeenBy'] ?? "",
      shopperIdConfirmedBy: json['shopperIdConfirmedBy'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderPlaced': orderPlaced,
      'orderSeenByShopper': orderSeenByShopper,
      'orderConfirmedByShopper': orderConfirmedByShopper,
      'orderAssignToShopper': orderAssignToShopper,
      'startWorkingOnOrder': startWorkingOnOrder,
      'doneCollecting': doneCollecting,
      'donePaymentProcess': donePaymentProcess,
      'orderDeliveryMission': orderDeliveryMission,
      'orderDeliveryMission': orderDeliveryMission,
      'enRouteToCustomer': enRouteToCustomer,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'courierArrivedToCustomer': courierArrivedToCustomer,
      'actualDeliveryTime': actualDeliveryTime,
      'orderDelivered': orderDelivered,
      'orderCancelled': orderCancelled,
      'issueReported': issueReported,
      'lastUpdated': lastUpdated,
      'orderRefused': orderRefused,
      'courierAssigned': courierAssigned,
      'cancelReason': cancelReason,
    };
  }
}