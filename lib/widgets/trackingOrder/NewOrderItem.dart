import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:intl/intl.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/providers/InPreparationOrderProvider.dart';
import 'package:tshopper_app/providers/NewOrderProvider.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/widgets/trackingOrder/StoreOrderCard.dart';
import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';
import '../../main.dart';
import 'CustomElevatedButton.dart';
import 'OrderItemContainer.dart';

class NewOrderItem extends riverpod.ConsumerStatefulWidget {
  NewOrderItem({super.key, required this.order, this.isFuture = false});
  final TShopperOrder order;
  bool isFuture;

  @override
  riverpod.ConsumerState<NewOrderItem> createState() => _NewOrderItemState();
}

class _NewOrderItemState extends riverpod.ConsumerState<NewOrderItem> {
  bool isLoading = true;
  int minutesSinceAssigned = 0;
  Timer? assignTimer;
  Timer? cancelTimer;
  int remainingTimeInSeconds = 0;
  bool isExpended = false;

  @override
  void initState() {
    super.initState();

    // Setup the cancel countdown timer
    remainingTimeInSeconds = widget.order.getOrderPlaced()
        .add(widget.order.orderStatus == "ASSIGNED"
        ? Duration(minutes: 10)
        : Duration(minutes: 5))
        .difference(DateTime.now())
        .inSeconds;

    if (widget.order.orderStatus == "ASSIGNED" &&
        (remainingTimeInSeconds > 600 || remainingTimeInSeconds < 0)) {
      remainingTimeInSeconds = 0;
    }

    startCancelTimer();
    startAssignTimer();
  }

  @override
  void dispose() {
    cancelTimer?.cancel();
    assignTimer?.cancel(); // Cancel assign timer too!
    super.dispose();
  }

  void startCancelTimer() {
    cancelTimer = Timer.periodic(const Duration(seconds: 1), (cancelTimer) {
      if (remainingTimeInSeconds > 0) {
        setState(() {
          remainingTimeInSeconds--;
        });
      } else {
        cancelTimer.cancel();
      }
    });
  }

  void startAssignTimer() {
    updateMinutesSinceAssigned(); // Initial value
    assignTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      updateMinutesSinceAssigned();
    });
  }

  void updateMinutesSinceAssigned() {
    final assignTime = widget.order.timeLine.orderAssignToShopper;
    if (assignTime != null && assignTime.isNotEmpty) {
      setState(() {
        minutesSinceAssigned = DateTime.now().difference(widget.order.getAssignTime()).inMinutes;
      });
    }else{
      minutesSinceAssigned = 0;
    }
  }

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.dp),
      child: OrderItemContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.dp, vertical: 8.dp),
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                " #${widget.order.orderNumber}",
                                style: TextStyle(
                                  fontSize: 30.dp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'todoFont',
                                  color: AppColors.blackText,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: AppColors.redColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6.dp),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 6.dp),
                                        child: Text(
                                          "ממתין לליקוט $minutesSinceAssigned דקות",
                                          style: TextStyle(
                                            color: AppColors.redColor,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'arimo',
                                            fontSize: AppFontSize.fontSizeExtraSmall,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(width: 8.dp),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: widget.order.orderStores
                        .map((store) => StoreOrderCard(store: store, order: widget.order,))
                        .toList(),
                  ),
                  SizedBox(height: 8.dp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          child: CustomElevatedButton(
                              backgroundColor: AppColors.primeryColor,
                              titleColor: AppColors.white,
                              title: "אני על זה!",
                              onPressed: () {
                                showAreYouSurePopup(context);
                              }),
                        ),
                      ),
                      SizedBox(width: 8.dp,),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          child: CustomElevatedButton(
                              backgroundColor: AppColors.lightStrongRed.withOpacity(0.8),
                              titleColor: AppColors.white,
                              title: "סרב",
                              onPressed: () async {
                                // showCancelOrderAlertDialog(
                                //     context);
                              }),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAreYouSurePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.dp))),
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("האם את בטוחה שאת רוצה לקבל את ההזמנה?", style: TextStyle( fontFamily: 'arimo',
                    fontWeight: FontWeight.w600, fontSize: 14.dp, color: AppColors.blackText
                ),)
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:  EdgeInsets.only(left: 4.0.dp),
                    child: TextButton(
                      onPressed: () async {
                        String response = await TShopperService.updateOrder(
                            orderId: widget.order.orderId,
                            actionType: "IN_PROGRESS",
                            notes: "",
                            image: "", missionId: '');
                        if(response.isEmpty){
                          widget.order.orderStatus = "IN_PROGRESS";
                          widget.order.timeLine.startWorkingOnOrder = DateTime.now().toString();
                          widget.order.timeLine.lastUpdated = DateTime.now().toString();
                          ref.read(inPreparationOrderProvider.notifier).addOrder(widget.order);
                          ref.read(newOrderProvider.notifier).deleteOrder(widget.order.orderId);
                        }
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.whiteText,
                        backgroundColor: AppColors.primeryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.dp, vertical: 15.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.dp),
                        ),
                      ),
                      child: Text(
                        "אישור",
                        style: TextStyle(
                            fontSize: AppFontSize.fontSizeRegular,
                            fontFamily: 'arimo',
                            color: AppColors.white,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:  EdgeInsets.only(right: 4.0.dp),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.whiteText,
                        backgroundColor: AppColors.superLightPurple,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.dp, vertical: 15.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.dp),
                        ),
                      ),
                      child: Text(
                        "ביטול",
                        style: TextStyle(
                            fontSize: AppFontSize.fontSizeRegular,
                            fontFamily: 'arimo',
                            color: AppColors.primeryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
