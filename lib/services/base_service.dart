import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:prayer_hybrid_app/auth/screens/auth_main_screen.dart';
import 'package:prayer_hybrid_app/auth/screens/auth_verification_screen.dart';
import 'package:prayer_hybrid_app/complete_profile/screens/complete_profile_screen.dart';
import 'package:prayer_hybrid_app/drawer/drawer_screen.dart';
import 'package:prayer_hybrid_app/main.dart';
import 'package:prayer_hybrid_app/models/notification_model.dart';
import 'package:prayer_hybrid_app/models/user_model.dart';
import 'package:prayer_hybrid_app/password/screens/reset_password_screen.dart';
import 'package:prayer_hybrid_app/prayer_group/screens/create_prayer_group_screen.dart';
import 'package:prayer_hybrid_app/prayer_partner/screens/prayer_partner_list_screen.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/prayer_praise_tab_screen.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/reminder_calendar/screens/reminder_screen.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
import 'package:prayer_hybrid_app/subscription/screens/buy_now_subscription.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class BaseService {
  var id;
  String token;
  String user;
  String fcmToken;

  void showToast(message, color) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
      //webBgColor: color,

      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: AppColors.WHITE_COLOR,
    );
  }

  /////===== USER DATA SETTING AND LOADING ======/////
  void loadLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("userID");
    token = prefs.getString("token");
    user = prefs.getString("user");

    debugPrint("ID FROM LOCAL:" + id.toString());
    debugPrint("Token FROM LOCAL:" + token.toString());
    debugPrint("User FROM Local:" + user.toString());
  }

  Future loadUserData(BuildContext context) async {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString("user");

    if (user == null) {
      AppNavigation.navigateReplacement(context, AuthMainScreen());
    } else {
      var data = jsonDecode(user);
      userProvider.setUser(AppUser.fromJson(data));
      AppNavigation.navigateToRemovingAll(context, DrawerScreen());
    }
  }

  Future setUserData(BuildContext context, value) async {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("userID", value["data"]["id"]);
    id = prefs.getInt("userID");
    debugPrint("LocalID:" + id.toString());
    prefs.setString("token", value["bearer_token"]);
    token = prefs.getString("token");
    token = prefs.getString("token");
    debugPrint("Token:" + token.toString());
    prefs.setString("user", jsonEncode(AppUser.fromJson(value["data"])));
    userProvider.setUser(AppUser.fromJson(value["data"]));
  }

  /////===== USER DATA SETTING AND LOADING END======/////

  /////-----BASE METHODS----//////

  Future getBaseMethod(context, url,
      {loading = true, tokenCheck = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse(ApiConst.BASE_URL + url);
    print(uri);
    if (loading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.cubeGrid
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = AppColors.BACKGROUND1_COLOR
        ..indicatorColor = AppColors.WHITE_COLOR
        ..textColor = AppColors.WHITE_COLOR
        ..indicatorSize = 35.0
        ..radius = 10.0
        ..maskColor = AppColors.BLACK_COLOR.withOpacity(0.6)
        ..userInteractions = false
        ..dismissOnTap = false;
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);
    }
    try {
      final http.Response response = await http
          .get(uri,
              headers: tokenCheck == true
                  ? {"Authorization": "Bearer ${prefs.getString("token")}"}
                  : {})
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          // Time has run out, do what you wanted to do.// Replace 500 with your http code.
          EasyLoading.dismiss();
          showToast("Check Your Connection", AppColors.ERROR_COLOR);
          return;
        },
      );

      if (response.statusCode == 200) {
        debugPrint("${response.persistentConnection.toString()}");
        EasyLoading.dismiss();
        var jsonData = jsonDecode(response.body);
        debugPrint(jsonData.toString());
        return jsonData;
      } else if (response.statusCode == 401) {
        print("********${response.statusCode.toString()}*****");
        prefs.clear();
        EasyLoading.dismiss();
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateToRemovingAll(context, AuthMainScreen());
        showToast("UnAuthorized", AppColors.ERROR_COLOR);
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      showToast("Internet Not Working", AppColors.ERROR_COLOR);
    }
  }

  Future getBaseMethodBible(context, url, {loading = true}) async {
    var uri = Uri.parse(url);
    print(uri);
    if (loading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.cubeGrid
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = AppColors.BACKGROUND1_COLOR
        ..indicatorColor = AppColors.WHITE_COLOR
        ..textColor = AppColors.WHITE_COLOR
        ..indicatorSize = 35.0
        ..radius = 10.0
        ..maskColor = AppColors.BLACK_COLOR.withOpacity(0.6)
        ..userInteractions = false
        ..dismissOnTap = false;
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);
    }
    try {
      final http.Response response = await http.get(uri, headers: {
        "cache-control": "no-cache",
        "content-type": "application/json",
        "api-key": "${ApiConst.BIBLE_API_KEY}"
      });

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var jsonData = jsonDecode(response.body);
        debugPrint(jsonData.toString());
        return jsonData;
      } else if (response.statusCode == 401) {
        print("********${response.statusCode.toString()}*****");
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      showToast("Internet Not Working", AppColors.ERROR_COLOR);
    }
  }

  Future postBaseMethod(url, body, {token}) async {
    var uri = Uri.parse(url);
    debugPrint(uri.toString());
    debugPrint(body.toString());
    EasyLoading.instance..backgroundColor = AppColors.BACKGROUND1_COLOR;
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = AppColors.BACKGROUND1_COLOR
      ..indicatorColor = AppColors.WHITE_COLOR
      ..textColor = AppColors.WHITE_COLOR
      ..indicatorSize = 35.0
      ..radius = 10.0
      ..maskColor = AppColors.BLACK_COLOR.withOpacity(0.6)
      ..userInteractions = false
      ..dismissOnTap = false;
    EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);

    final http.Response response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    try {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var jsonData = jsonDecode(response.body);
        debugPrint(jsonData.toString());
        return jsonData;
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      showToast("Internet Not Working", AppColors.ERROR_COLOR);
      debugPrint('Error: $e');
    }
  }

  Future formDataBaseMethod(context, url,
      {bool tokenCheck = false,
      bodyCheck = true,
      Map<String, String> body,
      File files,
      filesCheck = false}) async {
    var uri = Uri.parse(ApiConst.BASE_URL + url);
    debugPrint("Url:" + uri.toString());
    debugPrint("Body:" + body.toString());
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = AppColors.BACKGROUND1_COLOR
      ..indicatorColor = AppColors.WHITE_COLOR
      ..textColor = AppColors.WHITE_COLOR
      ..indicatorSize = 35.0
      ..radius = 10.0
      ..maskColor = AppColors.BLACK_COLOR.withOpacity(0.6)
      ..userInteractions = false
      ..dismissOnTap = false;
    EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll(tokenCheck == true
        ? {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            "Authorization": "Bearer ${prefs.getString("token")}"
          }
        : {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          });

    if (filesCheck == true) {
      request.files
          .add(await http.MultipartFile.fromPath('attachment', files.path));
    }
    bodyCheck == true ? request.fields.addAll(body) : request.files.addAll({});

    var response = await request.send().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        // Time has run out, do what you wanted to do.// Replace 500 with your http code.
        EasyLoading.dismiss();
        showToast("Check Your Connection", AppColors.ERROR_COLOR);
        return;
      },
    );
    final respStr = await response.stream.bytesToString();

    try {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        debugPrint("Response:" + respStr);
        return jsonDecode(respStr);
      } else if (response.statusCode == 401) {
        prefs.clear();
        print("********${response.statusCode.toString()}*****");
        EasyLoading.dismiss();
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateToRemovingAll(context, AuthMainScreen());
        showToast("UnAuthorized", AppColors.ERROR_COLOR);
      } else {
        print("____" + response.reasonPhrase);
        print(response.statusCode.toString());
        prefs.clear();
        EasyLoading.dismiss();
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateToRemovingAll(context, AuthMainScreen());
        showToast("UnAuthorized", AppColors.ERROR_COLOR);
      }
    } catch (e) {
      prefs.clear();
      print("____" + response.reasonPhrase);
      print(response.statusCode.toString());
      print(response.persistentConnection);
      EasyLoading.dismiss();
      showToast("Internet Not Working", AppColors.ERROR_COLOR);
      debugPrint('Error: $e');
    }
  }

  Future formDataBaseMethodPayment(context, url,
      {bool tokenCheck = false,
      bodyCheck = true,
      Map<String, String> body,
      File files,
      filesCheck = false}) async {
    var uri = Uri.parse(url);
    debugPrint("Url:" + uri.toString());
    debugPrint("Body:" + body.toString());
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = AppColors.BACKGROUND1_COLOR
      ..indicatorColor = AppColors.WHITE_COLOR
      ..textColor = AppColors.WHITE_COLOR
      ..indicatorSize = 35.0
      ..radius = 10.0
      ..maskColor = AppColors.BLACK_COLOR.withOpacity(0.6)
      ..userInteractions = false
      ..dismissOnTap = false;
    EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll(tokenCheck == true
        ? {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            "Authorization": "Bearer ${prefs.getString("token")}"
          }
        : {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          });

    if (filesCheck == true) {
      request.files
          .add(await http.MultipartFile.fromPath('attachment', files.path));
    }
    bodyCheck == true ? request.fields.addAll(body) : request.files.addAll({});

    var response = await request.send().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        // Time has run out, do what you wanted to do.// Replace 500 with your http code.
        EasyLoading.dismiss();
        showToast("Check Your Connection", AppColors.ERROR_COLOR);
        return;
      },
    );
    final respStr = await response.stream.bytesToString();

    try {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        debugPrint("Response:" + respStr);
        return jsonDecode(respStr);
      } else if (response.statusCode == 401) {
        prefs.clear();
        print("********${response.statusCode.toString()}*****");
        EasyLoading.dismiss();
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateToRemovingAll(context, AuthMainScreen());
        showToast("UnAuthorized", AppColors.ERROR_COLOR);
      } else {
        print("____" + response.reasonPhrase);
        print(response.statusCode.toString());
        prefs.clear();
        EasyLoading.dismiss();
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateToRemovingAll(context, AuthMainScreen());
        showToast("UnAuthorized", AppColors.ERROR_COLOR);
      }
    } catch (e) {
      prefs.clear();
      print("____" + response.reasonPhrase);
      print(response.statusCode.toString());
      print(response.persistentConnection);
      EasyLoading.dismiss();
      showToast("Internet Not Working", AppColors.ERROR_COLOR);
      debugPrint('Error: $e');
    }
  }

  /////-----BASE METHODS END----//////

  //---- SIGNUP AND LOGIN FLOW-----////////

  Future loginFormUser(BuildContext context, {email, password}) async {
    var _timezone = await FlutterNativeTimezone.getLocalTimezone();
    // print("*******" + prefs.getString("xyz").toString());
    String tokens = await FirebaseMessaging.instance.getToken();
    Map<String, String> requestBody = <String, String>{
      "email": email ?? "",
      "password": password ?? "",
      "device_token": tokens ?? "testing",
      "device_type": Platform.operatingSystem ?? "ios",
      "time_zone": _timezone
    };
    await formDataBaseMethod(context, ApiConst.SIGN_IN_URL, body: requestBody)
        .then((value) {
      if (value["status"] == 0) {
        showToast(value["message"], AppColors.ERROR_COLOR);
      } else if (value["status"] == 1) {
        if (value["data"]["account_verified"] == 0) {
          AppNavigation.navigateTo(
              context,
              VerificationScreen(
                emailVerificationCheck: false,
                userData: value["data"]["id"].toString(),
              ));
        } else {
          setUserData(context, value);
          showToast(value["message"], AppColors.SUCCESS_COLOR);
          AppNavigation.navigateReplacement(context, DrawerScreen());
        }
      }
    });
  }

  Future signUpUser(BuildContext context, firstName, lastName, email,
      phoneNumber, password, countryCode) async {
    // FCM_Token = prefs.getString("fcmToken");
    String tokens = await FirebaseMessaging.instance.getToken();
    Map<String, String> requestBody = <String, String>{
      "email": email ?? "",
      "password": password ?? "",
      "device_token": tokens ?? "testing",
      "device_type": Platform.operatingSystem ?? "ios",
      "first_name": firstName ?? "",
      "last_name": lastName ?? "",
      "contact_no": phoneNumber ?? "",
      "country_code": countryCode ?? ""
    };
    await formDataBaseMethod(context, ApiConst.SIGNUP_URL,
            bodyCheck: true, body: requestBody)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);

        AppNavigation.navigateTo(
            context,
            VerificationScreen(
              emailVerificationCheck: false,
              userData: value["data"]["user_id"].toString(),
            ));
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future verifyUserUsingOTP(BuildContext context, userID, otp) async {
    Map<String, String> requestBody = <String, String>{
      "user_id": userID,
      "otp": otp,
    };

    await formDataBaseMethod(context, ApiConst.VERIFICATION_URL,
            body: requestBody, bodyCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        setUserData(context, value);
        AppNavigation.navigateTo(context, DrawerScreen());
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future reSendVerification(BuildContext context, userID) async {
    Map<String, String> requestBody = <String, String>{
      "user_id": userID,
    };
    await formDataBaseMethod(context, ApiConst.RESEND_EMAIL_VERIFICATION_URL,
            bodyCheck: true, body: requestBody)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
      }
    });
  }

  Future updateUserprofile(
      BuildContext context, firstName, lastName, phoneNumber, countryCode,
      {File attachment}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    Map<String, String> requestBody = <String, String>{
      "first_name": firstName ?? "",
      "last_name": lastName ?? "",
      "contact_no": phoneNumber ?? "",
      "country_code": countryCode ?? ""
    };

    await formDataBaseMethod(context, ApiConst.UPDATE_PROFILE,
            bodyCheck: true,
            tokenCheck: true,
            body: requestBody,
            files: attachment,
            filesCheck: attachment != null ? true : false)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        // setUserData(context, value);
        prefs.setString("user", jsonEncode(AppUser.fromJson(value["data"])));
        userProvider.setUser(AppUser.fromJson(value["data"]));

        AppNavigation.navigateToRemovingAll(context, DrawerScreen());
      } else {
        showToast(value["message"], AppColors.RED_COLOR);
      }
    });
  }

  Future updateOrChangePassword(
      BuildContext context, oldPassword, newPassword) async {
    Map<String, String> requestBody = <String, String>{
      "old_password": oldPassword,
      "new_password": newPassword,
    };

    await formDataBaseMethod(context, ApiConst.UPDATE_PASSWORD_URL,
            bodyCheck: true, body: requestBody, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigateTo(context, DrawerScreen());
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  //---- SIGNUP AND LOGIN FLOW END-----////////

  ////------ Password Change Flow-------/////

  Future forgetPassword(BuildContext context, email) async {
    Map<String, String> requestBody = <String, String>{
      "email": email ?? "",
    };
    await formDataBaseMethod(context, ApiConst.FORGET_PASSWORD_URL,
            body: requestBody, bodyCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigateToRemovingAll(
            context,
            VerificationScreen(
              emailVerificationCheck: true,
              userData: email,
            ));
      } else {
        showToast(value["errors"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future verifyForgetPasswordUsingEmail(
      BuildContext context, email, otp) async {
    Map<String, String> requestBody = <String, String>{
      "email": email,
      "otp": otp,
    };

    await formDataBaseMethod(context, ApiConst.FORGET_VERIFICATION_URL,
            bodyCheck: true, body: requestBody)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigateTo(
            context,
            ResetPasswordScreen(
              otp: otp,
              email: email,
            ));
      } else {
        showToast(value["errors"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future restPassword(BuildContext context, newPassword, email, otp) async {
    Map<String, String> requestBody = <String, String>{
      "email": email,
      "otp": otp,
      "new_password": newPassword
    };

    await formDataBaseMethod(context, ApiConst.RESET_PASSWORD_URL,
            body: requestBody, bodyCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigateToRemovingAll(context, AuthMainScreen());
      } else {
        showToast(value["errors"], AppColors.ERROR_COLOR);
      }
    });
  }

  ////------ Password Change Flow END-------/////

  //-----LOGOUT------//

  Future logoutUser(BuildContext context) async {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    var prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    var reminderProvider =
        Provider.of<ReminderProvider>(context, listen: false);
    var groupProvider = Provider.of<GroupProvider>(context, listen: false);
    var notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await formDataBaseMethod(context, ApiConst.LOGOUT_URL,
            bodyCheck: false, tokenCheck: true)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        for (String key in prefs.getKeys()) {
          if (key != "${userProvider.appUser.id}") {
            prefs.remove(key);
          }
        }
        if (prayerProvider != null) {
          prayerProvider.resetPrayerProvider();
          prayerProvider.restPraise();
        }
        if (reminderProvider != null) {
          reminderProvider.resetReminderModel();
        }
        if (userProvider != null) {
          userProvider.resetPartnersList();
          //userProvider.restUserProvider();
        }
        if (groupProvider != null) {
          groupProvider.resetGroupsList();
        }
        if (notificationProvider != null) {
          notificationProvider.resetNotificationList();
        }
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateToRemovingAll(context, AuthMainScreen());
      } else {
        print("error");
      }
    });
  }

  //-----LOGOUT END------//

  ////====== SOCIAL LOGINS========/////

  Future fbSocialMethod(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken;

      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${accessToken.token}'));
      print("Graph response" + graphResponse.body.toString());
      var data = jsonDecode(graphResponse.body);

      socialLoginFacebook(
        context,
        data["id"],
        data["name"],
        data["email"],
        data["picture"]["data"]["url"],
      );
    } else if (result.status == LoginStatus.cancelled) {
      showToast("${result.message}", AppColors.ERROR_COLOR);
    } else if (result.status == LoginStatus.failed) {
      showToast("${result.message}", AppColors.ERROR_COLOR);
    }
  }

  Future googleSocialMethod(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      socialLoginGoogle(
        context,
        googleSignIn.currentUser.id,
        googleSignIn.currentUser.displayName,
        googleSignIn.currentUser.email,
        googleSignIn.currentUser.photoUrl,
      );
    }
  }

  Future appleSocialMethod(BuildContext context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credential != null) {
      socialLoginApple(
        context,
        credential.userIdentifier,
        credential.givenName,
        credential.email,
      );
    }
    // print(credential);
  }

  Future socialLoginApple(
      BuildContext context, accessToken, name, email) async {
    var _timezone = await FlutterNativeTimezone.getLocalTimezone();
    // FCM_Token = prefs.getString("fcmToken");
    String tokens = await FirebaseMessaging.instance.getToken();
    Map<String, String> requestBody = <String, String>{
      "access_token": accessToken,
      "device_token": tokens ?? "testing",
      "device_type": Platform.operatingSystem ?? "ios",
      "provider": "apple",
      "name": name ?? "",
      "email": email ?? "",
      "image": "",
      "phone": "",
      "time_zone": _timezone
    };
    await formDataBaseMethod(context, ApiConst.SOCIAL_LOGIN,
            body: requestBody, bodyCheck: true, filesCheck: false)
        .then((value) {
      if (value["status"] == 1) {
        setUserData(context, value);
        if (value['data']['contact_no'] == null) {
          AppNavigation.navigateTo(context, CompleteProfileScreen());
        } else {
          showToast(value["message"], AppColors.SUCCESS_COLOR);
          AppNavigation.navigateReplacement(context, DrawerScreen());
        }
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future socialLoginFacebook(
      BuildContext context, accessToken, name, email, image) async {
    var _timezone = await FlutterNativeTimezone.getLocalTimezone();
    //FCM_Token = prefs.getString("fcmToken");
    String tokens = await FirebaseMessaging.instance.getToken();
    Map<String, String> requestBody = <String, String>{
      "access_token": accessToken,
      "device_token": tokens ?? "test",
      "device_type": Platform.operatingSystem ?? "ios",
      "provider": "facebook",
      "name": name,
      "email": email,
      "image": image,
      "phone": "",
      "time_zone": _timezone
    };

    await formDataBaseMethod(context, ApiConst.SOCIAL_LOGIN,
            body: requestBody, bodyCheck: true)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        setUserData(context, value);
        if (value['data']['contact_no'] == null) {
          AppNavigation.navigateReplacement(context, CompleteProfileScreen());
        } else {
          showToast(value["message"], AppColors.SUCCESS_COLOR);
          AppNavigation.navigateReplacement(context, DrawerScreen());
        }
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future socialLoginGoogle(
      BuildContext context, accessToken, name, email, image) async {
    var _timezone = await FlutterNativeTimezone.getLocalTimezone();
    // FCM_Token = prefs.getString("fcmToken");
    String tokens = await FirebaseMessaging.instance.getToken();
    Map<String, String> requestBody = <String, String>{
      "access_token": accessToken,
      "device_token": tokens ?? "testing",
      "device_type": Platform.operatingSystem ?? "ios",
      "provider": "google",
      "name": name,
      "email": email,
      "image": image,
      "phone": "",
      "time_zone": _timezone
    };

    await formDataBaseMethod(context, ApiConst.SOCIAL_LOGIN,
            body: requestBody, bodyCheck: true)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        setUserData(context, value);
        if (value['data']['contact_no'] == null) {
          AppNavigation.navigateTo(context, CompleteProfileScreen());
        } else {
          showToast(value["message"], AppColors.SUCCESS_COLOR);
          AppNavigation.navigateReplacement(context, DrawerScreen());
        }
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  ////====== SOCIAL LOGINS END========/////

  /////======== CORE MODULE =========///////

  Future fetchPrayers(BuildContext context) async {
    var prayerProvider = Provider.of<PrayerProvider>(context, listen: false);

    await getBaseMethod(context, ApiConst.FETCH_PRAYERS_URL + "?type=prayer",
            tokenCheck: true, loading: true)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        prayerProvider.fetchPrayerList(value["data"]);
      } else {
        //showToast(value["message"], AppColors.ERROR_COLOR);
        // if(prayerProvider.prayerList.isNotEmpty){
        //   prayerProvider.resetPrayerProvider();
        // }
      }
    });
  }

  Future addPrayer(BuildContext context, categoryID, desc, title, name) async {
    Map<String, String> requestBody = <String, String>{
      "category": categoryID,
      "description": desc,
      "title": title,
      "name": name,
      "type": "prayer",
    };

    await formDataBaseMethod(context, ApiConst.ADD_PRAYER_URL,
            tokenCheck: true, bodyCheck: true, body: requestBody)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Prayer Added", AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateTo(context, PrayerPraiseTabScreen());
      }
    });
  }

  Future updatePrayer(
      BuildContext context, categoryID, prayerId, desc, title, name) async {
    Map<String, String> requestBody = <String, String>{
      "category": categoryID.toString(),
      "description": desc,
      "title": title,
      "name": name,
      "type": "prayer",
      "prayer": prayerId.toString(),
    };

    await formDataBaseMethod(context, ApiConst.UPDATE_PRAYER_URL,
            body: requestBody, bodyCheck: true, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateReplacement(
            context,
            PrayerPraiseTabScreen(
              tabInitialIndex: 0,
            ));
      }
    });
  }

  Future deletePrayer(BuildContext context, prayerID) async {
    Map<String, String> requestBody = <String, String>{
      "prayer": prayerID.toString(),
    };

    await formDataBaseMethod(context, ApiConst.DELETE_PRAYER_URL,
            bodyCheck: true, body: requestBody, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        fetchPrayers(context);
      }
    });
  }

  Future fetchPraise(BuildContext context) async {
    var praiseProvider = Provider.of<PrayerProvider>(context, listen: false);

    await getBaseMethod(context, ApiConst.FETCH_PRAYERS_URL + "?type=praise",
            tokenCheck: true, loading: true)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        praiseProvider.fetchPraiseList(value["data"]);
      } else {
        //showToast(value["message"], AppColors.ERROR_COLOR);
        praiseProvider.restPraise();
      }
    });
  }

  Future addPraise(BuildContext context, categoryID, desc, title, name) async {
    Map<String, String> requestBody = <String, String>{
      "category": categoryID,
      "description": desc,
      "title": title,
      "name": name,
      "type": "praise",
    };

    await formDataBaseMethod(context, ApiConst.ADD_PRAYER_URL,
            tokenCheck: true, bodyCheck: true, body: requestBody)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        showToast("Praise Added", AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateTo(
            context,
            PrayerPraiseTabScreen(
              tabInitialIndex: 1,
            ));
      }
    });
  }

  Future updatePraise(
      BuildContext context, categoryID, praiseId, desc, title, name) async {
    Map<String, String> requestBody = <String, String>{
      "category": categoryID.toString(),
      "description": desc,
      "title": title,
      "name": name,
      "type": "praise",
      "prayer": praiseId.toString(),
    };

    await formDataBaseMethod(context, ApiConst.UPDATE_PRAYER_URL,
            body: requestBody, bodyCheck: true, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateReplacement(
            context,
            PrayerPraiseTabScreen(
              tabInitialIndex: 1,
            ));
      }
    });
  }

  Future deletePraise(BuildContext context, praiseID) async {
    Map<String, String> requestBody = <String, String>{
      "prayer": praiseID.toString(),
    };

    await formDataBaseMethod(context, ApiConst.DELETE_PRAYER_URL,
            bodyCheck: true, body: requestBody, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        fetchPraise(context);
      } else {}
    });
  }

  Future finishPrayer(BuildContext context, prayerID, prayerDuration) async {
    Map<String, String> requestBody = <String, String>{
      "prayer": prayerID.toString(),
      "prayer_duration": prayerDuration
    };

    await formDataBaseMethod(context, ApiConst.ANSWER_PRAYER_URL,
            body: requestBody, bodyCheck: true, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Ended", AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);

        AppNavigation.navigateReplacement(context, PrayerPraiseTabScreen());
        fetchPrayers(context);
      }
    });
  }

  Future searchPrayer(BuildContext context, search) async {
    var praiseProvider = Provider.of<PrayerProvider>(context, listen: false);

    getBaseMethod(context, ApiConst.SEARCH_PRAYERS_URL + "?search=${search}",
            loading: true, tokenCheck: true)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        praiseProvider.fetchSearchList(value["data"]);
      } else {
        praiseProvider.resetPrayerSearchList();
        praiseProvider.resetPraiseSearchList();
        //showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future searchGroupPartners(BuildContext context, search) async {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);

    await getBaseMethod(
            context, ApiConst.SEARCH_PARTNERS_URL + "?search=${search}",
            tokenCheck: true, loading: true)
        .then((value) {
      if (value["status"] == 1) {
        userProvider.fetchSearchListPartners(value["data"]);
      } else {
        //showToast(value["message"], AppColors.ERROR_COLOR);
        userProvider.resetSearchPartnersList();
      }
    });
  }

  Future fetchReminderList(BuildContext context) async {
    var reminderProvider =
        Provider.of<ReminderProvider>(context, listen: false);

    await getBaseMethod(context, ApiConst.FETCH_REMINDERS_URL,
            tokenCheck: true, loading: true)
        .then((value) {
      if (value["status"] == 1) {
        reminderProvider.fetchReminderList(value["data"]);
      } else {
        reminderProvider.resetReminderModel();
      }
    });
  }

  Future addReminder(BuildContext context, title, frequency, reminderTime,
      reminderDate) async {
    Map<String, String> requestBody = <String, String>{
      "title": title,
      "reminder_date": reminderDate,
      "type": frequency,
      "reminder_time": reminderTime,
    };

    await formDataBaseMethod(context, ApiConst.ADD_REMINDER_URL,
            bodyCheck: true, body: requestBody, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Reminder Added", AppColors.SUCCESS_COLOR);
        // Navigator.pop(context);
        // fetchReminderList(context);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateReplacement(context, ReminderScreen());
      }
    });
  }

  Future updateReminder(BuildContext context, title, frequency, reminderTime,
      reminderDate, reminderID) async {
    Map<String, String> requestBody = <String, String>{
      "title": title,
      "reminder_date": reminderDate,
      "type": frequency,
      "reminder_time": reminderTime,
      "reminder": reminderID.toString(),
    };
    await formDataBaseMethod(context, ApiConst.UPDATE_REMINDER_URL,
            bodyCheck: true, body: requestBody, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Reminder Updated", AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateReplacement(context, ReminderScreen());
      }
    });
  }

  Future deleteReminder(BuildContext context, reminderID) async {
    Map<String, String> requestBody = <String, String>{
      "reminder": reminderID.toString(),
    };

    formDataBaseMethod(context, ApiConst.DELETE_REMINDER_URL,
            bodyCheck: true, body: requestBody, tokenCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Reminder Deleted", AppColors.SUCCESS_COLOR);
        fetchReminderList(context);
      } else {}
    });
  }

  Future fetchPartnersList(BuildContext context) async {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    await getBaseMethod(context, ApiConst.FETCH_PARTNERS_URL,
            loading: true, tokenCheck: true)
        .then((value) {
      if (value != null) if (value["status"] == 1) {
        userProvider.fetchPrayerPartners(value["data"]);
      } else {
        //showToast(value["message"], AppColors.ERROR_COLOR);
        userProvider.resetPartnersList();
      }
    });
  }

  Future addPrayerPartners(
      BuildContext context, contact, name, countryCode) async {
    Map<String, String> requestBody = <String, String>{
      "contact_no": contact,
      "name": name,
      "country_code": countryCode
    };

    var isContact = await formDataBaseMethod(context, ApiConst.ADD_PARTNERS_URL,
            tokenCheck: true, body: requestBody, bodyCheck: true)
        .then((value) {
      if (value["status"] == 0) {
        showToast(value["message"], AppColors.ERROR_COLOR);
        return value;

        // AppNavigation.navigatorPop(context);

      } else {
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateReplacement(context, PrayerPartnerListScreen());
        return value;
      }
    });
    return isContact;
  }

  Future fetchGroups(BuildContext context) async {
    var groupProvider = Provider.of<GroupProvider>(context, listen: false);
    await getBaseMethod(context, ApiConst.FETCH_GROUP_PRAYER,
            tokenCheck: true, loading: true)
        .then((value) {
      if (value["status"] == 1) {
        groupProvider.fetchGroups(value["data"]);
      } else {
        // showToast(value["message"], AppColors.ERROR_COLOR);
        groupProvider.resetGroupsList();
      }
    });
  }

  Future fetchGroupMembers(BuildContext context) async {
    var groupProvider = Provider.of<GroupProvider>(context, listen: false);

    await getBaseMethod(context, ApiConst.FETCH_GROUP_PRAYER,
            tokenCheck: true, loading: true)
        .then((value) {
      if (value["status"] == 1) {
        value["data"].forEach((element) {
          groupProvider.fetchGroupMembersList(element["member"]);
        });
      }
    });
  }

  Future addPrayerGroup(
    BuildContext context,
    name,
    member,
  ) async {
    Map<String, String> requestBody = <String, String>{
      "members": member,
      "name": name,
    };

    await formDataBaseMethod(context, ApiConst.ADD_PRAYER_GROUP_URL,
            tokenCheck: true, body: requestBody, bodyCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Prayer Group Added", AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        fetchGroups(context);
        //AppNavigation.navigateTo(context, PrayerGroupListScreen());
      }
    });
  }

  Future updatePrayerGroup(BuildContext context, groupID, name, member) async {
    Map<String, String> requestBody = <String, String>{
      "members": member,
      "name": name,
      "group": groupID.toString(),
    };

    await formDataBaseMethod(context, ApiConst.UPDATE_PRAYER_GROUP,
            tokenCheck: true, bodyCheck: true, body: requestBody)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Group Updated", AppColors.SUCCESS_COLOR);
        AppNavigation.navigatorPop(context);
        fetchGroups(context);
        // AppNavigation.navigateTo(context, PrayerGroupListScreen());
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future deleteGroupPrayer(BuildContext context, groupID) async {
    Map<String, String> requestBody = <String, String>{
      "group": groupID.toString(),
    };

    await formDataBaseMethod(context, ApiConst.DELETE_PRAYER_GROUP,
            tokenCheck: true, body: requestBody, bodyCheck: true)
        .then((value) {
      if (value["status"] == 1) {
        showToast("Group Deleted", AppColors.SUCCESS_COLOR);

        fetchGroups(context);
        //AppNavigation.navigateTo(context, PrayerGroupListScreen());
      } else {
        showToast(value["message"], AppColors.ERROR_COLOR);
      }
    });
  }

  Future<List<NotificationModel>> fetchNotificationList(
      BuildContext context) async {
    var notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    await getBaseMethod(context, ApiConst.NOTIFICATION_URL,
            tokenCheck: true, loading: true)
        .then((value) {
      if (value["status"] == 1) {
        notificationProvider.fetchNotification(value["data"]);
      } else {
        notificationProvider.resetNotificationList();
      }
    });
    return notificationProvider.notificationList;
  }

  /////////CALL SERVICE/////////

  Future joinCall(Map message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Channel:" + message["channel"].toString());
    return await postBaseMethod("${ApiConst.AGORA_BASE_URL}/joining-call", {
      "isPublisher": false,
      "reciever_id": prefs.getInt("userID"),
      "channel": message["channel"],
      "sender_id": message["user"] ?? null,
      "group_id": message["group"] ?? null
    });
  }

  Future rejectCall(Map message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await postBaseMethod("${ApiConst.AGORA_BASE_URL}/reject-call", {
      "reciever_id": prefs.getInt("userID"),
      "sender_id": message["user"] ?? null,
      "channel": message["channel"],
      "group_id": message["group_id"] ?? null
    });
  }

  Future<dynamic> cancelCall(channelName, id) async {
    await postBaseMethod("${ApiConst.AGORA_BASE_URL}/leave-channel",
        {"channel": channelName, "user_id": id}).then((value) {
      print("Leave Channel Value:" + value.toString());
      return value;
    });
  }

  Future createPayment(context, productID, purchaseID, token, type) async {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> requestBody = <String, String>{
      "product_id": productID,
      "purchase_id": purchaseID,
      "ver_token": token,
      "name": Platform.operatingSystem ?? "ios",
      "type": type,
    };

    formDataBaseMethod(context, "payment",
            body: requestBody, tokenCheck: true, bodyCheck: true)
        .then((value) {
      if (value != null) {
        if (value['status'] == 1) {
          userProvider.setUser(AppUser.fromJson(value['data']));
          print("${userProvider.appUser.id}");
          prefs.setString("${userProvider.appUser.id}",
              value['data']['user_package']['ver_token']);
          prefs.setString("user", jsonEncode(AppUser.fromJson(value["data"])));

          AppNavigation.navigateTo(context, CreatePrayerGroupScreen());
        }
      }
    });
  }

  Future verifyPayment(context) async {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tok = prefs.getString("userPackageToken") ?? "sda";
    Map<String, String> requestBody = <String, String>{
      "token": tok,
      "device_type": Platform.operatingSystem ?? "ios",
      "action": "verify",
    };
    print(requestBody);
    formDataBaseMethodPayment(
            context, "https://myprayerapp.com/webservices/verify/veri.php",
            body: requestBody, tokenCheck: true)
        .then((value) {
      if (value != null) {
        print(" ===>>>>>  $value");
        if (value['status'] == 0) {
          AppNavigation.navigateTo(context, BuyNowSubscription());
        } else {
          AppNavigation.navigateTo(context, CreatePrayerGroupScreen());
        }
      }
    });
  }

  /////======== CORE MODULE END =========///////

  void login(BuildContext context, {email, password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // FCM_Token = prefs.getString("fcmToken");
    String tokens = await FirebaseMessaging.instance.getToken();
    await postBaseMethod(ApiConst.SIGN_IN_URL, {
      "email": email ?? "",
      "password": password ?? "",
      "device_token": tokens ?? "testing",
      "device_type": Platform.operatingSystem ?? "ios"
    }).then((value) {
      if (value["status"] == 0) {
        showToast(value["message"], AppColors.ERROR_COLOR);
      } else {
        prefs.setInt("userID", value["data"]["id"]);
        id = prefs.getInt("userID");
        debugPrint("LocalID:" + id.toString());
        prefs.setString("token", value["bearer_token"]);
        token = prefs.getString("token");
        debugPrint(token.toString());
        showToast(value["message"], AppColors.SUCCESS_COLOR);
        AppNavigation.navigateTo(context, DrawerScreen());
      }
    });
  }
}
