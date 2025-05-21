import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../models/socialContenct/Comment.dart';
import '../../models/socialContenct/Reply.dart';
import '../../models/socialContenct/SocialContent.dart';
import '../../sevices/SocialContentService.dart';
import '../popup/BottomPopup.dart';

class ShoppersCommentsBottomSheet extends StatefulWidget {
  SocialContent content;
  final TextEditingController commentController;

  ShoppersCommentsBottomSheet({
    Key? key,
    required this.content,
    required this.commentController,
  }) : super(key: key);

  @override
  _ShoppersCommentsBottomSheetState createState() => _ShoppersCommentsBottomSheetState();
}

class _ShoppersCommentsBottomSheetState extends State<ShoppersCommentsBottomSheet> with WidgetsBindingObserver {

  Map<String, Color> colorMap = {
    'blue': Colors.blue,
    'green': Colors.green,
    'teal': Colors.teal,
    'tealAccent': Colors.tealAccent,
    'beige': Colors.orange[100]!,
    'orange': Colors.orange,
    'yellow': Colors.yellow,
    'red': Colors.red,
    'pink': Colors.pink,
    'lightPink':  Colors.pink[100]!,
    'brown':  Colors.brown,
    'black':  Colors.black,
  };
  double keyboardHeight = 0;
  Comment? replyingToComment;
  List<int> idsOfCommentWithOpenReplies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe keyboard changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Rebuild the widget when the keyboard state changes
    final keyboardVisible = View.of(context).viewInsets.bottom > 0;
    setState(() {
      keyboardHeight = keyboardVisible ? View.of(context).viewInsets.bottom : 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight == 0 ? keyboardHeight : keyboardHeight/3), // Use updated keyboard height
        child: DraggableScrollableSheet(
          initialChildSize: widget.content.comments.isNotEmpty ? keyboardHeight != 0 ? 0.8 : widget.content.comments.length > 3 ? 0.8 : 0.5 : keyboardHeight != 0 ? 0.5 : 0.3, // Start size
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.dp)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.dp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.dp),
                    // Sheet Header
                    Center(
                      child: Container(
                        width: 40.dp,
                        height: 4.dp,
                        decoration: BoxDecoration(
                          color: AppColors.borderColor,
                          borderRadius: BorderRadius.circular(2.dp),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.dp),
                    // Title
                    Center(
                      child: Text(
                        "${widget.content.comments.length} תגובות",
                        style: TextStyle(
                          fontSize: AppFontSize.fontSizeExtraSmall,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'arimo',
                          color: AppColors.mediumGreyText,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.dp),
                    // Comments List
                    Expanded(
                      child: widget.content.comments.isNotEmpty
                          ? ListView.builder(
                        controller: scrollController,
                        itemCount: widget.content.comments.length,
                        itemBuilder: (context, index) {
                          final comment = widget.content.comments[index];
                          bool isLiked = false;
                          return Padding(
                            padding:  EdgeInsets.only(bottom: 16.0.dp),
                            child: ListTile(
                                leading: Container(
                                  width: 40.dp,
                                  height: 40.dp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        colorMap[comment.userColor] ?? AppColors.mediumGreyText,
                                        (colorMap[comment.userColor] ?? AppColors.mediumGreyText).withOpacity(0.2),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        getInitials(comment.userName),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'todoFont',
                                          fontSize: 24.dp,
                                          color: AppColors.whiteText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getInitialsUserNameTitle(comment.userName),
                                      style: TextStyle(color: AppColors.mediumGreyText, fontSize: AppFontSize.fontSizeExtraSmall, fontWeight: FontWeight.w700, fontFamily: 'arimo',),
                                    ),
                                    Text(
                                      comment.content,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'arimo',
                                        fontSize: AppFontSize.fontSizeRegular,
                                      ),
                                    ),
                                    SizedBox(height: 4.dp),
                                    Row(
                                      children: [
                                        Text(
                                          getTimeAgo(comment.timestamp),
                                          style: TextStyle(
                                            fontFamily: 'arimo',
                                            color: AppColors.mediumGreyText,
                                            fontSize: AppFontSize.fontSizeExtraSmall,
                                          ),
                                        ),
                                        SizedBox(width: 8.dp,),
                                        GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              replyingToComment = comment;
                                            });
                                          },
                                          child: Text(
                                            "להשיב",
                                            style: TextStyle(
                                              fontFamily: 'arimo',
                                              color: AppColors.primeryColortext,
                                              fontSize: AppFontSize.fontSizeExtraSmall,
                                            ),
                                          ),
                                        ),
                                          SizedBox(width: 16.dp,),
                                          GestureDetector(
                                            onTap:() async{
                                              bool response = await SocialContentService.deleteComment(widget.content.id, comment.id);
                                              if(response){
                                                setState(() {
                                                  widget.content.comments.remove(comment);
                                                });
                                              }else{
                                                showTopPopup(
                                                  context: context,
                                                  message: "שגיאה במחיקת תגובה, נסה שוב",
                                                  imagePath: 'assets/images/warning_icon.png',
                                                  shouldAddFixedSpace: true,
                                                );
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, size: AppFontSize.fontSizeExtraSmall, color: AppColors.redColor,),
                                                SizedBox(width: 4.dp,),
                                                Text(
                                                  "    ",
                                                  style: TextStyle(
                                                    fontFamily: 'arimo',
                                                    color: AppColors.redColor,
                                                    fontSize: AppFontSize.fontSizeExtraSmall,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    if(comment.replies.isNotEmpty)...[
                                      SizedBox(height: 8.dp),
                                      GestureDetector(
                                        onTap:(){
                                          if(idsOfCommentWithOpenReplies.contains(comment.id)){
                                            setState(() {
                                              idsOfCommentWithOpenReplies.remove(comment.id);
                                            });
                                          }else{
                                            setState(() {
                                              idsOfCommentWithOpenReplies.add(comment.id);
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              idsOfCommentWithOpenReplies.contains(comment.id) ? "סגור" : "${comment.replies.length} תגובות נוספות",
                                              style: TextStyle(
                                                fontFamily: 'arimo',
                                                color: AppColors.mediumGreyText,
                                                fontSize: AppFontSize.fontSizeExtraSmall,
                                              ),
                                            ),
                                            SizedBox(width: 4.dp,),
                                            Icon(idsOfCommentWithOpenReplies.contains(comment.id) ? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_outlined, size: 16.dp, color:AppColors.mediumGreyText)
                                          ],
                                        ),
                                      ),
                                      if(idsOfCommentWithOpenReplies.contains(comment.id))...[
                                        SizedBox(
                                          height: comment.replies.length * 85.0.dp,
                                          child: ListView.builder(
                                            controller: scrollController,
                                            itemCount: comment.replies.length,
                                            itemBuilder: (context, index) {
                                              final reply = comment.replies[index];
                                              bool isLikedReply = false;
                                              return Padding(
                                                padding:  EdgeInsets.only(bottom: 16.0.dp),
                                                child: ListTile(
                                                    leading: Container(
                                                      width: 35.dp,
                                                      height: 35.dp,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            colorMap[reply.userColor] ?? AppColors.mediumGreyText,
                                                            (colorMap[reply.userColor] ?? AppColors.mediumGreyText).withOpacity(0.2),
                                                          ],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 8.0),
                                                          child: Text(
                                                            getInitials(reply.userName),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily: 'todoFont',
                                                              fontSize: 18.dp,
                                                              color: AppColors.whiteText,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          getInitialsUserNameTitle(reply.userName),
                                                          style: TextStyle(color: AppColors.mediumGreyText, fontSize: AppFontSize.fontSizeExtraSmall, fontWeight: FontWeight.w600,fontFamily: 'arimo',),
                                                        ),
                                                        Text(
                                                          reply.content,
                                                          style: TextStyle(
                                                            color: AppColors.blackText,
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: 'arimo',
                                                            fontSize: AppFontSize.fontSizeSmall,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4.dp),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              getTimeAgo(reply.timestamp),
                                                              style: TextStyle(
                                                                fontFamily: 'arimo',
                                                                color: AppColors.mediumGreyText,
                                                                fontSize: AppFontSize.fontSizeExtraSmall,
                                                              ),
                                                            ),
                                                              SizedBox(width: 8.dp,),
                                                              GestureDetector(
                                                                onTap:() async{
                                                                  bool response = await SocialContentService.deleteReply(widget.content.id, comment.id, reply.id);
                                                                  if(response){
                                                                    setState(() {
                                                                      comment.replies.remove(reply);
                                                                    });
                                                                  }else{
                                                                    showTopPopup(
                                                                      context: context,
                                                                      message: "שגיאה במחיקת תגובה, נסה שוב",
                                                                      imagePath: 'assets/images/warning_icon.png',
                                                                      shouldAddFixedSpace: true,
                                                                    );
                                                                  }
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(Icons.delete, size: AppFontSize.fontSizeExtraSmall, color: AppColors.redColor,),
                                                                    SizedBox(width: 4.dp,),
                                                                    Text(
                                                                      "    ",
                                                                      style: TextStyle(
                                                                        fontFamily: 'arimo',
                                                                        color: AppColors.redColor,
                                                                        fontSize: AppFontSize.fontSizeExtraSmall,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.favorite,
                                                          color: isLikedReply ? AppColors.redColor : AppColors.superLightPurple,
                                                          size: 16.dp,
                                                        ),
                                                        SizedBox(height: 4.dp,),
                                                        if(getLikesCountReply(reply) != "0")
                                                          Text(getLikesCountReply(reply), style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.primeryColortext),)
                                                      ],
                                                    )
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ],
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: isLiked ? AppColors.redColor : AppColors.superLightPurple,
                                      size: 16.dp,
                                    ),
                                    SizedBox(height: 4.dp,),
                                    if(getLikesCount(comment) != "0")
                                      Text(getLikesCount(comment), style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.primeryColortext),)
                                  ],
                                )
                            ),
                          );
                        },
                      )
                          : Center(
                        child: Column(
                          children: [
                            Text(
                              " אין תגובות עדיין...",
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: AppFontSize.fontSizeRegular, color: AppColors.blackText),
                            ),
                            SizedBox(height: 2.dp,),
                            Text(
                              "הגב כדי להתחיל שיחה",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.mediumGreyText, fontFamily: 'arimo',),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.dp),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String getLikesCount(Comment comment) {
    if(comment.likedByUserIds.length > 1000){
      return (comment.likedByUserIds.length / 1000).toStringAsFixed(1)+"k";
    }
    return comment.likedByUserIds.length.toString();
  }

  String getLikesCountReply(Reply reply) {
    if(reply.likedByUserIds.length > 1000){
      return (reply.likedByUserIds.length / 1000).toStringAsFixed(1)+"k";
    }
    return reply.likedByUserIds.length.toString();
  }

  String getInitials(String name) {
    // Split the name into parts based on spaces
    List<String> nameParts = name.split(" ");

    // Ensure there are at least two parts (first name and last name)
    if (nameParts.length < 2) {
      return name.isNotEmpty ? name[0].toUpperCase() : "";
    }

    // Get the first letter of the first name and the first letter of the last name
    String initials = nameParts[0][0].toLowerCase() + nameParts[1][0].toLowerCase();

    return initials;
  }

  String getInitialsUserNameTitle(String name) {
    // Split the name into parts based on spaces
    List<String> nameParts = name.split(" ");

    // Ensure there are at least two parts (first name and last name)
    if (nameParts.length < 2) {
      return name.isNotEmpty ? name[0].toUpperCase() : "";
    }

    // Get the first letter of the first name and the first letter of the last name
    String initials = nameParts[0].toLowerCase() +" "+ nameParts[1][0].toLowerCase();

    return initials;
  }

  String getTimeAgo(String timestamp) {
    DateTime? commentTime = DateTime.tryParse(timestamp);
    if (commentTime == null) {
      return "תאריך לא חוקי"; // Return a fallback message in case of parsing error
    }
    final Duration difference = DateTime.now().difference(commentTime);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} דקות";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} שעות";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} ימים";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} חודשים";
    } else {
      return "${(difference.inDays / 365).floor()} שנים";
    }
  }

}