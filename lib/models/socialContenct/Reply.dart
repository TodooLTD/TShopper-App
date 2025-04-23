class Reply {
  final int id;
  final String userId;
  final String userName;
  final String userColor;
  final String content;
  final String timestamp;
  final List<String> likedByUserIds;

  Reply({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userColor,
    required this.content,
    required this.timestamp,
    required this.likedByUserIds,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userColor: json['userColor'],
      content: json['content'],
      timestamp: json['timestamp'],
      likedByUserIds: List<String>.from(json['likedByUserIds']),
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
    };
  }
}
