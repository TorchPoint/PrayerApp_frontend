import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:prayer_hybrid_app/services/base_service.dart';

import 'package:prayer_hybrid_app/services/push_notifications_class.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';

import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BaseService baseService = BaseService();

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = await FirebaseMessaging.instance.getToken();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    String token = await _firebaseMessaging.getToken();

    prefs.setString("xyz", token);

    print("----" + token + "-=---");
  }

  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();


  @override
  void initState() {
    super.initState();
    getToken();
    baseService.loadLocalUser();
    pushNotificationsManager.loadFCM();

    //LocalNotifications().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackgroundContainer(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.62,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetPaths.FOREGROUND_IMAGE),
                    fit: BoxFit.contain)),
          ),
        ],
      )),
    );
  }
}
