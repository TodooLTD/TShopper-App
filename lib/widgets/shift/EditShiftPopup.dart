import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import '../../../../constants/AppFontSize.dart';
import '../../constants/AppColors.dart';
import '../../models/shift/ShopperShift.dart';
import 'EditShiftWidget.dart';

class EditShiftPopup extends StatefulWidget {
  ShopperShift? shift;
  final void Function() onConfirmed;
  Widget child;

  EditShiftPopup({
    Key? key,
    this.shift,
    required this.child,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  State<EditShiftPopup> createState() => EditShiftPopupState();
}

class EditShiftPopupState extends State<EditShiftPopup> with WidgetsBindingObserver{
  double paddingValue = 8.dp;
  bool isProduct = false;
  double totalPrice = 0;

  List<Widget> widgets = [];
  TextEditingController notes = TextEditingController();
  bool isLoading = true;
  bool _isModalOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
    }
    if (state == AppLifecycleState.resumed) {
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        setState(() {
          _isModalOpen = true;
        });
        WoltModalSheet.show<void>(
          context: context,
          pageListBuilder: (modalSheetContext) {
            return [
              _buildModalContent(),
            ];
          },
          modalTypeBuilder: (BuildContext modalContext) {
            return WoltModalType.bottomSheet;
          },
          onModalDismissedWithBarrierTap: () {
            Navigator.pop(context);
          },
          maxDialogWidth: 560,
          minDialogWidth: 400,
          minPageHeight: 0.0,
          maxPageHeight: 0.9,
        );
      },
      child: Container(child: widget.child),
    );
  }

  SliverWoltModalSheetPage _buildModalContent() {

    return SliverWoltModalSheetPage(
      backgroundColor: AppColors.backgroundColor,
      topBarTitle: Column(
        children: [
        ],
      ),
      pageTitle: Padding(
          padding: EdgeInsets.only(right: 10.dp),
          child: Container()
      ),
      trailingNavBarWidget:  Padding(
        padding: const EdgeInsets.all(15.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.iconLightGrey,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(5),
            child: Icon(
              size: 22.dp,
              Icons.close,
              color: AppColors.whiteText,
            ),
          ),
        ),
      ),



      mainContentSlivers: widgets = buildSliverList(),
    );
  }


  List<Widget> buildSliverList() {
    return <Widget>[
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: paddingValue),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              if(widget.shift != null)...[
                EditShiftWidget(shift: widget.shift, onConfirmed: widget.onConfirmed,)
              ],
              if(widget.shift == null)...[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "הוספת משמרת",
                        style: TextStyle(
                          fontSize: AppFontSize.mediumTitle,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'todoFont',
                          color: AppColors.blackText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 20.dp,)
            ],
          ),
        ),
      ),
    ];
  }

 

}
