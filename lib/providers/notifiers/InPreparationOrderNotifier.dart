import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:vibration/vibration.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../sevices/TShopperService.dart';

class InPreparationOrderData {
  InPreparationOrderData({
    required this.allInPreparationOrders,
    this.currentOrder,
    this.completeOrderTime,
  });

  List<TShopperOrder> allInPreparationOrders;
  TShopperOrder? currentOrder;
  String? completeOrderTime;

  InPreparationOrderData copyWith(
      {List<TShopperOrder>? allInPreparationOrders,
        TShopperOrder? currentOrder,
      String? completeOrderTime}) {
    return InPreparationOrderData(
      allInPreparationOrders:
          allInPreparationOrders ?? this.allInPreparationOrders,
      currentOrder: currentOrder ?? this.currentOrder,
      completeOrderTime: completeOrderTime ?? this.completeOrderTime,
    );
  }
}

class InPreparationOrderNotifier extends StateNotifier<InPreparationOrderData> {
  InPreparationOrderNotifier()
      : super(
          InPreparationOrderData(
            allInPreparationOrders: [],
            currentOrder: null,
            completeOrderTime: "",
          ),
        );

  void clear() {
    state = InPreparationOrderData(
      allInPreparationOrders: [],
      currentOrder: null,
      completeOrderTime: "",
    );
  }

  void updateCompleteOrderTime(String newTime) {
    state = state.copyWith(completeOrderTime: newTime);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    // Update in allOrders list
    int orderIndex = allInPreparationOrders.indexWhere((order) =>
    order.orderId == orderId);

    if (orderIndex != -1) {
      TShopperOrder updatedOrder = allInPreparationOrders[orderIndex];
      List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(allInPreparationOrders)
        ..[orderIndex] = updatedOrder;
      updatedOrdersList.removeWhere((order) => order.orderId == orderId);
      TShopperOrder newOrder = await TShopperService.getOrder(orderId);
      updatedOrdersList.add(newOrder);
      state = state.copyWith(allInPreparationOrders: updatedOrdersList);
      if(status == 'COURIER_ARRIVED'){
        showOrderUpdateNotification(newOrder, status, "השליח הגיע לנקודת האיסוף!", newOrder.deliveryMissions.first.pickupDeliveryInstruction);
      }
      if (currentOrder != null && currentOrder?.orderId == orderId) {
        state = state.copyWith(currentOrder: newOrder);
      }
      currentOrder = newOrder;
    }

  }

