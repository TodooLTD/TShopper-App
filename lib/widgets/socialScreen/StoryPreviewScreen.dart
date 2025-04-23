import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tshopper_app/models/socialContenct/SocialContent.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/sevices/ImageService.dart';
import 'package:tshopper_app/sevices/SocialContentService.dart';
import 'package:tshopper_app/widgets/popup/BottomPopup.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../appBars/CustomAppBarOnlyBack.dart';

class StoryPreviewScreen extends StatefulWidget {
  final List<XFile> selectedImages;

  const StoryPreviewScreen({super.key, required this.selectedImages});

  @override
  State<StoryPreviewScreen> createState() => _StoryPreviewScreenState();
}

class _StoryPreviewScreenState extends State<StoryPreviewScreen> {
  List<XFile> images = [];
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    images = List<XFile>.from(widget.selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: CustomAppBarOnlyBack(
          title: '',
          backgroundColor: AppColors.whiteText,
          onBackTap: () => Navigator.pop(context),
          isButton: true,
        ),
        body: isLoading ?
        Container(
          color: AppColors.whiteText,
          child: Center(
            child: CupertinoActivityIndicator(
              animating: true,
              color: AppColors.blackText,
              radius: 8.dp,
            ),
          ),
        ) : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal image scroll
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.dp),
                child: Text("העלאת סטורי", style: TextStyle(fontSize: 24.dp, fontFamily: 'todofont', fontWeight: FontWeight.w800, color: AppColors.blackText),),
              ),
              Container(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image.file(
                            File(images[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 3.dp,
                          right: 3.dp,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: const CircleAvatar(
                              backgroundColor: AppColors.iconLightGrey,
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),

              // Text input
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(8.dp),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    autofocus: true,
                    maxLines: 6,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onEditingComplete: () {
                      if (context.mounted) {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.dp,
                        vertical: 10.dp,
                      ),
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
              ),
              // Submit button

            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding:  EdgeInsets.only(right: 16.0.dp, left: 16.0.dp, bottom: 30.dp),
          child: GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              List<String> urls = [];
              for(XFile image in widget.selectedImages){
                File file = File(image.path);
                String? url = await ImageService.uploadImageNoCompress(file);
                if(url != null){
                  urls.add(url);
                }
              }
              SocialContent newStory = SocialContent(
                  id: 0,
                  urls: urls,
                  timestamp: "",
                  description: descriptionController.text,
                  type: 'STORY',
                  viewedByUserIds: [],
                  likeByUserIds: [],
                  verified: false,
                  comments: [],
                  shopperId: TShopper.instance.uid,
                  shoppingCenterId: TShopper.instance.currentShoppingCenterId);

              SocialContent? uploaded = await SocialContentService.addContent(newStory);
              setState(() {
                isLoading = false;
              });
              if(uploaded != null){
                showBottomPopup(
                  context: context,
                  message: "סטורי עלה בהצלחה",
                  imagePath: "assets/images/warning_icon.png",
                );
                Navigator.pop(context);
              }

            },
            child: Container(
              height: 50.dp,
              decoration: BoxDecoration(
                color: AppColors.primeryColor,
                borderRadius: BorderRadius.circular(10.dp),
                border: Border.all(
                  color: AppColors.primeryColor,
                  width: 1.dp,
                ),
              ),
              child: Center(child: Text("שתף", style:
              TextStyle(fontSize: 13.dp,  fontFamily: 'arimo', fontWeight: FontWeight.w800, color: AppColors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
