import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';

class DisabledTextFieldWidget extends StatelessWidget {
  const DisabledTextFieldWidget({
    super.key,
    required this.text,
    this.fontWeight,
    this.textColor,
    this.borderColor,
    this.prefixIconImagePath,
    this.onPressed,
    this.fontSize,
    this.shouldBeIcon = false
  });

  final String text;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? borderColor;
  final String? prefixIconImagePath;
  final double? fontSize;
  final Function()? onPressed;
  final bool? shouldBeIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.dp,
      child: InkWell(
        onTap: onPressed,  // Apply the onTap function to the entire card
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(
              fontFamily: 'arimo',
              fontSize: 12.dp,
              color: AppColors.blackText,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: prefixIconImagePath == null
                ? null
                : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 12.0.dp,
                height: 12.0.dp,
                child: Image.asset(prefixIconImagePath ?? ''),
              ),
            ),
            suffixIcon: onPressed != null || (shouldBeIcon ?? true) ? Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.blackText,
              size: 12.dp,
            ) : null,
            disabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(12.dp),
              borderSide:
              BorderSide(color: borderColor ?? AppColors.borderColor),
            ),
          ),
        ),
      ),
    );
  }
}
