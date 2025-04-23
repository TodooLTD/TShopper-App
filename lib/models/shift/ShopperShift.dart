
class ShopperShift {
  int id;
  String date;
  String startTime;
  String endTime;
  String status;
  int shoppingCenterId;
  String actualStartTime;
  String actualEndTime;
  double actualDurationHours;
  String notes;
  bool isDeleted;
  String startTimeEditedBy;
  String endTimeEditedBy;

  ShopperShift({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.shoppingCenterId,
    required this.actualStartTime,
    required this.actualEndTime,
    required this.actualDurationHours,
    required this.notes,
    required this.isDeleted,
    required this.startTimeEditedBy,
    required this.endTimeEditedBy,
  });

  factory ShopperShift.fromJson(Map<String, dynamic> json) {
    return ShopperShift(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      status: json['status'] ?? '',
      shoppingCenterId: json['shoppingCenterId'] ?? '',
      actualStartTime: json['actualStartTime'] ?? '',
      actualEndTime: json['actualEndTime'] ?? '',
      actualDurationHours: json['actualDurationHours'] ?? '',
      notes: json['notes'] ?? '',
      isDeleted: json['isDeleted'] ?? '',
      startTimeEditedBy: json['startTimeEditedBy'] ?? '',
      endTimeEditedBy: json['endTimeEditedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'shoppingCenterId': shoppingCenterId,
      'actualStartTime': actualStartTime,
      'actualEndTime': actualEndTime,
      'actualDurationHours': actualDurationHours,
      'notes': notes,
      'isDeleted': isDeleted,
    };
  }}