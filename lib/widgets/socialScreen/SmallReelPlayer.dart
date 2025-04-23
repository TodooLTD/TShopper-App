import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tshopper_app/models/socialContenct/SocialContent.dart';
import 'package:video_player/video_player.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../models/socialContenct/Comment.dart';
class SmallReelPlayer extends StatefulWidget {
  final SocialContent reel;

  const SmallReelPlayer({Key? key, required this.reel}) : super(key: key);

  @override
  _SmallReelPlayerState createState() => _SmallReelPlayerState();
}

class _SmallReelPlayerState extends State<SmallReelPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.reel.urls.first)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
        _controller.setVolume(0.0);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.black,
      ),
      child: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Center(child: CupertinoActivityIndicator(
        animating: true,
        color: AppColors.blackText,
        radius: 15.dp,
      ),),
    );
  }
}

class FullScreenReelScreen extends StatelessWidget {
  final SocialContent reel;

  const FullScreenReelScreen({Key? key, required this.reel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class FullscreenVideoPlayer extends ConsumerStatefulWidget {
  SocialContent reel;
  final Function(SocialContent reel)? onDelete;

  FullscreenVideoPlayer({
    super.key,
    required this.reel,
    required this.onDelete,
  });

  @override
  _FullscreenVideoPlayerState createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends ConsumerState<FullscreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool isMuted = true;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.reel.urls.first)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
    _controller.setVolume(0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _controller.setVolume(isMuted ? 0.0 : 1.0);
    });
  }

  void togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isLiked = false;

    return _controller.value.isInitialized ? Stack(
      children: [
        // GestureDetector to pause/play on tap
        GestureDetector(
            onTap: togglePlayPause,
            child:SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
        ),

        // Mute button in the top-right corner
        Positioned(
          top: 50.dp,
          left: 20,
          child: GestureDetector(
            onTap: toggleMute,
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
        Positioned(
          top: 50.dp,
          right: 20,
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
        //likes, comments, views
        Positioned(
          bottom: 320.dp,
          left: 20.dp,
          child: GestureDetector(
            onTap: () async{
              widget.onDelete!(widget.reel);
            },
            child: Column(
              children: [
                Icon(
                  Icons.delete,
                  color: AppColors.redColor,
                  size: 40.dp,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 250.dp,
          left: 20.dp,
          child: Column(
            children: [
              Icon(
                Icons.favorite,
                color: isLiked ? AppColors.redColor : Colors.white,
                size: 40.dp,
              ),
              SizedBox(height: 4.dp,),
              Text(getLikesCount(),
                style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.white),)
            ],
          ),
        ),
        Positioned(
          bottom: 190.dp,
          left: 20.dp,
          child: GestureDetector(
            onTap: () {
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
                  getCommentsCount(),
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
          bottom: 120.dp,
          left: 20.dp,
          child: GestureDetector(
            onTap: toggleMute,
            child: Column(
              children: [
                Image.asset("assets/images/playImage.png", height: 35.dp, width: 35.dp, fit: BoxFit.contain,),
                SizedBox(height: 4.dp,),
                Text(widget.reel.viewedByUserIds.length.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'arimo', fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.white),)
              ],
            ),
          ),
        ),
      ],
    ) : Center(child: Container(
      color: AppColors.black,
      child:  Center(
        child:  Center(
          child: CupertinoActivityIndicator(
            animating: true,
            color: AppColors.white,
            radius: 15.dp,
          ),
        ),
      ),
    ));
  }

  final TextEditingController _commentController = TextEditingController();

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


  String getLikesCount() {
    if(widget.reel.likeByUserIds.length > 1000){
      return (widget.reel.likeByUserIds.length / 1000).toStringAsFixed(1)+"k";
    }
    return widget.reel.likeByUserIds.length.toString();
  }


  String getCommentsCount() {
    int count = 0;
    count += widget.reel.comments.length;
    for(Comment c in widget.reel.comments){
      count += c.replies.length;
    }
    return count.toString();
  }
}
