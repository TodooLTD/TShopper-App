import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/AppColors.dart';
import '../../main.dart';
import '../../models/order/TShopperOrder.dart';
import '../../models/order/TShopperOrderStore.dart';
import '../../sevices/ImageService.dart';
import '../collectingProducts/EditablePriceField.dart';

class ChooseBagAndImagesWidget extends StatefulWidget {
  const ChooseBagAndImagesWidget({
    super.key,

    required this.onChooseNumber,
    required this.onChoosePrice,
    required this.onChooseInvoiceImageUrls,
    required this.onChooseBagImageUrls,
    required this.onChooseExchangeReceipt,
    required this.isSmall,
    required this.store,
    required this.order,
    required this.onChooseColor,
  });
  final TShopperOrderStore store;
  final TShopperOrder order;
  final Function(int) onChooseNumber;
  final Function(double) onChoosePrice;
  final Function(String) onChooseInvoiceImageUrls;
  final Function(String) onChooseBagImageUrls;
  final Function(String) onChooseExchangeReceipt;
  final Function(String) onChooseColor;

  final bool isSmall;

  @override
  State<ChooseBagAndImagesWidget> createState() =>
      _ChooseBagAndImagesWidgetState();
}

class _ChooseBagAndImagesWidgetState extends State<ChooseBagAndImagesWidget> {
  int selectedNumber = -1;
  double selectedPrice = 0;
  Color selectedColor = Colors.transparent;
  bool isItemFragile = false;
  String customNumber = '';
  final TextEditingController controller = TextEditingController();
  final picker = ImagePicker();

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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.67,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "בחר כמות שקיות ומלא את פרטי הרכישה מהחנות 🙏🏻💜",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16.dp,
                fontFamily: 'todofont',
                color: AppColors.blackText,
              ),
            ),
            SizedBox(height: 10.dp),
            Text(
              "כמה שקיות?",
              style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w600, fontSize: 13.dp, color: AppColors.blackText),),
            SizedBox(height: 10.dp),
            Wrap(
              spacing:  3 ,
              runSpacing: 4.0,
              children: List.generate(9, (index) => buildNumberCircle(index + 1)),
            ),
            if(widget.order.stickerColor == "")...[
              SizedBox(height: 10.dp),
              Text(
                "באיזה צבע השקיות?",
                style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w600, fontSize: 13.dp, color: AppColors.blackText),),
              SizedBox(height: 10.dp),
              Wrap(
                spacing: 6,
                runSpacing: 4.0,
                children: colors.map((color) => buildColorCircle(color)).toList(),
              ),
            ],
            SizedBox(height: 10.dp),
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("תמונה של הקבלה מהחנות",
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
                    child: widget.store.invoiceImageUrls != null && widget.store.invoiceImageUrls.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.dp),
                      child: Image.network(widget.store.invoiceImageUrls, fit: BoxFit.cover),
                    )
                        : Icon(Icons.add_a_photo, color: AppColors.mediumGreyText),
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("תמונה של הפתק החלפה מהחנות",
                  style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w600, fontSize: 13.dp, color: AppColors.blackText),),
                GestureDetector(
                  onTap: () => _pickImage(1),
                  child: Container(
                    width: 40.dp,
                    height: 40.dp,
                    decoration: BoxDecoration(
                      color: AppColors.whiteText,
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                    child: widget.store.exchangeReceipt != null && widget.store.exchangeReceipt.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.dp),
                      child: Image.network(widget.store.exchangeReceipt, fit: BoxFit.cover),
                    )
                        : Icon(Icons.add_a_photo, color: AppColors.mediumGreyText),
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("תמונה של השקיות",
                  style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w600, fontSize: 13.dp, color: AppColors.blackText),),
                GestureDetector(
                  onTap: () => _pickImage(2),
                  child: Container(
                    width: 40.dp,
                    height: 40.dp,
                    decoration: BoxDecoration(
                      color: AppColors.whiteText,
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                    child: widget.store.bagImageUrls != null && widget.store.bagImageUrls.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.dp),
                      child: Image.network(widget.store.bagImageUrls, fit: BoxFit.cover),
                    )
                        : Icon(Icons.add_a_photo, color: AppColors.mediumGreyText),
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("מחיר ששולם",
                  style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w600, fontSize: 13.dp, color: AppColors.blackText),),
                EditablePriceField(
                  initialPrice: 0.0,
                  onPriceUpdated: (newPrice) {
                    selectedPrice = newPrice;
                    widget.onChoosePrice?.call(newPrice);
                  },
                )
              ],
            ),
          ],
        ),
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
                      _getImage(index, ImageSource.gallery);
                    },
                  ),
                  _imageOption(
                    icon: Icons.camera_alt,
                    label: "מצלמה",
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(index, ImageSource.camera);
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

  Future<void> _getImage(int index, ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      File imageFile = File(picked.path);
      String? url = await ImageService.uploadImageNoCompress(imageFile);
      setState(() {
        if (index == 0) {
          widget.store.invoiceImageUrls = url!;
          widget.onChooseInvoiceImageUrls(url!);
        } else if (index == 1) {
          widget.store.exchangeReceipt = url!;
          widget.onChooseExchangeReceipt(url!);
        } else if (index == 2) {
          widget.store.bagImageUrls = url!;
          widget.onChooseBagImageUrls(url!);
        }
      });
      // widget.onChanged?.call();
    }
  }


}
