import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/AppColors.dart';
import '../models/conversation/message/Message.dart';
import '../models/conversation/message/MessageRequest.dart';
import '../providers/conversationProvider.dart';
import '../sevices/ConversationService.dart';
import '../sevices/ImageService.dart';
import '../widgets/appBars/CustomAppBarOnlyBack.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final picker = ImagePicker();
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _updateUserMessagesSeen();
    });
  }

  Future<void> _sendMessage() async {

    final text = _messageController.text.trim();
    print("here");
    if (text.isEmpty && imageUrl.isEmpty) return; // למנוע שליחה ריקה
    if (ref.read(conversationProvider).currentConversation == null) return;

    final request = MessageRequest(
      text: text,
      imageUrl: imageUrl, // עכשיו שולח את התמונה אם יש
      owner: 'SHOPPER',
    );

    final success = await ConversationService.sendMessage(
      conversationId: ref.read(conversationProvider).currentConversation!.id,
      request: request,
    );

    ref.read(conversationProvider.notifier).refresh();

    if (success) {
      _messageController.clear();
      setState(() {
        imageUrl = '';
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildMessageBubble(Message message) {
    final isShopper = message.owner == 'SHOPPER';
    final timestamp = DateTime.tryParse(message.timestamp);
    final seenAt = message.seenAt.isNotEmpty;

    String timeAgoText = '';

    if (timestamp != null) {
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      if (difference.inMinutes < 60) {
        if(difference.inMinutes == 0){
          timeAgoText = 'now';
        }else{
          timeAgoText = '${difference.inMinutes}m';
        }
      } else if (difference.inHours < 24) {
        timeAgoText = '${difference.inHours}h';
      } else {
        timeAgoText = '${difference.inDays}d';
      }

      if (seenAt && isShopper) {
        timeAgoText += ' | Seen';
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: isShopper ? 50.dp : 8.0.dp, right: isShopper ? 8.dp : 50.dp, top: 8.0.dp, bottom: 8.0.dp),
      child: Column(
        crossAxisAlignment:
        isShopper ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // 🟦 הבועה של הטקסט
          if (message.text.isNotEmpty)
            Align(
            alignment: isShopper ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isShopper
                    ? AppColors.primeryColor
                    : AppColors.superLightPurple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isShopper ? AppColors.white : AppColors.primeryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'arimo',
                  fontSize: 14.dp,
                ),
              ),
            ),
          ),

          // 🟦 תמונה אם יש
          if (message.imageUrl.isNotEmpty)
            Align(
              alignment: isShopper ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    message.imageUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // 🟦 הזמן
          Align(
            alignment: isShopper ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                timeAgoText,
                style: TextStyle(
                  color: AppColors.mediumGreyText,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'arimo',
                  fontSize: 10.dp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(conversationProvider);
    ref.read(conversationProvider).currentConversation?.messages.sort((a, b) => DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)));

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.whiteText,
        appBar: CustomAppBarOnlyBack(
          backgroundColor: AppColors.transparentPerm,
          onBackTap: () => Navigator.pop(context),
          title: "", isButton: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Text(
                "#${ref.read(conversationProvider).currentConversation!.orderNumber} | ${ref.read(conversationProvider).currentConversation!.userFirstName}",
                style: TextStyle(
                    fontSize: 24.dp,
                    fontFamily: 'todofont',
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackText),
              ),
              SizedBox(height: 8.dp,),
              Expanded(
                child: ref.read(conversationProvider).currentConversation == null
                    ? const Center(
                        child: Text('לא נמצאה שיחה',
                            style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                        reverse: true, // ההודעות האחרונות למטה
                        itemCount: ref
                            .read(conversationProvider)
                            .currentConversation!
                            .messages
                            .length,
                        itemBuilder: (context, index) {
                          final message = ref
                              .read(conversationProvider)
                              .currentConversation!
                              .messages
                              .reversed
                              .toList()[index];
                          return _buildMessageBubble(message);
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: AppColors.whiteText,
                child: Column(
                  children: [
                    if (imageUrl.isNotEmpty) // הצגת התמונה שבחרת
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    imageUrl = '';
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black.withOpacity(0.6),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(0),
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: EdgeInsets.all(0.dp),
                            decoration: BoxDecoration(
                              color: AppColors.whiteText,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColors.primeryColor,
                              size: 24.dp,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.dp),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.dp),
                              color: AppColors.whiteText,
                              border: Border.all(color: AppColors.borderColor),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.dp),
                              child: TextField(
                                controller: _messageController,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'arimo',
                                  fontSize: 14.dp,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'כתוב כאן..',
                                  hintStyle: TextStyle(
                                    color: AppColors.mediumGreyText,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'arimo',
                                    fontSize: 14.dp,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _sendMessage, // תקן כאן: בלי סוגריים => לא ()=>!
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: EdgeInsets.all(8.dp),
                            decoration: const BoxDecoration(
                              color: AppColors.primeryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 16.dp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   color: AppColors.whiteText,
              //   child: Row(
              //     children: [
              //       GestureDetector(
              //         onTap: () => _pickImage(0),
              //         child: Container(
              //             margin: const EdgeInsets.all(6),
              //             padding: EdgeInsets.all(0.dp),
              //             decoration: BoxDecoration(
              //               color: AppColors.whiteText,
              //               shape: BoxShape.circle,
              //             ),
              //             child: Icon(
              //               Icons.add,
              //               color: AppColors.primeryColor,
              //               size: 24.dp,
              //             )),
              //       ),
              //       SizedBox(
              //         width: 4.dp,
              //       ),
              //       Expanded(
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(30.dp),
              //             color: AppColors.whiteText,
              //             border: Border.all(
              //               color: AppColors.borderColor,
              //             ),
              //           ),
              //           child: Padding(
              //             padding:  EdgeInsets.symmetric(horizontal: 16.0.dp),
              //             child: TextField(
              //               controller: _messageController,
              //               style: TextStyle(
              //                 color: AppColors.blackText,
              //                 fontWeight: FontWeight.w400,
              //                 fontFamily: 'arimo',
              //                 fontSize: 14.dp,
              //               ),
              //               decoration: InputDecoration(
              //                 hintText: 'כתוב כאן..',
              //                 hintStyle: TextStyle(
              //                   color: AppColors.mediumGreyText,
              //                   fontWeight: FontWeight.w400,
              //                   fontFamily: 'arimo',
              //                   fontSize: 14.dp,
              //                 ),
              //                 border: InputBorder.none,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () => _sendMessage(),
              //         child: Container(
              //             margin: const EdgeInsets.all(6),
              //             padding: EdgeInsets.all(8.dp),
              //             decoration: const BoxDecoration(
              //               color: AppColors.primeryColor,
              //               shape: BoxShape.circle,
              //             ),
              //             child: Icon(
              //               Icons.send,
              //               color: Colors.white,
              //               size: 16.dp,
              //             )),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.dp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageOption(
                    icon: Icons.photo_library,
                    label: "גלריה",
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(index, ImageSource.gallery);
                    },
                  ),
                  _imageOption(
                    icon: Icons.camera_alt,
                    label: "מצלמה",
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(index, ImageSource.camera);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.dp),
            ],
          ),
        );
      },
    );
  }

  Widget _imageOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primeryColor.withOpacity(0.1),
            child: Icon(icon, color: AppColors.primeryColor, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.w600, color: AppColors.blackText)),
        ],
      ),
    );
  }

  Future<void> _getImage(int index, ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      File imageFile = File(picked.path);
      String? url = await ImageService.uploadImageNoCompress(imageFile);
      setState(() {
        if (index == 0) {
          imageUrl = url!;
        } else if (index == 1) {
          imageUrl = url!;
        }
      });
    }
  }

  Future<void> _updateUserMessagesSeen() async {
    final conversation = ref.read(conversationProvider).currentConversation;
    if (conversation == null) return;

    // סינון כל ההודעות של USER שלא נקראו
    final unseenShopperMessages = conversation.messages
        .where((message) =>
    message.owner == 'USER' && (message.seenAt.isEmpty || message.seenAt == 'null'))
        .toList();

    if (unseenShopperMessages.isEmpty) return;

    final messageIds = unseenShopperMessages.map((message) => message.id).toList();

    await ConversationService.updateMessagesSeen(messageIds);

    // אחרי עדכון, תבצע רענון לשיחה כדי להכניס את השינויים
    ref.read(conversationProvider.notifier).refresh();
  }


}
