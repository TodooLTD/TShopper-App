import 'dart:io';

import 'package:flutter_sizer/flutter_sizer.dart';

class AppFontSize {

  static double inputFieldTextFontSize = Platform.isAndroid ? 12.5.dp : 14.dp;
  static double regularFontSize = Platform.isAndroid ? 11.5.dp : 13.dp;
  static double smallerFontSize = Platform.isAndroid ? 10.5.dp : 12.dp;
  static double smallFontSize = Platform.isAndroid ? 10.5.dp : 11.dp;
  static double extraSmallFontSize = Platform.isAndroid ? 9.5.dp : 10.dp;

  static double fontSizeSuperTitle = 27;
  static double fontSizeTitle = 17;
  static double fontSizeRegular = 15;
  static double fontSizeMedium = 14.5;
  static double fontSizeSmall = 14;
  static double fontSizeMiddleSmall = 13;
  static double fontSizeExtraSmall = 12;
  static double fontSizeExtraExtraSmall = 10;
  static double fontSizeExtraExtraExtraSmall = 7;
  static double fontSizeIconSmall = 20;
  static double fontSizeIconTextBig = 22;
  static double fontSizeMegaSmall = 6;

  // Login & Registration related widgets/pages
  static double mainPageTitle = Platform.isAndroid ? 21.dp : 23.dp;
  static double pageSubTitle = Platform.isAndroid ? 19.dp : 22.dp;
  static double formTextMedium = Platform.isAndroid ? 14.dp : 17.dp;
  static double inputFieldText = Platform.isAndroid ? 14.dp : 17.dp;
  static double popUpDescriptionText = Platform.isAndroid ? 13.5.dp : 17.dp;
  static double checkBoxText = Platform.isAndroid ? 13.dp : 15.dp;
  static double formDescriptionTextBig = Platform.isAndroid ? 11.dp : 12.dp;
  static double formDescriptionTextMedium =
  Platform.isAndroid ? 10.5.dp : 12.dp;

  // restaurant menu
  static double iconBigSize = Platform.isAndroid ? 24.sp : 28.sp;
  static double iconBiggerSize = Platform.isAndroid ? 28.sp : 32.sp;
  static double fontSizeMediumTitle = Platform.isAndroid ? 19.sp : 23.sp;

  static const double circularRadiusVal = 15;

  //roni
  static double title = Platform.isAndroid ? 18.sp : 22.sp;
  static double mediumTitle = Platform.isAndroid ? 15.sp : 19.sp;
  static double smallTitle = Platform.isAndroid ? 14.sp : 16.sp;
  static double descriptionText = Platform.isAndroid ? 10.sp : 12.sp;
  static double priceText = Platform.isAndroid ? 14.sp : 16.sp;

}
