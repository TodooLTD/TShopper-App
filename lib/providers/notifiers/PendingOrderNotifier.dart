
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
import '../../sevices/TShopperService.dart';

class PendingOrderData {
  PendingOrderData({
    required this.allPendingOrders,
    this.currentOrder,
    this.completeOrderTime,
  });

  List<TShopperOrder> allPendingOrders;
  TShopperOrder? currentOrder;
  String? completeOrderTime;

  PendingOrderData copyWith({
    List<TShopperOrder>? allPendingOrders,
    TShopperOrder? currentOrder,
    String? completeOrderTime
  }) {
    return PendingOrderData(
      allPendingOrders: allPendingOrders ?? this.allPendingOrders,
      currentOrder: currentOrder ?? this.currentOrder,
      completeOrderTime: completeOrderTime ?? this.completeOrderTime,
    );
  }
}

class PendingOrderNotifier extends StateNotifier<PendingOrderData> {
  PendingOrderNotifier()
      : super(
    PendingOrderData(
      allPendingOrders: [],
      currentOrder: null,
      completeOrderTime: "",
    ),
  );

  bool _isNotificationVisible = false;

  void clear() {
    state = PendingOrderData(
      allPendingOrders: [],
      currentOrder: null,
      completeOrderTime: "",
    );
  }

  // Method to add a Order to the existing orderList
  void addOrder(TShopperOrder newOrder) async {

    final List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(state.allPendingOrders)
      ..add(newOrder);
    state = state.copyWith(allPendingOrders: updatedOrdersList);

    bool canVibrate = await Vibration.hasVibrator() ?? false;
    if (canVibrate) {
      Vibration.vibrate(duration: 500);
    }
    await showOrderUpdateNotification(newOrder);
  }


  void deleteOrder(String orderId) {

    final List<TShopperOrder> updatedOrdersList = state.allPendingOrders.where((order) => order.orderId != orderId).toList();
    if (updatedOrdersList.length < state.allPendingOrders.length) {
      state = state.copyWith(allPendingOrders: updatedOrdersList);
    } else {
    }
  }


  Future<void> updateOrderStatus(String orderId, String newStatus, String name, int minutesToBeReady, String notes) async {
    // Update in allPendingOrders list
    int orderIndex = allPendingOrders.indexWhere((order) =>
    order.orderId == orderId);

    if (orderIndex != -1) {
      TShopperOrder updatedOrder = allPendingOrders[orderIndex];
      List<TShopperOrder> updatedOrdersList = List<TShopperOrder>.from(allPendingOrders)
        ..[orderIndex] = updatedOrder;
      updatedOrdersList.removeWhere((order) => order.orderId == orderId);
      TShopperOrder newOrder = await TShopperService.getOrder(orderId);
      updatedOrdersList.add(newOrder);
      state = state.copyWith(allPendingOrders: updatedOrdersList);

      if (currentOrder != null && currentOrder?.orderId == orderId) {
        state = state.copyWith(currentOrder: updatedOrder);
      }

      currentOrder = updatedOrder;
    }
  }

  void setCurrentOrder(TShopperOrder newCurrentOrder) {

    bool orderExists = state.allPendingOrders.any((order) => order.orderId == newCurrentOrder.orderId);

    if (orderExists) {
      state = state.copyWith(currentOrder: newCurrentOrder);
    } else {
    }
  }

  void updateCompleteOrderTime(String newTime) {
    state = state.copyWith(completeOrderTime: newTime);
  }
  List<TShopperOrder> get allPendingOrders => state.allPendingOrders;
  set allPendingOrders(List<TShopperOrder> newAllOrders) {
    state = state.copyWith(allPendingOrders: newAllOrders);
  }
  TShopperOrder? get currentOrder => state.currentOrder;
  set currentOrder(TShopperOrder? newCurrentOrder) {
    state = state.copyWith(currentOrder: newCurrentOrder);
  }
  String? get completeOrderTime => state.completeOrderTime;
  set completeOrderTime(String? newCompleteOrderTime) {
    state = state.copyWith(completeOrderTime: newCompleteOrderTime);
  }

  Future<void> showOrderUpdateNotification(TShopperOrder newOrder) async {
    if (_isNotificationVisible) return;
    _isNotificationVisible = true;

    AudioPlayer audioPlayer = AudioPlayer();
    String storeName = newOrder.orderStores.first.storeName;
    if(newOrder.orderStores.length > 1){
      storeName += " ו${newOrder.orderStores[1].storeName}";
    }
    Map<String, String> messages = {
      "title": "התקבלה הזמנה חדשה מ$storeName " +" | "+ "${newOrder.getAmount()} מוצרים",
      "subtitle": "שימי לב- יש לאשר את ההזמנה בהקדם האפשרי!",
    };

    await audioPlayer.play(AssetSource('sounds/order_notification_sound.mp3'));

    if (messages['title']?.isNotEmpty ?? false) {
      OverlaySupportEntry? entry;

      entry = showOverlayNotification(
            (context) {
          return GestureDetector(
            onTap: () {
              entry?.dismiss();
              _isNotificationVisible = false;
            },
            child: Material(
              color: Colors.transparent,
              elevation: 5.0,
              shadowColor: AppColors.superLightGrey.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.dp),
                topRight: Radius.circular(20.dp),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.dp),
                  topRight: Radius.circular(20.dp),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20.dp),
                  decoration: BoxDecoration(
                    color: AppColors.primeryColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 25.0.dp, bottom: 6.0.dp, top: 10.dp),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              child: Text(
                                messages["title"] ?? '',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13.dp,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Arimo',
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if ((messages["subtitle"] ?? '').isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(right: 25.0.dp, bottom: 8.0.dp),
                          child: Text(
                            messages["subtitle"] ?? '',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 11.dp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Arimo',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.only(left: 25.0.dp, bottom: 4.dp),
                      //       child: TextButton(
                      //         onPressed: () {
                      //           entry?.dismiss();
                      //           _isNotificationVisible = false;
                      //         },
                      //         style: TextButton.styleFrom(
                      //           backgroundColor: AppColors.superLightPurple,
                      //         ),
                      //         child: Padding(
                      //           padding: EdgeInsets.symmetric(horizontal: 16.dp),
                      //           child: Text(
                      //             translate("General.i_got_it"),
                      //             style: TextStyle(
                      //               color: AppColors.primaryColor,
                      //               fontSize: AppFontSize.fontSizeExtraSmall,
                      //               fontWeight: FontWeight.w600,
                      //               fontFamily: 'Arimo',
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        duration: const Duration(seconds: 2),
        position: NotificationPosition.bottom,
      );

      // Reset visibility after it disappears (manually with a delay if needed)
      Future.delayed(const Duration(seconds: 2), () {
        _isNotificationVisible = false;
      });
    } else {
      _isNotificationVisible = false;
    }
  }

}
