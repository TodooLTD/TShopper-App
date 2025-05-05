import 'message/Message.dart';

class Conversation {
  final int id;
  final String status; // ConversationStatus enum as String
  final DateTime timestamp;
  final List<Message> messages;

  // user details
  final String userFirstName;
  final String userLastName;

  // shopper details
  final String shopperFirstName;
  final String shopperLastName;

  // order details
  final int orderNumber;
  final String orderId;

  Conversation({
    required this.id,
    required this.status,
    required this.timestamp,
    required this.messages,
    required this.userFirstName,
    required this.userLastName,
    required this.shopperFirstName,
    required this.shopperLastName,
    required this.orderNumber,
    required this.orderId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e))
          .toList(),
      userFirstName: json['userFirstName'],
      userLastName: json['userLastName'],
      shopperFirstName: json['shopperFirstName'],
      shopperLastName: json['shopperLastName'],
      orderNumber: json['orderNumber'],
      orderId: json['orderId'],
    );
  }
}

