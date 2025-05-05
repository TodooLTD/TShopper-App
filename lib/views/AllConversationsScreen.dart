import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tshopper_app/models/conversation/Conversation.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/providers/InPreparationOrderProvider.dart';
import 'package:tshopper_app/providers/ReadyOrderProvider.dart';
import '../constants/AppColors.dart';
import '../models/conversation/message/Message.dart';
import '../models/conversation/message/MessageRequest.dart';
import '../providers/conversationProvider.dart';
import '../sevices/ConversationService.dart';
import '../sevices/ImageService.dart';
import '../widgets/appBars/CustomAppBarOnlyBack.dart';
import '../widgets/overlayMenu/OverlayMenu.dart';
import '../widgets/popup/BottomPopup.dart';
import 'ConversationScreen.dart';

class AllConversationsScreen extends ConsumerStatefulWidget {
  const AllConversationsScreen({super.key});

  @override
  ConsumerState<AllConversationsScreen> createState() => _AllConversationsScreenState();
}

class _AllConversationsScreenState extends ConsumerState<AllConversationsScreen> with TickerProviderStateMixin {
  final OverlayMenu overlayMenu = OverlayMenu();
  List<Conversation> conversations = [];
 bool isLoading = true;

  @override
  void initState() {
    super.initState();
    overlayMenu.init(context, this);
    fetchAllConversations();

  }

  Future<void> fetchAllConversations() async{
    if(ref.read(inPreparationOrderProvider).allInPreparationOrders.isNotEmpty){
      for(TShopperOrder order in ref.read(inPreparationOrderProvider).allInPreparationOrders){
        Conversation? optConversation = await ConversationService.getConversationByOrderId(order.orderId);
        if(optConversation != null){
          conversations.add(optConversation);
        }
      }
    }
    if(ref.read(readyOrderProvider).allReadyOrders.isNotEmpty){
      for(TShopperOrder order in ref.read(readyOrderProvider).allReadyOrders){
        Conversation? optConversation = await ConversationService.getConversationByOrderId(order.orderId);
        if(optConversation != null){
          conversations.add(optConversation);
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.whiteText,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => overlayMenu.showOverlay(3),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.iconLightGrey,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    size: 22.dp,
                    Icons.menu,
                    color: AppColors.whiteText,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.whiteText,
          elevation: 0,
        ),
        body: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : conversations.isEmpty
              ? Center(
            child: Text(
              'אין שיחות',
              style: TextStyle(
                fontFamily: 'arimo',
                fontSize: 18.dp,
                color: AppColors.blackText,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
              : ListView(
            padding: EdgeInsets.all(12.dp),
            children: [
              // 🟦 כאן טקסט לפני הרשימה
              Text(
                "צ׳אט הזמנות פעילות",
                style: TextStyle(
                  fontSize: 24.dp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'todofont',
                  color: AppColors.blackText,
                ),
              ),
              SizedBox(height: 16.dp),

              // 🟦 כאן הרשימה
              ..._buildConversationList(),
            ],
          ),
        ),
      ),
    );
  }

 List<Widget> _buildConversationList() {
   List<Widget> widgets = [];

   for (int i = 0; i < conversations.length; i++) {
     if (i == 0) {
       // לפני הראשון, תוסיף Divider
       widgets.add(
         Divider(
           color: AppColors.borderColor,
           thickness: 1,
         ),
       );
     }

     widgets.add(_buildConversationCard(conversations[i]));

     widgets.add(
       Divider(
         color: AppColors.borderColor,
         thickness: 1,
       ),
     );
   }

   return widgets;
 }

 Widget _buildConversationCard(Conversation conversation) {
   // למצוא את ההודעה האחרונה לפי timestamp
   final messages = conversation.messages
       .where((m) => m.timestamp.isNotEmpty)
       .toList();

   messages.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp))); // חדש -> ישן

   final lastMessage = messages.isNotEmpty ? messages.first : null;

   String timeAgo = '';
   bool hasUnseen = false;

   if (lastMessage != null) {
     final timestamp = DateTime.tryParse(lastMessage.timestamp);
     if (timestamp != null) {
       final now = DateTime.now();
       final diff = now.difference(timestamp);

       if (diff.inMinutes < 60) {
         timeAgo = '${diff.inMinutes}m ago';
       } else if (diff.inHours < 24) {
         timeAgo = '${diff.inHours}h ago';
       } else {
         timeAgo = '${diff.inDays}d ago';
       }
     }

     // אם ההודעה האחרונה לא נראתה והיא שייכת ל-USER
     if (lastMessage.seenAt.isEmpty && lastMessage.owner == 'USER') {
       hasUnseen = true;
     }
   }

   return GestureDetector(
     onTap: () async{
       ref.read(conversationProvider).currentConversation = null;
       Conversation? optConversation = await ConversationService.getConversationByOrderId(conversation.orderId);
       if(optConversation != null && optConversation.status == 'OPEN'){
         ref.read(conversationProvider).currentConversation = optConversation;
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => const ConversationScreen(),
           ),
         );
       }else{
         showBottomPopup(
           duration: const Duration(
               seconds: 2),
           context: context,
           message: "צ׳אט לא זמין בשלב זה של ההזמנה",
           imagePath: "assets/images/warning_icon.png",
         );
       }
     },
     child: Card(
       elevation: 0,
       color: AppColors.whiteText,
       margin: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 0.dp),
       child: Row(
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     "#${conversation.orderNumber} | ${conversation.userFirstName}",
                     style: TextStyle(
                       fontFamily: 'todofont',
                       fontWeight: FontWeight.w800,
                       fontSize: 16.dp,
                       color: AppColors.blackText,
                     ),
                   ),
                   SizedBox(height: 3.dp),
                   SizedBox(
                     width: 200.dp,
                     child: Text(
                       lastMessage?.text ?? '',
                       style: TextStyle(
                         color: AppColors.mediumGreyText,
                         fontSize: 12.dp,
                         overflow: TextOverflow.ellipsis,
                       ),
                       maxLines: 2,
                     ),
                   ),
                 ],
               ),
             ],
           ),
           Spacer(),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   if (hasUnseen) ...[
                     SizedBox(width: 6),
                     CircleAvatar(
                       radius: 5,
                       backgroundColor: AppColors.primeryColor,
                     ),
                   ],
                   SizedBox(width: 6.dp,),
                   Text(
                     timeAgo,
                     style: TextStyle(
                       color: hasUnseen ? AppColors.primeryColor : AppColors.mediumGreyText,
                       fontSize: 12.dp,
                       fontFamily: 'arimo'
                     ),
                   ),

                 ],
               ),

             ],
           ),
         ],
       ),
     ),
   );
 }


}
