import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/providers/InPreparationOrderProvider.dart';
import 'package:tshopper_app/providers/NewOrderProvider.dart';
import 'package:tshopper_app/providers/PendingOrderProvider.dart';
import 'package:tshopper_app/providers/ReadyOrderProvider.dart';
import 'package:tshopper_app/sevices/AblyService.dart';
import 'package:tshopper_app/widgets/shift/EditShiftPopup.dart';

import '../../constants/AppColors.dart';
import '../../models/shift/ShopperShift.dart';
import '../../sevices/ShiftService.dart';
import '../popup/BottomPopup.dart';

class ShopperShiftsWidget extends ConsumerStatefulWidget {
  DateTime startDate;
  DateTime endDate;
  ShopperShiftsWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  _ShopperShiftsWidgetState createState() =>
      _ShopperShiftsWidgetState();
}

class _ShopperShiftsWidgetState extends ConsumerState<ShopperShiftsWidget>
    with TickerProviderStateMixin {

  bool isLoading = true;
  List<ShopperShift> fetchedShifts = [];
  String searchQuery = "";

  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate;
    endDate = widget.endDate;
    _fetchShifts();
  }

  Future<void> _fetchShifts() async {
    setState(() {
      isLoading = true;
    });
    TShopper.instance.totalHours = 0;
    final shifts = await ShiftService.getAssignedShiftsByShopper(
      shopperId: TShopper.instance.uid,
      centerId: TShopper.instance.currentShoppingCenterId,
      from: startDate,
      to: endDate,
    );
    fetchedShifts = List<ShopperShift>.from(shifts);
    TShopper.instance.totalHours = 0;
    for (var shift in fetchedShifts) {
      if(shift.actualDurationHours > 0 && !shift.isDeleted){
        TShopper.instance.totalHours += shift.actualDurationHours;
        TShopper.instance.totalDays ++;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchedShifts.sort((a,b) => b.date.compareTo(a.date));
    return isLoading
        ? Container(
      color: AppColors.whiteText,
      child: Center(
        child: CupertinoActivityIndicator(
          animating: true,
          color: AppColors.blackText,
          radius: 15.dp,
        ),
      ),
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.dp),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: fetchedShifts
                  .where((s) => !s.isDeleted) // optional filter
                  .map((shift) {
                final currentDate = DateTime.parse(shift.date);
                final shiftsForDay = fetchedShifts
                    .where((s) => s.date == shift.date)
                    .toList();

                return EditShiftPopup(
                  shift: shiftsForDay.first,
                  onConfirmed: (){
                    setState(() {
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.dp),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.dp, vertical: 5.dp),
                      decoration: BoxDecoration(
                        color: AppColors.whiteText,
                        border: Border.all(color: AppColors.borderColor, width: 1.dp),
                        borderRadius: BorderRadius.circular(15.dp),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 📅 Date Bubble
                          Material(
                            elevation: 4,
                            shape: CircleBorder(),
                            shadowColor: Colors.grey.withOpacity(0.4),
                            child: Container(
                              width: 50.dp,
                              height: 50.dp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.whiteText,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentDate.day.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.dp,
                                      color: AppColors.primeryColortext,
                                    ),
                                  ),
                                  SizedBox(height: 2.dp),
                                  Text(
                                    _getHebrewDayLetter(currentDate.weekday),
                                    style: TextStyle(
                                      fontSize: 14.dp,
                                      color: AppColors.primeryColortext,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      if(_isToday(currentDate))...[
                        Text(shiftsForDay.first
                            .actualStartTime.isNotEmpty ? shiftsForDay
                            .first.actualStartTime :
                        shiftsForDay.first.startTime,
                            style: TextStyle(
                              fontSize: 16.dp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'arimo',
                              color: shiftsForDay.first
                                  .actualStartTime.isNotEmpty ? AppColors.strongGreen :
                              AppColors.mediumGreyText,
                            )
                        ),
                        Text("עד",
                            style: TextStyle(
                              fontSize: 16.dp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'arimo',
                              color: AppColors.blackText,
                            )
                        ),
                        Text(shiftsForDay.first
                            .actualEndTime.isNotEmpty ? shiftsForDay
                            .first.actualEndTime :
                        shiftsForDay.first.endTime,
                            style: TextStyle(
                              fontSize: 16.dp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'arimo',
                              color: shiftsForDay.first
                                  .actualEndTime.isNotEmpty ? AppColors.strongGreen :
                              AppColors.mediumGreyText,
                            )
                        ),
                        if(shiftsForDay.first.actualStartTime.isEmpty && shiftsForDay.first.actualEndTime.isEmpty)
                          GestureDetector(
                            onTap: () async{
                              bool response = await ShiftService.startShift(shiftId: shiftsForDay.first.id);
                              if(response){
                                showBottomPopup(
                                  context: context,
                                  message: "חתימת כניסה התעדכנה בהצלחה",
                                  imagePath: "assets/images/warning_icon.png",
                                );
                                setState(() {
                                  shiftsForDay.first.actualStartTime = DateFormat('HH:mm').format(DateTime.now());
                                  AblyService.createAblyRealtimeInstance(
                                    TShopper.instance.uid,
                                    [TShopper.instance.uid, "tShoppersNewOrders-${TShopper.instance.currentShoppingCenterId}"],
                                  );
                                });
                              }else{
                                showBottomPopup(
                                  context: context,
                                  message: "שגיאה בעדכון כניסה, נסה שוב",
                                  imagePath: "assets/images/warning_icon.png",
                                );
                              }
                            },
                            child: Container(
                              width: 75.dp,
                              padding: EdgeInsets.symmetric(vertical: 6.dp, horizontal: 14.dp),
                              decoration: BoxDecoration(
                                color: AppColors.primeryColor,
                                borderRadius: BorderRadius.circular(10.dp),
                                border: Border.all(
                                  color: AppColors.primeryColor,
                                  width: 1.dp,
                                ),
                              ),
                              child: Center(
                                child: Text("כניסה", style: TextStyle(
                                  fontSize: 14.dp,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'arimo',
                                  color: AppColors.white,),),
                              ),
                            ),
                          ),
                        if(shiftsForDay.first.actualStartTime.isNotEmpty && shiftsForDay.first.actualEndTime.isEmpty)
                          GestureDetector(
                            onTap: () async{
                              if(ref.read(newOrderProvider).allNewOrders.isNotEmpty ||
                                  ref.read(inPreparationOrderProvider).allInPreparationOrders.isNotEmpty ||
                                  ref.read(readyOrderProvider).allReadyOrders.isNotEmpty){
                                showBottomPopup(
                                  context: context,
                                  message: "לא ניתן לצאת ממשמרת בזמן שיבוץ להזמנה",
                                  imagePath: "assets/images/warning_icon.png",
                                );
                              }else{
                                bool response = await ShiftService.endShift(shiftId: shiftsForDay.first.id);
                                if(response){
                                  showBottomPopup(
                                    context: context,
                                    message: "חתימת יציאה התעדכנה בהצלחה",
                                    imagePath: "assets/images/warning_icon.png",
                                  );
                                  setState(() {
                                    final now = DateTime.now();
                                    shiftsForDay.first.actualEndTime = DateFormat('HH:mm').format(now);

                                    final start = DateFormat('HH:mm').parse(shiftsForDay.first.actualStartTime);
                                    final end = DateFormat('HH:mm').parse(shiftsForDay.first.actualEndTime);

                                    final duration = end.difference(start);
                                    final durationInHours = duration.inMinutes / 60.0;

                                    shiftsForDay.first.actualDurationHours = double.parse(durationInHours.toStringAsFixed(2));
                                    ref.read(newOrderProvider).allNewOrders = [];
                                    ref.read(newOrderProvider).currentOrder = null;
                                    ref.read(pendingOrderProvider).allPendingOrders = [];
                                    ref.read(pendingOrderProvider).currentOrder = null;
                                    ref.read(inPreparationOrderProvider).allInPreparationOrders = [];
                                    ref.read(inPreparationOrderProvider).currentOrder = null;
                                    ref.read(readyOrderProvider).allReadyOrders = [];
                                    ref.read(pendingOrderProvider).currentOrder = null;
                                    AblyService.unsubscribeFromAllChannels();
                                  });
                                }else{
                                  showBottomPopup(
                                    context: context,
                                    message: "שגיאה בעדכון יציאה, נסה שוב",
                                    imagePath: "assets/images/warning_icon.png",
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 75.dp,
                              padding: EdgeInsets.symmetric(vertical: 8.dp),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(10.dp),
                                border: Border.all(
                                  color: AppColors.redColor,
                                  width: 1.dp,
                                ),
                              ),
                              child: Center(
                                child: Text("יציאה", style: TextStyle(
                                  fontSize: 16.dp,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'arimo',
                                  color: AppColors.white,),),
                              ),
                            ),
                          ),
                        if(shiftsForDay.first.actualStartTime.isNotEmpty && shiftsForDay.first.actualEndTime.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.access_time_filled_outlined,
                                  color: AppColors.mediumGreyText, size: 20.dp),
                              SizedBox(width: 8.dp,),
                              SizedBox(
                                width: 40.dp,
                                child: Text(
                                    _formatDurationToHHMM(
                                        shiftsForDay.first.actualDurationHours),
                                    style: TextStyle(
                                      fontSize: 14.dp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'arimo',
                                      color: shiftsForDay.isNotEmpty &&
                                          shiftsForDay.first.isDeleted
                                          ? AppColors.redColor
                                          :
                                      shiftsForDay.isNotEmpty &&
                                          (shiftsForDay.first
                                              .startTimeEditedBy == 'MANAGER' ||
                                              shiftsForDay.first
                                                  .endTimeEditedBy == 'MANAGER')
                                          ? AppColors.mediumBlue
                                          :
                                      shiftsForDay.isNotEmpty &&
                                          (shiftsForDay.first
                                              .startTimeEditedBy == 'SHOPPER' ||
                                              shiftsForDay.first
                                                  .endTimeEditedBy == 'SHOPPER')
                                          ? AppColors.pink
                                          :
                                      AppColors.blackText,
                                    )
                                ),
                              )
                            ],
                          ),
                      ],
                      if(!_isToday(currentDate))...[
                        Column(
                          children: [
                            Text("כניסה", style: TextStyle(
                              fontSize: 11.dp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'arimo',
                              color: AppColors.blackText,
                            ),),
                            SizedBox(height: 8.dp,),
                            Text(shiftsForDay.isNotEmpty ? shiftsForDay.first
                                .isDeleted ? "—" : shiftsForDay.first
                                .actualStartTime.isNotEmpty ? shiftsForDay
                                .first.actualStartTime :
                            shiftsForDay.first.startTime : "—",
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'arimo',
                                  color: shiftsForDay.isNotEmpty &&
                                      shiftsForDay.first.isDeleted ? AppColors
                                      .redColor :
                                  shiftsForDay.isNotEmpty &&
                                      shiftsForDay.first.startTimeEditedBy ==
                                          'MANAGER' ? AppColors.mediumBlue :
                                  shiftsForDay.isNotEmpty &&
                                      shiftsForDay.first.startTimeEditedBy ==
                                          'SHOPPER' ? AppColors.pink :
                                  AppColors.blackText,
                                )
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("יציאה", style: TextStyle(
                              fontSize: 11.dp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'arimo',
                              color: AppColors.blackText,
                            ),),
                            SizedBox(height: 8.dp,),
                            Text(shiftsForDay.isNotEmpty ? shiftsForDay.first
                                .isDeleted ? "—" : shiftsForDay.first
                                .actualEndTime.isNotEmpty ? shiftsForDay.first
                                .actualEndTime :
                            shiftsForDay.first.endTime : "—",
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'arimo',
                                  color: shiftsForDay.isNotEmpty &&
                                      shiftsForDay.first.isDeleted ? AppColors
                                      .redColor :
                                  shiftsForDay.isNotEmpty &&
                                      shiftsForDay.first.endTimeEditedBy ==
                                          'MANAGER' ? AppColors.mediumBlue :
                                  shiftsForDay.isNotEmpty &&
                                      shiftsForDay.first.endTimeEditedBy ==
                                          'SHOPPER' ? AppColors.pink :
                                  AppColors.blackText,
                                )
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time_filled_outlined,
                                color: AppColors.mediumGreyText, size: 20.dp),
                            SizedBox(width: 8.dp,),
                            SizedBox(
                              width: 40.dp,
                              child: Text(
                                  shiftsForDay.isNotEmpty ? shiftsForDay.first
                                      .isDeleted ? " — " : shiftsForDay.first
                                      .actualDurationHours != 0
                                      ? _formatDurationToHHMM(
                                      shiftsForDay.first.actualDurationHours)
                                      :
                                  " — " : " — ",
                                  style: TextStyle(
                                    fontSize: 14.dp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'arimo',
                                    color: shiftsForDay.isNotEmpty &&
                                        shiftsForDay.first.isDeleted
                                        ? AppColors.redColor
                                        :
                                    shiftsForDay.isNotEmpty &&
                                        (shiftsForDay.first
                                            .startTimeEditedBy == 'MANAGER' ||
                                            shiftsForDay.first
                                                .endTimeEditedBy == 'MANAGER')
                                        ? AppColors.mediumBlue
                                        :
                                    shiftsForDay.isNotEmpty &&
                                        (shiftsForDay.first
                                            .startTimeEditedBy == 'SHOPPER' ||
                                            shiftsForDay.first
                                                .endTimeEditedBy == 'SHOPPER')
                                        ? AppColors.pink
                                        :
                                    AppColors.blackText,
                                  )
                              ),
                            )
                          ],
                        ),
                      ],

                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDurationToHHMM(double duration) {
    int hours = duration.floor();
    int minutes = ((duration - hours) * 60).round();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }


  String _getHebrewDayLetter(int weekday) {
    const hebrewLetters = ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ש'];
    return hebrewLetters[weekday % 7]; // Sunday = 7 % 7 = 0 => 'א'
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

}
