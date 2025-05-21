import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:vibration/vibration.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../sevices/TShopperService.dart';

class ReadyOrderData {
  ReadyOrderData({
    required this.allReadyOrders,
    this.currentOrder,
    this.completeOrderTime,
  });

  List<TShopperOrder> allReadyOrders;
  TShopperOrder? currentOrder;
  String? completeOrderTime;

  ReadyOrderData copyWith({
    List<TShopperOrder>? allReadyOrders,
    TShopperOrder? currentOrder,
    String? completeOrderTime
  }) {
    return ReadyOrderData(
      allReadyOrders: allReadyOrders ?? this.allReadyOrders,
      currentOrder: currentOrder ?? this.currentOrder,
      completeOrderTime: completeOrderTime ?? this.completeOrderTime,
    );
  }
}

class ReadyOrderNotifier extends StateNotifier<ReadyOrderData> {
  ReadyOrderNotifier()
      : super(
    ReadyOrderData(
      allReadyOrders: [],
      currentOrder: null,
      completeOrderTime: "",
    ),
  );

  void clear() {
    state = ReadyOrderData(
      allReadyOrders: [],
      currentOrder: null,
      completeOrderTime: "",
    );
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    // Update in allOrders list
    int orderIndex = allReadyOrders.indexWhere((order) =>
    order.orderId == orderId);

    if (orderIndex != -1) {
      TShopperOrder updatedOrder = allReadyOrders[orderIndex];
      List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(allReadyOrders)
        ..[orderIndex] = updatedOrder;
      updatedOrdersList.removeWhere((order) => order.orderId == orderId);
      TShopperOrder newOrder = await TShopperService.getOrder(orderId);
      updatedOrdersList.add(newOrder);
      state = state.copyWith(allReadyOrders: updatedOrdersList);
      if(status == 'COURIER_ARRIVED'){
        showOrderUpdateNotification(newOrder, status);
      }
      if (currentOrder != null && currentOrder?.orderId == orderId) {
        state = state.copyWith(currentOrder: newOrder);
      }
      currentOrder = newOrder;
    }
  }

  Future<void> showOrderUpdateNotification(TShopperOrder newOrder, String status) async {

    AudioPlayer audioPlayer = AudioPlayer();
    String storeName = newOrder.orderStores.first.storeName;
    if(newOrder.orderStores.length > 1){
      storeName += " ו${newOrder.orderStores[1].storeName}";
    }
    Map<String, String> messages = {
      "title": "השליח הגיע לנקודת האיסוף!",
      "subtitle": newOrder.deliveryMissions.first.pickupDeliveryInstruction,
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
              shadowColor: AppColors.superLightGrey.withOpacity(0.2),
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


  void addOrder(TShopperOrder newOrder) async {

    final List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(state.allReadyOrders)
      ..insert(0, newOrder);
    state = state.copyWith(allReadyOrders: updatedOrdersList);

    AudioPlayer audioPlayer = AudioPlayer();
    bool canVibrate = await Vibration.hasVibrator() ?? false;
    if (canVibrate) {
      Vibration.vibrate(duration: 500);
    }
    await audioPlayer.play(AssetSource('sounds/user.mp3'));
  }


  void deleteOrder(String orderId) {

    final List<TShopperOrder> updatedOrdersList = state.allReadyOrders.where((order) => order.orderId != orderId).toList();
    if (updatedOrdersList.length < state.allReadyOrders.length) {
      state = state.copyWith(allReadyOrders: updatedOrdersList);
    } else {
    }
  }

  void setCurrentOrder(TShopperOrder newCurrentOrder) {
    bool orderExists = state.allReadyOrders.any((order) => order.orderId == newCurrentOrder.orderId);

    if (orderExists) {
      state = state.copyWith(currentOrder: newCurrentOrder);
    } else {

    }
  }
  void updateCompleteOrderTime(String newTime) {
    state = state.copyWith(completeOrderTime: newTime);
  }
  List<TShopperOrder> get allReadyOrders => state.allReadyOrders;
   set allReadyOrders(List<TShopperOrder> newAllOrders) {
    state = state.copyWith(allReadyOrders: newAllOrders);
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
