class PickupPoint {
  int id;
  String fullAddress;
  String notes;

  PickupPoint({
    required this.id,
    required this.fullAddress,
    required this.notes,
  });

  factory PickupPoint.fromJson(Map<String, dynamic> json) {
    return PickupPoint(
      id: json['id'] ?? 0,
      fullAddress: json['fullAddress'] ?? "",
      notes: json['notes'] ?? "",
    );
  }
}