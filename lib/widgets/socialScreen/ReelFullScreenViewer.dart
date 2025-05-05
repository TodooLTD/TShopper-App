import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../models/socialContenct/Comment.dart';
import '../../models/socialContenct/SocialContent.dart';
import '../popup/BottomPopup.dart';
import 'ShoppersCommentsBottomSheet.dart';
import 'SocialHelpers.dart';

class ReelFullScreenViewer extends StatefulWidget {
  final List<SocialContent> reels;
  final int initialIndex;

  const ReelFullScreenViewer({required this.reels, required this.initialIndex});

  @override
  State<ReelFullScreenViewer> createState() => _ReelFullScreenViewerState();
}

class _ReelFullScreenViewerState extends State<ReelFullScreenViewer> {
  late PageController _pageController;
  final List<VideoPlayerController> _videoControllers = [];
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _initVideos();
  }

  void _initVideos() {
    for (int i = 0; i < widget.reels.length; i++) {
      final reel = widget.reels[i];
      final controller = VideoPlayerController.networkUrl(Uri.parse(reel.urls.first));
      controller.setLooping(true);
      controller.initialize().then((_) {
        if (i == widget.initialIndex) {
          controller.play();
        }
        setState(() {});
      });

      _videoControllers.add(controller);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    for (int i = 0; i < _videoControllers.length; i++) {
      if (i == index) {
        _videoControllers[i].play();
      } else {
        _videoControllers[i].pause();
      }
    }
  }

  void togglePlayPause(VideoPlayerController c) {
    setState(() {
      if (c.value.isPlaying) {
        c.pause();
      } else {
        c.play();
      }
    });
  }

  void toggleMute(VideoPlayerController c) {
    setState(() {
      isMuted = !isMuted;
      c.setVolume(isMuted ? 0.0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.reels.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final reel = widget.reels[index];
          final controller = _videoControllers[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              controller.value.isInitialized
                  ?  GestureDetector(
                  onTap: (){
                    togglePlayPause(controller);
                  },
                  child:SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.value.size.width,
                        height: controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                    ),
                  )
              )
                  : Container(
                color: AppColors.black,
                child: Center(
                  child: CupertinoActivityIndicator(
                    animating: true,
                    color: AppColors.white,
                    radius: 15.dp,
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
                          reel.description,
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
                    Text(getLikesCount(reel), style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.white),)
                  ],
                ),
              ),
              Positioned(
                bottom: 160.dp,
                left: 20.dp,
                child: GestureDetector(
                  onTap: (){
                    _showCommentsBottomSheet(context, reel);
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
                        getCommentsCount(reel),
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
                    Text(reel.viewedByUserIds.length.toString(), style: TextStyle(fontWeight: FontWeight.w600,
                        fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.white),)
                  ],
                ),
              ),
              Positioned(
                  top: 50.dp,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  )
              ),
              // Mute button in the top-right corner
              Positioned(
                top: 50.dp,
                right: 20,
                child: GestureDetector(
                  onTap: (){
                    toggleMute(controller);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
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

  String getLikesCount(SocialContent reel) {
    if(reel.likeByUserIds.length > 1000){
      return (reel.likeByUserIds.length / 1000).toStringAsFixed(1)+"k";
    }
    return reel.likeByUserIds.length.toString();
  }

  String getCommentsCount(SocialContent reel) {
    int count = 0;
    count += reel.comments.length;
    for(Comment c in reel.comments){
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
