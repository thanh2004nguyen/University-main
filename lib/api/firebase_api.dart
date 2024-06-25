import 'package:firebase_messaging/firebase_messaging.dart';

import '../shared/common.dart';

class FireBaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future init() async {
    await _firebaseMessaging.requestPermission(
        alert : true,
        announcement : false,
        badge : true,
        carPlay : false,
        criticalAlert : false,
        provisional : false,
         sound : true
    );
    final fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken);
    CommonMethod.FmcToken=fCMToken!;
  }
}