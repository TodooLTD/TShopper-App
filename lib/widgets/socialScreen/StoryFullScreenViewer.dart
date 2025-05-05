import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/widgets/socialScreen/SocialHelpers.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../models/socialContenct/Comment.dart';
import '../../models/socialContenct/SocialContent.dart';
import '../popup/BottomPopup.dart';
import 'ShoppersCommentsBottomSheet.dart';

class StoryFullScreenViewer extends StatefulWidget {
  final List<SocialContent> stories;
  final int initialIndex;

  const StoryFullScreenViewer({required this.stories, required this.initialIndex});

  @override
  State<StoryFullScreenViewer> createState() => _StoryFullScreenViewerState();
}

class _StoryFullScreenViewerState extends State<StoryFullScreenViewer> {
  late PageController verticalController;
  late List<PageController> horizontalControllers;

  @override
  void initState() {
    super.initState();
    verticalController = PageController(initialPage: widget.initialIndex);
    horizontalControllers = widget.stories.map((_) => PageController()).toList();
  }

  @override
  void dispose() {
    verticalController.dispose();
    for (var controller in horizontalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: verticalController,
        scrollDirection: Axis.vertical,
        itemCount: widget.stories.length,
        itemBuilder: (context, storyIndex) {
          final story = widget.stories[storyIndex];
          final pageController = horizontalControllers[storyIndex];

          return SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: story.urls.length,
                  itemBuilder: (context, imgIndex) {
                    return Image.network(
                      story.urls[imgIndex],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                ),
                Positioned(
                  bottom: 100.dp,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: story.urls.length,
                      effect: WormEffect(
                        dotColor: Colors.white30,
                        activeDotColor: Colors.white,
                        dotHeight: 6.dp,
                        dotWidth: 6.dp,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40.dp,
                  right: 20.dp,
                  child: Row(
                    children: [
                      Container(
                        width: 50.dp,
                        height: 50.dp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              colorMap[TShopper.instance.color] ?? AppColors.mediumGreyText,
                              (getGradientColor(TShopper.instance.color)),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: TShopper.instance.imageUrl.isEmpty ? Text(
                            TShopper.instance.firstName[0]+TShopper.instance.lastName[0],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'todoFont',
                              fontSize: 24.dp,
                              color: AppColors.whiteText,
                              fontWeight: FontWeight.w800,
                            ),
                          ) : Image.network(TShopper.instance.imageUrl,
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: 8.dp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${TShopper.instance.firstName} | ${TShopper.instance.type}",
                            style: TextStyle(
                              fontFamily: 'todofont',
                              fontSize: 20.dp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: 2.dp,),
                          Text(
                            story.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'arimo',
                              fontSize: 13.dp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ),
                //likes, comments, views
                Positioned(
                  bottom: 220.dp,
                  left: 20.dp,
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 40.dp,
                      ),
                      SizedBox(height: 4.dp,),
                      Text(getLikesCount(story), style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.white),)
                    ],
                  ),
                ),
                Positioned(
                  bottom: 160.dp,
                  left: 20.dp,
                  child: GestureDetector(
                    onTap: (){
                      _showCommentsBottomSheet(context, story);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/chatImage.png",
                          height: 35.dp,
                          width: 35.dp,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 4.dp),
                        Text(
                          getCommentsCount(story),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'arimo',
                            fontSize: AppFontSize.fontSizeExtraSmall,
                            color: AppColors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100.dp,
                  left: 20.dp,
                  child: Column(
                    children: [
                      Image.asset("assets/images/playImage.png", height: 35.dp, width: 35.dp, fit: BoxFit.contain,),
                      SizedBox(height: 4.dp,),
                      Text(story.viewedByUserIds.length.toString(), style: TextStyle(fontWeight: FontWeight.w600,
                          fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.white),)
                    ],
                  ),
                ),
                Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.iconLightGrey,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, SocialContent content) {
    final TextEditingController _commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.dp)),
      ),
      builder: (context) {
        return ShoppersCommentsBottomSheet(
          content: content,
          commentController: _commentController,
        );
      },
    );
  }

  String getLikesCount(SocialContent story) {
    if(story.likeByUserIds.length > 1000){
      return (story.likeByUserIds.length / 1000).toStringAsFixed(1)+"k";
    }
    return story.likeByUserIds.length.toString();
  }

  String getCommentsCount(SocialContent story) {
    int count = 0;
    count += story.comments.length;
    for(Comment c in story.comments){
      count += c.replies.length;
    }
    return count.toString();
  }

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
    'lightPink': Colors.pink[100]!,
    'brown': Colors.brown,
    'black': Colors.black,
  };
}
