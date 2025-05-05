import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../constants/AppColors.dart';
import '../models/shift/ShopperShift.dart';
import '../models/tshopper/TShopper.dart';
import '../sevices/ShiftService.dart';
import '../widgets/appBars/CustomAppBarOnlyBack.dart';
import '../widgets/overlayMenu/OverlayMenu.dart';
import '../widgets/popup/BottomPopup.dart';

class ShiftSelectionPage extends StatefulWidget {
  @override
  _ShiftSelectionPageState createState() => _ShiftSelectionPageState();
}

class _ShiftSelectionPageState extends State<ShiftSelectionPage> with TickerProviderStateMixin{
  final OverlayMenu overlayMenu = OverlayMenu();

  bool isLoading = true;
  List<ShopperShift> fetchedShifts = [];
  late List<DateTime> weekDates;

  final List<String> days = [
    "יום ראשון",
    "יום שני",
    "יום שלישי",
    "יום רביעי",
    "יום חמישי",
    "יום שישי",
    "יום שבת"
  ];

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
    _fetchAssignedShifts();
    weekDates = _generateNextWeekDates();
  }

  Future<void> _fetchAssignedShifts() async {
    setState(() {
      isLoading = true;
    });

    final weekDates = _generateNextWeekDates();
    final from = weekDates.first;
    final to = weekDates.last;

    try {
      final shifts = await ShiftService.getAvailabilityShiftsByShopper(
        shoppingCenterId: TShopper.instance.currentShoppingCenterId,
        shopperId: TShopper.instance.uid,
        from: from,
        to: to,
      );

      fetchedShifts = List<ShopperShift>.from(shifts);

      // Clear previous data
      availability = List.generate(7, (day) {
        return [
          day == 6 ? null : false, // Saturday: no morning
          day == 5 ? null : false, // Friday: no evening
        ];
      });

      for (var shift in shifts) {
        final shiftDate = DateTime.parse(shift.date); // Assuming ISO "yyyy-MM-dd"
        final index = weekDates.indexWhere((d) =>
        d.year == shiftDate.year &&
            d.month == shiftDate.month &&
            d.day == shiftDate.day);

        if (index != -1) {
          if (shift.startTime.startsWith("10:")) {
            availability[index][0] = true; // Morning
          } else if (shift.startTime.startsWith("16:")) {
            availability[index][1] = true; // Evening
          }
        }
      }
    } catch (e) {
      print("Error fetching shifts: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  List<DateTime> _generateNextWeekDates() {
    final now = DateTime.now();

    // If today is Sunday, move to next Sunday
    final bool isTodaySunday = now.weekday == DateTime.sunday;

    final int daysUntilNextSunday = isTodaySunday
        ? 7
        : (DateTime.sunday - now.weekday + 7) % 7;

    final nextSunday = now.add(Duration(days: daysUntilNextSunday));

    return List.generate(7, (i) => nextSunday.add(Duration(days: i)));
  }

  // availability[day][shift] = true/false
  List<List<bool?>> availability = List.generate(7, (day) {
    return [
      day == 6 ? null : false, // Saturday: no morning
      day == 5 ? null : false, // Friday: no evening
    ];
  });

  void toggleShift(int dayIndex, int shiftIndex) {
    if (availability[dayIndex][shiftIndex] == null) return;
    setState(() {
      availability[dayIndex][shiftIndex] =
      !(availability[dayIndex][shiftIndex] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteText,
      appBar: CustomAppBarOnlyBack(
        title: '',
        backgroundColor: AppColors.whiteText,
        onBackTap: () => Navigator.pop(context),
        isButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("לו״ז הגשת משמרות", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26.dp, fontFamily: 'todofont', color: AppColors.blackText)),
            SizedBox(height: 8.dp,),
            // Header row
            Row(
              children: [
                SizedBox(width: 100),
                Expanded(
                  child: Center(
                    child: Text("בוקר", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.dp, fontFamily: 'arimo', color: AppColors.blackText)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text("ערב", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.dp, fontFamily: 'arimo', color: AppColors.blackText)),
                  ),
                ),
              ],
            ),
            Divider(),
            // Rows per day
            Expanded(
              child: ListView.separated(
                itemCount: days.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, i) {
                  return SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  days[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.dp,
                                    fontFamily: 'arimo',
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: 4.dp),
                                Text(
                                  "${weekDates[i].day.toString().padLeft(2, '0')}/${weekDates[i].month.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    fontSize: 12.dp,
                                    color: AppColors.mediumGreyText,
                                    fontFamily: 'arimo',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        for (int j = 0; j < 2; j++)
                          Expanded(
                            child: GestureDetector(
                              onTap: () => toggleShift(i, j),
                              child: availability[i][j] == null
                                  ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primeryColor.withOpacity(0.9),
                                      AppColors.primeryColor.withOpacity(0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  color: availability[i][j] != true ? AppColors.whiteText : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("שבת שלום", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.dp,
                                          fontFamily: 'arimo', color: AppColors.white),)
                                    ],
                                  ),
                                ),
                              )
                                  : Container(
                                height: 30.dp,
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  gradient: availability[i][j] == true
                                      ? LinearGradient(
                                    colors: [
                                      colorMap[TShopper.instance.color]!.withOpacity(0.9),
                                      colorMap[TShopper.instance.color]!.withOpacity(0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                      : null,
                                  color: availability[i][j] != true ? AppColors.whiteText : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        availability[i][j] == true
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: availability[i][j] == true
                                            ? colorMap[TShopper.instance.color]
                                            : AppColors.whiteText,
                                        size: 14.dp,
                                      ),
                                      SizedBox(width: 8.dp,),
                                      Text(TShopper.instance.firstName + " " + TShopper.instance.lastName, style: TextStyle(fontWeight:
                                      FontWeight.w900, fontSize: 12.dp,
                                          fontFamily: 'arimo', color: AppColors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.only(right: 16.0.dp, left: 16.0.dp, bottom: 30.dp),
        child: GestureDetector(
          onTap: _submitSelectedShifts,
          child: Container(
            height: 50.dp,
            decoration: BoxDecoration(
              color: AppColors.primeryColor,
              borderRadius: BorderRadius.circular(10.dp),
              border: Border.all(
                color: AppColors.primeryColor,
                width: 1.dp,
              ),
            ),
            child: Center(child: Text("הגש משמרות", style:
                  TextStyle(fontSize: 13.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.white)),
          ),
                ),
        ),
      ),
    );
  }

  Future<void> _submitSelectedShifts() async {
    final weekDates = _generateNextWeekDates();
    List<Map<String, dynamic>> shiftsToAdd = [];
    List<int> shiftIdsToDelete = [];

    // Use previously fetched shifts instead of refetching
    final previouslyAssignedShifts = fetchedShifts;

    bool isAlreadyAssigned(String date, String startTime) {
      return previouslyAssignedShifts.any((shift) =>
      shift.date == date && shift.startTime == startTime);
    }

    for (int day = 0; day < availability.length; day++) {
      final date = weekDates[day].toIso8601String().substring(0, 10);

      // Morning shift
      final bool? isMorning = availability[day][0];
      final bool wasMorning = isAlreadyAssigned(date, "10:00");

      if (isMorning == true && !wasMorning) {
        shiftsToAdd.add({
          "date": date,
          "startTime": "10:00",
          "endTime": "16:00",
          "status": "AVAILABILITY",
          "shoppingCenterId": TShopper.instance.currentShoppingCenterId,
        });
      } else if (isMorning == false && wasMorning) {
        final matched = previouslyAssignedShifts.firstWhere((shift) =>
        shift.date == date && shift.startTime == "10:00");
        shiftIdsToDelete.add(matched.id);
      }

      // Evening shift
      final bool? isEvening = availability[day][1];
      final bool wasEvening = isAlreadyAssigned(date, "16:00");

      if (isEvening == true && !wasEvening) {
        shiftsToAdd.add({
          "date": date,
          "startTime": "16:00",
          "endTime": "20:00",
          "status": "AVAILABILITY",
          "shoppingCenterId": TShopper.instance.currentShoppingCenterId,
        });
      } else if (isEvening == false && wasEvening) {
        final matched = previouslyAssignedShifts.firstWhere((shift) =>
        shift.date == date && shift.startTime == "16:00");
        shiftIdsToDelete.add(matched.id);
      }
    }

    bool success = true;

    if (shiftsToAdd.isNotEmpty) {
      success &= await ShiftService.submitAvailabilityShifts(
        shopperId: TShopper.instance.uid,
        shiftDtos: shiftsToAdd,
      );
    }

    if (shiftIdsToDelete.isNotEmpty) {
      success &= await ShiftService.deleteShiftsByIds(shiftIds: shiftIdsToDelete);
    }

    showBottomPopup(
      context: context,
      message: success ? "המשמרות נשלחו בהצלחה" : "שגיאה בשליחת משמרות, נסה שוב",
      imagePath: "assets/images/warning_icon.png",
    );

  }


}
