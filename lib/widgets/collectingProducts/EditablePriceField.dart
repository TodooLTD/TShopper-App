import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../constants/AppColors.dart';

class EditablePriceField extends StatefulWidget {
  final double initialPrice;
  final Function(double) onPriceUpdated;

  const EditablePriceField({
    Key? key,
    required this.initialPrice,
    required this.onPriceUpdated,
  }) : super(key: key);

  @override
  State<EditablePriceField> createState() => _EditablePriceFieldState();
}

class _EditablePriceFieldState extends State<EditablePriceField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late double lastValidPrice;

  @override
  void initState() {
    super.initState();
    lastValidPrice = widget.initialPrice;
    _controller = TextEditingController(text: lastValidPrice.toStringAsFixed(2));
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      } else {
        _savePrice();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _savePrice() {
    final text = _controller.text.trim();
    final parsed = double.tryParse(text);
    print("save price");

    if (parsed == null) {
      _controller.text = lastValidPrice.toStringAsFixed(2);
    } else {
      lastValidPrice = parsed;
      widget.onPriceUpdated(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.dp,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _savePrice(),
          onTap: () {
            if (_controller.text.trim() == '0' || _controller.text.trim() == '0.00') {
              _controller.clear();
            } else {
              _controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controller.text.length,
              );
            }
          },
          onEditingComplete: _savePrice,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 14.dp, horizontal: 8.dp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.dp),
              borderSide:  BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.dp),
              borderSide:  BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.dp),
              borderSide:  BorderSide(color: AppColors.borderColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.dp),
              borderSide:  BorderSide(color: AppColors.borderColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.dp),
              borderSide:  BorderSide(color: AppColors.borderColor),
            ),
          ),
          style: TextStyle(
            fontSize: 13.dp,
            fontWeight: FontWeight.w600,
            fontFamily: 'arimo',
            color: AppColors.blackText,
          ),
        ),
      ),
    );
  }
}
