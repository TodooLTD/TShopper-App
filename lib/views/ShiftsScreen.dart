import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tshopper_app/views/ShiftSelectionPage.dart';
import 'package:tshopper_app/widgets/shift/ShopperShiftsWidget.dart';
import '../constants/AppColors.dart';
import '../constants/AppFontSize.dart';
import '../main.dart';
import '../widgets/overlayMenu/OverlayMenu.dart';
import '../widgets/shift/TimesheetWidget.dart';

class ShiftsScreen extends ConsumerStatefulWidget {

  ShiftsScreen({super.key});

  @override
  _ShiftsScreenState createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends ConsumerState<ShiftsScreen> with TickerProviderStateMixin {
  final OverlayMenu overlayMenu = OverlayMenu();
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    overlayMenu.init(context, this);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteText,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => overlayMenu.showOverlay(3),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.iconLightGrey,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    size: 22.dp,
                    Icons.menu,
                    color: AppColors.whiteText,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.whiteText,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.dp),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.dp),
                      child: Text(
                        "משמרות",
                        style: TextStyle(
                          fontSize: 24.dp,
                          fontFamily: 'todofont',
                          color: AppColors.blackText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.dp,
                  ),
                  Container(
                    height: 32.dp,
                    margin: EdgeInsets.symmetric(horizontal: 8.dp),
                    decoration: BoxDecoration(
                      color: isLightMode
                          ? AppColors.primaryLightColor
                          : AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(
                          AppFontSize.circularRadiusVal),
                    ),
                    child: Row(
                      children: [
                        _buildToggleButton(
                          "משמרות",
                          count: 0,
                          isSelected: selectedIndex == 0,
                          onSelect: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                        ),
                        _buildToggleButton(
                          "גיליון שעות",
                          count: 0,
                          isSelected: selectedIndex == 1,
                          onSelect: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.dp,
                  ),
                  if (selectedIndex == 0) ...[
                    Expanded(
                      child: ShopperShiftsWidget(
                        startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7)),
                        endDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7)).add(Duration(days: 13)),
                      ),
                    )
                  ],
                  if(selectedIndex == 1)...[
                    Expanded(
                      child: TimesheetWidget(startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
                          endDate: DateTime.now()),
                    )
                  ],
                ],
              ),
              if(_isWithinAllowedDaysAndTime() && selectedIndex == 0)
                Positioned(
                  bottom: 30.dp,
                  left: 10.dp,
                  right: 10.dp,
                  child: GestureDetector(
                    onTap: () async {
                      DateTime now = DateTime.now();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShiftSelectionPage(
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 45.dp,
                      width: MediaQuery.sizeOf(context).width * 0.92,
                      decoration: BoxDecoration(
                        color: AppColors.primeryColor,
                        borderRadius: BorderRadius.circular(10.dp),
                        border: Border.all(
                          color: AppColors.primeryColor,
                          width: 1.dp,
                        ),
                      ),
                      child: Center(child: Text("הגשת משמרות", style:
                      TextStyle(fontSize: 13.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w900, color: AppColors.white)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
    );
  }

  Widget _buildToggleButton(
      String title, {
        int count = 0,
        bool isSelected = false,
        void Function()? onSelect,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: onSelect,
        child: Card(
          color: isSelected ? AppColors.whiteText : AppColors.transparentPerm,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.dp),
          ),
          child: Container(
            margin: EdgeInsets.all(4.dp),
            decoration: isSelected
                ? BoxDecoration(
              color: AppColors.whiteText,
              borderRadius: BorderRadius.circular(10.dp),
            )
                : null,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSize.fontSizeExtraSmall,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? AppColors.blackText
                        : isLightMode
                        ? AppColors.oppositeBackgroundColor
                        : AppColors.blackText,
                    fontFamily: 'Arimo',
                  ),
                ),
                if (count != 0) ...[
                  SizedBox(
                    width: 8.dp,
                  ),
                  Text(
                    "( $count )",
                    style: TextStyle(
                      fontSize: AppFontSize.fontSizeExtraSmall,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? AppColors.blackText
                          : isLightMode
                          ? AppColors.oppositeBackgroundColor
                          : AppColors.blackText,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isWithinAllowedDaysAndTime() {
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final hour = now.hour;

    if (weekday == DateTime.sunday && hour < 9) return true; // Sunday until 09:00
    if (weekday >= DateTime.monday && weekday <= DateTime.wednesday) return true; // Monday–Wednesday all day
    return false;
  }

}
