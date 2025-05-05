import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../constants/AppFontSize.dart';
import '../../constants/AppColors.dart';
import '../../models/socialContenct/SocialContent.dart';
import '../../models/tshopper/TShopper.dart';
import '../../sevices/ImageService.dart';
import '../../sevices/SocialContentService.dart';
import '../appBars/CustomAppBarOnlyBack.dart';
import '../popup/BottomPopup.dart';

class ReelPreviewScreen extends StatefulWidget {
  final XFile videoFile;
  final Function(SocialContent) onUploaded;

  const ReelPreviewScreen({super.key, required this.videoFile, required this.onUploaded});

  @override
  State<ReelPreviewScreen> createState() => _ReelPreviewScreenState();
}

class _ReelPreviewScreenState extends State<ReelPreviewScreen> {
  late VideoPlayerController _videoController;
  bool isLoading = false;
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.whiteText,
        appBar: CustomAppBarOnlyBack(
          title: '',
          backgroundColor: AppColors.whiteText,
          onBackTap: () => Navigator.pop(context),
          isButton: true,
        ),
        body: isLoading
            ? Center(
          child: CupertinoActivityIndicator(
            animating: true,
            color: AppColors.blackText,
            radius: 8.dp,
          ),
        )
            : Padding(
          padding: EdgeInsets.all(12.dp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("העלאת ריל", style: TextStyle(fontSize: 24.dp, fontFamily: 'todofont', fontWeight: FontWeight.w800, color: AppColors.blackText)),
                SizedBox(height: 12.dp),
                Center(
                  child: SizedBox(
                    height: 450.dp,
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.dp),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_videoController),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _videoController.value.isPlaying
                                      ? _videoController.pause()
                                      : _videoController.play();
                                });
                              },
                              child: Icon(
                                _videoController.value.isPlaying
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline,
                                color: Colors.white,
                                size: 50.dp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.dp),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(8.dp),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    autofocus: false,
                    maxLines: 6,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 10.dp),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontFamily: 'arimo',
                      fontSize: AppFontSize.fontSizeRegular,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackText,
                    ),
                  ),
                ),
                SizedBox(height: 250.dp),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(right: 16.dp, left: 16.dp, bottom: 30.dp),
          child: GestureDetector(
            onTap: () async {
              setState(() => isLoading = true);
              Uint8List videoBytes = await File(widget.videoFile.path).readAsBytes();
              String? url = await ImageService.convertVideoToUrl(videoBytes);
              if (url != null) {
                SocialContent reel = SocialContent(
                  id: 0,
                  urls: [url],
                  timestamp: "",
                  description: descriptionController.text,
                  type: 'REEL',
                  viewedByUserIds: [],
                  likeByUserIds: [],
                  verified: false,
                  comments: [],
                  shopperId: TShopper.instance.uid,
                  shoppingCenterId: TShopper.instance.currentShoppingCenterId,
                );
                SocialContent? uploaded = await SocialContentService.addContent(reel);
                setState(() => isLoading = false);
                if (uploaded != null) {
                  showBottomPopup(
                    context: context,
                    message: "ריל הועלה בהצלחה",
                    imagePath: "assets/images/warning_icon.png",
                  );
                  widget.onUploaded(uploaded);
                  Navigator.pop(context);
                }
              } else {
                showBottomPopup(
                  context: context,
                  message: "שגיאה בהעלאת ריל, נסה שוב",
                  imagePath: "assets/images/warning_icon.png",
                );
                setState(() => isLoading = false);
              }
            },
            child: Container(
              height: 50.dp,
              decoration: BoxDecoration(
                color: AppColors.primeryColor,
                borderRadius: BorderRadius.circular(10.dp),
              ),
              child: Center(
                child: Text("שתף", style: TextStyle(fontSize: 13.dp, fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
