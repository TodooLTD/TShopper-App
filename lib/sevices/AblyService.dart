import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/providers/PendingOrderProvider.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import '../models/ably/AblyUpdate.dart';
import '../providers/InPreparationOrderProvider.dart';
import '../providers/NewOrderProvider.dart';
import '../providers/ReadyOrderProvider.dart';
import '../providers/conversationProvider.dart';

class AblyService {
  static ably.Realtime? realtimeInstance;
  static bool _isConnected = false;
  static var newMsgFromAbly;
  static final Map<String, ably.RealtimeChannel> _channels = {};
  static late WidgetRef ref;

  static Future<void> createAblyRealtimeInstance(
      String businessId,
      List<String> channelNames,
      ) async {
    if (_isConnected && realtimeInstance != null) {
      return;
    }

    var clientOptions = ably.ClientOptions(key: "f-DbRg.ztB_rQ:mDMNF37u4rj1u54fguodfBOp541zI6EvLWRUtDK1pdY");

    clientOptions.clientId = businessId;
    try {
      realtimeInstance = ably.Realtime(options: clientOptions);
      for (String channelName in channelNames) {
        final channel = realtimeInstance!.channels.get(channelName);
        _channels[channelName] = channel;
        _subscribeToChannel(channel);
      }

      realtimeInstance!.connection
          .on(ably.ConnectionEvent.connected)
          .listen((ably.ConnectionStateChange stateChange) {
        _isConnected = true;
      });
    } catch (error) {
      rethrow;
    }
  }

  static void _subscribeToChannel(ably.RealtimeChannel channel) {
    var messageStream = channel.subscribe();
    messageStream.listen((ably.Message message) {
      newMsgFromAbly = message.data;
      handleOrderUpdateEvent(message.name ?? "", message.data.toString(), ref);
    });
  }


