import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/chat_audio_video/screens/chat_screen.dart';
import 'package:prayer_hybrid_app/common_classes/share_class.dart';
import 'package:prayer_hybrid_app/prayer_group/screens/create_prayer_group_screen.dart';
import 'package:prayer_hybrid_app/prayer_partner/screens/add_prayer_partner_screen.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class PrayerPartnerListScreen extends StatefulWidget {
  @override
  _PrayerPartnerListScreenState createState() =>
      _PrayerPartnerListScreenState();
}

class _PrayerPartnerListScreenState extends State<PrayerPartnerListScreen> {
  TextEditingController _searchController = TextEditingController();
  int prayerPartnerSelectedIndex = 0;

  BaseService baseService = BaseService();

  @override
  void initState() {
    // TODO: implement initState
    baseService.fetchPartnersList(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Column(
          children: [
            _customAppBar(),
            SizedBox(
              height: 20.0,
            ),
            _searchTextFormField(),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: userProvider.prayerPartnersList == null ||
                      userProvider.prayerPartnersList?.length == 0
                  ? Center(
                      child: Text(
                        "No Partners Found",
                        style: TextStyle(color: AppColors.WHITE_COLOR),
                      ),
                    )
                  : _searchController.text.isEmpty
                      ? ListView.builder(
                          itemCount:
                              userProvider.prayerPartnersList?.length ?? 0,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _praiyerGroupsListWidget(index);
                          })
                      : userProvider.searchPartnersList?.length == 0 ||
                              userProvider.searchPartnersList == null
                          ? Center(
                              child: Text(
                                "No Partners Found",
                                style: TextStyle(color: AppColors.WHITE_COLOR),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  userProvider.searchPartnersList?.length ?? 0,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return _praiyerGroupsListWidget(index);
                              }),
            ),
            SizedBox(
              height: 10.0,
            ),
            _addPrayerButtonWidget(),
            SizedBox(
              height: 12.0,
            ),
            _inviteToPrayerAppWidget(),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      title: AppStrings.PRAYER_PARTNERS_TEXT,
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
      //trailingIconPath: AssetPaths.SEARCH_ICON,
      //t
    );
  }

  //Prayer Groups List Widget
  Widget _praiyerGroupsListWidget(int partnerIndex) {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);
    return GestureDetector(
      onTap: () {
        print("next screen");
        //AppNavigation.navigateTo(context, FinishPrayingScreen());
        AppNavigation.navigateTo(
            context,
            ChatScreen(
                role: 0,
                user: _searchController.text.isEmpty
                    ? userProvider.prayerPartnersList[partnerIndex]
                    : userProvider.searchPartnersList[partnerIndex]));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: 7.5,
            bottom: 7.5),
        padding:
            EdgeInsets.only(top: 6.0, bottom: 6.0, left: 12.0, right: 12.0),
        decoration: BoxDecoration(
          color: AppColors.WHITE_COLOR,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          children: [
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _searchController.text.isEmpty
                          ? userProvider.prayerPartnersList[partnerIndex]
                                      .profileImage ==
                                  null
                              ? AssetImage(AssetPaths.NO_IMAGE)
                              : NetworkImage(userProvider
                                  .prayerPartnersList[partnerIndex]
                                  .profileImage)
                          : userProvider.searchPartnersList[partnerIndex]
                                      .profileImage ==
                                  null
                              ? AssetImage(AssetPaths.NO_IMAGE)
                              : NetworkImage(userProvider
                                  .searchPartnersList[partnerIndex]
                                  .profileImage),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text(
                _searchController.text.isEmpty
                    ? userProvider.prayerPartnersList[partnerIndex].firstName
                    : userProvider.searchPartnersList[partnerIndex].firstName,
                style: TextStyle(
                    fontSize: 15.5,
                    color: AppColors.BLACK_COLOR,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Add new prayer button widget
  Widget _addPrayerButtonWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.75,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.ADD_NEW_PRAYER_PARTNER_TEXT.toUpperCase(),
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.2,
      paddingTop: 13.5,
      paddingBottom: 13.5,
      onTap: () {
        //  AppNavigation.navigateTo(context, CreatePrayerGroupScreen());
        AppNavigation.navigateTo(context, AddPrayerPartnerScreen());
      },
    );
  }

  //Add new prayer button widget
  Widget _inviteToPrayerAppWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.75,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.INVITE_TO_PRAYER_APP.toUpperCase(),
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.2,
      paddingTop: 13.5,
      paddingBottom: 13.5,
      onTap: () {
        _inviteFriend();
      },
    );
  }

  Widget _searchTextFormField() {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);
    return CustomTextFormField(
      textController: _searchController,
      containerWidth: MediaQuery.of(context).size.width * 0.85,
      hintText: AppStrings.SEARCH_HINT_TEXT,
      borderRadius: 28.0,
      contentPaddingTop: 13.0,
      contentPaddingBottom: 13.0,
      contentPaddingRight: 8.0,
      contentPaddingLeft: 20.0,
      suffixIcon: AssetPaths.SEARCH_ICON,
      suffixIconWidth: 15,
      hintSize: 15.0,
      textSize: 15.0,
      isCollapsed: true,
      onChange: (val) {
        if (_searchController.text.isEmpty) {
          userProvider.resetSearchPartnersList();
        } else {
          baseService.searchGroupPartners(context, val.toString());
        }
      },
    );
  }

  void _inviteFriend() {
    ShareClass.shareMethod(
        message:
        "Join me on PrayerApp! It is an awesome and secure app we can use to connect with each other in prayer Download it at: ${Platform.isAndroid ? "https://play.google.com/store/apps/details?id=com.fictivestudios.prayer" : "https://apps.apple.com/us/app/prayerapp-invigorate-life/id1594913575"}");
  }
}
