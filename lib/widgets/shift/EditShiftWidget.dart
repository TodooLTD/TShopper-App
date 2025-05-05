import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../models/shift/ShopperShift.dart';
import '../../sevices/ShiftService.dart';

class EditShiftWidget extends ConsumerStatefulWidget {
  ShopperShift? shift;
  final void Function() onConfirmed;

  EditShiftWidget({Key? key,
    required this.shift,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  _EditShiftWidgetState createState() => _EditShiftWidgetState();
}

class _EditShiftWidgetState extends ConsumerState<EditShiftWidget>
    with SingleTickerProviderStateMixin {
  Color backgroundColor = Colors.transparent;
  IconData? iconData;
  String initialStartTime = "";
  String initialEndTime = "";
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    initialStartTime = widget.shift!.actualStartTime.isNotEmpty ? widget.shift!.actualStartTime : widget.shift!.startTime;
    initialEndTime = widget.shift!.actualEndTime.isNotEmpty ? widget.shift!.actualEndTime : widget.shift!.endTime;
  }

  @override
  void dispose() {
    super.dispose();
  }

  static bool get isLightMode =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "${_getHebrewWeekday(widget.shift!.date)} ",
                style: TextStyle(
                  fontSize: AppFontSize.mediumTitle,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'todoFont',
                  color: AppColors.blackText,
                ),
              ),
              TextSpan(
                text: "| ${_getFormattedDate(widget.shift!.date)}",
                style: TextStyle(
                  fontSize: AppFontSize.mediumTitle,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'todoFont',
                  color: AppColors.blackText,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.dp,),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.0.dp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Text("כניסה", style: TextStyle(
                    fontSize: 11.dp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'arimo',
                    color: AppColors.blackText,
                  ),),
                  SizedBox(height: 8.dp,),
                  GestureDetector(
                    onTap: () async {
                      if(isEditing){
                        final initial = _parseTime(initialStartTime);

                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: initial,
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
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            final formatted = picked.format(context);
                            initialStartTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 8.dp),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(8.dp),
                      ),
                      child: Text(
                        initialStartTime,
                        style: TextStyle(
                          fontSize: 14.dp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'arimo',
                          color: AppColors.blackText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "יציאה",
                    style: TextStyle(
                      fontSize: 11.dp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'arimo',
                      color: AppColors.blackText,
                    ),
                  ),
                  SizedBox(height: 8.dp),
                  GestureDetector(
                    onTap: () async {
                      if(isEditing){
                        final initial = _parseTime(initialEndTime);
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: initial,
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
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            final formatted = picked.format(context);
                            initialEndTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 8.dp),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(8.dp),
                      ),
                      child: Text(
                        initialEndTime,
                        style: TextStyle(
                          fontSize: 14.dp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'arimo',
                          color: AppColors.blackText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time_filled_outlined, color: AppColors.mediumGreyText, size: 20.dp),
                  SizedBox(width: 8.dp,),
                  SizedBox(
                    width: 40.dp,
                    child: Text(initialStartTime.isNotEmpty && initialEndTime.isNotEmpty ?
                    _getTotalDuration(initialStartTime, initialEndTime)
                        : " — ",
                        style: TextStyle(
                          fontSize: 14.dp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'arimo',
                          color: AppColors.blackText,
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 32.dp,),
        if(isEditing && isBeforeDate(widget.shift!.date))
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.0.dp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () async {
                    bool response = await ShiftService.editShiftActualTimes(shiftId: widget.shift!.id,
                        actualStartTime: initialStartTime, actualEndTime: initialEndTime, editedBy: 'SHOPPER');
                    if(response){
                      String oldStartTime = widget.shift!.actualStartTime.isNotEmpty ? widget.shift!.actualStartTime : widget.shift!.startTime;
                      String oldEndTime = widget.shift!.actualEndTime.isNotEmpty ? widget.shift!.actualEndTime : widget.shift!.endTime;
                      if(oldStartTime != initialStartTime){
                        widget.shift?.startTimeEditedBy = 'SHOPPER';
                      }
                      if(oldEndTime != initialEndTime){
                        widget.shift?.endTimeEditedBy = 'SHOPPER';
                      }
                      widget.shift?.actualStartTime = initialStartTime;
                      widget.shift?.actualEndTime = initialEndTime;
                      final total = convertToDecimalHours(_getTotalDuration(initialStartTime, initialEndTime));
                      widget.shift?.actualDurationHours = total;
                      widget.onConfirmed!();
                      Navigator.of(context).pop();
                    }else{

                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.dp,
                      vertical: 12.dp,
                    ),
                    decoration: BoxDecoration(
                      color: hasChanged() ? AppColors.primeryColor : AppColors.backgroundGreyColor,
                      border: Border.all(
                        color: hasChanged() ? AppColors.primeryColor : AppColors.backgroundGreyColor,
                        width: 1.dp,
                      ),
                      borderRadius: BorderRadius.circular(10.dp),
                    ),
                    child: Center(
                      child: Text("שמירת שינויים", style: TextStyle(
                        fontSize: 12.dp, fontFamily: 'arimo', fontWeight: FontWeight.w800,
                        color: hasChanged() ? AppColors.white : AppColors.mediumGreyText,
                      ),),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.dp,),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      isEditing = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.dp,
                      vertical: 12.dp,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.superLightPurple,
                      border: Border.all(
                        color: AppColors.superLightPurple,
                        width: 1.dp,
                      ),
                      borderRadius: BorderRadius.circular(10.dp),
                    ),
                    child: Center(
                      child: Text("ביטול", style: TextStyle(
                        fontSize: 12.dp, fontFamily: 'arimo', fontWeight: FontWeight.w400,
                        color: AppColors.primeryColor,
                      ),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if(!isEditing && isBeforeDate(widget.shift!.date))
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0.dp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.dp,
                        vertical: 12.dp,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primeryColor,
                        border: Border.all(
                          color: AppColors.primeryColor,
                          width: 1.dp,
                        ),
                        borderRadius: BorderRadius.circular(10.dp),
                      ),
                      child: Center(
                        child: Text("אישור שעות", style: TextStyle(
                          fontSize: 12.dp, fontFamily: 'arimo', fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.dp,),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.dp,
                        vertical: 12.dp,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.superLightPurple,
                        border: Border.all(
                          color: AppColors.superLightPurple,
                          width: 1.dp,
                        ),
                        borderRadius: BorderRadius.circular(10.dp),
                      ),
                      child: Center(
                        child: Text("עריכת משמרת", style: TextStyle(
                          fontSize: 12.dp, fontFamily: 'arimo', fontWeight: FontWeight.w800,
                          color: AppColors.primeryColor,
                        ),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

  }

  String _getTotalDuration(String start, String end) {
    try {
      final startParts = start.split(":");
      final endParts = end.split(":");

      final startTime = Duration(
        hours: int.parse(startParts[0]),
        minutes: int.parse(startParts[1]),
      );
      final endTime = Duration(
        hours: int.parse(endParts[0]),
        minutes: int.parse(endParts[1]),
      );

      final diff = endTime - startTime;

      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');

      return "$hours:$minutes";
    } catch (e) {
      return "00:00";
    }
  }

  double convertToDecimalHours(String time) {
    try {
      final parts = time.split(":");
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      return hours + (minutes / 60);
    } catch (e) {
      return 0.0;
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }


  String _getFormattedDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  bool isBeforeDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return date.isBefore(DateTime.now()) || date.isAtSameMomentAs(DateTime.now());
  }

  String _getHebrewWeekday(String dateStr) {
    final date = DateTime.parse(dateStr);
    const hebrewDays = [
      "יום ראשון",
      "יום שני",
      "יום שלישי",
      "יום רביעי",
      "יום חמישי",
      "יום שישי",
      "יום שבת",
    ];
    return hebrewDays[date.weekday % 7]; // Sunday = 0
  }

  bool hasChanged() {
    String oldStartTime = widget.shift!.actualStartTime.isNotEmpty ? widget.shift!.actualStartTime : widget.shift!.startTime;
    String oldEndTime = widget.shift!.actualEndTime.isNotEmpty ? widget.shift!.actualEndTime : widget.shift!.endTime;
    if(oldStartTime != initialStartTime ||
        oldEndTime != initialEndTime){
      return true;
    }
    return false;
  }

}
