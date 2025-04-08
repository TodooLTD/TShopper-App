import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppColors {
  static const transparentPerm = Colors.transparent;
  static const primaryLightColorPerm = Color(0xFFEFEFEF);
  static const whitePerm = Colors.white;
  static const blackPerm = Colors.black;
  static bool get isLightMode =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.light;
  static final Color primaryLightColor =
      isLightMode ? const Color(0xFFEFEFEF) : const Color(0xFFbababa);
  static Color salmon = const Color(0xFFFFA07A);
  static Color gold = const Color(0xFFFFC300);
  static const Color backgroundOrangeColor = const Color(0xFFffd1b7);
  static const Color backgroundRedColor = Color.fromARGB(255, 249, 214, 214);

  static final primaryLightColor2 = Color(0xFF6d22a1);
  static Color calmBlue = const Color.fromARGB(255, 114, 156, 204);

  static const Color mediumBlue = Color(0xFF004AAD);
  static const lightBlue = Color(0xFF6F98E8);

  static Color deepBlue = const Color(0XFF0F1482);
  static const pink = Color(0xFFFF66C4);
  Map<String, Color> colorMap = {
    'כחול בהיר': Color(0xFF6F98E8),
    'חאקי': Color(0xFFC2BC6F),
    'שמש צהוב': Color(0xFFFFBD59),
    'קאמל': Color(0xFFD8A269),
    'בננה צהוב': Color(0xFFFFEEA8),
    'רוזה': Color(0xFFDB6200),
    'כהה אפור': Color(0xFF545454),
    'אפור בהיר': Color(0xFFA6A6A6),
    'כהה ורוד': Color(0xFFFF66C4),
    'ביבי ורוד': Color(0xFFFAB9E6),
    'כהה תכלת': Color(0xFF43B0FF),
    'כחול נייבי': Color(0xFF43B0FF), //
    'ים תכלת': Color(0xFF6EA6FA),
    'חציל סגול': Color(0xFF520864),
    'אפרסק': Color(0xFFEFACA3),
    'פודרה': Color(0xFFF4DBB9),
    'דשא ירוק': Color(0xFF31820F),
    'בהיר ירוק': Color(0xFFB9DFA9),
    'כהה טורקיז': Color(0xFF0F6682),
    'ים כחול': Color(0xFF0F1482),
    'כחול כהה': Color(0xFF0F1482), //
    'תפוח ירוק': Color(0xFF89CF6B),
    'תפוח אדום': Color(0xFFCD6144),
    'כהה אדום': Color(0xFF7D270B),
    'לילך סגול': Color(0xFFCB9DDB),
    'בזוקה ורוד': Color(0xFFE8B1D7),
    'ורוד בהיר': Color(0xFFE8B1D7), //
    'מוקה': Color(0xFFBB981C),
    'אבטיח אדום': Color(0xFFE6523E),
    'מיושן שחור': Color(0xFF363737),
    'טורקיז': Color(0xFF2AB9BD),
    'ניקל': Color(0xFF777976),
    'ברונזה': Color(0xFF806D0C),
    'פוקסיה ורוד': Color(0xFFCB11BE),
    'קרם צבע': Color(0xFFEBDAA7),
    'קאמל צבע': Color(0xFFDBBB6B),
    'זית ירוק': Color(0xFF628952),
    'אדום': Color(0xFFFF3131),
    'כחול': Color(0xFF004AAD),
    'שחור': Color(0xFF000000),
    'לבן': Color(0xFFFFFFFF),
    'כסף': Color(0xFFBBB9B9),
    'זהב': Color(0xFFB4990E),
    'ירוק': Color(0xFF3B9215),
    'צהוב': Color(0xFFFFD425),
    'כתום': Color(0xFFFF914D),
    'סגול': Color(0xFF773CED),
    'ורוד': Color(0xFFFF66C4),
    'אפור': Color(0xFF737373),
    'בז': Color(0xFFD8C669),
    'תכלת': Color(0xFF38B6FF),
    'בורדו': Color(0xFF890418),
    'חום': Color(0xFF805000),
  };
  //static final Color backgroundColor =
  //    isLightMode ? Colors.white : Colors.black;

  static final Color titleColor =
      isLightMode ? AppColors.primaryColorText : Colors.white;
  static final Color darkModeGrey =
      isLightMode ? const Color(0xFF262626) : const Color(0xFF262626);

  static final Color popupBackgroundColor =
      isLightMode ? Colors.white : const Color(0xFF262626);

  static final Color oppositeBackgroundColor =
      isLightMode ? Colors.black : Colors.white;
  static final Color darkGrey =
      isLightMode ? const Color(0XFF5a5a5a) : const Color(0XFF5a5a5a);
  static final Color inputFieldFillColor =
      isLightMode ? Colors.black : Colors.white;
  static final Color lightGrey =
      isLightMode ? const Color(0XFFDBDBDB) : const Color(0XFFB5B5B5);
  static final errorColor = Color(0xFF890418);

  static final orange = isLightMode
      ? const Color.fromARGB(255, 255, 107, 8)
      : const Color.fromARGB(255, 255, 107, 8);

  // static final Color black = isLightMode ? Colors.black : darkGrey;

  static final iconsColor = Color(0XFF00000073);

  // static final Color borderColor = isLightMode ? mediumGrey : Color(0XFF2E2E2E);

  static final Color superLightPurple =
      isLightMode ? const Color(0xFFE7DCF0) : const Color(0xFFE7DCF0);
  static final Color lightGreen =
      isLightMode ? const Color(0xFFE0EFC8) : const Color(0xFFE0EFC8);
  static final Color checkBox =
      isLightMode ? const Color(0xFF9D9D9D) : const Color(0xFF9D9D9D);
  static final Color mediumGrey = isLightMode
      ? const Color.fromARGB(255, 129, 129, 129)
      : const Color(0xFF9D9D9D);
  static final Color primaryMediumColor = isLightMode
      ? const Color.fromARGB(255, 125, 80, 158)
      : const Color(0xFF4D1B70);
  static final Color lightWhitePurple = isLightMode
      ? const Color.fromARGB(255, 234, 229, 236)
      : const Color.fromARGB(255, 234, 229, 236);
  static final Color superLightGrey = isLightMode
      ? const Color.fromARGB(255, 216, 216, 216)
      : const Color.fromARGB(255, 216, 216, 216);
  static final Color warningColor = isLightMode
      ? const Color.fromARGB(255, 240, 30, 15)
      : const Color.fromARGB(255, 247, 79, 79);
  static final Color highTraffic = isLightMode
      ? const Color.fromARGB(255, 207, 230, 170)
      : const Color.fromARGB(255, 207, 230, 170);
  static final Color mainBoxShadowColor = isLightMode
      ? const Color(0XFFB5B5B5).withOpacity(0.5)
      : const Color(0XFFB5B5B5).withOpacity(0.1);
  static final Color mainIconButtonColor =
      isLightMode ? Colors.white : const Color(0XFFB5B5B5);
  static final Color mainIconButtonBgColor =
      isLightMode ? const Color(0XFFB5B5B5).withOpacity(0.8) : Colors.black;
  static final Color moderateTraffic =
      isLightMode ? const Color(0xFFC1E5EB) : const Color(0xFFC1E5EB);
  static final Color lowTraffic =
      isLightMode ? const Color(0xFFFFEFAE) : const Color(0xFFFFEFAE);
  static final Color mediumYellow =
      isLightMode ? const Color(0xFFF6E188) : const Color(0xFFF6E188);
  static final Color lightYellow =
      isLightMode ? const Color(0xFFC1E5EB) : const Color(0xFFC1E5EB);
  static final Color mediumGreen = isLightMode
      ? const Color.fromARGB(255, 175, 226, 163)
      : const Color.fromARGB(255, 175, 226, 163);

  static final Color strongGreen = isLightMode
      ? const Color(0xFF41B93C)
      : Color.fromARGB(255, 131, 226, 110);

  static const Color lightStrongGreen =
      Color(0xFF7ACE76);

  static const Color lightStrongRed =
  Color(0xFFF71100);

  // new colors - oren
  static const Color white = Color(0xFFFFFFFF);

  static final primaryColor =
      isLightMode ? const Color(0xFF4d1b70) : const Color(0xFF4d1b70);

  static final primaryColorText =
  isLightMode ? const Color(0xFF4d1b70) : const Color(0xFFBE62FF);

  static const Color black = Color(0xFF000000);

  static final Color whiteText =
      isLightMode ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

  static final Color blackText =
      isLightMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);

  static final Color backgroundColor =
      isLightMode ? const Color(0xFFFFFFFF) : const Color(0xFF171717);

  static final Color borderColor =
  isLightMode ? const Color(0xFFEFEFEF) : const Color(0xFF1C1C1E);


  static const Color mediumGreyText = Color(0xFF959595);

  static final Color backgroundGreyColor =
      isLightMode ? const Color(0xFFEFEFEF) : const Color(0xFF262626);

  static final Color lightGreyText =
      isLightMode ? const Color(0xFFEFEFEF) : const Color(0xFF959595);

  static final Color popupColor =
      isLightMode ? const Color(0xFFFFFFFF) : const Color(0xFF262626);

  static final Color CategoryColor =
  isLightMode ? const Color(0xFFEFEFEF) : const Color(0xFF202020);

  static final Color iconPrimeryColor =
      isLightMode ? const Color(0xFF4D1B70) : const Color(0xFFFFFFFF);
  static const Color primeryColor = Color(0xFF4D1B70);
  static const Color primeryLightColor = Color(0xFFE7DCF0);
  static const Color primeryMediumColor = Color(0xFF6D22A1);

  static const Color iconLightGrey = Color(0xFFBABABA);

  static final Color mediumLightPurple =
      isLightMode ? const Color(0xFF6D22A1) : const Color(0xFF9700FF);

  static final Color OnTapprimeryColor =
      isLightMode ? const Color(0xFFE7DCF0) : const Color(0xFF4D1B70);

  static final Color primeryColortext =
  isLightMode ? const Color(0xFF4D1B70) : const Color(0xFFFFFFFF);

  static final Color lightprimeryColortab =
  isLightMode ? const Color(0xFFFFFFFF) : const Color(0xFFE7DCF0);

  static final Color primeryMediumLightColor =
      isLightMode ? const Color(0xFF4D1B70) : const Color(0xFF6D22A1);
  static const Color redColor = Color(0xFFC80000);

  static const deliveryColor = Color(0xFF6DCB31);
  static const pickupColor = Color(0xFF004AAD);
  static const toTheCarColor = Color(0xFFFF66C4);
  static const Color redBackground = Color(0xFFFFCDD2);
  static const Color greenBackground = Color(0xFFDCEDC8);
  static const Color blueBackground = Color(0xFFB2EBF2);
  static const Color greyBackground = Color(0xFFE0E0E0);
  static const Color pinkBackground = Color(0xFFFCE4EC);
  static const Color orangeBackground = Color(0xFFFFCCBC);
  static const Color darkPurpleColor = Color(0xFF230c32);

}
