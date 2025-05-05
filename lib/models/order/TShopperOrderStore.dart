
import 'PaymentRequest.dart';
import 'ProductTShopperOrder.dart';
import 'StoreTimeline.dart';

class TShopperOrderStore {
  int id;
  String customerNotes;
  List<ProductTShopperOrder>products;
  int storeId;
  String storeName;
  String storeStatus;
  int bagsAmount;
  String bagImageUrls;
  String exchangeReceipt;
  String invoiceImageUrls;
  int numberOfCouriers;
  List<PaymentRequest>? paymentRequests;
  StoreTimeline timeLine;

  TShopperOrderStore({
    required this.id,
    required this.customerNotes,
    required this.products,
    required this.storeId,
    required this.storeName,
    required this.storeStatus,
    required this.paymentRequests,
    required this.bagsAmount,
    required this.bagImageUrls,
    required this.exchangeReceipt,
    required this.invoiceImageUrls,
    required this.numberOfCouriers,
    required this.timeLine,
  });

  factory TShopperOrderStore.fromJson(Map<String, dynamic> json) {
    print(json['storeStatus']);
    return TShopperOrderStore(
      id: json['id'] ?? 0,
      bagsAmount: json['bagsAmount'] ?? 0,
        storeName: json['storeName'] ?? "",
      bagImageUrls: json['bagImageUrls'] ?? "",
      exchangeReceipt: json['exchangeReceipt'] ?? "",
      invoiceImageUrls: json['invoiceImageUrls'] ?? "",
      customerNotes: json['customerNotes'] ?? "",
      storeStatus: json['storeStatus'] ?? "",
      products: List<ProductTShopperOrder>.from(
        json['products'].map(
              (x) => ProductTShopperOrder.fromJson(x),
        ),
      ) ??
          [],
        storeId:  json['storeId'] ?? 0,
      numberOfCouriers:  json['numberOfCouriers'] ?? 0,
      timeLine: StoreTimeline.fromJson(json['timeLine']),
      paymentRequests: json['paymentRequests'] != null ? List<PaymentRequest>.from(
        json['paymentRequests'].map(
              (x) => PaymentRequest.fromJson(x),
        ),
      ) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerNotes': customerNotes,
      'products': products.map((p) => p.toJson()).toList(),
      'storeId': storeId,
      'storeName': storeName,
    };
  }

  int getAmount() {
    int counter = 0;
        if(products.isNotEmpty){
          for(ProductTShopperOrder productOrder in products){
            if(timeLine.doneCollecting!.isNotEmpty) {
              counter += productOrder.collectQuantity;
            } else {
              counter += productOrder.quantity;
            }
          }
    }
    return counter;
  }

  double getPrice() {
    double counter = 0;
    if(products.isNotEmpty){
      for(ProductTShopperOrder productOrder in products){
        counter += productOrder.collectQuantity * productOrder.actualPrice;
      }
    }
    return counter;
  }

  bool isCollectionDone() {
    if(storeStatus == 'ON_HOLD' || storeStatus == 'IN_COLLECTION') return false;
    return true;
  }

}