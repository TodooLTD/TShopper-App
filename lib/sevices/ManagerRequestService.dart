import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tshopper_app/models/managerRequest/ManagerRequest.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import '../../constants/ApiRequestConstants.dart';

class ManagerRequestService {

  /// ✅ Add a new support request
  static Future<ManagerRequest?> addManagerRequest(ManagerRequest request) async {
    Uri uri = Uri.parse('$baseServerUrl/managerRequest/add/${TShopper.instance.uid}');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    String jsonBody = json.encode(request.toJson());

    final response = await http.post(uri, headers: headers, body: jsonBody);

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      return ManagerRequest.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  /// ✅ Delete a support request by ID
  static Future<bool> deleteManagerRequest(int requestId) async {
    Uri uri = Uri.parse('$baseServerUrl/managerRequest/$requestId');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.delete(uri, headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// ✅ Update the status of a support request
  static Future<bool> setStatus(int requestId, String status) async {
    Uri uri = Uri.parse('$baseServerUrl/managerRequest/$requestId/setStatus?status=$status');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.put(uri, headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// ✅ Update the response of a support request
  static Future<bool> setResponse(int requestId, String responseText) async {
    Uri uri = Uri.parse('$baseServerUrl/managerRequest/$requestId/setResponse?response=$responseText');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.put(uri, headers: headers);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// ✅ Get all support requests for a business
  static Future<List<ManagerRequest>> getManagerRequestsByShopper(String shopperId) async {
    Uri uri = Uri.parse('$baseServerUrl/managerRequest/getByShopper/$shopperId');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => ManagerRequest.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<List<ManagerRequest>> getManagerRequestsByOrder(String orderId) async {
    Uri uri = Uri.parse('$baseServerUrl/managerRequest/getByOrder/$orderId');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => ManagerRequest.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
