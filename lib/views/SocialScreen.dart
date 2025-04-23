import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/sevices/SocialContentService.dart';
import 'package:tshopper_app/widgets/socialScreen/ReelPreviewScreen.dart';
import '../../../constants/AppFontSize.dart';
import '../../constants/AppColors.dart';
import '../../widgets/appBars/CustomAppBar.dart';
import '../main.dart';
import '../models/socialContenct/SocialContent.dart';
import '../sevices/ImageService.dart';
import '../widgets/overlayMenu/OverlayMenu.dart';
import '../widgets/popup/BottomPopup.dart';
import '../widgets/socialScreen/SmallReelPlayer.dart';
import '../widgets/socialScreen/StoryPreviewScreen.dart';

class SocialScreen extends ConsumerStatefulWidget {
  SocialScreen({super.key});
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  final OverlayMenu overlayMenu = OverlayMenu();
  int selectedIndex = 0;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _videoFile;
  List<SocialContent> contents = [];
  List<SocialContent> reels = [];
  List<SocialContent> stories = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    overlayMenu.init(context, this);
    fetchSocialContent();
  }

  Future<void> fetchSocialContent() async{
    setState(() {
      isLoading = true;
    });
    contents = await SocialContentService.getByTypeAndShopper(type: 'REEL', shopperId: TShopper.instance.uid);
    List<SocialContent> stories = await SocialContentService.getByTypeAndShopper(type: 'STORY', shopperId: TShopper.instance.uid);
    contents.addAll(stories);

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
    reels = contents.where((c) => c.type == 'REEL').toList();
    stories = contents.where((c) => c.type == 'STORY').toList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteText,
      appBar: CustomAppBar(
        backgroundColor: AppColors.whiteText,
        noBackButton: false,
          onMenuTap: () => overlayMenu.showOverlay(4)
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.dp),
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: isLoading
                    ? Center(
                  child: CupertinoActivityIndicator(
                    animating: true,
                    color: AppColors.primeryColor,
                    radius: 15.dp,
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // BusinessCircularLogo(business: BusinessSummary.instance),
                    // SizedBox(height: 8.dp),
                    // Text(
                    //   translate(BusinessSummary.instance.name),
                    //   style: TextStyle(
                    //     fontFamily: 'todofont',
                    //     fontWeight: FontWeight.w700,
                    //     fontSize: 18.dp,
                    //     color: AppColors.blackText,
                    //   ),
                    // ),
                    SizedBox(height: 16.dp),
                    Container(
                      height: 32.dp,
                      margin: EdgeInsets.symmetric(horizontal: 8.dp),
                      decoration: BoxDecoration(
                        color: isLightMode
                            ? AppColors.primaryLightColor
                            : AppColors.backgroundColor,
                        borderRadius:
                        BorderRadius.circular(AppFontSize.circularRadiusVal),
                      ),
                      child: Row(
                        children: [
                          _buildToggleButton(
                            "סטורי",
                            count: stories.length,
                            isSelected: selectedIndex == 0,
                            onSelect: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                          ),
                          _buildToggleButton(
                            "רילס",
                            count: reels.length,
                            isSelected: selectedIndex == 1,
                            onSelect: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.dp),
                    if (selectedIndex == 0) _buildStoryGrid(),
                    if (selectedIndex == 1) _buildReelsGrid(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30.dp,
              left: 10.dp,
              child: InkWell(
                onTapDown: (TapDownDetails details) {
                  _showPopupMenu(context, details.globalPosition);
                },
                child: Material(
                  elevation: 6.dp,
                  shape: const CircleBorder(),
                  shadowColor: AppColors.mediumGreyText,
                  child: Container(
                    width: 50.dp,
                    height: 50.dp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.backgroundColor,
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: AppColors.primeryColor, size: 40.dp),
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, Offset position) async {
    await showMenu(
      color: AppColors.backgroundColor,
      elevation: isLightMode ? 4.dp : 0,
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx + 1, position.dy + 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Set your border radius here
      ),
      items: [
        PopupMenuItem(
            child: Text("הוסף סטורי", style: TextStyle(fontFamily: 'arimo',fontSize: AppFontSize.fontSizeExtraSmall, fontWeight: FontWeight.w900, color: AppColors.blackText),),
            onTap: () async {
              _showImagePicker(context);
            }
        ),
        PopupMenuItem(
            child: Text('הוסף ריל', style: TextStyle(fontFamily: 'arimo',fontSize: AppFontSize.fontSizeExtraSmall, fontWeight: FontWeight.w900, color: AppColors.blackText),),
            onTap: () async {
              _pickVideo();
            }
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        // Handle Edit
        print("Edit Clicked");
      } else if (value == 'delete') {
        // Handle Delete
        print("Delete Clicked");
      }
    });
  }

  Future<void> _showImagePicker(BuildContext context) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();

      if (images.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryPreviewScreen(selectedImages: images),
          ),
        );
      }
    } catch (e) {
      showBottomPopup(
        context: context,
        message: "שגיאה בבחירת תמונות: ${e.toString()}",
        imagePath: "assets/images/warning_icon.png",
      );
    }
  }


  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        if (video.name.endsWith('.MOV')) {
          setState(() {
            _videoFile = video;
          });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReelPreviewScreen(videoFile: video),
              ),
            );
        } else {
          showBottomPopup(
            context: context,
            message: "Please select an MP4 file.",
            imagePath: "assets/images/warning_icon.png",
          );
        }
      }
    } catch (e) {
      showBottomPopup(
        context: context,
        message: "Failed to pick video: ${e.toString()}",
        imagePath: "assets/images/warning_icon.png",
      );
    }
  }


  // Future<void> _uploadAndCreateReel() async {
  //   if (_videoFile == null) {
  //     showBottomPopup(
  //       context: context,
  //       message: "Please select a video first.",
  //       imagePath: "assets/images/warning_icon.png",
  //     );
  //     return;
  //   }
  //
  //   String videoPath = _videoFile!.path;
  //
  //   // Upload the video
  //   try {
  //     Uint8List videoBytes = await File(videoPath).readAsBytes();
  //     String videoUrl = await ImageService.convertVideoToUrl(videoBytes);
  //     if (videoUrl.isNotEmpty) {
  //       // Create the reel
  //       Reel? success = await ReelService.addReel(
  //           Reel(
  //               id: 0,
  //               reelUrl: videoUrl,
  //               timestamp: "",
  //               viewedByUserIds: [],
  //               likeByUserIds: [],
  //               verified: false,
  //               comments: [],
  //               ));
  //
  //       if (success != null) {
  //         setState(() {
  //           BusinessSummary.instance.reels.add(success);
  //         });
  //         showBottomPopup(
  //           context: context,
  //           message: "הריל עלה בהצלחה וממתין לאישור הצוות!💜",
  //           imagePath: "assets/images/warning_icon.png",
  //         );
  //       }
  //     } else {
  //       throw Exception("Video upload failed.");
  //     }
  //   } catch (e) {
  //     showBottomPopup(
  //       context: context,
  //       message: "שגיאה בהעלאת ריל. נסה שוב🙏🏻",
  //       imagePath: "assets/images/warning_icon.png",
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Widget _buildStoryGrid() {
  //   return Padding(
  //     padding:  EdgeInsets.symmetric(horizontal: 10.0.dp),
  //     child: GridView.builder(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 10.dp,
  //         mainAxisSpacing: 10.dp,
  //         childAspectRatio: 0.6,
  //       ),
  //       itemCount: stories.length,
  //       itemBuilder: (context, index) {
  //         SocialContent story = stories[index];
  //         return Stack(
  //           clipBehavior: Clip.none,
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(8.dp),
  //               child: Image.network(
  //                 story.urls.first,
  //                 width: double.infinity,
  //                 height: double.infinity,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             Positioned(
  //               bottom: 8.dp,
  //               right: 8.dp,
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.remove_red_eye_outlined, color: AppColors.white, size: 16.dp,),
  //                   SizedBox(width: 8.dp,),
  //                   Text(
  //                     story.viewedByUserIds.length.toString(),
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 13.dp,
  //                         fontFamily: 'arimo'
  //                     ),
  //                   ),
  //                 ],
  //               ),),
  //
  //             if (!story.verified)
  //               Container(
  //                 decoration: BoxDecoration(
  //                   color: Colors.black.withOpacity(0.5),
  //                   borderRadius: BorderRadius.circular(8.dp),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     "ממתין לאישור",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 14.dp,
  //                       fontFamily: 'arimo'
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             Positioned(
  //               top: -7.dp,
  //               left: -9.dp,
  //               child: GestureDetector(
  //                 onTap: (){
  //                   showAreYouSurePopup(context, story);
  //                 },
  //                 child: Container(
  //                   width: 26.dp,
  //                   height: 26.dp,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: Colors.red,
  //                   ),
  //                   child: Center(
  //                       child: Icon(Icons.remove, color: Colors.white, size: 26.dp)
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildStoryGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.dp),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.dp,
          mainAxisSpacing: 10.dp,
          childAspectRatio: 0.6,
        ),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          SocialContent story = stories[index];
          PageController pageController = PageController();

          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.dp),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: story.urls.length,
                      itemBuilder: (_, imgIndex) {
                        return Image.network(
                          story.urls[imgIndex],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 6.dp,
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
                  ],
                ),
              ),
              Positioned(
                bottom: 8.dp,
                right: 8.dp,
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, color: AppColors.white, size: 16.dp),
                    SizedBox(width: 8.dp),
                    Text(
                      story.viewedByUserIds.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.dp,
                        fontFamily: 'arimo',
                      ),
                    ),
                  ],
                ),
              ),
              if (!story.verified)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.dp),
                  ),
                  child: Center(
                    child: Text(
                      "ממתין לאישור",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.dp,
                        fontFamily: 'arimo',
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: -7.dp,
                left: -9.dp,
                child: GestureDetector(
                  onTap: () {
                    showAreYouSurePopup(context, story);
                  },
                  child: Container(
                    width: 26.dp,
                    height: 26.dp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Icon(Icons.remove, color: Colors.white, size: 26.dp),
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

  void showAreYouSurePopup(BuildContext context, SocialContent? content) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.dp))),
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("האם אתה בטוח שאתה רוצה למחוק?", style: TextStyle( fontFamily: 'arimo',
                    fontWeight: FontWeight.w600, fontSize: 14.dp, color: AppColors.blackText
                ),)
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:  EdgeInsets.only(left: 4.0.dp),
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          _deleteContent(content!);
                        });
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.whiteText,
                        backgroundColor: AppColors.primeryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.dp, vertical: 15.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.dp),
                        ),
                      ),
                      child: Text(
                        "אישור",
                        style: TextStyle(
                            fontSize: AppFontSize.fontSizeRegular,
                            fontFamily: 'arimo',
                            color: AppColors.white,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:  EdgeInsets.only(right: 4.0.dp),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.whiteText,
                        backgroundColor: AppColors.superLightPurple,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.dp, vertical: 15.dp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.dp),
                        ),
                      ),
                      child: Text(
                        "ביטול",
                        style: TextStyle(
                            fontSize: AppFontSize.fontSizeRegular,
                            fontFamily: 'arimo',
                            color: AppColors.primeryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  Widget _buildReelsGrid() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.0.dp),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.dp,
          mainAxisSpacing: 10.dp,
          childAspectRatio: 0.6,
        ),
        itemCount: reels.length,
        itemBuilder: (context, index) {
          SocialContent reel = reels[index];
          return GestureDetector(
            onTap: (){
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => FullscreenVideoPlayer(reel: reel, onDelete: (Reel reel) async {
              //       bool response = await ReelService.deleteReel(reel.id);
              //       if(response){
              //         setState(() {
              //           BusinessSummary.instance.reels.remove(reel);
              //         });
              //       }
              //     },),
              //   ),
              // );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.dp),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                    child: SmallReelPlayer(reel: reel,),
                  ),
                ),
                Positioned(
                  bottom: 8.dp,
                  right: 8.dp,
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, color: AppColors.white, size: 16.dp,),
                      SizedBox(width: 4.dp,),
                      Text(
                        reel.viewedByUserIds.length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.dp,
                            fontFamily: 'arimo'
                        ),
                      ),
                      SizedBox(width: 16.dp,),
                      Icon(Icons.heart_broken, color: AppColors.white, size: 16.dp,),
                      SizedBox(width: 4.dp,),
                      Text(
                        reel.likeByUserIds.length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.dp,
                            fontFamily: 'arimo'
                        ),
                      ),
                      SizedBox(width: 16.dp,),
                      Icon(Icons.chat, color: AppColors.white, size: 16.dp,),
                      SizedBox(width: 4.dp,),
                      Text(
                        reel.comments.length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.dp,
                            fontFamily: 'arimo'
                        ),
                      ),
                    ],
                  ),
                ),
                if (!reel.verified)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                    child: Center(
                      child: Text(
                        "ממתין לאישור",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.dp,
                            fontFamily: 'arimo'
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: -7.dp,
                  left: -9.dp,
                  child: GestureDetector(
                    onTap: (){
                      showAreYouSurePopup(context, reel);
                    },
                    child: Container(
                      width: 26.dp,
                      height: 26.dp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Icon(Icons.remove, color: Colors.white, size: 26.dp)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteContent(SocialContent content) async {
    bool response = await SocialContentService.deleteContent(content.id);
    if (response) {
      setState(() {
        contents.remove(content);
      });
    } else {
    }
  }

  Widget _buildToggleButton(
      String title, {
        int count = 0,
        bool isSelected = false,
        void Function()? onSelect,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: onSelect,
        child: Card(
          color: isSelected ? AppColors.whiteText : AppColors.transparentPerm,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.dp),
          ),
          child: Container(
            margin: EdgeInsets.all(4.dp),
            decoration: isSelected
                ? BoxDecoration(
              color: AppColors.whiteText,
              borderRadius: BorderRadius.circular(10.dp),
            )
                : null,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSize.fontSizeExtraSmall,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? AppColors.blackText
                        : isLightMode ? AppColors.oppositeBackgroundColor : AppColors.blackText,
                    fontFamily: 'Arimo',
                  ),
                ),
                if(count != 0)...[
                  SizedBox(width: 8.dp,),
                  Text(
                    "( $count )",
                    style: TextStyle(
                      fontSize: AppFontSize.fontSizeExtraSmall,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? AppColors.blackText
                          : isLightMode ? AppColors.oppositeBackgroundColor : AppColors.blackText,
                      fontFamily: 'Arimo',
                    ),
                  ),
                  // Container(
                  //   width: 20.dp,
                  //   height: 20.dp,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.blackText,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     '$count', // Show the amount
                  //     style: TextStyle(
                  //         color:AppColors.whiteText,
                  //         fontSize: AppFontSize.fontSizeExtraSmall,
                  //         fontWeight: FontWeight.w800,
                  //         fontFamily: 'arimo'
                  //     ),
                  //   ),
                  // ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration commonInputDecoration(String labelText, bool isIcon) {
    return InputDecoration(
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.dp),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      labelText: translate(labelText),
      errorStyle: const TextStyle(
        color: AppColors.mediumGreyText,
        fontSize: 0,
        fontFamily: 'arimo',
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        color: AppColors.mediumGreyText,
        fontSize: AppFontSize.fontSizeExtraSmall,
        fontFamily: 'arimo',
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: isIcon
          ? Padding(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          width: 20.0.dp,
          height: 20.0.dp,
          child: const Icon(
            Icons.search,
            color: AppColors.mediumGreyText,
          ),
        ),
      )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.dp),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
    );
  }


  String getOpeningHoursDay(int index){
    if(index == 0){
      return "יום ראשון";
    }
    if(index == 1){
      return "יום שני";
    }
    if(index == 2){
      return "יום שלישי";
    }
    if(index == 3){
      return "יום רביעי";
    }
    if(index == 4){
      return "יום חמישי";
    }
    if(index == 5){
      return "יום שישי";
    }
    if(index == 6){
      return "יום שבת";
    }
    return "";
  }

}
