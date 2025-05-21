import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:overlay_support/overlay_support.dart';
import 'package:tshopper_app/views/SplashScreen.dart';

import 'constants/AppColors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase Initialization Error: $e");
  }

  OneSignal.initialize("e1e3d6f3-2b37-4f04-9d4e-54fe0b71e7e4");
  OneSignal.Notifications.requestPermission(true);

  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'he',
    supportedLocales: ['he'],
  );
  // Lock the orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //TODO - INTERCOM
  // await intercomService.initialize(
  //   intercomAppId,
  //   iosApiKey: iosApiKey,
  //   androidApiKey: androidApiKey,
  // );
  runApp(
    riverpod.ProviderScope(
      child: FlutterSizer(
        builder: (context, orientation, deviceType) => OverlaySupport.global(
          child: LocalizedApp(
            delegate,
            MyApp(),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.8823529411764706)),
      child: MaterialApp(
        title: 'TODO TShopper',
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          shadowColor: AppColors.oppositeBackgroundColor,
          fontFamily: "arino",
          colorSchemeSeed: AppColors.primeryColor,
          useMaterial3: false,
        ),
        home: const SplashScreen(),
        // Set SplashScreen as the default home
        locale: const Locale('he'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('iw', ''), // Hebrew
        ],
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}