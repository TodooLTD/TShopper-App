import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:photo_view/photo_view.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../models/order/ProductTShopperOrder.dart';

class AfterCollectionProductCard extends StatefulWidget {
  final ProductTShopperOrder product;
  final bool collectionProducts;

  const AfterCollectionProductCard({Key? key,
    required this.product,
    required this.collectionProducts
  }) : super(key: key);

  @override
  _AfterCollectionProductCardState createState() => _AfterCollectionProductCardState();
}

class _AfterCollectionProductCardState extends State<AfterCollectionProductCard>
    with SingleTickerProviderStateMixin {
  Color backgroundColor = Colors.transparent;
  IconData? iconData;
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200.dp,
                      child: Text(
                        widget.product.description,
                        maxLines: 18,
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.dp,
                        ),
                      ),
                    ),
                    Text(
                      "x" + widget.product.collectQuantity.toString(),
                      style: TextStyle(
                        color: AppColors.blackText,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.dp,
                      ),
                    ),
                    Text(
                      (widget.product.actualPrice! * widget.product.collectQuantity!).toStringAsFixed(2) + "₪",
                      style: TextStyle(
                        color: AppColors.primeryColortext,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.dp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.dp,),
                Row(
                  children: [
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
                    SizedBox(width: 8.dp,),
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
                                        widget.product.shopperUploadedImage!,
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
                                imageUrl: widget.product.shopperUploadedImage!,
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
                    SizedBox(width: 8.dp,),
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
                                        widget.product.priceTagImage!,
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
                                imageUrl: widget.product.priceTagImage!,
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
                SizedBox(height: 8.dp,),
                if (widget.product.shopperNotes != "" &&
                    widget.product.shopperNotes != null)...[
                  SizedBox(height: 8.dp,),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/warning_icon.png",
                        width: 16.dp,
                        height: 16.dp,
                      ),
                      SizedBox(width: 8.dp,),
                      Text("הערת שופר:", style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: AppFontSize.fontSizeSmall,
                          fontWeight: FontWeight.w800
                      ),)
                    ],
                  ),
                  SizedBox(
                    width: 100.w,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: Text(
                        widget.product.shopperNotes ?? "",
                        style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: AppFontSize.fontSizeExtraSmall,
                            fontFamily: 'arimo'
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Divider(
          color: AppColors.borderColor,
          thickness: 1,
        ),
      ],
    );
  }
}
