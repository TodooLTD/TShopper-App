import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../constants/AppColors.dart';
import '../constants/AppFontSize.dart';
import '../main.dart';
import '../sevices/TShopperService.dart';
import '../widgets/appBars/CustomAppBar.dart';
import '../widgets/buttons/SubmitButton.dart';
import '../widgets/popup/BottomPopup.dart';
import '../models/tshopper/TShopper.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  final TextEditingController _emailController =
  TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  OverlayEntry? overlayEntry;
  late AnimationController animationController;
  late Animation<Offset> positionAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    positionAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        overlayEntry?.remove();
        overlayEntry = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration commonInputDecoration(String labelText) {
      return InputDecoration(
        labelText: translate(labelText),
        labelStyle: TextStyle(
          color: AppColors.mediumGreyText,
          fontSize: AppFontSize.inputFieldText,
          fontFamily: 'arimo',
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.dp),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        // Focused border style
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.dp),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        // Enabled border style
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.dp),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        suffixIcon: labelText == "Login.password"
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.mediumGreyText,
            size: 15.dp,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteText,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        onMenuTap: () {},
        onLocationTap: () {},
        noBackButton: false,
      ),
      body: GestureDetector(
        onHorizontalDragStart: (_) {},
        onHorizontalDragUpdate: (_) {},
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            color: AppColors.whiteText,
            child: Column(
              children: <Widget>[
                Center(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40.dp),
                        Image.asset(isLightMode ? "assets/images/managers.png" : "assets/images/managersDark.png", width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,),
                        SizedBox(height: 30.dp),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                            commonInputDecoration("Login.email_address"),
                            style: TextStyle(
                              color: AppColors.mediumGreyText,
                              fontSize: AppFontSize.inputFieldText,
                              fontFamily: 'arimo',
                            ),
                          ),
                        ),
                        SizedBox(height: 18.dp),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: !_isPasswordVisible,
                            decoration: commonInputDecoration("Login.password"),
                            style: TextStyle(
                              color: AppColors.mediumGreyText,
                              fontSize: AppFontSize.inputFieldText,
                              fontFamily: 'arimo',
                            ),
                          ),
                        ),
                        SizedBox(height: 60.dp),
                        SubmitButton(
                          text: translate('Login.login'),
                          onPressed: () => _handleLoginButtonPress(context),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 70.dp,
                        ),
                        SizedBox(height: 18.dp),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 26.dp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLoginButtonPress(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showBottomPopup(
        context: context,
        message: "יש למלא את כל השדות",
        imagePath: "assets/images/warning_icon.png",
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Successfully signed in
      User? user = userCredential.user;
      print("here");
      print(user == null);

      if (user != null) {
        print(user.uid);
        // OneSignal.login(user.uid);
        //
        TShopper? shopper = await TShopperService.fetchShopper(user.uid);
        if(shopper == null){
          showBottomPopup(
            context: context,
            message:
            "שגיאה בהתחברות. נסה שוב",
            imagePath: 'assets/images/warning_icon.png',
          );
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      print(errorMessage);
      // Show an error popup
      showBottomPopup(
        context: context,
        message: "שם משתמש או סיסמה שגויים",
        imagePath: "assets/images/warning_icon.png",
      );
    }
  }
}
