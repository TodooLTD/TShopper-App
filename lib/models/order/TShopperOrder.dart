import 'package:intl/intl.dart';
import 'package:tshopper_app/models/order/PaymentRequest.dart';
import 'package:tshopper_app/models/order/deliveryMission/DeliveryMission.dart';

import 'PriceSummaryTShopper.dart';
import 'ProductTShopperOrder.dart';
import 'TShopperOrderStore.dart';
import 'TimelineTShopper.dart';

class TShopperOrder{
  final int orderNumber;
  int numberOfCouriers;
  final String orderId;
  String orderStatus;
  bool collectionProducts;
  String stickerColor;
  String dropOffNumber;
  final TimelineTShopper timeLine;
  final PriceSummaryTShopper priceSummary;
  List<TShopperOrderStore> orderStores;
  int centerShoppingId;
  List<DeliveryMission> deliveryMissions;

  TShopperOrder({
    required this.orderNumber,
    required this.orderId,
    required this.orderStatus,
    required this.collectionProducts,
    required this.stickerColor,
    required this.dropOffNumber,
    required this.timeLine,
    required this.orderStores,
    required this.numberOfCouriers,
    required this.priceSummary,
    required this.centerShoppingId,
    required this.deliveryMissions,
  });



  factory TShopperOrder.fromJson(Map<String, dynamic> json) {
    return TShopperOrder(
      orderNumber: json['orderNumber'],
      centerShoppingId: json['centerShoppingId'] ?? 0,
      orderId: json['orderId'],
      orderStatus: json['orderStatus'],
      collectionProducts: json['collectionProducts'],
      stickerColor: json['stickerColor'],
      dropOffNumber: json['dropOffNumber'] ?? "",
      numberOfCouriers: json['numberOfCouriers'] ?? 1,
      timeLine: TimelineTShopper.fromJson(json['timeLine']),
      priceSummary: PriceSummaryTShopper.fromJson(json['priceSummary']),
      orderStores: List<TShopperOrderStore>.from(
        json['orderStores'].map(
              (x) => TShopperOrderStore.fromJson(x),
        ),
      ) ??
          [],
      deliveryMissions: List<DeliveryMission>.from(
        json['deliveryMissions'].map(
              (x) => DeliveryMission.fromJson(x),
        ),
      ) ??
          [],
    );
  }

  TShopperOrder copyWith({
    int? orderNumber,
    int? numberOfCouriers,
    String? orderId,
    String? orderStatus,
    bool? collectionProducts,
    String? stickerColor,
    String? dropOffNumber,
    TimelineTShopper? timeLine,
    PriceSummaryTShopper? priceSummary,
    List<TShopperOrderStore>? orderStores,
    List<DeliveryMission>? deliveryMissions,
    int? centerShoppingId,
  }) {
    return TShopperOrder(
      numberOfCouriers: numberOfCouriers ?? this.numberOfCouriers,
      orderNumber: orderNumber ?? this.orderNumber,
      orderId: orderId ?? this.orderId,
      orderStatus: orderStatus ?? this.orderStatus,
      collectionProducts: collectionProducts ?? this.collectionProducts,
      stickerColor: stickerColor ?? this.stickerColor,
      dropOffNumber: dropOffNumber ?? this.dropOffNumber,
      timeLine: timeLine ?? this.timeLine,
      orderStores: orderStores ?? this.orderStores,
      priceSummary: priceSummary ?? this.priceSummary,
      centerShoppingId: centerShoppingId ?? this.centerShoppingId,
      deliveryMissions: deliveryMissions ?? this.deliveryMissions,
    );
  }

  int getAmount() {
    int counter = 0;
    if(orderStores.isNotEmpty){
      for(TShopperOrderStore store in orderStores){
        if(store.products.isNotEmpty){
          for(ProductTShopperOrder productOrder in store.products){
            counter += productOrder.quantity;
          }
        }
      }
    }
    return counter;
  }

  int getBagsAmount() {
    int counter = 0;
    if(orderStores.isNotEmpty){
      for(TShopperOrderStore store in orderStores){
        counter += store.bagsAmount;
      }
    }
    return counter;
  }

  int getBagsLeft() {
    int counter = 0;
    int bagsAmount = getBagsAmount();
    print(bagsAmount);
    if(deliveryMissions.isNotEmpty){
      for(DeliveryMission mission in deliveryMissions){
        if(mission.timeline.orderPickedUp != null && mission.timeline.orderPickedUp!.isNotEmpty){
          counter += mission.bagsAmount;
        }
      }
    }
    return bagsAmount - counter;
  }

  bool isTheLastCourierPick() {
    int counter = 0;
    if(deliveryMissions.isNotEmpty){
      for(DeliveryMission mission in deliveryMissions){
        if(mission.timeline.orderPickedUp == null || (mission.timeline.orderPickedUp != null && mission.timeline.orderPickedUp!.isEmpty)){
          counter ++;
        }
      }
    }
    print(counter);
    print(counter == 1);
    return counter == 1;
  }

  void setOrderRefused(String reason) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
    String formattedDate = format.format(now);
    timeLine.orderRefused = formattedDate;
    timeLine.lastUpdated = formattedDate;
    timeLine.cancelReason = reason;
  }

  void setOrderCancelled(String reason) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
    String formattedDate = format.format(now);
    timeLine.orderCancelled = formattedDate;
    timeLine.lastUpdated = formattedDate;
    timeLine.cancelReason = reason;
  }

  DateTime getOrderPlaced() {
    String? dateString = timeLine.orderPlaced;
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } on FormatException {
        throw Exception('Date string is not in a valid format: $dateString');
      }
    } else {
      return DateTime(2000, 1, 1);
    }
  }

  DateTime getOrderConfirmed() {
    String? dateString = timeLine.orderConfirmedByShopper;
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } on FormatException {
        throw Exception('Date string is not in a valid format: $dateString');
      }
    } else {
      return DateTime(2000, 1, 1);
    }
  }

  DateTime getAssignTime() {
    String? dateString = timeLine.orderAssignToShopper;
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } on FormatException {
        throw Exception('Date string is not in a valid format: $dateString');
      }
    } else {
      return DateTime(2000, 1, 1);
    }
  }

  bool getIsLastCollection(){
    int counter = 0;
    for(TShopperOrderStore store in orderStores){
      if(store.storeStatus == 'COLLECTION_DONE' || store.storeStatus == 'WAITING_FOR_PAYMENT' || store.storeStatus == 'PAYMENT_DECLINED' ||
          store.storeStatus == 'CANCELLED' || store.storeStatus == 'DONE') counter++;
    }
    return orderStores.length - counter == 1;
  }

  bool allPaymentRequestDone(){
    int counter = 0;
    if(orderStores.isNotEmpty){
      for(TShopperOrderStore store in orderStores){
        if(store.paymentRequests != null && store.paymentRequests!.isNotEmpty){
          for(PaymentRequest payment in store.paymentRequests!){
            if(payment.status == 'WAITING' || payment.status == 'FAILED'){
              counter++;
            }
          }
        }else{
          return false;
        }
      }
    }
    return counter == 0;
  }

  bool allStoresDone(){
    int counter = 0;
    if(orderStores.isNotEmpty){
      for(TShopperOrderStore store in orderStores){
        if(store.storeStatus != 'DONE' && store.storeStatus != 'CANCELLED'){
          counter++;
        }
      }
    }
    return counter == 0;
  }

}