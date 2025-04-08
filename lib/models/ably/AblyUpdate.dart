import 'dart:convert';

class AblyUpdate {
  final Map<String, dynamic> data;

  AblyUpdate({ required this.data});

  factory AblyUpdate.fromJson(String jsonString) {
    return AblyUpdate(
      data: jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}