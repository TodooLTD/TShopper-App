import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tshopper_app/models/order/PaymentRequest.dart';
import 'package:tshopper_app/models/order/TShopperOrderStore.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/views/CollectingProductsScreen.dart';
import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';
import '../../models/managerRequest/ManagerRequest.dart';
import '../../models/order/TShopperOrder.dart';
import '../../sevices/ManagerRequestService.dart';
import '../popup/BottomPopup.dart';
import 'ChooseBagAndImagesWidget.dart';
import 'CustomElevatedButton.dart';

class StoreOrderCard extends StatefulWidget {
  final TShopperOrderStore store;
  final TShopperOrder order;
  bool isInProgress;
  final void Function()? setState;
  final void Function()? onRequestSent;

  StoreOrderCard({super.key,
    required this.store,
    required this.order,
    this.isInProgress = false,
    this.setState,
    this.onRequestSent,
  });

  @override
  _StoreOrderCardState createState() => _StoreOrderCardState();
}
class _StoreOrderCardState extends State<StoreOrderCard>
    with SingleTickerProviderStateMixin {

 bool isExpended = false;
 int selectedNumber = 0;
 double selectedPrice = 0;
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
 TextEditingController notesController = TextEditingController();

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
                Spacer(),
                if(widget.store.storeStatus == 'DONE')...[
                  Container(
                    decoration:  BoxDecoration(
                        color: colorMap[widget.order.stickerColor],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(
                            5.dp)
                    ),
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.dp, vertical: 6.dp),
                      child: Row(
                        children: [
                          Icon(Icons.shopping_bag, color: AppColors.white, size: 12.dp,),
                          SizedBox(width: 4.dp,),
                          Text(widget.store.bagsAmount.toString(),
                            style: TextStyle(fontSize: 14.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w900, color: AppColors.white),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.dp,),
                ],
                if(widget.store.storeStatus == 'CANCELLED')...[
                  Container(
                    decoration:  BoxDecoration(
                        color: AppColors.redColor.withValues(alpha: 0.1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(
                            5.dp)
                    ),
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.dp, vertical: 6.dp),
                      child: Text("בוטלה",
                        style: TextStyle(fontSize: 10.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.redColor),),
                    ),
                  ),
                  SizedBox(width: 8.dp,),
                ],
                if(widget.isInProgress && widget.store.storeStatus != 'CANCELLED' && widget.store.storeStatus != 'DONE' && widget.store.storeStatus != 'PAYMENT_DONE'
                    && widget.store.storeStatus != 'DONE')...[
                  GestureDetector(
                    onTap: () async {
                      bool response = await checkCancelStoreRequests();
                      if(!response){
                        showSendManagerRequestPopup(context);
                      }else{
                        showBottomPopup(
                          context: context,
                          message: "בקשה לביטול חנות נשלחה, לא ניתן לשלוח יותר מבקשה אחת",
                          imagePath:
                          "assets/images/warning_icon.png",
                        );
                      }

                    },
                    child: Container(
                      decoration:  BoxDecoration(
                          color: AppColors.redColor.withValues(alpha: 0.1),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(
                              5.dp)
                      ),
                      child:
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.dp, vertical: 6.dp),
                        child: Row(
                          children: [
                            Icon(Icons.cancel, size: 12.dp, color: AppColors.redColor,),
                            SizedBox(width: 4.dp,),
                            Text("ביטול חנות",
                              style: TextStyle(fontSize: 10.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.redColor),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.dp,),
                ],
                if(widget.isInProgress && (widget.store.paymentRequests != null && widget.store.paymentRequests!.isNotEmpty
                    && widget.store.paymentRequests!.first.status == 'PAID' && widget.store.storeStatus != 'DONE'))...[
                  SizedBox(height: 16.dp,),
                  GestureDetector(
                    onTap: (){
                      showStoreReadyAlertDialog(context);
                    },
                    child: Container(
                      height: 30.dp,
                      decoration:  BoxDecoration(
                          color: AppColors.primeryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(
                              8.dp)
                      ),
                      child:
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.0.dp, vertical: 6.dp),
                          child: Text("סיימתי לרכוש",
                            style: TextStyle(fontSize: 12.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.white),),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  if(widget.isInProgress && widget.store.isCollectionDone())...[
                    if(widget.store.paymentRequests!.isNotEmpty && !widget.isInProgress)...[
                      Text(" | ", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,
                          fontFamily: 'arimo', fontWeight: FontWeight.w500, color: AppColors.blackText),),
                      Text("${widget.store.paymentRequests?.first.productsPrice.toStringAsFixed(2)}₪", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,
                          fontFamily: 'arimo', fontWeight: FontWeight.w500, color: (widget.store.paymentRequests?.first.productsPrice != widget.store.paymentRequests?.first.forcePrice)
                              && widget.store.paymentRequests?.first.status == 'PAID' ? AppColors.mediumGreyText : AppColors.blackText),),
                      if((widget.store.paymentRequests?.first.productsPrice != widget.store.paymentRequests?.first.forcePrice)
                          && widget.store.paymentRequests?.first.status == 'PAID')
                        Text("  ${widget.store.paymentRequests?.first.forcePrice.toStringAsFixed(2)}₪", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,
                            fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.primeryColor),),
                    ],
                    if(widget.store.paymentRequests!.isNotEmpty && widget.isInProgress)...[
                      Text(" | ", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,
                          fontFamily: 'arimo', fontWeight: FontWeight.w500, color: AppColors.blackText),),
                      Text("${widget.store.getPrice().toStringAsFixed(2)}₪", style: TextStyle(fontSize: AppFontSize.fontSizeSmall,
                          fontFamily: 'arimo', fontWeight: FontWeight.w500, color: AppColors.blackText),),
                    ],
                    Spacer(),
                    Spacer(),
                    Spacer(),
                      if(widget.store.storeStatus == 'WAITING_FOR_PAYMENT')
                        Row(
                          children: [
                            Container(
                              decoration:  BoxDecoration(
                                  color: AppColors.orange.withValues(alpha: 0.1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(
                                      5.dp)
                              ),
                              child:
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0.dp, vertical: 6.dp),
                                child: Text("נשלחה בקשת תשלום",
                                  style: TextStyle(fontSize: 10.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.orange),),
                              ),
                            ),
                          ],
                        ),
                    if(widget.store.storeStatus == 'COLLECTION_DONE')...[
                      GestureDetector(
                        onTap: () async{
                          PaymentRequest paymentRequest = new PaymentRequest(
                              id: 0,
                              requestCreated: "",
                              paidAt: "",
                              rejectedAt: "",
                              cancelledAt: "",
                              reason: "",
                              verifyPrice: widget.store.getPrice(),
                              forcePrice: 0,
                              deliveryFeePrice: 0,
                              status: 'WAITING',
                              failedAt: '',
                              todoCommission: 0,
                              productsPrice: 0);
                          bool response = await TShopperService.addPaymentRequest(storeId: widget.store.id, paymentRequest: paymentRequest);
                          if(response){
                            showBottomPopup(
                              context: context,
                              message: "בקשת תשלום נשלחה בהצלחה!💜",
                              imagePath:
                              "assets/images/warning_icon.png",
                            );
                            setState(() {
                              widget.store.storeStatus = 'WAITING_FOR_PAYMENT';
                            });
                          }else{
                            showBottomPopup(
                              context: context,
                              message: "שגיאה בעת שליחת בקשת תשלום, נסה שוב",
                              imagePath:
                              "assets/images/warning_icon.png",
                            );
                          }
                        },
                        child: Container(
                          decoration:  BoxDecoration(
                              color: AppColors.primeryColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(
                                  5.dp)
                          ),
                          child:
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0.dp, vertical: 6.dp),
                            child: Text("שלח בקשת תשלום", style: TextStyle(fontSize: 10.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.whiteText),),
                          ),
                        ),
                      ),
                    ],
                  ],
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpended = !isExpended;
                      });
                    },
                    child: Container(
                      decoration:  BoxDecoration(
                        color: AppColors.primaryLightColor,
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
              children: List.generate(widget.store.products.length, (index) {
              final product = widget.store.products[index];

                    return Column(
                  children: [
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200.dp,
                                  child: Text(
                                    product.description,
                                    maxLines: 18,
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontFamily: 'Arimo',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.dp,
                                    ),
                                  ),
                                ),
                                if(widget.store.timeLine.doneCollecting!.isNotEmpty)
                                Text(
                                  "${product.collectQuantity!}/${product.quantity}",
                                  style: TextStyle(
                                    color: product.collectQuantity! != product.quantity ? AppColors.redColor : AppColors.blackText,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.dp,
                                  ),
                                ),
                                if(widget.store.timeLine.doneCollecting!.isEmpty)
                                Text(
                                  "x" +
                                      product.quantity.toString(),
                                  style: TextStyle(
                                    color: AppColors.blackText,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.dp,
                                  ),
                                ),
                                if (widget.store.timeLine.doneCollecting!.isNotEmpty)
                                  Text(
                                    (product.actualPrice! *
                                        product
                                            .collectQuantity!)
                                        .toStringAsFixed(2) +
                                        "₪",
                                    style: TextStyle(
                                      color: AppColors.primeryColortext,
                                      fontFamily: 'Arimo',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.dp,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 8.dp,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        backgroundColor:
                                        Colors.transparent,
                                        insetPadding:
                                        EdgeInsets.all(10),
                                        child: Stack(
                                          children: [
                                            // Image with zoom
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundColor,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                                child: PhotoView(
                                                  imageProvider:
                                                  CachedNetworkImageProvider(
                                                    product
                                                        .customerUploadedImage,
                                                  ),
                                                  loadingBuilder:
                                                      (context,
                                                      event) =>
                                                      Center(
                                                        child:
                                                        CupertinoActivityIndicator(
                                                          animating: true,
                                                          color: AppColors
                                                              .primeryColor,
                                                          radius: 15.dp,
                                                        ),
                                                      ),
                                                  errorBuilder: (context,
                                                      error,
                                                      stackTrace) =>
                                                  const Center(
                                                    child: Icon(
                                                        Icons.error,
                                                        color: Colors
                                                            .white),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // X button to close
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(
                                                        context)
                                                        .pop(),
                                                child: Container(
                                                  decoration:
                                                  const BoxDecoration(
                                                    color: AppColors
                                                        .iconLightGrey,
                                                    shape:
                                                    BoxShape.circle,
                                                  ),
                                                  padding:
                                                  const EdgeInsets
                                                      .all(8),
                                                  child: const Icon(
                                                      Icons.close,
                                                      color:
                                                      Colors.white,
                                                      size: 20),
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
                                      borderRadius:
                                      BorderRadius.circular(15.dp),
                                      child: Container(
                                        height: 65.dp,
                                        width: 65.dp,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteText,
                                          borderRadius:
                                          BorderRadius.circular(
                                              8.dp),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 0.0.dp, right: 0.dp),
                                          child: CachedNetworkImage(
                                            errorWidget:
                                                (context, url, error) =>
                                                Container(),
                                            fit: BoxFit.contain,
                                            imageUrl: product
                                                .customerUploadedImage,
                                            placeholder:
                                                (context, url) =>
                                                Center(
                                                  child:
                                                  CupertinoActivityIndicator(
                                                    animating: true,
                                                    color: AppColors
                                                        .primeryColor,
                                                    radius: 15.dp,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.dp,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        backgroundColor:
                                        Colors.transparent,
                                        insetPadding:
                                        EdgeInsets.all(10),
                                        child: Stack(
                                          children: [
                                            // Image with zoom
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundColor,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                                child: PhotoView(
                                                  imageProvider:
                                                  CachedNetworkImageProvider(
                                                    product
                                                        .shopperUploadedImage!,
                                                  ),
                                                  loadingBuilder:
                                                      (context,
                                                      event) =>
                                                      Center(
                                                        child:
                                                        CupertinoActivityIndicator(
                                                          animating: true,
                                                          color: AppColors
                                                              .primeryColor,
                                                          radius: 15.dp,
                                                        ),
                                                      ),
                                                  errorBuilder: (context,
                                                      error,
                                                      stackTrace) =>
                                                  const Center(
                                                    child: Icon(
                                                        Icons.error,
                                                        color: Colors
                                                            .white),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // X button to close
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(
                                                        context)
                                                        .pop(),
                                                child: Container(
                                                  decoration:
                                                  const BoxDecoration(
                                                    color: AppColors
                                                        .iconLightGrey,
                                                    shape:
                                                    BoxShape.circle,
                                                  ),
                                                  padding:
                                                  const EdgeInsets
                                                      .all(8),
                                                  child: const Icon(
                                                      Icons.close,
                                                      color:
                                                      Colors.white,
                                                      size: 20),
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
                                      borderRadius:
                                      BorderRadius.circular(15.dp),
                                      child: Container(
                                        height: 65.dp,
                                        width: 65.dp,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteText,
                                          borderRadius:
                                          BorderRadius.circular(
                                              8.dp),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 0.0.dp, right: 0.dp),
                                          child: CachedNetworkImage(
                                            errorWidget:
                                                (context, url, error) =>
                                                Container(),
                                            fit: BoxFit.contain,
                                            imageUrl: product
                                                .shopperUploadedImage!,
                                            placeholder:
                                                (context, url) =>
                                                Center(
                                                  child:
                                                  CupertinoActivityIndicator(
                                                    animating: true,
                                                    color: AppColors
                                                        .primeryColor,
                                                    radius: 15.dp,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.dp,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        backgroundColor:
                                        Colors.transparent,
                                        insetPadding:
                                        EdgeInsets.all(10),
                                        child: Stack(
                                          children: [
                                            // Image with zoom
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundColor,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                                child: PhotoView(
                                                  imageProvider:
                                                  CachedNetworkImageProvider(
                                                    product
                                                        .priceTagImage!,
                                                  ),
                                                  loadingBuilder:
                                                      (context,
                                                      event) =>
                                                      Center(
                                                        child:
                                                        CupertinoActivityIndicator(
                                                          animating: true,
                                                          color: AppColors
                                                              .primeryColor,
                                                          radius: 15.dp,
                                                        ),
                                                      ),
                                                  errorBuilder: (context,
                                                      error,
                                                      stackTrace) =>
                                                  const Center(
                                                    child: Icon(
                                                        Icons.error,
                                                        color: Colors
                                                            .white),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // X button to close
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(
                                                        context)
                                                        .pop(),
                                                child: Container(
                                                  decoration:
                                                  const BoxDecoration(
                                                    color: AppColors
                                                        .iconLightGrey,
                                                    shape:
                                                    BoxShape.circle,
                                                  ),
                                                  padding:
                                                  const EdgeInsets
                                                      .all(8),
                                                  child: const Icon(
                                                      Icons.close,
                                                      color:
                                                      Colors.white,
                                                      size: 20),
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
                                      borderRadius:
                                      BorderRadius.circular(15.dp),
                                      child: Container(
                                        height: 65.dp,
                                        width: 65.dp,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteText,
                                          borderRadius:
                                          BorderRadius.circular(
                                              8.dp),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 0.0.dp, right: 0.dp),
                                          child: CachedNetworkImage(
                                            errorWidget:
                                                (context, url, error) =>
                                                Container(),
                                            fit: BoxFit.contain,
                                            imageUrl:
                                            product.priceTagImage!,
                                            placeholder:
                                                (context, url) =>
                                                Center(
                                                  child:
                                                  CupertinoActivityIndicator(
                                                    animating: true,
                                                    color: AppColors
                                                        .primeryColor,
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
                            SizedBox(
                              height: 8.dp,
                            ),
                            if (product.shopperNotes != "" &&
                                product.shopperNotes != null) ...[
                              SizedBox(
                                height: 8.dp,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/warning_icon.png",
                                    width: 16.dp,
                                    height: 16.dp,
                                  ),
                                  SizedBox(
                                    width: 8.dp,

                                  ),
                                  // Text("הערת שופר:", style: TextStyle(
                                  //     color: AppColors.blackText,
                                  //     fontSize: AppFontSize.fontSizeSmall,
                                  //     fontWeight: FontWeight.w800
                                  // ),)
                                  SizedBox(
                                    width: 74.w,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal: 10),
                                      child: Text(
                                        product.shopperNotes ?? "",
                                        style: TextStyle(
                                            color: AppColors.darkGrey,
                                            fontSize: AppFontSize
                                                .fontSizeExtraSmall,
                                            fontFamily: 'arimo'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                          if (index != widget.store.products.length - 1)
                        Divider(
                        color: AppColors.borderColor,
                        thickness: 1,
                        ),
                  ],
                );})
                                ),
              if (widget.store.customerNotes != "" &&
                  widget.store.customerNotes != null) ...[
                SizedBox(
                  height: 8.dp,
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/warning_icon.png",
                      width: 16.dp,
                      height: 16.dp,
                    ),
                    SizedBox(
                      width: 8.dp,

                    ),
                    SizedBox(
                      width: 74.w,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 10),
                        child: Text(
                          widget.store.customerNotes,
                          style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: AppFontSize
                                  .fontSizeExtraSmall,
                              fontFamily: 'arimo'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if(widget.isInProgress && (widget.store.storeStatus == 'ON_HOLD' || widget.store.storeStatus == 'IN_COLLECTION' || widget.store.storeStatus == 'COLLECTION_DONE'
              || widget.store.storeStatus == 'WAITING_FOR_PAYMENT'))...[
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

            ],
          ],
        ),
      ),
    );
  }

 void showStoreReadyAlertDialog(BuildContext context) {
   selectedNumber = 0;
   selectedPrice = 0;
   showDialog(
     context: context,
     barrierDismissible: true,
     builder: (BuildContext context) {
       return AlertDialog(
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(15.dp))),
         backgroundColor: AppColors.backgroundColor,
         elevation: 0,
         content: SizedBox(
           width: MediaQuery.of(context).size.width * 0.9,
           child: SingleChildScrollView(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   mainAxisSize: MainAxisSize.max,
                   children: <Widget>[
                     ChooseBagAndImagesWidget(
                       order: widget.order,
                       store: widget.store,
                       isSmall: true,
                       onChooseNumber: (newValue) => selectedNumber = newValue,
                       onChooseInvoiceImageUrls: (newValue) => invoiceImageUrls = newValue,
                       onChooseExchangeReceipt: (newValue) => exchangeReceipt = newValue,
                       onChooseBagImageUrls: (newValue) => bagImageUrls = newValue,
                       onChooseColor: (newValue) => selectedColor = newValue,
                       onChoosePrice: (newValue) => selectedPrice = newValue,
                     )
                   ],
                 ),
               ],
             ),
           ),
         ),
         actions: <Widget>[
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             mainAxisSize: MainAxisSize.max,
             children: [
               Expanded(
                 flex: 1,
                 child: Padding(
                   padding:  EdgeInsets.only(left: 4.0.dp),
                   child: TextButton(
                     onPressed: () async {
                       if(widget.order.stickerColor != ""){
                         selectedColor = widget.order.stickerColor;
                       }
                       if (selectedNumber == 0 || invoiceImageUrls.isEmpty || exchangeReceipt.isEmpty || bagImageUrls.isEmpty
                       || selectedColor.isEmpty || selectedPrice == 0) {
                         showBottomPopup(
                           context: context,
                           message: "יש למלא את כל הפרטים",
                           imagePath:
                           "assets/images/warning_icon.png",
                         );
                       } else {
                         if(selectedPrice > widget.store.getPrice()){
                           showBottomPopup(
                             context: context,
                             message: "מחיר ששולם לא יכול להיות גדול ממחיר המוצרים לאחר ליקוט",
                             imagePath:
                             "assets/images/warning_icon.png",
                           );
                         }else{
                           bool response = await TShopperService.updateReady(
                               storeId: widget.store.id, bagsAmount: selectedNumber, selectedColor: selectedColor,
                               invoiceImageUrls: invoiceImageUrls, bagImageUrls: bagImageUrls, exchangeReceipt: exchangeReceipt);
                           bool response2 = await TShopperService.updateForcePrice(
                               requestId: widget.store.paymentRequests!.first.id, amount: selectedPrice);
                           if(response){
                             setState(() {
                               widget.store.invoiceImageUrls = invoiceImageUrls;
                               widget.store.bagImageUrls = bagImageUrls;
                               widget.store.exchangeReceipt = exchangeReceipt;
                               widget.store.bagsAmount = selectedNumber;
                               widget.store.storeStatus = 'DONE';
                               widget.order.stickerColor = selectedColor;
                             });
                             widget.setState?.call();
                             Navigator.pop(context);
                           }
                         }

                           // await OrderService.updateOrder(
                           //     orderId: widget.order.orderId,
                           //     userId: widget.order.userId,
                           //     businessId: widget.order.businessId,
                           //     actionType:
                           //     OrderTimelineStatus.preparationCompleted.name,
                           //     minutes: selectedNumber,
                           //     notes: selectedColor);
                           // Navigator.pop(context);
                       }
                     },
                     style: TextButton.styleFrom(
                       foregroundColor: AppColors.whiteText,
                       backgroundColor: AppColors.primeryColor,
                       padding: EdgeInsets.symmetric(
                           horizontal: 0.dp, vertical: 4.dp),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8.dp),
                       ),
                     ),
                     child: Text(
                       "אישור",
                       style: TextStyle(
                           fontSize: 13.dp,
                           fontFamily: 'arimo',
                           color: AppColors.white,
                           fontWeight: FontWeight.w800),
                     ),
                   ),
                 ),
               ),
               Expanded(
                 flex: 1,
                 child: Padding(
                   padding:  EdgeInsets.only(right: 4.0.dp),
                   child: TextButton(
                     onPressed: () {
                       Navigator.pop(context);
                     },
                     style: TextButton.styleFrom(
                       foregroundColor: AppColors.whiteText,
                       backgroundColor: AppColors.superLightPurple,
                       padding: EdgeInsets.symmetric(
                           horizontal: 0.dp, vertical: 4.dp),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8.dp),
                       ),
                     ),
                     child: Text(
                       "ביטול",
                       style: TextStyle(
                           fontSize: 13.dp,
                           fontFamily: 'arimo',
                           color: AppColors.primeryColor,
                           fontWeight: FontWeight.w500),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ],
       );
     },
   );
 }
 void showSendManagerRequestPopup(BuildContext context) {
   showDialog(
     context: context,
     barrierDismissible: true,
     builder: (BuildContext context) {
       return AlertDialog(
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(15.dp))),
         backgroundColor: AppColors.backgroundColor,
         elevation: 0,
         content: SizedBox(
           width: MediaQuery.of(context).size.width * 0.9,
           child: SingleChildScrollView(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 Text("רשמי את סיבת הביטול ופרטי על המקרה 💜🙏🏻", style: TextStyle(color: AppColors.blackText, fontSize: 16.dp, fontWeight: FontWeight.w800, fontFamily: 'todofont'),),
                 SizedBox(height: 16.dp,),
                 Container(
                   decoration: BoxDecoration(
                     border: Border.all(color: AppColors.borderColor),
                     borderRadius: BorderRadius.circular(8.dp),
                   ),
                   child: TextField(
                     controller: notesController,
                     autofocus: true,
                     maxLines: 6,
                     minLines: 1,
                     keyboardType: TextInputType.multiline,
                     textInputAction: TextInputAction.newline,
                     onEditingComplete: () {
                       if (context.mounted) {
                         FocusScope.of(context).unfocus();
                         Navigator.of(context).pop();
                       }
                     },
                     decoration: InputDecoration(
                       contentPadding: EdgeInsets.symmetric(
                         horizontal: 10.dp,
                         vertical: 10.dp,
                       ),
                       border: InputBorder.none,
                     ),
                     style: TextStyle(
                       fontFamily: 'arimo',
                       fontSize: AppFontSize.fontSizeRegular,
                       fontWeight: FontWeight.w400,
                       color: AppColors.blackText,
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
         actions: <Widget>[
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             mainAxisSize: MainAxisSize.max,
             children: [
               Expanded(
                 flex: 1,
                 child: Padding(
                   padding:  EdgeInsets.only(left: 4.0.dp),
                   child: TextButton(
                     onPressed: () async {
                       ManagerRequest request = ManagerRequest(
                           id: 0,
                           createdAt: "",
                           request: "ביטול חנות ${widget.store.storeName} מהזמנה מספר ${widget.order.orderNumber} ממרכז קניות ${widget.order.centerShoppingName}",
                           shopperNotes: notesController.text,
                           requestSubject: "cancelStore",
                           status: "",
                           response: "",
                           resolvedAt: "",
                           objectId: widget.store.id,
                           orderId: widget.order.orderId,
                           shopperName: "",
                           shoppingCenterId: widget.order.centerShoppingId);
                       ManagerRequest? response = await ManagerRequestService.addManagerRequest(request);
                       if(response != null){
                         showBottomPopup(
                           context: context,
                           message: "בקשת ביטול חנות נשלחה בהצלחה!💜",
                           imagePath:
                           "assets/images/warning_icon.png",
                         );
                         widget.onRequestSent?.call();
                         Navigator.pop(context);
                       }else{
                         showBottomPopup(
                           context: context,
                           message: "שגיאה בעת שליחת בקשת ביטול חנות, נסה שוב",
                           imagePath:
                           "assets/images/warning_icon.png",
                         );
                       }
                     },
                     style: TextButton.styleFrom(
                       foregroundColor: AppColors.whiteText,
                       backgroundColor: AppColors.primeryColor,
                       padding: EdgeInsets.symmetric(
                           horizontal: 0.dp, vertical: 4.dp),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8.dp),
                       ),
                     ),
                     child: Text(
                       "אישור",
                       style: TextStyle(
                           fontSize: 13.dp,
                           fontFamily: 'arimo',
                           color: AppColors.white,
                           fontWeight: FontWeight.w800),
                     ),
                   ),
                 ),
               ),
               Expanded(
                 flex: 1,
                 child: Padding(
                   padding:  EdgeInsets.only(right: 4.0.dp),
                   child: TextButton(
                     onPressed: () {
                       Navigator.pop(context);
                     },
                     style: TextButton.styleFrom(
                       foregroundColor: AppColors.whiteText,
                       backgroundColor: AppColors.superLightPurple,
                       padding: EdgeInsets.symmetric(
                           horizontal: 0.dp, vertical: 4.dp),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8.dp),
                       ),
                     ),
                     child: Text(
                       "ביטול",
                       style: TextStyle(
                           fontSize: 13.dp,
                           fontFamily: 'arimo',
                           color: AppColors.primeryColor,
                           fontWeight: FontWeight.w500),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ],
       );
     },
   );
 }

 Future<bool> checkCancelStoreRequests() async{

   List<ManagerRequest> requests = await ManagerRequestService.getManagerRequestsByOrder(widget.order.orderId);
   if(requests.where((request) => request.requestSubject == "cancelStore" && request.objectId == widget.store.id).toList().isNotEmpty){
     return true;
   }
   return false;
 }

}