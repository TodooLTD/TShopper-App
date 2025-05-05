import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:url_launcher/url_launcher.dart';
import '../constants/AppColors.dart';
import '../constants/AppFontSize.dart';
import '../sevices/AblyService.dart';
import '../sevices/HelpCenterService.dart';
import '../widgets/overlayMenu/OverlayMenu.dart';
import '../widgets/shopperDetails/DisabledTextFieldWidget.dart';
import '../widgets/socialScreen/SocialHelpers.dart';
import '../widgets/trackingOrder/CustomElevatedButton.dart';
import 'DeleteAccountScreen.dart';
import 'LoginScreen.dart';

class ShopperDetailsScreen extends ConsumerStatefulWidget {

  ShopperDetailsScreen({super.key});

  @override
  _ShopperDetailsScreenState createState() => _ShopperDetailsScreenState();
}

class _ShopperDetailsScreenState extends ConsumerState<ShopperDetailsScreen> with TickerProviderStateMixin {
  final OverlayMenu overlayMenu = OverlayMenu();

  @override
  void initState() {
    super.initState();
    overlayMenu.init(context, this);
  }

  Map<String, Color> colorMap = {
    'blue': Colors.blue,
    'green': Colors.green,
    'teal': Colors.teal,
    'tealAccent': Colors.tealAccent,
    'beige': Colors.orange[100]!,
    'orange': Colors.orange,
    'yellow': Colors.yellow,
    'red': Colors.red,
    'pink': Colors.pink,
    'lightPink':  Colors.pink[100]!,
    'brown':  Colors.brown,
    'black':  Colors.black,
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteText,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => overlayMenu.showOverlay(3),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.iconLightGrey,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  size: 22.dp,
                  Icons.menu,
                  color: AppColors.whiteText,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.whiteText,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.0.dp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.0.dp),
                  child: Row(
                    children: [
                      Container(
                        width: 40.dp,
                        height: 40.dp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              colorMap[TShopper.instance.color] ?? AppColors.mediumGreyText,
                              (getGradientColor(TShopper.instance.color)),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: TShopper.instance.imageUrl.isEmpty ? Text(
                            TShopper.instance.firstName[0]+TShopper.instance.lastName[0],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'todoFont',
                              fontSize: 24.dp,
                              color: AppColors.whiteText,
                              fontWeight: FontWeight.w800,
                            ),
                          ) : Image.network(TShopper.instance.imageUrl,
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: 16.dp,),
                      Text(TShopper.instance.firstName + " " + TShopper.instance.lastName, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24.dp, fontFamily: 'todofont', color: AppColors.blackText),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.dp,),
              Align(
                alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteText,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "פרטים אישיים",
                                style: TextStyle(
                                  fontSize: 16.dp,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'todofont',
                                  color: AppColors.blackText,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: AppColors.borderColor,
                            thickness: 1.0,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration:  BoxDecoration(
                                      color: AppColors.blackText,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      size: 12.dp,
                                      Icons.person,
                                      color: AppColors.whiteText,
                                    ),
                                  ),
                                  SizedBox(width: 8.0.dp),
                                  Text(TShopper.instance.firstName + " " + TShopper.instance.lastName, style: TextStyle(fontFamily: 'arimo', color: AppColors.blackText,
                                  fontSize: 12.dp, fontWeight: FontWeight.w600),)
                                ],
                              ),
                              Divider(
                                color: AppColors.borderColor,
                                thickness: 1.0,
                              ),                              Row(
                                children: [
                                  Container(
                                    decoration:  BoxDecoration(
                                      color: AppColors.blackText,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      size: 12.dp,
                                      Icons.mail,
                                      color: AppColors.whiteText,
                                    ),
                                  ),
                                  SizedBox(width: 8.0.dp),
                                  Text(TShopper.instance.mail, style: TextStyle(fontFamily: 'arimo', color: AppColors.blackText,
                                      fontSize: 12.dp, fontWeight: FontWeight.w600),)
                                ],
                              ),
                              Divider(
                                color: AppColors.borderColor,
                                thickness: 1.0,
                              ),                              Row(
                                children: [
                                  Container(
                                    decoration:  BoxDecoration(
                                      color: AppColors.blackText,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      size: 12.dp,
                                      Icons.phone,
                                      color: AppColors.whiteText,
                                    ),
                                  ),
                                  SizedBox(width: 8.0.dp),
                                  Text(TShopper.instance.phoneNumber, style: TextStyle(fontFamily: 'arimo', color: AppColors.blackText,
                                      fontSize: 12.dp, fontWeight: FontWeight.w600),)
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(height: 24.dp),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "תנאי שימוש והגנת מידע",
                      style: TextStyle(
                        fontSize: 16.dp,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'todofont',
                        color: AppColors.blackText,
                      ),
                    ),
                    SizedBox(height: 14.dp),
                    DisabledTextFieldWidget(
                      fontSize: AppFontSize.fontSizeRegular,
                      text: translate("personal_information_area.terms"),
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.blackText,
                      onPressed: () =>
                          launchURL('https://www.todoisrael.com/'),
                    ),
                    SizedBox(height: 8.dp),
                    DisabledTextFieldWidget(
                      fontSize: AppFontSize.fontSizeRegular,
                      text: translate(
                          "personal_information_area.accessibility_statement"),
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.blackText,
                      onPressed: () =>
                          launchURL('https://www.todoisrael.com/'),
                    ),
                    SizedBox(height: 8.dp),
                    DisabledTextFieldWidget(
                      fontSize: AppFontSize.fontSizeRegular,
                      text: translate(
                          "personal_information_area.transaction_cancellation_policy"),
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.blackText,
                      onPressed: () =>
                          launchURL('https://www.todoisrael.com/'),
                    ),
                    SizedBox(height: 8.dp),
                    DisabledTextFieldWidget(
                      fontSize: AppFontSize.fontSizeRegular,
                      text: translate(
                          "personal_information_area.privacy_policy"),
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.blackText,
                      onPressed: () =>
                          launchURL('https://www.todoisrael.com/'),
                    ),
                    SizedBox(height: 8.dp,),
                    DisabledTextFieldWidget(
                      fontSize: AppFontSize.fontSizeRegular,
                      text: translate(
                          "personal_information_area.delete_account"),
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.blackText,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeleteAccountScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 80.dp,
                    ),
                    SizedBox(
                      width: 100.w,
                      height: 50.dp,
                      child: CustomElevatedButton(
                        title:
                        translate("personal_information_area.exit"),
                        backgroundColor: AppColors.redColor,
                        onPressed: () async {
                          OneSignal.logout();
                          firebase.FirebaseAuth.instance.signOut();
                          AblyService.unsubscribeFromAllChannels();
                          await HelpCenterService.logout();
                          OneSignal.logout().then((_) {
                          }).catchError((error) {
                          });
                          TShopper.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                                (Route<dynamic> route) => false,
                          );
                          // firebase.FirebaseAuth.instance
                          //     .signOut()
                          //     .then((value) => Navigator.popAndPushNamed(
                          //   context,
                          //   loginScreenPath,
                          // ));


                        },
                      ),
                    ),
                    SizedBox(height: 20.dp),
                  ],
                ),
              )

            ],
          ),
        ),
      )
    );
  }

  void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

}
