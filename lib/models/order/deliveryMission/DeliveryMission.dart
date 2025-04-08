import 'package:tshopper_app/models/order/deliveryMission/timeLine/MissionTimeline.dart';

import 'address/Address.dart';

class DeliveryMission {
  final String id;
  final String businessName;
  final double businessLat;
  final double businessLon;
  final String businessAddress;
  final double customerLat;
  final double customerLon;
  final Address customerAddress;
  final String pickUpTime;
  final String businessLogoLight;
  final String businessLogoDark;
  final String businessId;
  MissionTimeline timeline;
  final int orderNumber;
  final String orderId;
  String status;
  final bool ageRestriction;
  final bool toTheCar;
  final String courierNotes;
  final String costumerName;
  final String courierPhoneNumber;
  String orderStatus;
  int bagsAmount;
  int bagsCounter;
  String stickerColor;
  bool noContactDelivery;
  String imageNoContactDelivery;
  String userImageNoContactDelivery;
  String costumerFirstName;
  String costumerLastName;
  String phoneNumber;
  double bonusAmount;
  double tip;
  bool isSplit;
  String supplyMode;
  String deliveryMissionType;
  bool isReorder;
  String lastNotificationTime;
  int drinksAmount;
  //T-Man
   String packageNotes;
   String packageSize;
   String pickupContactName;
   String pickupContactNumber;
   String pickupAddress;
   double pickupLatitude;
   double pickupLongitude;
   String dropOffContactName;
   String dropOffContactNumber;
   String dropOffAddress;
   double dropOffLatitude;
   double dropOffLongitude;
   String pickupFloor;
   String pickupEntrance = "";
   String pickupApartment;
   String pickupDeliveryInstruction;
   String dropOffFloor;
   String dropOffEntrance = "";
   String dropOffApartment;
   String dropOffDeliveryInstruction;
   String businessAddressNotes;
   bool thirdPartyOrder;
  String courierId;
  String courierName;
  double courierLastLatitude;
  double courierLastLongitude;
  String pickupBagsImage;
  String dropOffBagsImage;

  DeliveryMission({
    required this.courierId,
    required this.courierName,
    required this.pickupContactName,
    required this.pickupContactNumber,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.courierPhoneNumber,
    required this.pickupLongitude,
    required this.dropOffContactName,
    required this.dropOffContactNumber,
    required this.dropOffAddress,
    required this.dropOffLatitude,
    required this.dropOffLongitude,
    required this.id,
    required this.businessName,
    required this.businessLat,
    required this.businessLon,
    required this.businessAddress,
    required this.customerLat,
    required this.customerLon,
    required this.customerAddress,
    required this.pickUpTime,
    required this.businessLogoLight,
    required this.businessLogoDark,
    required this.businessId,
    required this.timeline,
    required this.orderNumber,
    required this.orderId,
    required this.status,
    required this.ageRestriction,
    required this.toTheCar,
    required this.courierNotes,
    required this.costumerName,
    required this.orderStatus,
    required this.bagsAmount,
    required this.stickerColor,
    required this.noContactDelivery,
    required this.imageNoContactDelivery,
    required this.costumerFirstName,
    required this.costumerLastName,
    required this.phoneNumber,
    required this.bonusAmount,
    required this.tip,
    required this.isSplit,
    required this.bagsCounter,
    required this.supplyMode,
    required this.deliveryMissionType,
    required this.isReorder,
    required this.lastNotificationTime,
    required this.pickupFloor,
    required this.pickupEntrance,
    required this.pickupApartment,
    required this.pickupDeliveryInstruction,
    required this.dropOffFloor,
    required this.dropOffEntrance,
    required this.dropOffApartment,
    required this.dropOffDeliveryInstruction,
    required this.packageNotes,
    required this.packageSize,
    required this.userImageNoContactDelivery,
    required this.drinksAmount,
    required this.businessAddressNotes,
    required this.thirdPartyOrder,
    required this.courierLastLatitude,
    required this.courierLastLongitude,
    required this.pickupBagsImage,
    required this.dropOffBagsImage,
  });

