
class Message {
  final int id;
  final String text;
  final String imageUrl;
  final String timestamp;
  final String seenAt;
  final String owner;

  Message({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.seenAt,
    required this.owner,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timestamp: json['timestamp'] ?? '',
      seenAt: json['seenAt'] ?? '',
      owner: json['owner'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'seenAt': seenAt,
      'owner': owner,
    };
  }
}