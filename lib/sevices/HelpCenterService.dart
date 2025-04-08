import 'package:flutter/services.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

final Intercom intercomService = Intercom.instance;

class HelpCenterService {
  static Future<void> loginUser({
    required String userId,
    required String email,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      await intercomService.loginIdentifiedUser(email: email);
      await intercomService.updateUser(
        name: name,
        phone: phoneNumber,
      );
    } on PlatformException catch (e) {
      if ( e.code == '400' &&
          e.message?.contains('User already exists') == true) {
      } else {
      }
    } catch (e) {
    }
  }

  static Future<void> loginGuest() async {
    try {
      await intercomService.loginUnidentifiedUser();
    } catch (e) {
    }
  }

  static Future<void> logout() async {
    try {
      await intercomService.logout();
    } catch (e) {
    }
  }

  static Future<void> openHelpCenterPopup() async {
    try {
      await intercomService.displayMessenger();
    } catch (e) {
      if (e.toString().contains('no user registered')) {
        await loginGuest();
        try {
          // Retry displaying the messenger after logging in as a guest
          await intercomService.displayMessenger();
        } catch (retryError) {
        }
      } else {
      }
    }
  }

}
