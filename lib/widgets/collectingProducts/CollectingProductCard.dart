import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tshopper_app/models/order/ProductTShopperOrder.dart';
import 'package:tshopper_app/widgets/trackingOrder/OrderItemContainer.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../sevices/ImageService.dart';
import 'EditablePriceField.dart';

class CollectingProductCard extends StatefulWidget {
  final ProductTShopperOrder product;
  final bool isCollecting;
  final VoidCallback? onChanged;

  CollectingProductCard({Key? key, required this.product, required this.isCollecting, this.onChanged,}) : super(key: key);

  @override
  _CollectingProductCardState createState() => _CollectingProductCardState();
}

class _CollectingProductCardState extends State<CollectingProductCard>
    with SingleTickerProviderStateMixin {
  Color backgroundColor = Colors.transparent;
  IconData? iconData;
  int? selectedQuantity;
  final picker = ImagePicker();
  bool showAddNotes = false;
  @override
  void initState() {
    super.initState();
      if(widget.isCollecting){
        selectedQuantity = widget.product.collectQuantity;
      }else{
        selectedQuantity = widget.product.quantity;
      }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> _pickImage(int index) async {
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     File imageFile = File(picked.path);
  //     String? url = await ImageService.uploadImageNoCompress(imageFile);
  //     setState(() {
  //       if(index == 0){
  //         widget.product.shopperUploadedImage = url!;
  //       }
  //       if(index == 1){
  //         widget.product.priceTagImage = url!;
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       FocusScope.of(context).unfocus();
       if(widget.product.shopperNotes.isEmpty){
         showAddNotes = false;
       }
      },
      child: OrderItemContainer(
        borderRadiusValue: 10.dp,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 50.dp,
                        height: 40.dp,
                        padding: EdgeInsets.symmetric(horizontal: 8.dp),
                        decoration: BoxDecoration(
                          color: AppColors.primeryColor,
                          borderRadius: BorderRadius.circular(10.dp),
                          border: Border.all(
                            color: AppColors.primeryColor,
                            width: 1.dp,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: AppColors.primeryColor, // Dropdown menu color
                          ),
                          child: DropdownButtonFormField<int>(
                            elevation: 1,
                            value: selectedQuantity,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.dp), // 🔥 Rounded border
                                borderSide: BorderSide.none, // Remove default border
                              ),
                              filled: true,
                              fillColor: AppColors.primeryColor,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.dp),
                            ),
                            items: List.generate(
                              widget.product.quantity + 1,
                                  (index) => DropdownMenuItem(
                                value: index,
                                child: Text(
                                  index.toString(),
                                  style: TextStyle(
                                    fontSize: AppFontSize.fontSizeSmall,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedQuantity = value;
                                widget.product.collectQuantity = value!;
                              });
                              widget.onChanged?.call();
                            },
                            dropdownColor: AppColors.primeryColor,
                            iconEnabledColor: AppColors.white,
                            borderRadius: BorderRadius.circular(10.dp),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.dp,),
                      if(selectedQuantity != null)...[
                        if((widget.product.quantity - selectedQuantity!) != 0)
                          Container(
                              width: 50.dp,
                              padding: EdgeInsets.symmetric(horizontal: 2.dp),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(8.dp),
                                border: Border.all(
                                  width: 1.dp,
                                  color: AppColors.redColor,
                                ),
                              ),
                              child: Center(child: Padding(
                                padding:  EdgeInsets.all(4.0.dp),
                                child: Text('חסר ${widget.product.quantity - selectedQuantity!}',
                                  style: TextStyle(
                                      fontSize: 12.dp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                      fontFamily: 'arimo'
                                  ),),
                              ))
                          ),
                      ]
                    ],
                  ),
                  SizedBox(width: 8.dp,),
                  SizedBox(
                    width: 170.dp,
                    child: Text(widget.product.description,
                    style: TextStyle(fontFamily: 'arimo', fontWeight: FontWeight.w800, fontSize: 14.dp, color: AppColors.blackText),
                    maxLines: 10,),
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                // Image with zoom
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: PhotoView(
                                      backgroundDecoration: BoxDecoration(
                                          color: AppColors.whiteText
                                      ),
                                      imageProvider: CachedNetworkImageProvider(
                                        widget.product.customerUploadedImage,
                                      ),
                                      loadingBuilder: (context, event) => Center(
                                        child: CupertinoActivityIndicator(
                                          animating: true,
                                          color: AppColors.primeryColor,
                                          radius: 15.dp,
                                        ),
                                      ),
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Icon(Icons.error, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),

                                // X button to close
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.iconLightGrey,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.dp),
                        child: Container(
                          height: 65.dp,
                          width: 65.dp,
                          decoration: BoxDecoration(
                            color: AppColors.whiteText,
                            borderRadius: BorderRadius.circular(8.dp),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0.dp, right: 0.dp),
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) => Container(),
                              fit: BoxFit.contain,
                              imageUrl: widget.product.customerUploadedImage,
                              placeholder: (context, url) => Center(
                                child: CupertinoActivityIndicator(
                                  animating: true,
                                  color: AppColors.primeryColor,
                                  radius: 15.dp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                  Text("תמונה של המוצר",
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
                      child: widget.product.shopperUploadedImage != null && widget.product.shopperUploadedImage.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.dp),
                        child: Image.network(widget.product.shopperUploadedImage, fit: BoxFit.cover),
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
                  Text("תמונה של תווית המחיר",
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
                      child: widget.product.priceTagImage != null && widget.product.priceTagImage.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.dp),
                        child: Image.network(widget.product.priceTagImage, fit: BoxFit.cover),
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
                  Text(
                    "מחיר המוצר",
                    style: TextStyle(
                      fontFamily: 'arimo',
                      fontWeight: FontWeight.w600,
                      fontSize: 13.dp,
                      color: AppColors.blackText,
                    ),
                  ),
                  EditablePriceField(
                    initialPrice: widget.product.actualPrice,
                    onPriceUpdated: (newPrice) {
                      widget.product.actualPrice = newPrice;
                      widget.onChanged?.call();
                    },
                  )
                ],
              ),
              Divider(
                color: AppColors.borderColor,
                thickness: 1,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: showAddNotes || widget.product.shopperNotes.isNotEmpty
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.dp),
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    maxLines: 5,
                    minLines: 1,
                    onChanged: (val) {
                      widget.product.shopperNotes = val;
                      widget.onChanged?.call();
                    },
                    controller: TextEditingController(text: widget.product.shopperNotes ?? ""),
                    decoration: InputDecoration(
                      hintText: "כתבי הערה",
                      hintStyle: TextStyle(
                        fontFamily: 'arimo',
                        fontSize: 13.dp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide: BorderSide(color: AppColors.backgroundColor, width: 0.dp),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide: BorderSide(color: AppColors.backgroundColor, width: 0.dp),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide: BorderSide(color: AppColors.backgroundColor, width: 0.dp),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.dp, vertical: 10.dp),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    setState(() {
                      showAddNotes = true;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.dp),
                    child: Text(
                      "+ הוספת הערה",
                      style: TextStyle(
                        fontFamily: 'arimo',
                        fontWeight: FontWeight.w600,
                        fontSize: 13.dp,
                        color: AppColors.primeryColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
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
          widget.product.shopperUploadedImage = url!;
        } else if (index == 1) {
          widget.product.priceTagImage = url!;
        }
      });
      widget.onChanged?.call();
    }
  }


  Color getBorderColor() {
    if (widget.product.collectQuantity == 0) {
      return AppColors.redColor;
    }
    if (widget.product.collectQuantity == widget.product.quantity) {
      return AppColors.strongGreen;
    }
    return AppColors.black;
  }
}
