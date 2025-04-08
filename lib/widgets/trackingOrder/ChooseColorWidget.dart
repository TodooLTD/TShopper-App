import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tshopper_app/models/tshopper/PickupPoint.dart';
import '../../../../constants/AppColors.dart';

class ChooseColorWidget extends StatefulWidget {
  const ChooseColorWidget({
    super.key,
    required this.onChooseColor,
  });
  final Function(String) onChooseColor;

  @override
  State<ChooseColorWidget> createState() =>
      _ChooseColorWidgetState();
}

class _ChooseColorWidgetState extends State<ChooseColorWidget> {
  int selectedNumber = -1;
  Color selectedColor = Colors.transparent;
  bool isItemFragile = false;
  String customNumber = '';
  final TextEditingController controller = TextEditingController();
  final picker = ImagePicker();
  bool isLoading = false;
  List<PickupPoint> pickupPoints = [];
  PickupPoint? selectedPickupPoint;

  Map<Color, String> colorNames = {
    Colors.blue: 'blue',
    Colors.green: 'green',
    Colors.teal: 'teal',
    Colors.tealAccent: 'tealAccent',
    Colors.orange[100]!: 'beige',
    Colors.orange: 'orange',
    Colors.yellow: 'yellow',
    Colors.red: 'red',
    Colors.pink: 'pink',
    Colors.pink[100]!: 'lightPink',
    Colors.brown: 'brown',
    Colors.black: 'black'
  };

  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.teal,
    Colors.tealAccent,
    Colors.orange[100]!,
    Colors.orange,
    Colors.yellow,
    Colors.red,
    Colors.pink,
    Colors.pink[100]!,
    Colors.brown,
    Colors.black,
  ];


  Widget buildColorCircle(Color color) {
    bool isSelected = color == selectedColor;
    return GestureDetector(
      onTap: () {
        setState(() => selectedColor = color);

        String colorName = colorNames[color] ?? 'unknown';
        widget.onChooseColor(colorName);
      },
      child: Material(
        elevation: 0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 14,
          child: isSelected
              ? Icon(
            Icons.check,
            color: Colors.white,
            size: 14,
          )
              : Container(),
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
          SizedBox(height: 10.dp),
          Wrap(
            spacing: 6,
            runSpacing: 4.0,
            children: colors.map((color) => buildColorCircle(color)).toList(),
          ),
        ],
      ),
    );
  }

}
