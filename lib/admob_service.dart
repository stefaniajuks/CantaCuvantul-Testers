import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>[],
  contentUrl: 'https://flutter.io',
  // birthday: DateTime.now(),
  childDirected: false,
  // designedForFamilies: false,
  // gender:
  //   MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

class AdMobService {
  String getAdMobID() {
    if (Platform.isIOS)
      return 'ca-app-pub-4042459717874979~7506488809';
    else if (Platform.isAndroid)
      return 'ca-app-pub-4042459717874979~4514733659';
    return '';
  }

  String getaddCoisID() {
    if (Platform.isIOS)
      return 'ca-app-pub-4042459717874979/5207628521';
    else if (Platform.isAndroid)
      return 'ca-app-pub-4042459717874979/2278085570';
    return '';
  }

  String getfinishADID() {
    if (Platform.isIOS)
      return 'ca-app-pub-4042459717874979/9464106724';
    else if (Platform.isAndroid)
      return 'ca-app-pub-4042459717874979/8887875314';
    return '';
  }
}
