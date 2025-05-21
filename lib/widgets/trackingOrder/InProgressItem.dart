import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/widgets/trackingOrder/StoreOrderCard.dart';
import '../../../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../models/managerRequest/ManagerRequest.dart';
import '../../sevices/ManagerRequestService.dart';
import '../popup/BottomPopup.dart';
import 'ChooseTimeForCourierWidget.dart';
import 'OrderItemContainer.dart';
import 'TimeToCourierWidget.dart';

class InProgressItem extends riverpod.ConsumerStatefulWidget {
  InProgressItem({super.key, required this.order, this.isFuture = false});
  final TShopperOrder order;
  bool isFuture;

  @override
  riverpod.ConsumerState<InProgressItem> createState() => _InProgressItemState();
}

class _InProgressItemState extends riverpod.ConsumerState<InProgressItem> {
  bool isLoading = true;
  bool haveOpenRequest = false;
  bool isExpended = false;
  int selectedNumber = -1;
  int selectedPoint = -1;
  String selectedColor = "";
  String? selectedSupplyMode;
  List<String> supplyModeOptions = ["רגיל", "שביר"];


  @override
  void initState() {
    super.initState();
    checkCancelOrderRequests();
    }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    Container(
      color: AppColors.whiteText,
      child: Center(
        child: CupertinoActivityIndicator(
          animating: true,
          color: AppColors.blackText,
          radius: 15.dp,
        ),
      ),
    )
    : Padding(
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
                            if(widget.order.allPaymentRequestDone() && (widget.order.timeLine.orderDeliveryMission ?? "").isEmpty)
                              GestureDetector(
                                onTap: (){
                                  showCourierTimeAlertDialog(context);
                                },
                                child: Container(
                                  height: 30.dp,
                                  decoration:  BoxDecoration(
                                      color: AppColors.primeryColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                          8.dp)
                                  ),
                                  child:
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.0.dp, vertical: 6.dp),
                                      child: Text("הזמן שליח",
                                        style: TextStyle(fontSize: 12.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.white),),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(haveOpenRequest)...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: AppColors.todoColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6.dp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 6.dp),
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/newIcons/warningIcon.png", width: 14,),
                                        SizedBox(width: 8,),
                                        Text(
                                          "נשלחה בקשה לביטול חנות",
                                          style: TextStyle(
                                            color: AppColors.todoColor,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'arimo',
                                            fontSize: AppFontSize.fontSizeExtraSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 8.dp),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if(widget.order.deliveryMissions.isNotEmpty)...[
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
                    SizedBox(height: 8.dp),
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
                                    SizedBox(width: 16.dp,),
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
                                          Icons.phone,
                                          color:
                                          AppColors
                                              .white,
                                          size: 14.dp,
                                        )),
                                    SizedBox(width: 2.dp,),
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
                                  ],
                                ],
                              ),
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
                        .map((store) => StoreOrderCard(store: store, order: widget.order, isInProgress: true,
                      setState: (){setState(() {});},onRequestSent: (){ print("on request senttttt"); setState(() {haveOpenRequest = true;});},))
                        .toList(),
                  ),
                  SizedBox(height: 8.dp),
                  if(widget.order.allStoresDone() && (widget.order.timeLine.orderDeliveryMission ?? '').isNotEmpty)
                    GestureDetector(
                      onTap: () async{
                        showOrderReadyAlertDialog(context);

                      },
                      child: Container(
                        height: 30.dp,
                        decoration:  BoxDecoration(
                            color: AppColors.primeryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(
                                8.dp)
                        ),
                        child:
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.dp, vertical: 6.dp),
                            child: Text("ההזמנה מוכנה",
                              style: TextStyle(fontSize: 12.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.white),),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showOrderReadyAlertDialog(BuildContext context) {
    selectedSupplyMode = null;
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
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("בחרי את מצב האספקה של ההזמנה 💜🙏🏻", style: TextStyle(color: AppColors.blackText, fontSize: 15.dp, fontWeight: FontWeight.w800, fontFamily: 'todofont'),),
                SizedBox(height: 4.dp,),
                Text("במידה ומצב האספקה אינו דורש התייחסות מיוחדת - יש לבחור מצב אספקה ״רגיל״", style: TextStyle(color: AppColors.blackText, fontSize: 11.dp, fontWeight: FontWeight.w400, fontFamily: 'arimo'),),
                SizedBox(height: 16.dp,),
                _buildDropdown(MediaQuery.sizeOf(context).width * 0.6.dp, selectedSupplyMode, "בחרי מצב אספקה", supplyModeOptions, (value) {
                  setState(() {
                    setState(() => selectedSupplyMode = value);
                  });
                }),
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
                        if (selectedSupplyMode == null || selectedSupplyMode == "") {
                          showBottomPopup(
                            context: context,
                            message: 'יש לבחור מצב אספקה',
                            imagePath:
                            "assets/images/warning_icon.png",
                          );
                        } else {
                          String response = await TShopperService.updateOrder(
                              orderId: widget.order.orderId,
                              actionType: 'READY_FOR_PICKUP_DELIVERY',
                              notes: getSupplyModeEnglishName(selectedSupplyMode!),
                              image: '', missionId: '');

                            Navigator.pop(context);
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

  void showCourierTimeAlertDialog(BuildContext context) {
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
                    ChooseTimeForCourierWidget(
                      shoppingCenterId: widget.order.centerShoppingId,
                      onChooseNumber: (newValue) => setState(() {
                        selectedNumber = newValue;
                      }),
                     onChoosePickupPoint: (newValue) => setState(() {
                       selectedPoint = newValue;
                      }),
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
                        if (selectedPoint == -1) {
                          showBottomPopup(
                            context: context,
                            message: 'יש למלא את כל הפרטים',
                            imagePath:
                            "assets/images/warning_icon.png",
                          );
                        } else {
                          String response = await TShopperService.updateOrder(
                              orderId: widget.order.orderId,
                              actionType: 'DELIVERY_MISSION_ORDER',
                              notes: selectedPoint.toString(),
                              image: selectedNumber.toString(), missionId: '');
                          if(response.isEmpty){
                            setState(() {
                              widget.order.timeLine.orderDeliveryMission = DateTime.now().toString();
                            });
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

  String getSupplyModeEnglishName(String hebrewName){
    switch(hebrewName){
      case "רגיל":
        return "REGULAR";
      case "שביר":
        return "FRAGILE";
      case "נוזלי":
        return "LIQUID";
      case "כבד":
        return "HEAVY";
      case "גדול":
        return "BULKY";
      case "קפוא":
        return "FROZEN";
      case "אלקטרוניקה":
        return "ELECTRONICS";
      case "דליק":
        return "FLAMMABLE";
      case "ציוד רפואי":
        return "MEDICAL";
      case "מסמכים":
        return "DOCUMENTS";
      default:
        return "REGULAR";
    }
  }

  Widget _buildDropdown(double width, String? value, String hint, List<String> items, Function(String?) onChanged) {
    return SizedBox(
      width: width,
      height: 50.dp,
      child: DropdownButtonFormField<String>(
        value: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.backgroundColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 2.dp),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.dp),
            borderSide: BorderSide(color: AppColors.borderColor, width: 1.dp),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.dp),
            borderSide: BorderSide(color: AppColors.borderColor, width: 1.dp),
          ),
        ),
        hint: Text(hint, style: _hintStyle()),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.mediumGreyText),
        dropdownColor: AppColors.backgroundColor,
        elevation: 2,
        menuMaxHeight: 250.dp,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: _optionStyle(item)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> checkCancelOrderRequests() async{

    List<ManagerRequest> requests = await ManagerRequestService.getManagerRequestsByOrder(widget.order.orderId);
    if(requests.where((request) => request.requestSubject == "cancelStore"
        && (request.status == "Pending" || request.status == "InProgress")).toList().isNotEmpty){
      haveOpenRequest = true;
    }
    setState(() {
      isLoading = false;
    });
  }

  TextStyle _hintStyle() => TextStyle(color: AppColors.mediumGreyText, fontWeight: FontWeight.w500, fontSize: AppFontSize.fontSizeExtraSmall, fontFamily: 'arimo');
  TextStyle _optionStyle(String item) => TextStyle(color: item == "חסום" ? AppColors.redColor : item == "פתוח" ? AppColors.strongGreen : AppColors.blackText, fontWeight: FontWeight.w500, fontSize: AppFontSize.fontSizeExtraSmall, fontFamily: 'arimo');
}