  factory DeliveryMission.fromJson(Map<String, dynamic> json) {

    return DeliveryMission(
      dropOffBagsImage: json['dropOffBagsImage'] ?? "",
      courierName: json['courierName'] ?? "",
      pickupBagsImage: json['pickupBagsImage'] ?? "",
      courierId: json['courierId'] ?? "",
        id: json['id'],
        businessName: json['businessName'] ?? "",
        businessLat: json['businessLat'],
        businessLon: json['businessLon'],
        businessAddress: json['businessAddress'] ?? "",
      courierPhoneNumber: json['courierPhoneNumber'] ?? "",
        customerLat: json['costumerLat'],
        customerLon: json['costumerLon'],
        customerAddress: json['costumerAddress'] != null ? Address.fromJson(json['costumerAddress']) : Address(
            country: 'ISRAEL',
            fullAddress: "",
            latitude: 0,
            latitudeOnMap: 0,
            longitude: 0,
            longitudeOnMap: 0,
            name: "",
            town: "",
            buildingNumber: "",
            workArea: 'Gderot'),
        pickUpTime: json['pickUpTime'] ?? "",
        businessLogoLight: json['businessLogoLight'] ?? "",
        businessLogoDark: json['businessLogoDark'] ?? "",
      businessId: json['businessId'] ?? "",
        timeline: json['timeLine'] != null ? MissionTimeline.fromJson(json['timeLine']) : MissionTimeline(),
        orderNumber: json['orderNumber'],
      orderId: json['orderId'] ?? "",
        status: json['status'] ?? "",
        ageRestriction: json['ageRestriction'] ?? false,
      thirdPartyOrder: json['thirdPartyOrder'] ?? false,
        toTheCar: json['toTheCar'] ?? false,
        courierNotes: json['courierNotes'] ?? "",
        costumerName: json['costumerName'] ?? "",
      orderStatus: json['orderStatus'] ?? "",
      bagsAmount: json['bagsAmount'] ?? 0,
      stickerColor: json['stickerColor'] ?? "",
      imageNoContactDelivery: json['imageNoContactDelivery'] ?? "",
      userImageNoContactDelivery: json['userImageNoContactDelivery'] ?? "",
      noContactDelivery: json['noContactDelivery'] ?? false,
      costumerFirstName: json['costumerFirstName'] ?? '',
      costumerLastName: json['costumerLastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      bonusAmount: json['bonusAmount'] ?? 0,
      tip: json['tip'] ?? 0,
      bagsCounter: json['bagsCounter'] ?? 0,
      isSplit: json['split'] ?? false,
      supplyMode: json['supplyMode'] ?? "",
      deliveryMissionType: json['deliveryMissionType'] ?? "",
      isReorder: json['isReorder'] ?? "",
      lastNotificationTime: json['lastNotificationTime'] ?? "",
      pickupContactName: json['pickupContactName'] ?? "",
      pickupContactNumber: json['pickupContactNumber'] ?? "",
      pickupAddress: json['pickupAddress'] ?? "",
      pickupLatitude: json['pickupLatitude'] ?? 0,
      pickupLongitude: json['pickupLongitude'] ?? 0,
      dropOffContactName: json['dropOffContactName'] ?? "",
      dropOffContactNumber: json['dropOffContactNumber'] ?? "",
      pickupFloor: json['pickupFloor'] ?? "",
      pickupEntrance: json['pickupEntrance'] ?? "",
      pickupApartment: json['pickupApartment'] ?? "",
      pickupDeliveryInstruction: json['pickupDeliveryInstruction'] ?? "",
      dropOffFloor: json['dropOffFloor'] ?? "",
      dropOffEntrance: json['dropOffEntrance'] ?? "",
      dropOffApartment: json['dropOffApartment'] ?? "",
      dropOffDeliveryInstruction: json['dropOffDeliveryInstruction'] ?? "",
      packageNotes: json['packageNotes'] ?? "",
      packageSize: json['packageSize'] ?? "",
      dropOffAddress: json['dropOffAddress'] ?? "",
      dropOffLatitude: json['dropOffLatitude'] ?? 0,
      dropOffLongitude: json['dropOffLongitude'] ?? 0,
      drinksAmount: json['drinksAmount'] ?? 0,
      businessAddressNotes: json['businessAddressNotes'] ?? "",
      courierLastLatitude: json['courierLastLatitude'] ?? 0,
      courierLastLongitude: json['courierLastLongitude'] ?? 0,
    );
  }

  DateTime getPickupTime(){
    String? dateString = pickUpTime;
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } on FormatException {
        throw Exception('Date string is not in a valid format: $dateString');
      }
    } else {
      throw Exception('Order placed date is null');
    }
  }
}
