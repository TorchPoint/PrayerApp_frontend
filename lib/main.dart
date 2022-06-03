import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:prayer_hybrid_app/chat_audio_video/screens/audio_screen.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/local_notifications_class.dart';
import 'package:prayer_hybrid_app/services/push_notifications_class.dart';
import 'package:prayer_hybrid_app/splash/splash_screen.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

Future<void> backGroundHandleFCM(RemoteMessage remoteMessage) async {
  print(remoteMessage.data.toString());
  print(remoteMessage.notification?.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotifications().initialize();
  FirebaseMessaging.onBackgroundMessage(backGroundHandleFCM);

  HttpOverrides.global = MyHttpOverrides();
  if (defaultTargetPlatform == TargetPlatform.android) {
    print("android");
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  runApp(MyApp());
}

void configLoading() {}
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
RtcEngine rtcEngine;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // LocalNotifications().initialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppUserProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
          title: AppStrings.APP_TITLE_TEXT,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Quicksand',
          ),
          builder: EasyLoading.init(),
          navigatorKey: navigatorKey,
          routes: {
            AudioScreen.id: (context) => AudioScreen(),
          },
          home: SplashScreen()),
    );
  }
}
