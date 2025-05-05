import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';


import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';

void showBottomPopup({
  required BuildContext context,
  required String message,
  required String imagePath,
  bool shouldAddFixedSpace = false,
  Duration? duration,
}) {
  const Duration defaultDuration = Duration(seconds: 2);



  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation:0,
      duration: duration ?? defaultDuration,
      backgroundColor: AppColors.backgroundGreyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.dp),
      ),
      content: Row(
        children: [
          Image.asset(
            imagePath,
            width: 24.dp,
            height: 24.dp,
          ),
          SizedBox(width: 8.dp),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: AppColors.blackText,
                  fontFamily: 'arimo',
                  fontWeight: FontWeight.w400,
                  fontSize: AppFontSize.fontSizeRegular
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: shouldAddFixedSpace ? 100.dp : 20.dp,
          right: 10.dp,
          left: 10.dp),
    ),
  );
}
void showTopPopup({
  required BuildContext context,
  required String message,
  required String imagePath,
  bool shouldAddFixedSpace = false,
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: shouldAddFixedSpace ? (Platform.isAndroid ? 90.dp : 55.dp) : 50.dp,
      left: 10.dp,
      right: 10.dp,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(8.dp),
          decoration: BoxDecoration(
            color: AppColors.backgroundGreyColor,
            borderRadius: BorderRadius.circular(15.dp),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 24.dp,
                height: 24.dp,
              ),
              SizedBox(width: 8.dp),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.blackText,
                    fontFamily: 'arimo',
                    fontWeight: FontWeight.w400,
                    fontSize: AppFontSize.fontSizeRegular,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert overlay entry
  overlay?.insert(overlayEntry);

  // Remove overlay entry after the duration
  Future.delayed(duration, () => overlayEntry.remove());
}