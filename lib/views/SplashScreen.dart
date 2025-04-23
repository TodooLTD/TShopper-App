import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/views/HomeScreen.dart';
import '../constants/AppColors.dart';
import '../sevices/FirebaseAuthService.dart';
import 'LoginScreen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  String businessUid = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        final bool isAuth = authService.isAuthenticated();
        if (isAuth) {
          String uid = authService.getUserId() ?? '';

          // Start the timer after checking the business status and authentication
          Timer(const Duration(seconds: 3), () async {
            if (!mounted) return;
            if (true) {
              OneSignal.login(uid);

              TShopper? shopper = await TShopperService.fetchShopper(uid);
              if(shopper == null){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
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
          });
        } else {
          // If not authenticated, wait 3 seconds before navigating to login
          Timer(const Duration(seconds: 3), () {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>  LoginScreen(),
              ),
            );
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Lottie.asset("assets/lottie/TODO.json"),
        ),
      ),
    );
  }
}
