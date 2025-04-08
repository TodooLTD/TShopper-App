import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:shimmer/shimmer.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';


class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.text,
    this.nextLine = "",
    required this.onPressed,
    this.width,
    this.shimmer = false,
    this.hideBackgroundElements = false,
    this.backgroundColor,
    this.foregroundColor = AppColors.whitePerm,
  });

  final double? width;
  final String text;
  final String nextLine;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color foregroundColor;
  final bool shimmer;
  final bool hideBackgroundElements;

  @override
  Widget build(BuildContext context) {
    final Widget buttonLabelWidget = _buildButtonLabel(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (hideBackgroundElements)
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 70.dp,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10.dp),
            ),
          ),
        SizedBox(
          width: width ?? MediaQuery.of(context).size.width * 0.90,
          height: nextLine.isNotEmpty
              ? 60.dp
              : 50.dp, // Dynamically adjust height here too
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor ?? AppColors.primeryColor,
              padding: EdgeInsets.symmetric(
                  vertical: nextLine.isNotEmpty
                      ? 10.dp
                      : 17.dp), // Adjust padding based on content
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.dp),
              ),
              splashFactory: InkRipple.splashFactory,
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return AppColors.primaryColor.withOpacity(0.1);
                    }
                    return Colors.transparent;
                  }),
            ),
            child: buttonLabelWidget,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonLabel(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmer ? AppColors.lightGreyText : foregroundColor,
      highlightColor: Colors.transparent,
      enabled: shimmer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'arimo',
                fontSize: AppFontSize.fontSizeRegular,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (nextLine.isNotEmpty)
            Flexible(
              // Also wrap this Text in Flexible
              child: Text(
                nextLine,
                style: TextStyle(
                  fontFamily: 'arimo',
                  fontSize: AppFontSize.fontSizeExtraExtraSmall,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
