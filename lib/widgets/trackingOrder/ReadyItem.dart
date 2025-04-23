import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/models/order/deliveryMission/DeliveryMission.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/widgets/trackingOrder/AfterCollectingStoreOrderCard.dart';
import 'package:tshopper_app/widgets/trackingOrder/StoreOrderCard.dart';
import 'package:tshopper_app/widgets/trackingOrder/UpdateCourierPickedUpWidget.dart';
import '../../../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../popup/BottomPopup.dart';
import 'ChooseTimeForCourierWidget.dart';
import 'OrderItemContainer.dart';
import 'TimeToCourierWidget.dart';

class ReadyItem extends riverpod.ConsumerStatefulWidget {
  ReadyItem({super.key, required this.order, this.isFuture = false});
  final TShopperOrder order;
  bool isFuture;

  @override
  riverpod.ConsumerState<ReadyItem> createState() => _ReadyItemState();
}

class _ReadyItemState extends riverpod.ConsumerState<ReadyItem> {
  bool isLoading = true;
  bool isExpended = false;
  int selectedNumber = -1;
  String selectedImageUrl = '';

  Map<String, Color> colorMap = {
    'blue': Colors.blue,
    'green': Colors.green,
    'teal': Colors.teal,
    'tealAccent': Colors.tealAccent,
    'beige': Colors.orange[100]!,
    'orange': Colors.orange,
    'yellow': Colors.yellow,
    'red': Colors.red,
    'pink': Colors.pink,
    'lightPink':  Colors.pink[100]!,
    'brown':  Colors.brown,
    'black':  Colors.black,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                            Spacer(),
                            Container(
                              height: 30.dp,
                              decoration:  BoxDecoration(
                                  color: colorMap[widget.order.stickerColor],
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(
                                      8.dp)
                              ),
                              child:
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0.dp, vertical: 6.dp),
                                child: Row(
                                  children: [
                                    Icon(Icons.shopping_bag, color: AppColors.white, size: 12.dp,),
                                    SizedBox(width: 4.dp,),
                                    Text(widget.order.getBagsAmount().toString(),
                                      style: TextStyle(fontSize: 14.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w900, color: AppColors.white),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(widget.order.deliveryMissions.length > 1)...[
                    SizedBox(height: 8.dp),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/warning_icon.png",
                          width: 16.dp,
                          height: 16.dp,
                        ),
                        SizedBox(width: 8.dp,),
                        Text("שימי לב- בהזמנה זו ${widget.order.deliveryMissions.length} שליחים",
                          style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: AppFontSize.fontSizeSmall,
                            fontWeight: FontWeight.w800
                        ),)
                      ],
                    ),
                  ],
                  if(widget.order.deliveryMissions.isNotEmpty)...[
                    SizedBox(height: 8.dp,),
                    Row(
                      children: [
                        Container(
                            margin:
                            const EdgeInsets
                                .all(2),
                            padding:
                            const EdgeInsets
                                .all(1),
                            decoration:
                            BoxDecoration(
                              color: AppColors
                                  .blackText,
                              shape: BoxShape
                                  .circle,
                            ),
                            child: Icon(
                              Icons.location_pin,
                              color:
                              AppColors
                                  .white,
                              size: 14.dp,
                            )),
                        SizedBox(width: 4.dp,),
                        Text(widget.order.deliveryMissions.first.pickupDeliveryInstruction, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.dp, color:
                        AppColors.mediumGreyText, fontFamily: 'arimo'),)
                      ],
                    ),
                    SizedBox(height: 8.dp),
                    Column(
                      children: widget.order.deliveryMissions
                          .map((mission) =>
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      margin:
                                      const EdgeInsets
                                          .all(2),
                                      padding:
                                      const EdgeInsets
                                          .all(1),
                                      decoration:
                                      BoxDecoration(
                                        color: AppColors
                                            .blackText,
                                        shape: BoxShape
                                            .circle,
                                      ),
                                      child: Icon(
                                        Icons.delivery_dining,
                                        color:
                                        AppColors
                                            .white,
                                        size: 14.dp,
                                      )),
                                  SizedBox(width: 4.dp,),
                                  Text(mission.status != 'NO_COURIER' ? mission.courierName.split(' ').first : "מחפש שליח",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.dp, color: AppColors.blackText, fontFamily: 'arimo'),),
                                  if(mission.status != 'NO_COURIER')...[
                                    SizedBox(width: 4.dp,),
                                    GestureDetector(
                                      child: Icon(Icons.copy, color: AppColors.blackText, size: 14.dp),
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: mission.courierPhoneNumber));
                                        showBottomPopup(
                                          context: context,
                                          message: "מספר טלפון של השליח הועתק בהצלחה",
                                          imagePath: "assets/images/warning_icon.png",
                                        );
                                      },
                                    ),

                                    SizedBox(width: 16.dp,),
                                    TimeToCourierWidget(mission: mission),

                                    if(mission.timeline.courierArrivedToShopper!.isNotEmpty && mission.timeline.orderPickedUp!.isEmpty)...[
                                      Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          showCourierPickedUpAlertDialog(context, mission);

                                        },
                                        child: Container(
                                          height: 23.dp,
                                          decoration:  BoxDecoration(
                                              color: AppColors.primeryColor,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(
                                                  8.dp)
                                          ),
                                          child:
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0.dp, vertical: 6.dp),
                                            child: Row(
                                              children: [
                                                Icon(Icons.check_circle, color: AppColors.white, size: 12.dp,),
                                                SizedBox(width: 4.dp,),
                                                Text("סמן איסוף",
                                                  style: TextStyle(fontSize: 10.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w600, color: AppColors.white),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                              if(mission.timeline.courierArrivedToShopper!.isEmpty && mission.timeline.courierScannedWrongBarcode!.isNotEmpty)...[
                                Row(
                                  children: [
                                    Icon(Icons.warning, color: AppColors.redColor, size: 14.dp,),
                                    SizedBox(width: 8.dp,),
                                    Text("שליח סרק ברקוד שגוי", style: TextStyle(fontWeight: FontWeight.w600,
                                        fontSize: 14.dp, color: AppColors.redColor, fontFamily: 'arimo')),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () async {
                                        bool response = await TShopperService.updateCourierArrived(missionId: int.parse(mission.id));
                                      },
                                      child: Container(
                                        height: 23.dp,
                                        decoration:  BoxDecoration(
                                            color: AppColors.primeryColor,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(
                                                8.dp)
                                        ),
                                        child:
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0.dp, vertical: 6.dp),
                                          child: Row(
                                            children: [
                                              Icon(Icons.check_circle, color: AppColors.white, size: 12.dp,),
                                              SizedBox(width: 4.dp,),
                                              Text("סמני שליח הגיע",
                                                style: TextStyle(fontSize: 10.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w600, color: AppColors.white),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                              Divider(
                                thickness: 1,
                                color: AppColors.borderColor,
                              )
                            ],
                          ))
                          .toList(),
                    ),
                  ],
                  Column(
                    children: widget.order.orderStores
                        .map((store) => AfterCollectionStoreOrderCard(store: store, order: widget.order, isInProgress: true,
                      setState: (){
                        setState(() {

                        });
                      },))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCourierPickedUpAlertDialog(BuildContext context, DeliveryMission mission) {
    selectedNumber = 0;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    UpdateCourierPickedUpWidget(
                      order: widget.order,
                      mission: mission,
                      onChooseNumber: (newValue) => selectedNumber = newValue,
                      onChoosePickupBagsImageUrls: (newValue) => selectedImageUrl = newValue,
                    )
                  ],
                ),
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
                        if(widget.order.numberOfCouriers == 1){
                          selectedNumber = widget.order.getBagsAmount();
                        }
                        if ((widget.order.numberOfCouriers > 1 && selectedNumber == 0) || selectedImageUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'יש למלא את כל הפרטים',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primeryColor,
                                    fontFamily: 'arimo',
                                    fontSize: AppFontSize.fontSizeRegular),
                              ),
                              duration: const Duration(seconds: 5),
                              backgroundColor: AppColors.lightGreyText,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(bottom: 50.dp),
                            ),
                          );
                        } else {
                          String response = await TShopperService.updateOrder(
                              orderId: widget.order.orderId, actionType: 'PICKED_UP', notes: selectedImageUrl,
                              image: selectedNumber.toString(), missionId: mission.id);
                          if(response.isEmpty){
                            Navigator.pop(context);
                          }
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
