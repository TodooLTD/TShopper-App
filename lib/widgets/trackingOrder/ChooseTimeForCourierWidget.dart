import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tshopper_app/models/tshopper/PickupPoint.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import '../../../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';

class ChooseTimeForCourierWidget extends StatefulWidget {
  const ChooseTimeForCourierWidget({
    super.key,
    required this.onChooseNumber,
    required this.onChoosePickupPoint,
    required this.shoppingCenterId,
  });
  final Function(int) onChooseNumber;
  final Function(int) onChoosePickupPoint;
  final int shoppingCenterId;

  @override
  State<ChooseTimeForCourierWidget> createState() =>
      _ChooseTimeForCourierWidgetState();
}

class _ChooseTimeForCourierWidgetState extends State<ChooseTimeForCourierWidget> {
  int selectedNumber = -1;
  Color selectedColor = Colors.transparent;
  bool isItemFragile = false;
  String customNumber = '';
  final TextEditingController controller = TextEditingController();
  final picker = ImagePicker();
  bool isLoading = false;
  List<PickupPoint> pickupPoints = [];
  PickupPoint? selectedPickupPoint;
  @override
  void initState() {
    super.initState();
    fetchPickupPoints();
  }

  Future<void> fetchPickupPoints() async{
    setState(() {
      isLoading = true;
    });
    pickupPoints = await TShopperService.getPickupPoints(widget.shoppingCenterId);
    setState(() {
      isLoading = false;
    });
  }
  Widget buildNumberCircle(int number) {
    bool isSelected = number == selectedNumber;

    return GestureDetector(
      onTap: () {
        setState(() => selectedNumber = number);
        widget.onChooseNumber(selectedNumber);
      },
      child: Material(
        elevation: isLightMode ? 3 : 0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor:
          isSelected ? AppColors.superLightPurple : AppColors.popupBackgroundColor,
          radius: 12,
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 16,
              color: isLightMode ? AppColors.primeryColor : AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.67,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "לאן תרצי שהשליח יגיע?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16.dp,
              fontFamily: 'todofont',
              color: AppColors.blackText,
            ),
          ),
          // SizedBox(height: 10.dp),
          // Wrap(
          //   spacing:  5 ,
          //   runSpacing: 4.0,
          //   children: [10, 15, 20, 25, 30, 35, 40, 45, 50].map(buildNumberCircle).toList(),
          // ),
          // SizedBox(height: 16.dp),
          // GestureDetector(
          //   onTap: (){
          //     setState(() => selectedNumber = 0);
          //     widget.onChooseNumber(selectedNumber);
          //   },
          //   child: Container(
          //     height: 30.dp,
          //     decoration:  BoxDecoration(
          //         color: selectedNumber == 0 ? AppColors.primeryColor : AppColors.superLightPurple,
          //         shape: BoxShape.rectangle,
          //         borderRadius: BorderRadius.circular(
          //             8.dp)
          //     ),
          //     child:
          //     Center(
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 20.0.dp, vertical: 6.dp),
          //         child: Text("שיבוץ מיידי",
          //           style: TextStyle(fontSize: 12.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: selectedNumber == 0 ? AppColors.white : AppColors.primeryColor),),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 16.dp),
          _buildDropdown(MediaQuery.sizeOf(context).width * 0.8.dp, selectedPickupPoint, "בחר נקודת איסוף", pickupPoints, (value) {
            setState(() {
              setState(() => selectedPickupPoint = value);
              widget.onChoosePickupPoint(selectedPickupPoint!.id);
            });
          }),
        ],
      ),
    );
  }

  Widget _buildDropdown(double width, PickupPoint? value, String hint, List<PickupPoint> items, Function(PickupPoint?) onChanged) {
    return SizedBox(
      width: width,
      height: 50.dp,
      child: DropdownButtonFormField<PickupPoint>(
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
        elevation: isLightMode ? 2 : 0,
        menuMaxHeight: 250.dp,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item.fullAddress, style: _optionStyle(item.fullAddress)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  TextStyle _hintStyle() => TextStyle(color: AppColors.mediumGreyText, fontWeight: FontWeight.w500, fontSize: AppFontSize.fontSizeExtraSmall, fontFamily: 'arimo');
  TextStyle _optionStyle(String item) => TextStyle(color: item == "חסום" ? AppColors.redColor : item == "פתוח" ? AppColors.strongGreen : AppColors.blackText, fontWeight: FontWeight.w500, fontSize: AppFontSize.fontSizeExtraSmall, fontFamily: 'arimo');

}
