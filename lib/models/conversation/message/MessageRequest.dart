
class MessageRequest {
  final String text;
  final String imageUrl;
  final String owner;

  MessageRequest({
    required this.text,
    required this.imageUrl,
    required this.owner,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'owner': owner,
    };
  }
}