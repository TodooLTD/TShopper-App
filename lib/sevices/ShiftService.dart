import '../models/shift/ShopperShift.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/ApiRequestConstants.dart';

class ShiftService {
  static Future<List<ShopperShift>> getAvailabilityShiftsByShopper({
    required int shoppingCenterId,
    required String shopperId,
    required DateTime from,
    required DateTime to,
  }) async {

    final uri = Uri.parse("$baseServerUrl/shopperShift/getAvailabilityShiftsByShopper")
        .replace(queryParameters: {
      'shoppingCenterId': shoppingCenterId.toString(),
      'shopperId': shopperId,
      'fromDate': from.toIso8601String().substring(0, 10),
      'toDate': to.toIso8601String().substring(0, 10),
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final List jsonList = json.decode(response.body);
    return jsonList.map((e) => ShopperShift.fromJson(e)).toList();
  }

  static Future<bool> submitAvailabilityShifts({
    required String shopperId,
    required List<Map<String, dynamic>> shiftDtos,
  }) async {
    final uri = Uri.parse('$baseServerUrl/shopperShift/addShifts')
        .replace(queryParameters: {'shopperId': shopperId});

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(shiftDtos),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteShiftsByIds({required List<int> shiftIds}) async {
    final uri = Uri.parse('$baseServerUrl/shopperShift/deleteShifts');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(shiftIds),
    );

    return response.statusCode == 200;
  }

  static Future<List<ShopperShift>> getAssignedShiftsByShopper({
    required int centerId,
    required String shopperId,
    required DateTime from,
    required DateTime to,
  }) async {

    final uri = Uri.parse("$baseServerUrl/shopperShift/getAssignedShiftsByShopper")
        .replace(queryParameters: {
      'shoppingCenterId': centerId.toString(),
      'shopperId': shopperId,
      'fromDate': from.toIso8601String().substring(0, 10),
      'toDate': to.toIso8601String().substring(0, 10),
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
    return jsonList.map((json) => ShopperShift.fromJson(json)).toList();
  }

  static Future<bool> startShift({
    required int shiftId,
  }) async {
    final uri = Uri.parse('$baseServerUrl/shopperShift/$shiftId/start');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  static Future<bool> endShift({
    required int shiftId,
  }) async {
    final uri = Uri.parse('$baseServerUrl/shopperShift/$shiftId/end');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  static Future<bool> editShiftActualTimes({
    required int shiftId,
    required String actualStartTime,
    required String actualEndTime,
    required String editedBy,
  }) async {
    final uri = Uri.parse("$baseServerUrl/shopperShift/$shiftId/editActualTimes");

    final body = {
      "actualStartTime": actualStartTime,
      "actualEndTime": actualEndTime,
      "editedBy": editedBy,
    };

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

}
