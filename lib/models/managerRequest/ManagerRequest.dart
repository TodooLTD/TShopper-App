class ManagerRequest {
  final int id;
  final String createdAt;
  final String request;
  final String shopperNotes;
  final String requestSubject; //cancelOrder, cancelStore, unassignShopper
  final String status; // "Pending", "Resolved", "In Progress"
  final String response;
  final String resolvedAt;
  final int objectId;
  final String orderId;
  final String shopperName;
  final int shoppingCenterId;

  ManagerRequest({
    required this.id,
    required this.createdAt,
    required this.request,
    required this.shopperNotes,
    required this.requestSubject,
    required this.status,
    required this.response,
    required this.resolvedAt,
    required this.objectId,
    required this.orderId,
    required this.shopperName,
    required this.shoppingCenterId,
  });

  /// ✅ Convert JSON to ManagerRequest object
  factory ManagerRequest.fromJson(Map<String, dynamic> json) {
    return ManagerRequest(
      id: json['id'] ?? 0,
      createdAt: json['createdAt'] ?? "",
      request: json['request'] ?? "",
      shopperNotes: json['shopperNotes'] ?? "",
      requestSubject: json['requestSubject'] ?? "",
      status: json['status'] ?? "",
      response: json['response'] ?? "",
      resolvedAt: json['resolvedAt'] ?? "",
      objectId: json['objectId'] ?? 0,
      orderId: json['orderId'] ?? "",
      shopperName: json['shopperName'] ?? "",
      shoppingCenterId: json['shoppingCenterId'] ?? 0,
    );
  }

  /// ✅ Convert ManagerRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "createdAt": createdAt,
      "requestSubject": requestSubject,
      "request": request,
      "shopperNotes": shopperNotes,
      "status": status,
      "response": response,
      "resolvedAt": resolvedAt,
      "objectId": objectId,
      "orderId": orderId,
      "shopperName": shopperName,
      "shoppingCenterId": shoppingCenterId,
    };
  }

  /// ✅ Convert createdAt & resolvedAt to DateTime
  DateTime getCreatedAt() {
    try {
      return DateTime.parse(createdAt);
    } on FormatException {
      throw Exception('Invalid date format: $createdAt');
    }
  }

  DateTime getResolvedAt() {
    try {
      return DateTime.parse(resolvedAt);
    } on FormatException {
      throw Exception('Invalid date format: $resolvedAt');
    }
  }
}
