class TShopper {
  static TShopper? _instance;

  final String uid;
  final String firstName;
  final String lastName;
  final String color;
  final String mail;
  final String phoneNumber;
  final int currentShoppingCenterId;
  final double latitude;
  final double longitude;
  final String status;
  final String barcodeCode;
  final String barcodeImageUrl;
  final String type;
  final String imageUrl;
  double totalHours = 0;
  int totalDays = 0;


  TShopper._({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.color,
    required this.mail,
    required this.phoneNumber,
    required this.currentShoppingCenterId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.barcodeCode,
    required this.barcodeImageUrl,
    required this.type,
    required this.imageUrl,
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
      color: json['color'] ?? "",
      lastName: json['lastName'] ?? "",
      mail: json['mail'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      currentShoppingCenterId: json['currentShoppingCenterId'] ?? 0,
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      status: json['status'] ?? "",
      barcodeCode: json['barcodeCode'] ?? "",
      barcodeImageUrl: json['barcodeImageUrl'] ?? "",
      type: json['type'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
    );
  }
}
