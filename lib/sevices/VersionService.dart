import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/ApiRequestConstants.dart';

class VersionService {
  static Future<bool?> isLatestVersion(String platform, String appVersion) async {
    String apiUrl = '$baseServerUrl/appVersion/checkBusinessManagers?platform=$platform&appVersion=1.0.1';
    bool isLatestVersion = false;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to get answer from API ${response.statusCode}',
        );
      }
      if(response.body == "false"){
        return false;
      }
      if(response.body == "true"){
        return true;
      }
    } catch (e) {
      return null;
    }
    return isLatestVersion;
  }
}