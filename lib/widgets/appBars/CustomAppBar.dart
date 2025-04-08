import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';

class CustomAppBar extends riverpod.ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Function()? onMenuTap;
  final Function()? onLocationTap;
  final bool noBackButton;
  final String? title;

  const CustomAppBar({
    super.key,
    this.backgroundColor,
    this.onMenuTap,
    this.onLocationTap,
    this.title,
    this.noBackButton = false,
  });

  @override
  riverpod.ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends riverpod.ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {

    return AppBar(
      iconTheme: IconThemeData(
        color: AppColors.whiteText,
      ),
      backgroundColor: AppColors.whiteText,
      elevation: 0,
      title: widget.title == null
          ? null
          : Text(
        widget.title ?? '',
        style: TextStyle(
            color: AppColors.blackText,
            fontSize: AppFontSize.fontSizeTitle,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              SizedBox(width: 9.5.dp),
              if (!widget.noBackButton)
                GestureDetector(
                  onTap: widget.onMenuTap ?? () => Navigator.pop(context),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.iconLightGrey,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      size: 22.dp,
                      widget.onMenuTap != null ? Icons.menu : Icons.keyboard_arrow_right_sharp,
                      color: AppColors.whiteText,
                    ),
                  ),
                ),
              const Spacer(),
              SizedBox(width: 9.5.dp),
            ],
          ),
        ),
      ],
    );
  }
}