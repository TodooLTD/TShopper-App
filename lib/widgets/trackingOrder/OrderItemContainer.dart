import 'package:flutter/cupertino.dart';
import '../../../constants/AppColors.dart';

class OrderItemContainer extends StatelessWidget {
  const OrderItemContainer(
      {super.key,
        required this.child,
        this.width,
        this.borderRadiusValue = 30,
        this.borderColor});
  final Widget child;
  final double? width;
  final double borderRadiusValue;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(
            color: borderColor ?? AppColors.borderColor,
            width: 1,
          ),
          color: AppColors.backgroundColor),
      child: child,
    );
  }
}
