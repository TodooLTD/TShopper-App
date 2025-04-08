
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../constants/ApiRequestConstants.dart';

class ImageService {

  static Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseServerUrl/image/uploadImage'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        return responseData.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> uploadImageNoCompress(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseServerUrl/image/uploadImageNoCompress'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        return responseData.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> convertFileToUrl(dynamic bytes) async {
    if (bytes == null) return '';

    const String apiUrl = '$baseServerUrl/image/uploadImage';
    String fileUrl = '';

    try {
      final http.MultipartRequest fileConversionRequest = http.MultipartRequest(
        'POST',
        Uri.parse(apiUrl),
      );

      fileConversionRequest.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: generateTimestampBasedUUID(),
        ),
      );

      final response = await fileConversionRequest.send();
      final String responseBody = await response.stream.bytesToString();
      if (response.statusCode != 200) {
        throw Exception('Upload image status: ${response.statusCode}');
      }

      fileUrl = responseBody;
    } catch (e) {
    }

    return fileUrl;
  }

  static String generateTimestampBasedUUID() {
    var uuid = const Uuid();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String uniqueId = '${uuid.v1()}_$timestamp';
    return uniqueId;
  }

}
