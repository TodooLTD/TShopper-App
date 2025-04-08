class TShopper {
  static TShopper? _instance;

  final String uid;
  final String firstName;
  final String lastName;
  final String mail;
  final String phoneNumber;
  final int currentShoppingCenterId;
  final double latitude;
  final double longitude;
  final String status;
  final String barcodeCode;

  TShopper._({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.mail,
    required this.phoneNumber,
    required this.currentShoppingCenterId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.barcodeCode,
  });

  static clear() {
    _instance = null;
  }

  static TShopper get instance {
    return _instance!;
  }

  static void setInstance(TShopper newInstance) {
    _instance = newInstance;
  }

  factory TShopper.fromJson(Map<String, dynamic> json) {
    return _instance ??= TShopper._(
      uid: json['uid'] ?? "",
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      mail: json['mail'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      currentShoppingCenterId: json['currentShoppingCenterId'] ?? 0,
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      status: json['status'] ?? "",
      barcodeCode: json['barcodeCode'] ?? "",
    );
  }
}
