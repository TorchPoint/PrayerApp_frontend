import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/chat_audio_video/screens/chat_screen.dart';
import 'package:prayer_hybrid_app/prayer_group/screens/create_prayer_group_screen.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/finish_praying_screen.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/subscription/screens/buy_now_subscription.dart';
import 'package:prayer_hybrid_app/subscription/screens/pay_subscription_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerGroupListScreen extends StatefulWidget {
  @override
  _PrayerGroupListScreenState createState() => _PrayerGroupListScreenState();
}

class _PrayerGroupListScreenState extends State<PrayerGroupListScreen> {
  int prayerGroupSelectedIndex = 0;

  BaseService baseService = BaseService();

  void loadID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString("userID");
  }

  @override
  void initState() {
    // TODO: implement initState
    baseService.fetchGroups(context);
    baseService.loadLocalUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var groupProvider = Provider.of<GroupProvider>(context, listen: true);
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Column(
          children: [
            _customAppBar(),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: groupProvider.groupList == null ||
                      groupProvider.groupList.length == 0
                  ? Center(
                      child: Text(
                        "No Groups Found",
                        style: TextStyle(color: AppColors.WHITE_COLOR),
                      ),
                    )
                  : ListView.builder(
                      itemCount: groupProvider.groupList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return _praiyerGroupsListWidget(index);
                      }),
            ),
            SizedBox(
              height: 19.0,
            ),
            _createGroupWidget(),
            SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      title: AppStrings.PRAYER_GROUPS_TEXT,
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  //_prayerGroupsListWidget
  Widget _praiyerGroupsListWidget(int groupIndex) {
    var groupProvider = Provider.of<GroupProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        print("next screen");

        AppNavigation.navigateTo(
            context,
            ChatScreen(
              role: 1,
              groupPrayerModel: groupProvider.groupList[groupIndex],
            ));
      },
      onLongPress: () {
        setState(() {
          prayerGroupSelectedIndex = groupIndex;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: 7.5,
            bottom: 7.5),
        padding:
            EdgeInsets.only(top: 13.0, bottom: 13.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: prayerGroupSelectedIndex == groupIndex
                ? AppColors.BUTTON_COLOR
                : AppColors.WHITE_COLOR,
            borderRadius: BorderRadius.circular(23.0),
            boxShadow: prayerGroupSelectedIndex == groupIndex
                ? [
                    BoxShadow(
                      color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
                : []),
        child: Row(
          children: [
            Expanded(
              child: Text(
                groupProvider.groupList[groupIndex].name,
                style: TextStyle(
                    fontSize: 14,
                    color: prayerGroupSelectedIndex == groupIndex
                        ? AppColors.WHITE_COLOR
                        : AppColors.BLACK_COLOR,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
            Spacer(),
            baseService.id == groupProvider.groupList[groupIndex].groupAdmin.id
                ? GestureDetector(
                    onTap: () {
                      AppNavigation.navigateTo(
                          context,
                          CreatePrayerGroupScreen(
                            groupPrayerModel:
                                groupProvider.groupList[groupIndex],
                          ));
                    },
                    child: Image.asset(
                      AssetPaths.EDIT_ICON,
                      height: 18,
                    ),
                  )
                : Container(),
            SizedBox(
              width: 10,
            ),
            baseService.id == groupProvider.groupList[groupIndex].groupAdmin.id
                ? GestureDetector(
                    onTap: () {
                      baseService.deleteGroupPrayer(
                          context, groupProvider.groupList[groupIndex].id);
                    },
                    child: Image.asset(
                      AssetPaths.DELETE_ICON,
                      height: 18,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  //Create Group Button Widget
  Widget _createGroupWidget() {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);

    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.73,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.ADD_NEW_GROUP_TEXT.toUpperCase(),
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.2,
      paddingTop: 13.5,
      paddingBottom: 13.5,
      onTap: ()async {
        //log(userProvider.appUser.userPackage.toString());
        // AppNavigation.navigateTo(context, BuyNowSubscription());
        //userProvider.appUser.userPackage != null
        if (Platform.isIOS) {
          baseService.verifyPayment(context);
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print("${userProvider.appUser.id}");
          String token = prefs.getString("${userProvider.appUser.id}")??"empty";
          print(token);
          if(token!="empty"){
            AppNavigation.navigateTo(context, CreatePrayerGroupScreen());
          }
          else {
            AppNavigation.navigateTo(context, BuyNowSubscription());
          }
        }
        // userProvider.appUser.userPackage == null
        //     ? AppNavigation.navigateTo(context, BuyNowSubscription())
        //     : AppNavigation.navigateTo(context, CreatePrayerGroupScreen());
      },
    );
  }
}