  Future<void> showOrderUpdateNotification(TShopperOrder newOrder, String status, String title, String subtitle) async {

    AudioPlayer audioPlayer = AudioPlayer();
    String storeName = newOrder.orderStores.first.storeName;
    if(newOrder.orderStores.length > 1){
      storeName += " ו${newOrder.orderStores[1].storeName}";
    }
    Map<String, String> messages = {
      "title": title,
      "subtitle": subtitle,
    };
    await audioPlayer.play(AssetSource('sounds/order_notification_sound.mp3'));

    if (messages['title']?.isNotEmpty ?? false) {
      OverlaySupportEntry? entry;

      entry = showOverlayNotification(
            (context) {
          return GestureDetector(
            onTap: () {
              entry?.dismiss();
            },
            child: Material(
              color: Colors.transparent,
              elevation: 5.0,
              shadowColor: isLightMode
                  ? AppColors.superLightGrey.withOpacity(0.2)
                  : AppColors.backgroundColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.dp),
                bottomRight: Radius.circular(20.dp),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.dp),
                  bottomRight: Radius.circular(20.dp),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 50.dp),
                  color: AppColors.popupBackgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 25.0.dp, bottom: 10.0.dp, top: 30.dp),
                        child: Text(
                          messages["title"] ?? '',
                          style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: AppFontSize.fontSizeRegular,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Arimo',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      if ((messages["subtitle"] ?? '').isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(right: 25.0.dp, bottom: 8.0.dp),
                          child: Text(
                            messages["subtitle"] ?? '',
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: AppFontSize.fontSizeExtraSmall,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Arimo',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25.0.dp, bottom: 4.dp),
                            child: TextButton(
                              onPressed: () {
                                entry?.dismiss();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.superLightPurple,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.dp),
                                child: Text(
                                  "קיבלתי",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: AppFontSize.fontSizeExtraSmall,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Arimo',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        duration: const Duration(seconds: 5),
        position: NotificationPosition.top,
      );

      // Reset visibility after it disappears (manually with a delay if needed)
      Future.delayed(const Duration(seconds: 5), () {
      });
    } else {
    }
  }

  Map<String, String> getStatusMessages(String status, String estimatedDeliveryTime) {
    switch (status) {
      case "PAID":
        return {
          "title": "",
          "subtitle": "",
        };
      default:
        return {
          "title": "",
          "subtitle": "",
        };
    }
  }



  Future<void> updatePaymentRequest(String orderId, String status) async {
    // Update in allOrders list
    int orderIndex = allInPreparationOrders.indexWhere((order) =>
    order.orderId == orderId);

    if (orderIndex != -1) {
      TShopperOrder updatedOrder = allInPreparationOrders[orderIndex];
      List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(allInPreparationOrders)
        ..[orderIndex] = updatedOrder;
      updatedOrdersList.removeWhere((order) => order.orderId == orderId);
      TShopperOrder newOrder = await TShopperService.getOrder(orderId);
      updatedOrdersList.add(newOrder);
      if(status == 'PAID'){
        showOrderUpdateNotification(newOrder, status, "בקשת תשלום עבור הזמנה #${newOrder.orderNumber} שולמה!", "");
      }
      if(status == 'CANCELLED'){
        showOrderUpdateNotification(newOrder, status, "בקשת תשלום עבור הזמנה #${newOrder.orderNumber} בוטלה!", "");
      }
      if(status == 'REJECTED'){
        showOrderUpdateNotification(newOrder, status, "בקשת תשלום עבור הזמנה #${newOrder.orderNumber} סורבה!", "");
      }
      state = state.copyWith(allInPreparationOrders: updatedOrdersList);
      if (currentOrder != null && currentOrder?.orderId == orderId) {
        state = state.copyWith(currentOrder: newOrder);
      }
      currentOrder = newOrder;
    }
  }


  void deleteOrder(String orderId) {
    final List<TShopperOrder> updatedOrdersList = state.allInPreparationOrders
        .where((order) => order.orderId != orderId)
        .toList();
    if (updatedOrdersList.length < state.allInPreparationOrders.length) {
      state = state.copyWith(allInPreparationOrders: updatedOrdersList);
    } else {
    }
  }

  void addOrder(TShopperOrder newOrder) async {
    final List<TShopperOrder> updatedOrdersList =
        List<TShopperOrder>.from(state.allInPreparationOrders)..insert(0, newOrder);
    state = state.copyWith(allInPreparationOrders: updatedOrdersList);
    AudioPlayer audioPlayer = AudioPlayer();
    bool canVibrate = await Vibration.hasVibrator() ?? false;
    if (canVibrate) {
      Vibration.vibrate(duration: 500);
    }
    await audioPlayer.play(AssetSource('sounds/user.mp3'));
  }

  void setTime(int time) {
    state = state.copyWith(completeOrderTime: time.toString());
  }

  void setCurrentOrder(String orderId) {
    TShopperOrder? orderExists = state.allInPreparationOrders
        .firstWhere((order) => order.orderId == orderId);

    if (orderExists != null) {
      state = state.copyWith(currentOrder: orderExists);
    } else {
    }
  }
  void setOrderCollectingProducts() {
    if (currentOrder != null) {

      currentOrder!.collectionProducts = true;

      // Find the corresponding order in the list and update it
      List<TShopperOrder> updatedOrdersList = state.allInPreparationOrders.map((order) {
        if (order.orderId == currentOrder!.orderId) {
          return currentOrder!;
        }
        return order;
      }).toList();

      // Update the state with the updated orders list and current order
      state = state.copyWith(
        allInPreparationOrders: updatedOrdersList,
        currentOrder: currentOrder,
      );
    } else {
    }
  }
  // void setCollectingProducts(Map<int, int> quantities) {
  //   if (currentOrder != null) {
  //     // Update the quantities for the current order
  //     for (ProductOrderR product in currentOrder!.products) {
  //       if (quantities.containsKey(product.id)) {
  //         product.collectQuantity = quantities[product.id]!;
  //       }
  //     }
  //     currentOrder!.collectionProducts = true;
  //
  //     // Find the corresponding order in the list and update it
  //     List<OrderR> updatedOrdersList = state.allInPreparationOrders.map((order) {
  //       if (order.orderId == currentOrder!.orderId) {
  //         return currentOrder!;
  //       }
  //       return order;
  //     }).toList();
  //
  //     // Update the state with the updated orders list and current order
  //     state = state.copyWith(
  //       allInPreparationOrders: updatedOrdersList,
  //       currentOrder: currentOrder,
  //     );
  //   } else {
  //   }
  // }


  List<TShopperOrder> get allInPreparationOrders => state.allInPreparationOrders;
  set allInPreparationOrders(List<TShopperOrder> newAllOrders) {
    state = state.copyWith(allInPreparationOrders: newAllOrders);
  }

  TShopperOrder? get currentOrder => state.currentOrder;
  set currentOrder(TShopperOrder? newCurrentOrder) {
    state = state.copyWith(currentOrder: newCurrentOrder);
  }

  String? get completeOrderTime => state.completeOrderTime;
  set completeOrderTime(String? newCompleteOrderTime) {
    state = state.copyWith(completeOrderTime: newCompleteOrderTime);
  }
}