  static Future<void> handleOrderUpdateEvent(
      String eventName, dynamic event, WidgetRef ref) async {
    AblyUpdate ablyUpdate = AblyUpdate.fromJson(event);
    print("handleOrderUpdateEvent $eventName");

    switch (eventName) {
      case "new-message":
        String orderId = ablyUpdate.data['orderId'];
        try {
          if(ref.read(conversationProvider).currentConversation != null &&
              ref.read(conversationProvider).currentConversation!.orderId == orderId){
            ref.read(conversationProvider.notifier).newMessage(orderId);
          }
        } catch (error, stackTrace) {
        }
        break;
      case "new-order":
        String orderId = ablyUpdate.data['order'];
        TShopperOrder? newOrder = await TShopperService.getOrder(orderId);

        if (newOrder != null) {
          ref.read(newOrderProvider.notifier).addOrder(newOrder);
        }
        break;

      case "payment-update":
        String orderId = ablyUpdate.data['order'];
        String status = ablyUpdate.data['status'];
        ref.read(inPreparationOrderProvider.notifier).updatePaymentRequest(orderId, status);
        break;
      case "tshopper-order-update":
        String orderStatus = ablyUpdate.data['status'];
        String orderId = ablyUpdate.data['orderId'];
        String estimatedDeliveryTime = "";
        String notes = "";
        int minutesToBeReady = 0;
        if(orderStatus == "PENDING" || orderStatus == 'UNASSIGNED'){
          TShopperOrder? newPendingOrder = await TShopperService.getOrder(orderId);
          if (newPendingOrder != null) {
            ref.read(pendingOrderProvider.notifier).addOrder(newPendingOrder);
          }
          if(orderStatus == 'UNASSIGNED'){
            ref.read(newOrderProvider.notifier).deleteOrder(orderId);
          }
        }
        if(orderStatus == "PENDING-ASSIGN"){
          ref.read(pendingOrderProvider.notifier).deleteOrder(orderId);
        }
        if(orderStatus == "SEEN_BY_SHOPPER"){
          String name = ablyUpdate.data['name'];
          ref.read(pendingOrderProvider.notifier).updateOrderStatus(
              orderId,
              orderStatus,
              name,
              0,
              "");
        }
        if(orderStatus == "UNASSIGNED_SHOPPER"){
          ref.read(newOrderProvider.notifier).deleteOrder(orderId);
        }
        if(orderStatus == "ON_HOLD"){
          String name = ablyUpdate.data['name'];
          ref.read(pendingOrderProvider.notifier).updateOrderStatus(
              orderId,
              orderStatus,
              name,
              0,
              "");
        }
        if(orderStatus == "DONE_COLLECTING" || orderStatus == 'WAITING_FOR_PAYMENT_REQUEST'){
          ref.read(inPreparationOrderProvider.notifier).updateOrderStatus(orderId, orderStatus);
        }
        if (orderStatus == "IN_PROGRESS") {
          int currentOrderIndex =
          ref.read(newOrderProvider).allNewOrders.indexWhere(
                (person) => person.orderId == orderId,
          );

          TShopperOrder? currentOrder = currentOrderIndex > -1
              ? ref.read(newOrderProvider).allNewOrders[currentOrderIndex]
              : null;
          if(currentOrder != null){
            ref.read(inPreparationOrderProvider.notifier).addOrder(currentOrder);
            ref.read(newOrderProvider.notifier).deleteOrder(orderId);
          }
        }
        if (orderStatus == "READY_FOR_PICKUP_DELIVERY") {
          int currentOrderIndex =
          ref.read(inPreparationOrderProvider).allInPreparationOrders.indexWhere(
                (person) => person.orderId == orderId,
          );

          TShopperOrder? currentOrder = currentOrderIndex > -1
              ? ref.read(inPreparationOrderProvider).allInPreparationOrders[currentOrderIndex]
              : null;
          if(currentOrder != null){
            ref.read(readyOrderProvider.notifier).addOrder(currentOrder);
            ref.read(inPreparationOrderProvider.notifier).deleteOrder(orderId);
          }
        }
        if (orderStatus == "COURIER_ARRIVED_TO_SHOPPER" || orderStatus == "COURIER_ASSIGN" || orderStatus == "COURIER_ARRIVED"
            || orderStatus == 'SPLIT' || orderStatus == 'WRONG_BARCODE' || orderStatus == "DELIVERY_MISSION_ORDER" || orderStatus == 'STORE_CANCELLED' ||
        orderStatus == 'STORE_READY') {
          int currentOrderIndex =
          ref.read(inPreparationOrderProvider).allInPreparationOrders.indexWhere(
                (person) => person.orderId == orderId,
          );
          TShopperOrder? currentOrder = currentOrderIndex > -1
              ? ref.read(inPreparationOrderProvider).allInPreparationOrders[currentOrderIndex]
              : null;
          if (currentOrder != null) {
            ref.read(inPreparationOrderProvider.notifier).updateOrderStatus(orderId, orderStatus);
          }else{
            currentOrderIndex =
                ref.read(readyOrderProvider).allReadyOrders.indexWhere(
                      (person) => person.orderId == orderId,
                );
            TShopperOrder? currentOrder = currentOrderIndex > -1
                ? ref.read(readyOrderProvider).allReadyOrders[currentOrderIndex]
                : null;
            if (currentOrder != null) {
              ref.read(readyOrderProvider.notifier).updateOrderStatus(orderId, orderStatus);
            }
          }
        }
        if (orderStatus == "PICKED_UP") {
          int currentOrderIndex =
          ref.read(readyOrderProvider).allReadyOrders.indexWhere(
                (person) => person.orderId == orderId,
          );
          TShopperOrder? currentOrder = currentOrderIndex > -1
              ? ref.read(readyOrderProvider).allReadyOrders[currentOrderIndex]
              : null;
          if (currentOrder != null) {
            ref.read(readyOrderProvider.notifier).deleteOrder(orderId);
          }
        }
        if (orderStatus == "PICKED_UP_COURIER") {
          int currentOrderIndex =
          ref.read(readyOrderProvider).allReadyOrders.indexWhere(
                (person) => person.orderId == orderId,
          );
          TShopperOrder? currentOrder = currentOrderIndex > -1
              ? ref.read(readyOrderProvider).allReadyOrders[currentOrderIndex]
              : null;
          if (currentOrder != null) {
            ref.read(readyOrderProvider.notifier).updateOrderStatus(orderId, orderStatus);
          }
        }
        if (orderStatus == "CANCELLED" || orderStatus == "REFUSED") {
          notes = ablyUpdate.data['reason'] ?? "";
          int currentOrderIndex =
          ref.read(newOrderProvider).allNewOrders.indexWhere(
                (person) => person.orderId == orderId,
          );

          TShopperOrder? currentOrder = currentOrderIndex > -1
              ? ref.read(newOrderProvider).allNewOrders[currentOrderIndex]
              : null;

            if (currentOrder == null) {
              currentOrderIndex = ref
                  .read(inPreparationOrderProvider)
                  .allInPreparationOrders
                  .indexWhere(
                    (person) => person.orderId == orderId,
              );

              currentOrder = currentOrderIndex > -1
                  ? ref
                  .read(inPreparationOrderProvider)
                  .allInPreparationOrders[currentOrderIndex]
                  : null;
              if (currentOrder == null) {
                currentOrderIndex =
                    ref.read(readyOrderProvider).allReadyOrders.indexWhere(
                          (person) =>
                      person.orderId == orderId,
                    );

                currentOrder = currentOrderIndex > -1
                    ? ref
                    .read(readyOrderProvider)
                    .allReadyOrders[currentOrderIndex]
                    : null;
                if (currentOrder != null) {
                  ref
                      .read(readyOrderProvider.notifier)
                      .deleteOrder(orderId);
                }
              } else {
                ref
                    .read(inPreparationOrderProvider.notifier)
                    .deleteOrder(orderId);
              }
          } else {
            ref.read(newOrderProvider.notifier).deleteOrder(orderId);
          }
          if(orderStatus == "CANCELLED"){
            currentOrder?.orderStatus == "CANCELLED";
            currentOrder?.setOrderCancelled(notes);
          }
          else{
            currentOrder?.orderStatus == "REFUSED";
            currentOrder?.setOrderRefused(notes);
          }
        }
        break;
    }
  }

  // Method to check if Ably is already connected
  static bool isConnected() {
    return _isConnected && realtimeInstance != null;
  }

  // Method to unsubscribe from the channel and clean up resources
  static void unsubscribeFromAllChannels() {
    _channels.forEach((name, channel) => channel.detach());
    _channels.clear();

    realtimeInstance?.close();
    realtimeInstance = null;
    _isConnected = false;
  }

}
