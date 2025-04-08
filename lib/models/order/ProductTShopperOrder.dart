import 'dart:io';

class ProductTShopperOrder {
   int id;
   int quantity;
   int collectQuantity;
   double actualPrice;
   String description;
   String customerUploadedImage;
   String shopperUploadedImage;
   String priceTagImage;
   String shopperNotes;
  ProductTShopperOrder({
    required this.id,
    required this.quantity,
    required this.collectQuantity,
    required this.actualPrice,
    required this.description,
    required this.customerUploadedImage,
    required this.shopperUploadedImage,
    required this.priceTagImage,
    required this.shopperNotes,
  });


  factory ProductTShopperOrder.fromJson(Map<String, dynamic> json) {
    return ProductTShopperOrder(
        id: json['id'] ?? 0,
        quantity: json['quantity'] ?? 0,
      collectQuantity: json['collectQuantity'] ?? 0,
      actualPrice: json['actualPrice'] ?? 0.0,
        description: json['description'] ?? "",
        customerUploadedImage: json['customerUploadedImage'] ?? "",
      shopperUploadedImage: json['shopperUploadedImage'] ?? "",
      priceTagImage: json['priceTagImage'] ?? "",
      shopperNotes: json['shopperNotes'] ?? "",

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'description':description,
      'customerUploadedImage': customerUploadedImage,
      'collectQuantity': collectQuantity,
      'shopperUploadedImage': shopperUploadedImage,
      'actualPrice': actualPrice,
      'priceTagImage': priceTagImage,
      'shopperNotes': shopperNotes,
    };
  }
}
