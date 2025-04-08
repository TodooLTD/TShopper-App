import 'package:flutter/material.dart';

import 'package:flutter_sizer/flutter_sizer.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.backgroundColor,
    required this.title,
    this.subTitle,
    this.onPressed,
    this.titleColor,
    this.fontSize,
  });

  final Color? backgroundColor;
  final Color? titleColor;
  final double? fontSize;
  final String title;
  final String? subTitle;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primeryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.dp),
          ),
          elevation: 0,
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: fontSize ?? AppFontSize.fontSizeExtraSmall,
                fontFamily: 'Arimo',
                color: titleColor ?? AppColors.backgroundColor,
              ),
            ),
            if(subTitle != null && subTitle != "")...[
              SizedBox(height: 2.dp,),
              Text(
                subTitle ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: AppFontSize.fontSizeExtraExtraSmall,
                  fontFamily: 'Arimo',
                  color: titleColor ?? AppColors.backgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ));
  }
}
