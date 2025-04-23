import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:tshopper_app/models/tshopper/TShopper.dart';

import '../../constants/AppFontSize.dart';
import '../constants/AppColors.dart';
import '../sevices/AblyService.dart';
import '../widgets/appBars/CustomAppBarOnlyBack.dart';
import '../widgets/popup/BottomPopup.dart';
import '../widgets/trackingOrder/CustomElevatedButton.dart';
import 'LoginScreen.dart';


class DeleteAccountScreen extends riverpod.ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  riverpod.ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState
    extends riverpod.ConsumerState<DeleteAccountScreen> {
  TextEditingController _nameController = TextEditingController();

  List<String> reasons = [
    "אני לא מרוצה מהשירות שלכם",
    "אני לא רוצה להשתמש באפליקציה יותר",
    "המחירים מאוד יקרים לי",
    "לא אחת מהסיבות האלו",
    "אין סיבה"
  ];
  int choosenReasone = -1;

  String otherText = "";


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration commonInputDecoration(String labelText) {
      return InputDecoration(
        labelText: translate(labelText),
        labelStyle: TextStyle(
          color: AppColors.mediumGreyText,
          fontSize: AppFontSize.fontSizeMedium,
          fontFamily: 'arimo',
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.dp),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        // Focused border style
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        // Enabled border style
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteText,
      appBar: CustomAppBarOnlyBack(
        backgroundColor: AppColors.whiteText,
        onBackTap: () => Navigator.pop(context),
        title: "", isButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 18.0.dp, left: 18.0.dp),
          child: Stack(
            children: [
              SizedBox(
                width: 100.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 45.w,
                              child: Text(
                                translate("delete_account.screen_title"),
                                style: TextStyle(
                                    fontFamily: 'todoFont',
                                    fontSize: AppFontSize.fontSizeSuperTitle,
                                    color: AppColors.blackText,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/broken_heart_guy.png",
                                width: 155.dp,
                                height: 155.dp,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate(
                                "delete_account.we_are_here_for_you"),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: AppFontSize.fontSizeRegular,
                                color: AppColors.blackText,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${translate("delete_account.important_to_say")}.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: AppFontSize.fontSizeRegular,
                                color: AppColors.blackText,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.dp,
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.95,
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: commonInputDecoration(
                            "ספר לנו למה אתה רוצה למחוק את החשבון"),
                        style: TextStyle(
                          color: AppColors.mediumGreyText,
                          fontSize: AppFontSize.inputFieldText,
                          fontFamily: 'arimo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 10.dp,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 50.dp,
                    width: 10.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.5.dp),
                      child: CustomElevatedButton(
                        title: translate(
                            "personal_information_area.delete_account"),
                        onPressed: () async {
                          try {
                            TShopper.clear();
                            OneSignal.logout();
                            firebase.FirebaseAuth.instance.signOut();
                            AblyService.unsubscribeFromAllChannels();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          } catch (e) {
                            showBottomPopup(
                              duration: const Duration(seconds: 2),
                              context: context,
                              message: translate(
                                  "משהו השתבש.. נסה שוב"),
                              imagePath: "assets/images/warning_icon.png",
                            );
                          }
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
