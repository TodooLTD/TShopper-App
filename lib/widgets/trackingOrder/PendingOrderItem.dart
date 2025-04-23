import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:intl/intl.dart';
import 'package:tshopper_app/models/managerRequest/ManagerRequest.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/sevices/ManagerRequestService.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/widgets/trackingOrder/StoreOrderCard.dart';
import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';
import '../popup/BottomPopup.dart';
import 'CustomElevatedButton.dart';
import 'OrderItemContainer.dart';

class PendingOrderItem extends riverpod.ConsumerStatefulWidget {
  PendingOrderItem({super.key, required this.order, this.isFuture = false});
  final TShopperOrder order;
  bool isFuture;

  @override
  riverpod.ConsumerState<PendingOrderItem> createState() => _PendingOrderItemState();
}

class _PendingOrderItemState extends riverpod.ConsumerState<PendingOrderItem> {
  bool isLoading = true;
  int minutesSinceAssigned = 0;
  Timer? assignTimer;
  Timer? cancelTimer;
  int remainingTimeInSeconds = 0;
  bool isExpended = false;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();

    // Setup the cancel countdown timer
    remainingTimeInSeconds = widget.order.getOrderPlaced()
        .add(widget.order.orderStatus == "SEEN_BY_SHOPPER"
        ? Duration(minutes: 10)
        : Duration(minutes: 5))
        .difference(DateTime.now())
        .inSeconds;

    if (widget.order.orderStatus == "SEEN_BY_SHOPPER" &&
        (remainingTimeInSeconds > 600 || remainingTimeInSeconds < 0)) {
      remainingTimeInSeconds = 0;
    }

    startCancelTimer();
    startAssignTimer();
  }

  @override
  void dispose() {
    cancelTimer?.cancel();
    assignTimer?.cancel();
    _notesController.dispose();
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
    final assignTime = widget.order.timeLine.orderPlaced;
    if (assignTime != null && assignTime.isNotEmpty) {
      setState(() {
        minutesSinceAssigned = DateTime.now().difference(widget.order.getOrderPlaced()).inMinutes;
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
    String timeString = '';
    if(widget.order.orderStatus == 'ON_HOLD'){
      timeString = DateFormat('HH:mm').format(widget.order.getOrderConfirmed());
    }

    return GestureDetector(
      onTap: () async {
        if(widget.order.orderStatus == 'PENDING'){
          String response = await TShopperService.updateOrder(
              orderId: widget.order.orderId,
              actionType: "SEEN_BY_SHOPPER",
              notes: TShopper.instance.uid,
              image: TShopper.instance.firstName, missionId: '');
        }
      },
      child: Padding(
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
                                          color: widget.order.orderStatus == 'ON_HOLD' ? AppColors.strongGreen.withOpacity(0.1) : AppColors.redColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6.dp),
                                        ),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 6.dp),
                                          child: Text(
                                            widget.order.orderStatus == 'ON_HOLD' ?
                                                "אושרה | ${widget.order.timeLine.ShopperNameSeenBy} | $timeString"
                                                : "ממתין לאישור $minutesSinceAssigned דקות",
                                            style: TextStyle(
                                              color: widget.order.orderStatus == 'ON_HOLD' ? AppColors.strongGreen : AppColors.redColor,
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
                    if(widget.order.orderStatus != 'ON_HOLD')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            child: CustomElevatedButton(
                                backgroundColor: AppColors.lightStrongGreen,
                                titleColor: AppColors.white,
                                title: "קבל",
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
                                  showSendManagerRequestPopup(context);

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
                            actionType: "ON_HOLD",
                            notes: TShopper.instance.uid,
                            image: TShopper.instance.firstName, missionId: '');
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

  void showSendManagerRequestPopup(BuildContext context) {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("רשמי את סיבת הביטול ופרטי על המקרה 💜🙏🏻", style: TextStyle(color: AppColors.blackText, fontSize: 16.dp, fontWeight: FontWeight.w800, fontFamily: 'todofont'),),
                  SizedBox(height: 16.dp,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderColor),
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                    child: TextField(
                      controller: _notesController,
                      autofocus: true,
                      maxLines: 6,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onEditingComplete: () {
                        if (context.mounted) {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.dp,
                          vertical: 10.dp,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontFamily: 'arimo',
                        fontSize: AppFontSize.fontSizeRegular,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackText,
                      ),
                    ),
                  ),
                ],
              ),
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
                        ManagerRequest request = ManagerRequest(
                            id: 0,
                            createdAt: "",
                            request: "ביטול הזמנה מספר ${widget.order.orderNumber} ממרכז קניות ${widget.order.centerShoppingName}",
                            shopperNotes: _notesController.text,
                            requestSubject: "cancelOrder",
                            status: "",
                            response: "",
                            resolvedAt: "",
                            objectId: 0,
                            orderId: widget.order.orderId,
                            shopperName: "",
                            shoppingCenterId: widget.order.centerShoppingId);
                        ManagerRequest? response = await ManagerRequestService.addManagerRequest(request);
                        if(response != null){
                            showBottomPopup(
                              context: context,
                              message: "בקשת ביטול נשלחה בהצלחה!💜",
                              imagePath:
                              "assets/images/warning_icon.png",
                            );
                            Navigator.pop(context);
                          }else{
                            showBottomPopup(
                              context: context,
                              message: "שגיאה בעת שליחת בקשת ביטול, נסה שוב",
                              imagePath:
                              "assets/images/warning_icon.png",
                            );
                          }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.whiteText,
                        backgroundColor: AppColors.primeryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.dp, vertical: 4.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.dp),
                        ),
                      ),
                      child: Text(
                        "אישור",
                        style: TextStyle(
                            fontSize: 13.dp,
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
                            horizontal: 0.dp, vertical: 4.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.dp),
                        ),
                      ),
                      child: Text(
                        "ביטול",
                        style: TextStyle(
                            fontSize: 13.dp,
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
