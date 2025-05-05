import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import '../../models/conversation/Conversation.dart';
import '../../sevices/ConversationService.dart';

class ConversationData {
  ConversationData({
    this.currentConversation,
  });

  Conversation? currentConversation;

  ConversationData copyWith({
    Conversation? currentConversation,
  }) {
    return ConversationData(
      currentConversation: currentConversation ?? this.currentConversation,
    );
  }
}

class ConversationNotifier extends StateNotifier<ConversationData> {
  ConversationNotifier()
      : super(
    ConversationData(
      currentConversation: null,
    ),
  );

  void addConversation(Conversation newConversation) async {
    state = state.copyWith(currentConversation: newConversation);
  }

  void newMessage(String orderId) async {
    Conversation? conversation = await ConversationService.getConversationByOrderId(orderId);
    state = state.copyWith(currentConversation: conversation);
    if(conversation != null){
      AudioPlayer audioPlayer = AudioPlayer();
      bool canVibrate = await Vibration.hasVibrator() ?? false;
      if (canVibrate) {
        Vibration.vibrate(duration: 500);
      }
      await audioPlayer.play(AssetSource('sounds/order_notification_sound.mp3'));
    }
  }

  void refresh() async {
    Conversation? conversation = await ConversationService.getConversationByOrderId(currentConversation.orderId);
    state = state.copyWith(currentConversation: conversation);
  }


  Conversation get currentConversation => state.currentConversation!;
  set currentConversation(Conversation newConversation) {
    state = state.copyWith(currentConversation: newConversation);
  }




}
