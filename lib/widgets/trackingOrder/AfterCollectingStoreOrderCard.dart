import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tshopper_app/models/order/PaymentRequest.dart';
import 'package:tshopper_app/models/order/TShopperOrderStore.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/views/CollectingProductsScreen.dart';
import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../models/order/TShopperOrder.dart';
import '../popup/BottomPopup.dart';
import 'AfterCollectionProductCard.dart';
import 'ChooseBagAndImagesWidget.dart';
import 'CustomElevatedButton.dart';
import 'ProductTShopperOrderCard.dart';

class AfterCollectionStoreOrderCard extends StatefulWidget {
  final TShopperOrderStore store;
  final TShopperOrder order;
  bool isInProgress;
  final void Function()? setState;

  AfterCollectionStoreOrderCard({super.key,
    required this.store,
    required this.order,
    this.isInProgress = false,
    this.setState,
  });

  @override
  _AfterCollectionStoreOrderCardState createState() => _AfterCollectionStoreOrderCardState();
}
class _AfterCollectionStoreOrderCardState extends State<AfterCollectionStoreOrderCard>
    with SingleTickerProviderStateMixin {

  bool isExpended = false;
  int selectedNumber = 0;
  String selectedColor = "";
  String invoiceImageUrls = "";
  String exchangeReceipt = "";
  String bagImageUrls = "";

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
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    widget.store.products.removeWhere((p) => p.collectQuantity == 0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.dp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.dp),
        color: AppColors.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(0.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.store.storeName,
                  style: TextStyle(fontSize: 15.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w900, color: AppColors.blackText),),
              ],
            ),
            Divider(
              color: AppColors.borderColor,
              thickness: 1,
            ),
            Row(
                children: [
                  Container(
                    decoration:  BoxDecoration(
                        color: AppColors.primeryColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(
                            5.dp)
                    ),
                    padding:  EdgeInsets.symmetric(horizontal :8.dp, vertical:3.dp ),
                    child:
                    Text("${widget.store.getAmount()}", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,
                        fontFamily: 'arimo', fontWeight: FontWeight.w900, color: AppColors.white),),
                  ),
                  Text("  מוצרים", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,  fontFamily: 'arimo', fontWeight: FontWeight.w500, color: AppColors.blackText),),
                  Text(" | ${widget.store.getPrice().toStringAsFixed(2)}₪", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,  fontFamily: 'arimo', fontWeight: FontWeight.w500, color: AppColors.blackText),),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpended = !isExpended;
                      });
                    },
                    child: Container(
                      decoration:  BoxDecoration(
                        color: isLightMode ? AppColors.primaryLightColor : AppColors.black,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        size: 22.dp,
                        isExpended ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.oppositeBackgroundColor,
                      ),
                    ),
                  ),
                ]),
            if(isExpended)...[
              Column(
                children: widget.store.products
                    .map((product) =>
                    AfterCollectionProductCard(product: product, collectionProducts: widget.order.collectionProducts,))
                    .toList(),

              ),
              if (widget.store.customerNotes != "" &&
                  widget.store.customerNotes != null)...[
                SizedBox(height: 8.dp,),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/warning_icon.png",
                      width: 16.dp,
                      height: 16.dp,
                    ),
                    SizedBox(width: 8.dp,),
                    Text("הערת לקוח:", style: TextStyle(
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
                        vertical: 8.0, horizontal: 10),
                    child: Text(
                      widget.store.customerNotes,
                      style: TextStyle(
                          color: isLightMode ? AppColors.darkGrey : AppColors.white,
                          fontSize: AppFontSize.fontSizeExtraSmall,
                          fontFamily: 'arimo'
                      ),
                    ),
                  ),
                ),
              ],
              if(widget.isInProgress && (widget.store.storeStatus == 'ON_HOLD' || widget.store.storeStatus == 'IN_COLLECTION' || widget.store.storeStatus == 'COLLECTION_DONE'))...[
                SizedBox(height: 16.dp,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 40.dp,
                  child: CustomElevatedButton(
                      fontSize: 13.dp,
                      backgroundColor: widget.store.storeStatus == 'ON_HOLD' || widget.store.storeStatus == 'IN_COLLECTION' ? AppColors.primeryColor : AppColors.primeryLightColor,
                      titleColor: widget.store.storeStatus == 'ON_HOLD' || widget.store.storeStatus == 'IN_COLLECTION' ? AppColors.white : AppColors.primeryColor,
                      title: widget.store.storeStatus == 'ON_HOLD' || widget.store.storeStatus == 'IN_COLLECTION' ? "ליקוט מוצרים  |  ${widget.store.storeName}" :
                      "עריכת ליקוט  |  ${widget.store.storeName}",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CollectingProductsScreen(order: widget.order, store: widget.store, isStoreCollected:  widget.store.storeStatus != 'ON_HOLD' && widget.store.storeStatus != 'IN_COLLECTION',)));
                      }),
                ),
              ],
              if(widget.isInProgress && (widget.store.paymentRequests != null && widget.store.paymentRequests!.isNotEmpty
                  && widget.store.paymentRequests!.first.status == 'PAID' && widget.store.storeStatus != 'DONE'))...[
                SizedBox(height: 16.dp,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 40.dp,
                  child: CustomElevatedButton(
                      fontSize: 13.dp,

                      backgroundColor: AppColors.primeryColor,
                      titleColor: AppColors.white,
                      title: "חנות מוכנה",
                      onPressed: () {
                      }),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

}