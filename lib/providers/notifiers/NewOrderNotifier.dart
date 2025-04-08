
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../../constants/AppColors.dart';
import '../../../constants/AppFontSize.dart';
import 'package:vibration/vibration.dart';
import '../../main.dart';
import '../../models/order/TShopperOrder.dart';

class NewOrderData {
  NewOrderData({
    required this.allNewOrders,
    this.currentOrder,
    this.completeOrderTime,
  });

  List<TShopperOrder> allNewOrders;
  TShopperOrder? currentOrder;
  String? completeOrderTime;

  NewOrderData copyWith({
    List<TShopperOrder>? allNewOrders,
    TShopperOrder? currentOrder,
    String? completeOrderTime
  }) {
    return NewOrderData(
      allNewOrders: allNewOrders ?? this.allNewOrders,
      currentOrder: currentOrder ?? this.currentOrder,
      completeOrderTime: completeOrderTime ?? this.completeOrderTime,
    );
  }
}

class NewOrderNotifier extends StateNotifier<NewOrderData> {
  NewOrderNotifier()
      : super(
    NewOrderData(
      allNewOrders: [],
      currentOrder: null,
      completeOrderTime: "",
    ),
  );

  void clear() {
    state = NewOrderData(
      allNewOrders: [],
      currentOrder: null,
      completeOrderTime: "",
    );
  }

  // Method to add a Order to the existing orderList
  void addOrder(TShopperOrder newOrder) async {

      final List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(state.allNewOrders)
        ..add(newOrder);
      state = state.copyWith(allNewOrders: updatedOrdersList);

      bool canVibrate = await Vibration.hasVibrator() ?? false;
      if (canVibrate) {
        Vibration.vibrate(duration: 500);
      }
      await showOrderUpdateNotification(newOrder);
  }


  Future<void> showOrderUpdateNotification(TShopperOrder newOrder) async {

    AudioPlayer audioPlayer = AudioPlayer();
    String storeName = newOrder.orderStores.first.storeName;
    if(newOrder.orderStores.length > 1){
      storeName += " ו${newOrder.orderStores[1].storeName}";
    }
    Map<String, String> messages = {
      "title": "שובצת להזמנה #${newOrder.orderNumber} מ$storeName",
      "subtitle": "שימי לב- יש לאשר את השיבוץ בהקדם האפשרי!",
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

  void deleteOrder(String orderId) {

    final List<TShopperOrder> updatedOrdersList = state.allNewOrders.where((order) => order.orderId != orderId).toList();
    if (updatedOrdersList.length < state.allNewOrders.length) {
      state = state.copyWith(allNewOrders: updatedOrdersList);
    } else {
    }
  }


  Future<void> updateOrderStatus(String orderId, String newStatus, String estimatedDeliveryTime, int minutesToBeReady, String notes) async {

    // Update in allNewOrders list
    int orderIndex = allNewOrders.indexWhere((order) =>
    order.orderId == orderId);
    if (orderIndex != -1) {
      TShopperOrder updatedOrder = allNewOrders[orderIndex].copyWith(orderStatus: newStatus);
      List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(allNewOrders)
        ..[orderIndex] = updatedOrder;
      if(newStatus == "IN_PROGRESS") {
        deleteOrder(orderId);
      }
      state = state.copyWith(allNewOrders: updatedOrdersList);

      if (currentOrder != null && currentOrder?.orderId == orderId) {
        state = state.copyWith(currentOrder: updatedOrder);
      }

      currentOrder = updatedOrder;
    }
  }

  void setCurrentOrder(TShopperOrder newCurrentOrder) {

    bool orderExists = state.allNewOrders.any((order) => order.orderId == newCurrentOrder.orderId);

    if (orderExists) {
      state = state.copyWith(currentOrder: newCurrentOrder);
    } else {
    }
  }

  void updateCompleteOrderTime(String newTime) {
    state = state.copyWith(completeOrderTime: newTime);
  }
  List<TShopperOrder> get allNewOrders => state.allNewOrders;
  set allNewOrders(List<TShopperOrder> newAllOrders) {
    state = state.copyWith(allNewOrders: newAllOrders);
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
