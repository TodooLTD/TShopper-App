import 'Reply.dart';

class Comment {
  final int id;
  final String userId;
  final String userName;
  final String userColor;
  final String content;
  final String timestamp;
  final List<String> likedByUserIds;
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userColor,
    required this.content,
    required this.timestamp,
    required this.likedByUserIds,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userColor: json['userColor'],
      content: json['content'],
      timestamp: json['timestamp'],
      likedByUserIds: List<String>.from(json['likedByUserIds']),
      replies: (json['replies'] != null && json['replies'] is List)
          ? (json['replies'] as List).map((e) => Reply.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userColor': userColor,
      'content': content,
      'timestamp': timestamp,
      'likedByUserIds': likedByUserIds,
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }
}
