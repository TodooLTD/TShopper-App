class MissionTimeline {
  String? courierAssigned;
  String? estimatedPreparationCompletedTime;
  String? estimatedDeliveryTime;
  String? preparationCompleted;
  String? courierArrivedAtBusiness;
  String? orderPickedUp;
  String? enRouteToCustomer;
  String? courierArrivedToCustomer;
  String? actualDeliveryTime;
  String? orderDelivered;
  String? cancelReason;
  String? orderCancelled;
  String? lastUpdated;
  String? courierArrivedToShopper;
  String? courierScannedWrongBarcode;

  MissionTimeline({
    this.estimatedPreparationCompletedTime,
    this.preparationCompleted,
    this.courierAssigned,
    this.courierArrivedAtBusiness,
    this.orderPickedUp,
    this.enRouteToCustomer,
    this.estimatedDeliveryTime,
    this.courierArrivedToCustomer,
    this.actualDeliveryTime,
    this.orderDelivered,
    this.orderCancelled,
    this.lastUpdated,
    this.cancelReason,
    this.courierArrivedToShopper,
    this.courierScannedWrongBarcode,
  });

  factory MissionTimeline.fromJson(Map<String, dynamic> json) {

    return MissionTimeline(
      estimatedPreparationCompletedTime: json['estimatedPreparationCompletedTime'] ?? "",
      preparationCompleted: json['preparationCompleted'] ?? "",
      courierAssigned: json['courierAssigned'] ?? "",
      courierArrivedAtBusiness: json['courierArrivedAtBusiness'] ?? "",
      orderPickedUp: json['orderPickedUp'] ?? "",
      enRouteToCustomer: json['enRouteToCustomer'] ?? "",
      estimatedDeliveryTime: json['estimatedDeliveryTime'] ?? "",
      courierArrivedToCustomer: json['courierArrivedToCustomer'] ?? "",
      actualDeliveryTime: json['actualDeliveryTime'] ?? "",
      orderDelivered: json['orderDelivered'] ?? "",
      orderCancelled: json['orderCancelled'] ?? "",
      lastUpdated: json['lastUpdated'] ?? "",
      cancelReason: json['cancelReason'] ?? "",
      courierArrivedToShopper: json['courierArrivedToShopper'] ?? "",
      courierScannedWrongBarcode: json['courierScannedWrongBarcode'] ?? "",
    );
  }
}