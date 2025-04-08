import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/models/order/deliveryMission/DeliveryMission.dart';
import '../../../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../sevices/ImageService.dart';

class UpdateCourierPickedUpWidget extends StatefulWidget {
  UpdateCourierPickedUpWidget({
    super.key,

    required this.onChooseNumber,
    required this.onChoosePickupBagsImageUrls,
    required this.order,
    required this.mission,
  });
  final Function(int) onChooseNumber;
  final Function(String) onChoosePickupBagsImageUrls;
  final TShopperOrder order;
  final DeliveryMission mission;

  @override
  State<UpdateCourierPickedUpWidget> createState() =>
      _UpdateCourierPickedUpWidgetState();
}

class _UpdateCourierPickedUpWidgetState extends State<UpdateCourierPickedUpWidget> {
  int selectedNumber = -1;
  final TextEditingController controller = TextEditingController();
  final picker = ImagePicker();

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
    if(widget.order.deliveryMissions.length > 1 && widget.order.isTheLastCourierPick()){
      widget.onChooseNumber(widget.order.getBagsLeft());
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.67,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "יש לעלות תמונה של השקיות בזמן המסירה לשליח 🙏🏻💜",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16.dp,
              fontFamily: 'todofont',
              color: AppColors.blackText,
            ),
          ),
          SizedBox(height: 10.dp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("תמונה של השקיות",
                style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w600, fontSize: 13.dp, color: AppColors.blackText),),
              GestureDetector(
                onTap: () => _pickImage(0),
                child: Container(
                  width: 40.dp,
                  height: 40.dp,
                  decoration: BoxDecoration(
                    color: AppColors.whiteText,
                    borderRadius: BorderRadius.circular(8.dp),
                  ),
                  child: widget.mission.pickupBagsImage != null && widget.mission.pickupBagsImage.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.dp),
                    child: Image.network(widget.mission.pickupBagsImage, fit: BoxFit.cover),
                  )
                      : Icon(Icons.add_a_photo, color: AppColors.mediumGreyText),
                ),
              ),
            ],
          ),
          if(widget.order.deliveryMissions.length > 1 && !widget.order.isTheLastCourierPick())...[
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
            Text(
              "כמה שקיות השליח אוסף?",
              style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w600, fontSize: 13.dp, color: AppColors.blackText),),
            SizedBox(height: 10.dp),
            Wrap(
              spacing:  5 ,
              runSpacing: 4.0,
              children: List.generate(widget.order.getBagsLeft(), (index) => buildNumberCircle(index + 1)),
            ),
            SizedBox(height: 10.dp),
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
          ],
          if(widget.order.deliveryMissions.length > 1 && widget.order.isTheLastCourierPick())...[
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
            SizedBox(height: 10.dp,),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "עלייך לספק לשליח",
                    style: TextStyle(
                        fontSize:
                        13.dp,
                        color: AppColors.blackText,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Arimo'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 5.dp,
                  ),
                  Text(
                    widget.order.getBagsLeft().toString(),
                    style: TextStyle(
                        fontSize: 20.dp,
                        color: colorMap[widget.order.stickerColor],
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Arimo'),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    " שקיות בצבע ",
                    style: TextStyle(
                        fontSize:
                        13.dp,
                        color: AppColors.blackText,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Arimo'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 5.dp,
                  ),
                  Material(
                    elevation: 2,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor:colorMap[widget.order.stickerColor],
                      radius: 8.dp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.dp,),
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
          ],
        ],
      ),
    );
  }


  Future<void> _pickImage(int index) async {
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.dp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageOption(
                    icon: Icons.photo_library,
                    label: "גלריה",
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.gallery);
                    },
                  ),
                  _imageOption(
                    icon: Icons.camera_alt,
                    label: "מצלמה",
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.dp),
            ],
          ),
        );
      },
    );
  }

  Widget _imageOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primeryColor.withOpacity(0.1),
            child: Icon(icon, color: AppColors.primeryColor, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.w600, color: AppColors.blackText)),
        ],
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      File imageFile = File(picked.path);
      String? url = await ImageService.uploadImageNoCompress(imageFile);
      setState(() {
        widget.mission.pickupBagsImage = url!;
        widget.onChoosePickupBagsImageUrls(url!);
      });
      // widget.onChanged?.call();
    }
  }


}
