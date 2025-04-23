import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';

import '../../constants/AppColors.dart';
import '../../models/shift/ShopperShift.dart';
import '../../sevices/ShiftService.dart';

class TimesheetWidget extends StatefulWidget {
  DateTime startDate;
  DateTime endDate;
  TimesheetWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  _TimesheetWidgetState createState() =>
      _TimesheetWidgetState();
}

class _TimesheetWidgetState extends State<TimesheetWidget>
    with TickerProviderStateMixin {

  bool isLoading = true;
  List<ShopperShift> fetchedShifts = [];
  String searchQuery = "";

  late DateTime startDate;
  late DateTime endDate;

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
    'lightPink': Colors.pink[100]!,
    'brown': Colors.brown,
    'black': Colors.black,
  };

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
    TShopper.instance.totalDays = 0;
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
    TShopper.instance.totalHours = 0;
    TShopper.instance.totalDays = 0;
    for (var shift in fetchedShifts) {
      if (shift.actualDurationHours > 0 && !shift.isDeleted) {
        TShopper.instance.totalHours += shift.actualDurationHours;
        TShopper.instance.totalDays ++;
      }
    }
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
            GestureDetector(
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                  initialDateRange: DateTimeRange(
                    start: startDate,
                    end: endDate,
                  ),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primeryColor,
                          onPrimary: Colors.white,
                          onSurface: AppColors.blackText,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primeryColor,
                            textStyle: TextStyle(
                              fontFamily: 'arimo',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.dp,
                            ),
                          ),
                        ),
                        textTheme: TextTheme(
                          // For default body text
                          bodyMedium: TextStyle(
                            fontFamily: 'arimo',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.dp,
                            color: AppColors.blackText,
                          ),
                          // For header like "Select Date Range"
                          titleLarge: TextStyle(
                            fontFamily: 'todofont',
                            fontWeight: FontWeight.w800,
                            fontSize: 20.dp,
                            color: AppColors.blackText,
                          ),
                          titleMedium: TextStyle(
                            fontFamily: 'arimo',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.dp,
                            color: AppColors.blackText,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    startDate = picked.start;
                    endDate = picked.end;
                    _fetchShifts();
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.dp, vertical: 4.dp),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGreyColor,
                      borderRadius: BorderRadius.circular(10.dp),
                      border: Border.all(
                        color: AppColors.backgroundGreyColor,
                        width: 1.dp,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${startDate.day.toString().padLeft(2, '0')}/${startDate
                            .month.toString().padLeft(2, '0')}/${startDate.year
                            .toString().padLeft(4, '0')}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.dp,
                          fontFamily: 'arimo',
                          color: AppColors.blackText,
                        ),
                      ),
                    ),
                  ),
                  Text("עד",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.dp,
                      fontFamily: 'arimo',
                      color: AppColors.mediumGreyText,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.dp, vertical: 4.dp),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGreyColor,
                      borderRadius: BorderRadius.circular(10.dp),
                      border: Border.all(
                        color: AppColors.backgroundGreyColor,
                        width: 1.dp,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${endDate.day.toString().padLeft(2, '0')}/${endDate.month
                            .toString().padLeft(2, '0')}/${endDate.year.toString()
                            .padLeft(4, '0')}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.dp,
                          fontFamily: 'arimo',
                          color: AppColors.blackText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.dp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.access_time_filled_outlined,
                  color: AppColors.mediumGreyText, size: 16.dp,),
                SizedBox(width: 8.dp,),
                Text(TShopper.instance.totalHours.toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.w600,
                      fontFamily: 'arimo',
                      color: AppColors.blackText,
                      fontSize: 15.dp),),
                SizedBox(width: 24.dp,),
                Icon(Icons.date_range, color: AppColors.mediumGreyText,
                  size: 16.dp,),
                SizedBox(width: 8.dp,),
                Text(TShopper.instance.totalDays.toString(), style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'arimo',
                    color: AppColors.blackText,
                    fontSize: 15.dp),),
              ],
            ),
            SizedBox(height: 16.dp,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      endDate.difference(startDate).inDays + 1,
                          (index) {
                        final currentDate = endDate.subtract(Duration(days: index));
                        final formattedDate = "${currentDate.day.toString().padLeft(
                            2, '0')}/${currentDate.month.toString().padLeft(
                            2, '0')}/${currentDate.year}";
                        final shiftsForDay = fetchedShifts.where((s) =>
                        s.date == currentDate.toIso8601String().substring(0, 10))
                            .toList();

                        return Padding(
                            padding: EdgeInsets.only(bottom: 12.dp),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.dp,
                                vertical: 5.dp,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.whiteText,
                                border: Border.all(
                                  color: AppColors.borderColor,
                                  width: 1.dp,
                                ),
                                borderRadius: BorderRadius.circular(15.dp),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
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
                                          SizedBox(height: 2.dp,),
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
                                  )
                                ],
                              ),
                            ),
                          );
                      },
                    ),
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

}
