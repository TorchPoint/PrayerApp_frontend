import 'package:flutter/material.dart';

import 'package:prayer_hybrid_app/complete_profile/screens/complete_profile_screen.dart';
import 'package:prayer_hybrid_app/home/home_screen.dart';

import 'package:prayer_hybrid_app/notification/screens/notification_screen.dart';
import 'package:prayer_hybrid_app/password/change_password.dart';
import 'package:prayer_hybrid_app/prayer_group/screens/prayer_group_list_screen.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/prayer_praise_tab_screen.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/reminder_calendar/screens/reminder_screen.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/terms_privacy_screen/screens/terms_privacy_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool settingsOn = false;
  AnimationController _animationController;
  BaseService baseService = BaseService();

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    return WillPopScope(
      child: CustomBackgroundContainer(
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColors.TRANSPARENT_COLOR,
              drawer: Drawer(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                        AppColors.BACKGROUND1_COLOR,
                        AppColors.BACKGROUND2_COLOR,
                        AppColors.BACKGROUND2_COLOR,
                      ],
                          stops: [
                        0.1,
                        0.5,
                        1.0
                      ])),
                  child: SafeArea(
                    child: Column(
                      children: [
                        //For Profile Container
                        profileData(),
                        //For Menu Container
                        Expanded(
                          child: userMenuData(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  _customAppBar(),
                  Expanded(
                    child: HomeScreen(),
                  ),
                ],
              ))),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      title: AppStrings.HOME_TEXT,
      leadingIconPath: AssetPaths.MENU_ICON,
      paddingTop: 20.0,
      isBarImage: false,
      leadingIconSize: 25.0,
      leadingTap: () {
        _scaffoldKey.currentState.openDrawer();
      },
      trailingIconPath: AssetPaths.NOTIFICATION_ICON,
      trailingTap: () {
        AppNavigation.navigateTo(context, ReminderScreen());
      },
    );
  }

  //It includes user image and and close drawer button
  Widget profileData() {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                AppNavigation.navigatorPop(context);
              },
              child: Container(
                width: 21.0,
                height: 21.0,
                margin: EdgeInsets.only(right: 20.0, top: 12.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AssetPaths.BACK_ICON),
                        fit: BoxFit.contain)),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            AppNavigation.navigateTo(context, CompleteProfileScreen());
          },
          child: Container(
            margin: EdgeInsets.only(
                left: 18.0,
                right: 15.0,
                top: MediaQuery.of(context).size.height * 0.04,
                bottom: MediaQuery.of(context).size.height * 0.07),
            child: Row(
              children: [
                Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    color: AppColors.BACKGROUND1_COLOR,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: userProvider.appUser?.profileImage == null
                            ? AppColors.WHITE_COLOR
                            : AppColors.WHITE_COLOR,
                        width: 2.0),
                    image: DecorationImage(
                        image: userProvider.appUser?.profileImage != null
                            ? NetworkImage(userProvider.appUser?.profileImage)
                            : AssetImage(AssetPaths.NO_IMAGE),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(child: profileSubData()),
              ],
            ),
          ),
        )
      ],
    );
  }

  //It includes user name , user phone no, user email
  Widget profileSubData() {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.0,
        ),
        Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Text(
              "${userProvider.appUser?.firstName} ${userProvider.appUser?.lastName}" ??
                  "",
              style: TextStyle(
                  color: AppColors.WHITE_COLOR,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5),
              textScaleFactor: 1.25,
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
        SizedBox(
          height: 6.0,
        ),
        Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: userProvider.appUser?.contactNo == null ||
                    userProvider.appUser.contactNo.isEmpty
                ? Container()
                : Text(
                    // userProvider.appUser.contactNo ?? AppStrings.USER_PHONE_NO_TEXT,
                    userProvider.appUser.countryCode +
                        " " +
                        userProvider.appUser?.contactNo,
                    style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700),
                    textScaleFactor: 0.98,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
        SizedBox(
          height: 5.0,
        ),
        Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: userProvider.appUser?.email == null ||
                    userProvider.appUser.email.isEmpty
                ? Container()
                : Text(
                    userProvider.appUser?.email,
                    style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700),
                    textScaleFactor: 0.98,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
        SizedBox(
          height: 6.0,
        ),
      ],
    );
  }

  Widget userMenuData() {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        menuListTile(
            imagePath: AssetPaths.NOTIFICATION_ICON,
            title: AppStrings.NOTIFICATION_TEXT,
            index: 7,
            topMargin: 10.0,
            bottomMargin: 20.0,
            imageWidth: 21,
            sizedBoxWidth: 35,
            leftPadding: 20.0,
            dividerContainer: false),

        //For Timer
        menuListTile(
            imagePath: AssetPaths.TERMS_CONDITION_MENU_ICON,
            title: AppStrings.TERMS_CONDITIONS_TEXT,
            index: 8,
            topMargin: 10.0,
            bottomMargin: 20.0,
            imageWidth: 18,
            sizedBoxWidth: 38,
            leftPadding: 20.0,
            dividerContainer: false),

        //For Security
        menuListTile(
            imagePath: AssetPaths.PRIVACY_POLICY_MENU_ICON,
            title: AppStrings.PRIVACY_POLICY_TEXT,
            index: 9,
            topMargin: 10.0,
            bottomMargin: 20.0,
            imageWidth: 20,
            sizedBoxWidth: 37,
            leftPadding: 20.0),
        //For Settings

        //For Change Password

        userProvider.appUser?.isSocial == "yes"
            ? Container()
            : menuListTile(
                imagePath: AssetPaths.PASSWORD_ICON,
                title: AppStrings.CHANGE_PASSWORD,
                index: 11,
                topMargin: 14.0,
                bottomMargin: 20.0,
                imageWidth: 18,
                sizedBoxWidth: 39,
                leftPadding: 20.0,
                imageColor: AppColors.WHITE_COLOR.withOpacity(0.8),
                dividerContainer: false),

        //For Logout
        menuListTile(
            imagePath: AssetPaths.LOGOUT_MENU_ICON,
            title: AppStrings.LOGOUT_TEXT,
            index: 10,
            topMargin: 14.0,
            bottomMargin: 20.0,
            imageWidth: 18,
            sizedBoxWidth: 39,
            leftPadding: 20.0,
            imageColor: AppColors.WHITE_COLOR.withOpacity(0.8),
            dividerContainer: false),

        SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  Widget menuListTile(
      {String imagePath,
      String title,
      Widget menuWidget,
      int index,
      Color imageColor,
      double topMargin,
      double bottomMargin,
      double imageWidth,
      double sizedBoxWidth,
      double leftPadding,
      Color backgroundContainerColor,
      IconData settingIcon,
      bool dividerContainer = true}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            navigateToNewScreen(navigateIndex: index);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: backgroundContainerColor ?? AppColors.TRANSPARENT_COLOR,
            padding: EdgeInsets.only(
                left: leftPadding, top: topMargin, bottom: bottomMargin),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagePath, width: imageWidth, color: imageColor),
                SizedBox(
                  width: sizedBoxWidth,
                ),
                Expanded(
                    child: Text(
                  title,
                  style: TextStyle(
                      color: AppColors.WHITE_COLOR,
                      fontWeight: FontWeight.w700),
                  textScaleFactor: 1.3,
                )),
                // settingIcon != null
                //     ? Padding(
                //         padding: EdgeInsets.only(right: 10.0),
                //         child: Icon(
                //           settingIcon,
                //           color: AppColors.WHITE_COLOR.withOpacity(0.9),
                //         ))
                //     : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void navigateToNewScreen({int navigateIndex}) {
    //For My Prayer List
    if (navigateIndex == 1) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateTo(
          context,
          PrayerPraiseTabScreen(
            tabInitialIndex: 0,
          ));
    }
    //For My Praise List
    else if (navigateIndex == 2) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateTo(
          context,
          PrayerPraiseTabScreen(
            tabInitialIndex: 1,
          ));
    }
    //For Shared Prayers
    else if (navigateIndex == 3) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateTo(context, PrayerPraiseTabScreen());
    }
    //For Prayer Groups List
    else if (navigateIndex == 4) {
      AppNavigation.navigatorPop(context);
      // AppNavigation.navigateTo(context, CreatePrayerGroupScreen());
      AppNavigation.navigateTo(context, PrayerGroupListScreen());
    }
    //For Report
    else if (navigateIndex == 5) {
      AppNavigation.navigatorPop(context);
    }
    //For Settings
    else if (navigateIndex == 6) {
      //AppNavigation.navigatorPop(context);

      settingsOn = !settingsOn;
      settingsOn == true
          ? _animationController.forward()
          : _animationController.reverse();
      setState(() {});
    }
    //For Notification
    else if (navigateIndex == 7) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateTo(context, NotificationScreen());
    }
    //For Terms & Conditions
    else if (navigateIndex == 8) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateTo(
          context, TermsPrivacyScreen(title: AppStrings.TERMS_CONDITIONS_TEXT));
    }
    //For Privacy Policy
    else if (navigateIndex == 9) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateTo(
          context, TermsPrivacyScreen(title: AppStrings.PRIVACY_POLICY_TEXT));
    }
    //For Logout
    else if (navigateIndex == 10) {
      baseService.logoutUser(context);
    } else if (navigateIndex == 11) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateTo(context, ChangePasswordScreen());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
