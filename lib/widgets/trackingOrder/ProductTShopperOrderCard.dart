import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../models/order/ProductTShopperOrder.dart';

class ProductTShopperOrderCard extends StatefulWidget {
  final ProductTShopperOrder product;
  final bool collectionProducts;

  const ProductTShopperOrderCard({Key? key,
    required this.product,
    required this.collectionProducts
  }) : super(key: key);

  @override
  _ProductTShopperOrderCardState createState() => _ProductTShopperOrderCardState();
}

class _ProductTShopperOrderCardState extends State<ProductTShopperOrderCard>
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundGreyColor,
        borderRadius: BorderRadius.circular(5.dp),
      ),
      child: Card(
        elevation: 0,
        color: AppColors.backgroundColor,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.dp),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: 3.0),
                        child: Column(
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
                                    fontSize: AppFontSize.fontSizeRegular,
                                  ),
                                )),
                            if(widget.collectionProducts)...[
                              if ((widget.product.quantity -
                                  widget.product.collectQuantity!) !=
                                  0)...[
                                    SizedBox(height: 4.dp,),
                                Container(
                                    width: 30.dp,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.dp),
                                    decoration: BoxDecoration(
                                      color: AppColors.redColor,
                                      borderRadius:
                                      BorderRadius.circular(6.dp),
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
                                                fontSize: 8.dp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.white,
                                                fontFamily: 'arimo'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ))),

                              ],
                            ],
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.only(top: 5.0.dp, right: 4.dp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 190.dp,
                              child: Text(
                                widget.product.description,
                                maxLines: 10,
                                style: TextStyle(
                                    fontSize:13.dp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'arimo',
                                    color: AppColors.mediumGreyText,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            if(widget.collectionProducts)...[
                              if(widget.product.actualPrice != 0)...[
                                SizedBox(height: 6.dp,),
                                Text(
                                  widget.product.actualPrice.toStringAsFixed(2)+"₪",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize:13.dp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'arimo',
                                      color: AppColors.primeryColortext,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ],

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.dp),
                          child: SizedBox(
                            height: 55.dp,
                            width:55.dp,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0.dp,
                                  right: 0.dp),
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    Container(),
                                fit: BoxFit.contain,
                                imageUrl:
                                widget.product.customerUploadedImage
                                ,
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
                Divider(
                  color: AppColors.borderColor,
                  thickness: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
