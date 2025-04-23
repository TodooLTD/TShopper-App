import 'Comment.dart';

class SocialContent {
  final int id;
  final List<String> urls;
  final String timestamp;
  final String description;
  final String type;
  final List<String> viewedByUserIds;
  final List<String> likeByUserIds;
   bool verified;
  final List<Comment> comments;
  String shopperId;
  int shoppingCenterId;

  SocialContent({
    required this.id,
    required this.urls,
    required this.timestamp,
    required this.description,
    required this.type,
    required this.viewedByUserIds,
    required this.likeByUserIds,
    required this.verified,
    required this.comments,
    required this.shopperId,
    required this.shoppingCenterId,
  });

  factory SocialContent.fromJson(Map<String, dynamic> json) {
    return SocialContent(
      id: json['id'],
      urls: List<String>.from(json['urls']),
      timestamp: json['timestamp'],
      description: json['description'],
      type: json['type'],
      viewedByUserIds: List<String>.from(json['viewedByUserIds']),
      likeByUserIds: List<String>.from(json['likeByUserIds']),
      verified: json['verified'],
      shopperId: json['shopperId'],
      shoppingCenterId: json['shoppingCenterId'],
      comments: (json['comments'] as List)
          .map((e) => Comment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urls': urls,
      'timestamp': timestamp,
      'viewedByUserIds': viewedByUserIds,
      'likeByUserIds': likeByUserIds,
      'verified': verified,
      'type': type,
      'description': description,
      'comments': comments.map((e) => e.toJson()).toList(),
      'shopperId': shopperId,
      'shoppingCenterId': shoppingCenterId
    };
  }

  DateTime getTimestamp() {
    String? dateString = timestamp;
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } on FormatException {
        throw Exception('Date string is not in a valid format: $dateString');
      }
    } else {
      return DateTime(2000, 1, 1);
    }
  }
}
