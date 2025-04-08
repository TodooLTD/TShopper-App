import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';
import '../../models/order/ProductTShopperOrder.dart';

class MissingProductCard extends StatefulWidget {
  final ProductTShopperOrder product;

  const MissingProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _MissingProductCardState createState() => _MissingProductCardState();
}

class _MissingProductCardState extends State<MissingProductCard>
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.dp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.dp),
        color: AppColors.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(0.dp),
        child: Stack(
          children: [
            Card(
              elevation: 0,
              color: AppColors.backgroundColor,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.dp),
                side: BorderSide(
                  color: AppColors.borderColor,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.0.dp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.dp, vertical: 5.dp),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6.dp),
                                          color: AppColors.primeryColor,
                                        ),
                                        child: Text(
                                          widget.product.quantity.toString(),
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontFamily: 'Arimo',
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                AppFontSize.fontSizeRegular,
                                          ),
                                        )),
                                    SizedBox(
                                      height: 8.dp,
                                    ),
                                    if ((widget.product.quantity -
                                            widget.product.collectQuantity!) !=
                                        0)
                                      Container(
                                          width: 40.dp,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.dp),
                                          decoration: BoxDecoration(
                                            color: AppColors.redColor,
                                            borderRadius:
                                                BorderRadius.circular(8.dp),
                                            border: Border.all(
                                              width: 1.dp,
                                              color: AppColors.redColor,
                                            ),
                                          ),
                                          child: Center(
                                              child: Padding(
                                            padding: EdgeInsets.all(4.0.dp),
                                            child: Text(
                                              'חסר ${widget.product.quantity - widget.product.collectQuantity!}',
                                              style: TextStyle(
                                                  fontSize: 10.dp,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.white,
                                                  fontFamily: 'arimo'),
                                            ),
                                          ))),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 5.0.dp, right: 8.dp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 105.dp,
                                        child: Text(
                                          widget.product.description,
                                          maxLines: 10,
                                          style: TextStyle(
                                              fontSize: 12.dp,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'arimo',
                                              color: AppColors.mediumGreyText,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.dp),
                                    child: SizedBox(
                                      height: 40.dp,
                                      width: 40.dp,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 0.0.dp, right: 0.dp),
                                        child: CachedNetworkImage(
                                          errorWidget: (context, url, error) =>
                                              Container(),
                                          fit: BoxFit.contain,
                                          imageUrl: widget
                                              .product.customerUploadedImage,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
