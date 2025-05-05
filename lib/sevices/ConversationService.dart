import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tshopper_app/models/conversation/message/MessageRequest.dart';
import '../../constants/ApiRequestConstants.dart';
import '../models/conversation/Conversation.dart';
class ConversationService {
  static Future<Conversation?> getConversationByOrderId(String orderId) async {
    final url = Uri.parse('$baseServerUrl/shopperConversation/byOrder/$orderId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        Conversation conversation = Conversation.fromJson(jsonResponse);
        return conversation;
      } else {
        print('Failed to fetch conversation: ${response.statusCode}');
        print(response.body);
        return null;
      }
    } catch (e) {
      print('Error in getConversationByOrderId: $e');
      return null;
    }
  }

  static Future<bool> sendMessage({
    required int conversationId,
    required MessageRequest request,
  }) async {
    final url = Uri.parse('$baseServerUrl/shopperConversation/$conversationId/send');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data == true;
      } else {
        print('Failed to send message: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      return false;
    }
  }

  static Future<void> updateMessagesSeen(List<int> messageIds) async {
    final url = Uri.parse('$baseServerUrl/shopperConversation/updateSeen');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(messageIds),
      );

      if (response.statusCode != 200) {
        print('Failed to update seen messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating seen messages: $e');
    }
  }

}
