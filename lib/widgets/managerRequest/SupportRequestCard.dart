import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:tshopper_app/models/managerRequest/ManagerRequest.dart';
import 'package:tshopper_app/sevices/ManagerRequestService.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';

class ManagerRequestCard extends StatefulWidget {
  const ManagerRequestCard({
    super.key,
    required this.onDelete,
    this.onMoreDetailsPressed,
    required this.request,
  });

  final void Function(ManagerRequest request) onDelete;
  final void Function()? onMoreDetailsPressed;
  final ManagerRequest request;

  @override
  State<ManagerRequestCard> createState() => _ManagerRequestCardState();
}

class _ManagerRequestCardState extends State<ManagerRequestCard> {
  bool isExpended = false;

  @override
  Widget build(BuildContext context) {

    final String orderTitle = "#${widget.request.id}";
    DateTime dateTime = widget.request.getCreatedAt();

    final String dateOfOrder = DateFormat('dd/MM/yyyy').format(dateTime);
    final String hourOfOrder = DateFormat('HH:mm').format(dateTime);

    return Padding(
      padding: EdgeInsets.only(top: 16.0.dp),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.dp,
          vertical: 5.dp,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border.all(
            color: AppColors.borderColor,
            width: 1.0.dp,
          ),
          borderRadius: BorderRadius.circular(15.dp),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if(widget.request.status == "Pending")
              Positioned(
                top: -7.dp,
                left: -9.dp,
                child: GestureDetector(
                  onTap: (){
                    showAreYouSurePopup(context, widget.request);
                  },
                  child: Container(
                    width: 26.dp,
                    height: 26.dp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                        child: Icon(Icons.remove, color: Colors.white, size: 26.dp)
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 5.dp,
              left: 22.dp,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: getColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                        5.dp)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.dp, vertical: 6.dp),
                  child: Text(
                    getStatus(),
                    style: TextStyle(
                      fontSize: 12.dp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'arimo',
                      color: getColor(),
                    ),
                  ),
                ),
              ),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8.dp,),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                orderTitle,
                                style: TextStyle(
                                  fontFamily: 'todofont',
                                  fontSize: 26.dp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blackText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.dp),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                dateOfOrder,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.dp,
                                  fontFamily: 'arimo',
                                  color: AppColors.blackText,
                                ),
                              ),
                              Text(
                                "  |  " + hourOfOrder,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.dp,
                                  fontFamily: 'arimo',
                                  color: AppColors.blackText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: 6.dp),
                Divider(color: AppColors.borderColor, thickness: 1,),
                Row(
                    children: [
                      Text("פרטי הפנייה", style: TextStyle(fontSize: 13.dp,
                          fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.blackText),),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpended = !isExpended;
                          });
                        },
                        child: Container(
                          decoration:  BoxDecoration(
                            color: AppColors.primaryLightColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            size: 22.dp,
                            isExpended ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.oppositeBackgroundColor,
                          ),
                        ),
                      ),
                    ]),
                if(isExpended)
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.0.dp),
                    child: Column(
                      children: [
                        SizedBox(height: 16.dp,),
                        Row(
                          children: [
                            Text("נושא", style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall,
                                fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.blackText),),
                            const Spacer(),
                            Text(widget.request.requestSubject == "cancelOrder" ? "ביטול הזמנה" :
                            widget.request.requestSubject == "cancelStore" ? "ביטול חנות" : "הסרת שיבוץ", style: TextStyle(fontSize: 13.dp,
                                fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.blackText),),
                          ],
                        ),
                        Divider(color: AppColors.borderColor, thickness: 1,),
                        Row(
                          children: [
                            Text("פירוט", style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.blackText),),
                            const Spacer(),
                            Container(
                                width: 250.dp,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.request.request,
                                    style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall,  fontFamily: 'arimo',
                                        fontWeight: FontWeight.w400, color: AppColors.blackText),
                                  ),
                                ),),
                          ],
                        ),
                        if(widget.request.response != "")...[
                          Divider(color: AppColors.borderColor, thickness: 1,),
                          Row(
                            children: [
                              Text("תשובת מנהלת", style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.blackText),),
                              const Spacer(),
                              Container(
                                width: 230.dp,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.request.response,
                                    style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall,  fontFamily: 'arimo',
                                        fontWeight: FontWeight.w400, color: AppColors.blackText),
                                  ),
                                ),),
                            ],
                          ),
                        ],
                        if(widget.request.resolvedAt != "")...[
                          Divider(color: AppColors.borderColor, thickness: 1,),
                          Row(
                            children: [
                              Text("נסגרה בתאריך", style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.blackText),),
                              const Spacer(),
                              Text("${DateFormat('dd/MM/yyyy').format(widget.request.getResolvedAt())} | ${DateFormat('HH:mm').format(widget.request.getResolvedAt())}",
                                style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall,  fontFamily: 'arimo',
                                  fontWeight: FontWeight.w400, color: AppColors.blackText),),
                            ],
                          ),
                        ],
                      ],
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    if(widget.request.status == "Pending") {
      return AppColors.mediumGreyText;
    }
    if(widget.request.status == "InProgress") {
      return AppColors.primeryColor;
    }
    if(widget.request.status == "Confirmed") {
      return AppColors.strongGreen;    }
    if(widget.request.status == "Refused") {
      return AppColors.redColor;    }
    return AppColors.mediumGreyText;
  }

  String getStatus() {
    if(widget.request.status == "Pending") {
      return "בהמתנה";
    }
    if(widget.request.status == "InProgress") {
      return "בטיפול";
    }
    if(widget.request.status == "Confirmed") {
      return "אושר";
    }
    if(widget.request.status == "Refused") {
      return "נדחה";
    }
    return "אחר";
  }

  void showAreYouSurePopup(BuildContext context, ManagerRequest request) {
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
                Text("האם אתה בטוח שאתה רוצה למחוק?", style: TextStyle( fontFamily: 'arimo',
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
                          setState(() {
                            _deleteRequest(request);
                          });
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.whiteText,
                        backgroundColor: AppColors.primeryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.dp, vertical: 12.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.dp),
                        ),
                      ),
                      child: Text(
                        "אישור",
                        style: TextStyle(
                            fontSize: AppFontSize.fontSizeSmall,
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
                            horizontal: 0.dp, vertical: 12.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.dp),
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
  Future<void> _deleteRequest(ManagerRequest currentRequest) async {
    bool response = await ManagerRequestService.deleteManagerRequest(currentRequest.id);
    if (response) {
      setState(() {
        widget.onDelete!(currentRequest);
      });
    } else {
    }
  }
}
