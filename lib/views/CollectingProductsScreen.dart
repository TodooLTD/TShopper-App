import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tshopper_app/models/order/ProductTShopperOrder.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import '../constants/AppColors.dart';
import '../constants/AppFontSize.dart';
import '../main.dart';
import '../models/conversation/Conversation.dart';
import '../models/order/TShopperOrderStore.dart';
import '../providers/conversationProvider.dart';
import '../sevices/ConversationService.dart';
import '../widgets/appBars/CustomAppBarOnlyBack.dart';
import '../widgets/collectingProducts/CollectingProductCard.dart';
import '../widgets/collectingProducts/MissingProductCard.dart';
import '../widgets/popup/BottomPopup.dart';
import 'ConversationScreen.dart';

class CollectingProductsScreen extends ConsumerStatefulWidget {
  TShopperOrder order;
  TShopperOrderStore store;
  bool isStoreCollected;

  CollectingProductsScreen({
    required this.order,
    required this.store,
    required this.isStoreCollected,
    Key? key,
  }) : super(key: key);

  @override
  _CollectingProductsScreenState createState() =>
      _CollectingProductsScreenState();
}

class _CollectingProductsScreenState
    extends ConsumerState<CollectingProductsScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  String storeLocationDescription = "";
  bool showChooseCouriersNumber = false;
  int selectedNumber = 0;

  @override
  void initState() {
    super.initState();
    fetchStoreLocationDescription();
    for (var product in widget.store.products) {
      if (!widget.order.collectionProducts) {
        product.collectQuantity = product.quantity;
      }
    }
    showChooseCouriersNumber = widget.store.numberOfCouriers > 0;
    if(showChooseCouriersNumber){
      selectedNumber = widget.store.numberOfCouriers;
    }
  }

  Future<void> fetchStoreLocationDescription() async {
    setState(() {
      isLoading = true;
    });
    if(widget.store.storeStatus == 'ON_HOLD'){
      bool response = await TShopperService.updateStoreStatus(
          storeId: widget.store.id, status: 'IN_COLLECTION');
      if (response) widget.store.storeStatus = 'IN_COLLECTION';
    }
    storeLocationDescription =
        await TShopperService.getStoreLocationDescription(widget.store.storeId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteText,
      appBar: CustomAppBarOnlyBack(
        title: '',
        backgroundColor: AppColors.whiteText,
        onBackTap: () => Navigator.pop(context),
        isButton: true,
      ),
      body: isLoading
          ? Container(
              color: AppColors.whiteText,
              child: Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  color: AppColors.blackText,
                  radius: 15.dp,
                ),
              ),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10.0.dp, left: 6.dp, right: 16.dp),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "ליקוט מוצרים | #${widget.order.orderNumber}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 26.dp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blackText,
                            fontFamily: 'todofont',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.dp,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.store.storeName,
                          style: TextStyle(
                              fontSize: 16.dp,
                              fontFamily: 'arimo',
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackText),
                        ),
                      ),
                      if (storeLocationDescription.isNotEmpty) ...[
                        SizedBox(
                          height: 8.dp,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              Icon(
                                Icons.info,
                                size: 16.dp,
                                color: AppColors.primeryColortext,
                              ),
                              SizedBox(
                                width: 8.dp,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.sizeOf(context).width * 0.75.dp,
                                child: Text(
                                  storeLocationDescription,
                                  style: TextStyle(
                                      fontSize: 12.dp,
                                      fontFamily: 'arimo',
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blackText),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(
                        height: 16.dp,
                      ),
                      Column(
                        children: widget.store.products
                            .map((product) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.0.dp),
                                  child: CollectingProductCard(
                                    product: product,
                                    isCollecting:
                                        widget.order.collectionProducts,
                                    onChanged: () {
                                      setState(() {});
                                    },
                                  ),
                                ))
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
                                fontSize: 14.dp,
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
                      if (widget.order.getIsLastCollection() || widget.store.numberOfCouriers > 0) ...[
                        SizedBox(
                          height: 8.dp,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("האם זוהי הזמנה גדולה?",
                                    style: TextStyle(
                                        fontSize: 14.dp,
                                        fontFamily: 'arimo',
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.blackText)),
                                SizedBox(
                                  height: 2.dp,
                                ),
                                Text(
                                    "הזמנה גדולה הינה הזמנה שמצריכה יותר משליח אחד.",
                                    style: TextStyle(
                                        fontSize: 12.dp,
                                        fontFamily: 'arimo',
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.mediumGreyText)),
                              ],
                            ),
                            CupertinoSwitch(
                              value: showChooseCouriersNumber,
                              activeColor: AppColors.primeryColor,
                              trackColor: AppColors.backgroundGreyColor,
                              onChanged: (value) {
                                setState(() {
                                  showChooseCouriersNumber = value;
                                  selectedNumber = 0;
                                });
                              },
                            )
                          ],
                        ),
                        if (showChooseCouriersNumber) ...[
                          SizedBox(height: 12.dp),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              int number = index + 2;
                              bool isSelected = selectedNumber == number;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedNumber = number;
                                  });
                                },
                                child: Container(
                                  width: 38.dp,
                                  height: 38.dp,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.superLightPurple
                                        : AppColors.whiteText,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.superLightPurple
                                          : AppColors.whiteText,
                                      width: 1.dp,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$number",
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primeryColor
                                            : AppColors.blackText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.dp,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ]
                      ],
                      SizedBox(height: 80.dp),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.dp, right: 16.dp, bottom: 30.dp),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: isCollectionDone()
                    ? () async {
                  List<ProductTShopperOrder> missingProducts = _getMissingProducts();
                  if (missingProducts.isNotEmpty) {
                    _showMissingProductsDialog(missingProducts);
                  } else {
                    bool response = await updateCollection();
                    if (response) {
                      widget.store.storeStatus = 'COLLECTION_DONE';
                      int counter = widget.order.orderStores
                          .where((store) => store.storeStatus == 'IN_COLLECTION' || store.storeStatus == 'ON_HOLD')
                          .length;

                      if (counter == 0) {
                        widget.order.orderStatus = 'WAITING_FOR_PAYMENT_REQUEST';
                      }

                      showBottomPopup(
                        context: context,
                        message: "ליקוט התעדכן בהצלחה!💜",
                        imagePath: "assets/images/warning_icon.png",
                      );
                      Navigator.pop(context);
                    } else {
                      showBottomPopup(
                        context: context,
                        message: "שגיאה בעדכון ליקוט, נסה שוב",
                        imagePath: "assets/images/warning_icon.png",
                      );
                    }
                  }
                }
                    : null,
                child: Container(
                  height: 50.dp,
                  decoration: BoxDecoration(
                    color: isCollectionDone()
                        ? AppColors.primeryColor
                        : AppColors.mediumGreyText,
                    borderRadius: BorderRadius.circular(10.dp),
                    border: Border.all(
                      color: isCollectionDone()
                          ? AppColors.primeryColor
                          : AppColors.mediumGreyText,
                      width: 1.dp,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "סיימתי ללקט👏🏻",
                      style: TextStyle(
                        fontSize: 13.dp,
                        fontFamily: 'arimo',
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.dp),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async{
                  ref.read(conversationProvider).currentConversation = null;
                  Conversation? conversation = await ConversationService.getConversationByOrderId(widget.order.orderId);
                  if(conversation != null && conversation.status == 'OPEN'){
                    ref.read(conversationProvider).currentConversation = conversation;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConversationScreen(),
                      ),
                    );
                  }else{
                    showBottomPopup(
                      duration: const Duration(
                          seconds: 2),
                      context: context,
                      message: "צ׳אט לא זמין בשלב זה של ההזמנה",
                      imagePath: "assets/images/warning_icon.png",
                    );
                  }
                },
                child: Container(
                  height: 50.dp,
                  decoration: BoxDecoration(
                    color: AppColors.primeryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.dp),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/iconChat.png",
                      height: 38.dp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProductTShopperOrder> _getMissingProducts() {
    List<ProductTShopperOrder> missingProducts = [];
    for (var product in widget.store.products) {
      if (product.collectQuantity < product.quantity) {
        missingProducts.add(product);
      }
    }
    return missingProducts;
  }

  void _showMissingProductsDialog(List<ProductTShopperOrder> missingProducts) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.dp)),
          ),
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: Column(
            children: [
              Text(
                'האם הנך בטוח שמוצרים אלו חסרים במלאי?',
                style: TextStyle(
                    fontSize: 20.dp,
                    fontFamily: 'todofont',
                    color: AppColors.blackText,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: missingProducts.length > 1 ? 300.dp : 100.dp,
            child: ListView.builder(
              itemCount: missingProducts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.0.dp),
                  child: MissingProductCard(
                    product: missingProducts[index],
                  ),
                );
              },
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.37,
                  child: TextButton(
                    onPressed: () async {
                      bool response = await updateCollection();
                      if (response) {
                        widget.store.storeStatus = 'COLLECTION_DONE';
                        int counter = 0;
                        for (TShopperOrderStore store
                        in widget.order.orderStores) {
                          if (store.storeStatus ==
                              'IN_COLLECTION' ||
                              store.storeStatus ==
                                  'ON_HOLD') {
                            counter++;
                          }
                        }
                        if (counter == 0) {
                          widget.order.orderStatus =
                          'DONE_COLLECTING';
                        }

                        Navigator.pop(context);
                      } else {
                        showBottomPopup(
                          context: context,
                          message: "שגיאה בעדכון ליקוט, נסה שוב",
                          imagePath: "assets/images/warning_icon.png",
                        );
                      }
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.whiteText,
                      backgroundColor: AppColors.primeryColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.dp, vertical: 15.dp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.dp),
                      ),
                    ),
                    child: Text(
                      "אישור",
                      style: TextStyle(
                        fontSize: AppFontSize.fontSizeExtraSmall,
                        fontFamily: 'arimo',
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.37,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.whiteText,
                      backgroundColor: AppColors.superLightPurple,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.dp, vertical: 15.dp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.dp),
                      ),
                    ),
                    child: Text(
                      "ביטול",
                      style: TextStyle(
                        fontSize: AppFontSize.fontSizeExtraSmall,
                        fontFamily: 'arimo',
                        color: AppColors.primeryColor,
                        fontWeight: FontWeight.w600,
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

  bool isCollectionDone() {
    int counter = 0;
    for (var product in widget.store.products) {
      counter += product.collectQuantity;
      // If quantity to collect is 0 — skip checks
      if (product.collectQuantity == 0) continue;

      // Check that all required fields are filled
      if (product.priceTagImage.isEmpty ||
          product.shopperUploadedImage.isEmpty ||
          product.actualPrice == 0) {
        return false;
      }
    }
    if(counter == 0) return false;

    return true;
  }

  Future<bool> updateCollection() async {
    print("widget.isStoreCollected && selectedNumber != widget.store.numberOfCouriers && widget.store.paymentRequests!.isNotEmpty");
    print(widget.isStoreCollected && selectedNumber != widget.store.numberOfCouriers && widget.store.paymentRequests!.isNotEmpty
    );
    if(widget.isStoreCollected && selectedNumber != widget.store.numberOfCouriers && widget.store.paymentRequests!.isNotEmpty){
      await TShopperService.updateCouriersNumber(
          storeId: widget.store.id, paymentId: widget.store.paymentRequests!.first.id, numberOfCouriers: selectedNumber);
    }
    return await TShopperService.updateCollectedProducts(
        storeId: widget.store.id, products: widget.store.products, numberOfCouriers: selectedNumber);
  }
}
