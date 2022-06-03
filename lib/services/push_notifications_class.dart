import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:prayer_hybrid_app/chat_audio_video/screens/audio_screen.dart';
import 'package:prayer_hybrid_app/chat_audio_video/screens/pre_calling_screen.dart';
import 'package:prayer_hybrid_app/drawer/drawer_screen.dart';
import 'package:prayer_hybrid_app/main.dart';
import 'package:prayer_hybrid_app/models/group_prayer_model.dart';
import 'package:prayer_hybrid_app/models/user_model.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/services/local_notifications_class.dart';

import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => instance;

  static final PushNotificationsManager instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  BaseService baseService = BaseService();

  Future joinCall(Map message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Channel:" + message["channel"].toString());
    return await baseService
        .postBaseMethod("${ApiConst.AGORA_BASE_URL}/joining-call", {
      "isPublisher": false,
      "reciever_id": prefs.getInt("userID"),
      "channel": message["channel"],
      "sender_id": message["user"] ?? null,
      "group_id": message["group"] ?? null
    });
  }

  Future<void> loadFCM() async {
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        print(message.data);
        handleMessage(message.data);
      } else {
        _splashTimer(navigatorKey.currentContext);
      }
    });
    getForeGroundFCM();
    onClickFCM();
  }

  //works in foreground
  Future<void> getForeGroundFCM() async {
    FirebaseMessaging.onMessage.listen((message) {
      if (message != null) {
        print("Title:" + message.notification.title.toString());
        print("Notification Body:" + message.notification.body.toString());
        if (message.data["type"] == "call_reject") {
          log("Wowowowoow");
          rtcEngine.leaveChannel();
          rtcEngine.destroy();
          AppNavigation.navigateToRemovingAll(navigatorKey.currentContext, DrawerScreen());
        }
      }
      print("not clicked on fcm");
      LocalNotifications().showLocalNotifications(message);
    });
  }

//works when app is in background and user taps
  Future<void> onClickFCM() async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null) {
        handleMessage(message.data);
      }
    });
  }

  void handleMessage(Map remoteMessage) async {
    var userProvider = Provider.of<AppUserProvider>(navigatorKey.currentContext,
        listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("MESSAGE:" + remoteMessage.toString());
    if (remoteMessage["type"] == "call") {
      String users = prefs.getString("user");
      var data = jsonDecode(users);
      userProvider.setUser(AppUser.fromJson(data));
      AppNavigation.navigateReplacement(
          navigatorKey.currentContext,
          PreCallingScreen(
            appUser: remoteMessage["user_name"],
            message: remoteMessage,
          ));
    } else if (remoteMessage["type"] == "group_call") {
      String users = prefs.getString("user");
      var data = jsonDecode(users);
      userProvider.setUser(AppUser.fromJson(data));
      AppNavigation.navigateReplacement(
          navigatorKey.currentContext,
          PreCallingScreen(
            appUser: remoteMessage["user_name"],
            message: remoteMessage,
          ));
    } else {
      String users = prefs.getString("user");
      var data = jsonDecode(users);
      userProvider.setUser(AppUser.fromJson(data));
      AppNavigation.navigateToRemovingAll(
          navigatorKey.currentContext, DrawerScreen());
      print("no data found for call");
    }
  }
}

Future<Timer> _splashTimer(context) async {
  return Timer(Duration(seconds: 3), () {
    BaseService().loadUserData(context);
  });
}
