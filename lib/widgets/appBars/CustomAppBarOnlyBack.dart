import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';


class CustomAppBarOnlyBack extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Function onBackTap;
  final String title;
  final bool isButton;

  const CustomAppBarOnlyBack({
    super.key,
    required this.backgroundColor,
    required this.onBackTap,
    required this.title,
    required this.isButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: isButton ? Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.iconLightGrey,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 22.dp,
          color: AppColors.whiteText,
          onPressed: () => onBackTap(),
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
        ),
      ) : Container(),
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontFamily: 'arimo',
            color: AppColors.blackText,
            fontSize: AppFontSize.fontSizeTitle,
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
