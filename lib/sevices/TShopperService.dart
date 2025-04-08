import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tshopper_app/models/order/PaymentRequest.dart';
import 'package:tshopper_app/models/tshopper/PickupPoint.dart';
import '../constants/ApiRequestConstants.dart';
import '../models/order/ProductTShopperOrder.dart';
import '../models/order/TShopperOrder.dart';
import '../models/tshopper/TShopper.dart';

class TShopperService {

  static Future<TShopper> fetchShopper(String uid) async {
    final String apiUrl = '$baseServerUrl/tshopper/$uid';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      TShopper shopper = TShopper.fromJson(jsonResponse);
      return shopper;
    } else {
      throw Exception('Failed to load shopper with id $uid from API');
    }
  }

  static Future<List<TShopperOrder>?> getActiveOrders() async {
    String urlString =
        "$baseServerUrl/tshopperOrder/activeByShopper/${TShopper.instance.uid}/${TShopper.instance.currentShoppingCenterId}";
    final requestUrl = Uri.parse(urlString);
    print(urlString);
    try {
      final response = await http.get(
        requestUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to getActiveOrders: ${response.statusCode}');
      }

      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> ordersList = json.decode(responseBody);

      return ordersList
          .map((json) => TShopperOrder.fromJson(json))
          .toList();
    } catch (e) {

      return null;
    }
  }

  static Future<TShopperOrder> getOrder(String uid) async {
    final String apiUrl = '$baseServerUrl/tshopperOrder/$uid';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      TShopperOrder order = TShopperOrder.fromJson(jsonResponse);
      return order;
    } else {
      throw Exception('Failed to load order with id $uid from API');
    }
  }

  static Future<String> updateOrder(
      {required String orderId, required String actionType, required String notes, required String image, required String missionId}) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrder/update');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "orderId": orderId,
      "actionType": actionType,
      "notes": notes,
      "image": image,
      "missionId": missionId.isEmpty ? "0" : missionId
    };
    print(body);
    print(jsonEncode(body));
    print(uri);
    final response =
    await http.put(uri, body: jsonEncode(body), headers: headers);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return "";
    } else {
      return "${response.statusCode} ${response.body}";
    }
  }

  static Future<bool> updateNumberOfCouriers(
      {required String orderId, required int numberOfCourier}) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrder/updateNumberOfCouriers/$orderId/$numberOfCourier');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response =
    await http.put(uri, headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<String> getStoreLocationDescription(int id) async {
    final String apiUrl = '$baseServerUrl/store/getLocationDescription/$id';
    final response = await http.get(Uri.parse(apiUrl));
    return(response.body);
  }

  static Future<bool> updateStoreStatus(
      {required int storeId, required String status}) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrderStore/$storeId/status?status=$status');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response =
    await http.put(uri, headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> updateStoreSummary(
      {required int storeId, required int bagsAmount, required String invoiceImageUrls, required String bagImageUrls,  required String exchangeReceipt}) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrderStore/$storeId/summary');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "bagsAmount": bagsAmount,
      "invoiceImageUrls": invoiceImageUrls,
      "exchangeReceipt": exchangeReceipt,
      "bagImageUrls": bagImageUrls,
    };

    final response =
    await http.put(uri, body: jsonEncode(body), headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> updateCollectedProducts({
    required int storeId,
    required List<ProductTShopperOrder> products,
    required int numberOfCouriers
  }) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrderStore/$storeId/products/$numberOfCouriers');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final List<Map<String, dynamic>> productJsonList =
    products.map((product) => product.toJson()).toList();

    final response = await http.put(
      uri,
      body: jsonEncode(productJsonList),
      headers: headers,
    );
    print(response.body);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> addPaymentRequest(
      {required int storeId, required PaymentRequest paymentRequest}) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrderStore/$storeId/payment');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = paymentRequest.toJson();

    final response =
    await http.put(uri, body: jsonEncode(body), headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> updateReady(
      {required int storeId, required int bagsAmount, required String selectedColor, required String invoiceImageUrls, required String bagImageUrls,  required String exchangeReceipt}) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrderStore/$storeId/updateReady');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "bagsNumber": bagsAmount,
      "stickerColor": selectedColor,
      "invoiceImageUrls": invoiceImageUrls,
      "exchangeReceipt": exchangeReceipt,
      "bagImageUrls": bagImageUrls,
    };

    final response =
    await http.put(uri, body: jsonEncode(body), headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> cancelStore(
      {required int storeId, required String reason}) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrderStore/$storeId/cancelStore');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "reason": reason,
    };

    final response =
    await http.put(uri, body: jsonEncode(body), headers: headers);
    print(response.body);
    print(response.statusCode);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<List<PickupPoint>> getPickupPoints(int shoppingCenterId) async {
    Uri uri = Uri.parse('$baseServerUrl/shoppingCenter/$shoppingCenterId/getPickupPoints');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response =
        await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      return [];
    }
    final String responseBody = utf8.decode(response.bodyBytes);
    final List<dynamic> ordersList = json.decode(responseBody);

    return ordersList
        .map((json) => PickupPoint.fromJson(json))
        .toList();
  }

  static Future<int> getTimeTillCourierArrive(int id) async {
    final String apiUrl = '$baseServerUrl/deliveryMission/getTimeTillCourierArrive/$id';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return double.parse(response.body).toInt();
    } else {
      return -1;
    }
  }

  static Future<bool> updateCouriersNumber({
    required int storeId,
    required int paymentId,
    required int numberOfCouriers
  }) async {
    Uri uri = Uri.parse('$baseServerUrl/tshopperOrderStore/$storeId/updateCouriersNumber/$paymentId/$numberOfCouriers');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      uri,
      headers: headers,
    );
    print(response.body);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> updateForcePrice(
      {required int requestId, required double amount}) async {
    Uri uri = Uri.parse('$baseServerUrl/paymentRequest/$requestId/editAmount?action=force&amount=$amount');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response =
    await http.put(uri, headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }


}