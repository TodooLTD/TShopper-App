import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tshopper_app/models/socialContenct/SocialContent.dart';
import '../../constants/ApiRequestConstants.dart';

class SocialContentService {

  static Future<SocialContent?> addContent(SocialContent newContent) async {
    Uri uri = Uri.parse('$baseServerUrl/socialContent');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    String jsonBody = json.encode(newContent.toJson());

    final response =
    await http.post(uri, headers: headers, body: jsonBody);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      SocialContent content = SocialContent.fromJson(jsonResponse);
      return content;
    } else {
      return null;
    }
  }

  static Future<List<SocialContent>> getByTypeAndShopper({
    required String type,
    required String shopperId,
  }) async {
    final uri = Uri.parse('$baseServerUrl/socialContent/getByTypeAndShopper')
        .replace(queryParameters: {
      'type': type,
      'shopperId': shopperId,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => SocialContent.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<bool> setVerified(int reelId) async {
    Uri uri = Uri.parse('$baseServerUrl/reel/$reelId/verify?verified=true');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response =
    await http.put(uri, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteContent(int id) async {
    Uri uri = Uri.parse('$baseServerUrl/socialContent/$id');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response =
    await http.delete(uri, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteComment(int reelId, int commentId) async {
    Uri uri = Uri.parse('$baseServerUrl/reel/$reelId/comment/$commentId');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response =
    await http.delete(uri, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteReply(int reelId, int commentId, int replyId) async {
    Uri uri = Uri.parse('$baseServerUrl/reel/$reelId/comment/$commentId/reply/$replyId');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response =
    await http.delete(uri, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }



}