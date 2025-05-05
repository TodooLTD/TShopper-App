import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers/ConversationNotifier.dart';

final conversationProvider =
StateNotifierProvider<ConversationNotifier, ConversationData>(
      (ref) => ConversationNotifier(),
);