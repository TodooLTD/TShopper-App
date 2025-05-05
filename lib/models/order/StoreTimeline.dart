class StoreTimeline {
  String? startCollecting;
  String? doneCollecting;
  String? startPaymentProcess;
  String? donePaymentProcess;
  String? donePreparation;
  String? storeCancelled;
  String? cancelReason;


  StoreTimeline({
    this.startCollecting,
    this.doneCollecting,
    this.startPaymentProcess,
    this.donePaymentProcess,
    this.donePreparation,
    this.storeCancelled,
    this.cancelReason,
  });

  factory StoreTimeline.fromJson(Map<String, dynamic> json) {

    return StoreTimeline(
      startCollecting: json['startCollecting'] ?? "",
      doneCollecting: json['doneCollecting'] ?? "",
      startPaymentProcess: json['startPaymentProcess'] ?? "",
      donePaymentProcess: json['donePaymentProcess'] ?? "",
      donePreparation: json['donePreparation'] ?? "",
      storeCancelled: json['storeCancelled'] ?? "",
      cancelReason: json['cancelReason'] ?? "",
    );
  }

}