import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prayer_hybrid_app/common_classes/share_class.dart';
import 'package:prayer_hybrid_app/drawer/drawer_screen.dart';
import 'package:prayer_hybrid_app/home/home_screen.dart';
import 'package:prayer_hybrid_app/models/group_prayer_model.dart';
import 'package:prayer_hybrid_app/models/user_model.dart';
import 'package:prayer_hybrid_app/prayer_group/screens/prayer_group_list_screen.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;

class CreatePrayerGroupScreen extends StatefulWidget {
  final GroupPrayerModel groupPrayerModel;

  CreatePrayerGroupScreen({this.groupPrayerModel});

  @override
  _CreatePrayerGroupScreenState createState() =>
      _CreatePrayerGroupScreenState();
}

class _CreatePrayerGroupScreenState extends State<CreatePrayerGroupScreen> {
  TextEditingController _groupTitleController = TextEditingController();
  TextEditingController _searchMemberController = TextEditingController();
  final membersList = ['John', 'Mathews', 'Brain', 'Tom', 'Terry'];
  List<AppUser> user = [];
  List<AppUser> groupMemberList = [];
  bool groupTitleBool = true;
  bool groupMemberBool = true;
  String currentMember = "";
  BaseService baseService = BaseService();
  int selectedIndex = 0;
  List<int> memberIds = [];
  bool check = false;

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse(ApiConst.BASE_URL + ApiConst.FETCH_PARTNERS_URL);

    final http.Response response = await http.get(uri,
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"});

    if (response.statusCode == 200) {
      print(response.body);
      Map data = jsonDecode(response.body);

      data["data"].forEach((element) {
        user.add(AppUser.fromJson(element));
        setState(() {});
      });
      return user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.groupPrayerModel != null) {
      baseService.fetchGroupMembers(context);
      _groupTitleController.text = widget.groupPrayerModel.name;
      groupMemberList = widget.groupPrayerModel.member;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _customAppBar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.075,
                          right: MediaQuery.of(context).size.width * 0.075),
                      child: Text(
                        AppStrings.GROUP_TITLE_TEXT,
                        style: TextStyle(
                            color: AppColors.WHITE_COLOR,
                            fontWeight: FontWeight.w600),
                        textScaleFactor: 1.18,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: _groupTitleTextFormField()),
                  _errorGroupTitleWidget(),
                  SizedBox(
                    height: 18.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.075,
                          right: MediaQuery.of(context).size.width * 0.075),
                      child: Text(
                        AppStrings.GROUP_MEMBERS_TEXT,
                        style: TextStyle(
                            color: AppColors.WHITE_COLOR,
                            fontWeight: FontWeight.w600),
                        textScaleFactor: 1.18,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: _searchMembersTextFormField()),
                  SizedBox(
                    height: 10.0,
                  ),
                  _searchMemberController.text.isEmpty
                      ? Container()
                      : Wrap(
                          children: List.generate(
                              userProvider.searchPartnersList?.length ?? 0,
                              (index) {
                            return _searchUserWidget(index);
                          }),
                        ),
                  _errorMemberWidget(),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Align(alignment: Alignment.center, child: _addMemberWidget()),
                  SizedBox(
                    height: 10.0,
                  ),
                  _groupMembersListTextWidget(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: groupMemberList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext ctxt, int index) {
                                return _groupMembersListWidget(index);
                              }),
                          SizedBox(
                            height: 10.0,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: _createGroupWidget()),
                          SizedBox(
                            height: 10.0,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: _inviteToPrayerAppWidget()),
                          SizedBox(
                            height: 10.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);

    return CustomAppBar(
      title: AppStrings.PRAYER_GROUPS_TEXT,
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        userProvider.appUser.userPackage == null
            ? AppNavigation.navigatorPop(context)
            : AppNavigation.navigateToRemovingAll(context, DrawerScreen());
      },
      // trailingIconPath: AssetPaths.SETTING_ICON,
      // trailingTap: (){
      //   print("Prayer Group Icon");
      // },
    );
  }

  //Group Title Text Form Field
  Widget _groupTitleTextFormField() {
    return CustomTextFormField(
      textController: _groupTitleController,
      containerWidth: MediaQuery.of(context).size.width * 0.85,
      hintText: AppStrings.GROUP_TITLE_HINT_TEXT,
      borderRadius: 28.0,
      contentPaddingTop: 13.0,
      contentPaddingBottom: 13.0,
      contentPaddingRight: 20.0,
      contentPaddingLeft: 20.0,
      hintSize: 15.0,
      textSize: 15.0,
      isCollapsed: true,
      borderColor: groupTitleBool == true
          ? AppColors.TRANSPARENT_COLOR
          : AppColors.ERROR_COLOR,
      filledColor: AppColors.WHITE_COLOR,
      hintColor: AppColors.BLACK_COLOR,
      textColor: AppColors.BLACK_COLOR,
      cursorColor: AppColors.BLACK_COLOR,
    );
  }

  //Search Members Text Form Field
  Widget _searchMembersTextFormField() {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);
    return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075),
        child: CustomTextFormField(
          prefixIconColor: AppColors.BLACK_COLOR,
          filledColor: AppColors.WHITE_COLOR,
          hintColor: AppColors.BLACK_COLOR,
          textColor: AppColors.BLACK_COLOR,
          cursorColor: AppColors.BLACK_COLOR,
          textController: _searchMemberController,
          containerWidth: MediaQuery.of(context).size.width * 0.85,
          hintText: AppStrings.SEARCH_HINT_TEXT,
          borderRadius: 28.0,
          contentPaddingTop: 13.0,
          contentPaddingBottom: 13.0,
          contentPaddingRight: 8.0,
          contentPaddingLeft: 20.0,
          suffixIcon: AssetPaths.SEARCH_ICON,
          suffixColor: AppColors.BLACK_COLOR,
          suffixIconWidth: 15,
          hintSize: 15.0,
          textSize: 15.0,
          isCollapsed: true,
          onChange: (val) {
            if (_searchMemberController.text.isEmpty) {
              userProvider.resetSearchPartnersList();
            } else {
              baseService.searchGroupPartners(context, val.toString());
            }
          },
        ));
  }

  //Error Group Title Widget
  Widget _errorGroupTitleWidget() {
    return groupTitleBool == true
        ? Container()
        : Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.075,
                top: 10.0),
            child: Text(
              AppStrings.GROUP_TITLE_EMPTY_ERROR,
              style: TextStyle(
                fontSize: 13.0,
                color: AppColors.ERROR_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ));
  }

  //Error Member Widget
  Widget _errorMemberWidget() {
    return groupMemberBool == true
        ? Container()
        : Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.075,
                top: 10.0),
            child: Text(
              AppStrings.SEARCH_MEMBER_EMPTY_ERROR,
              style: TextStyle(
                fontSize: 13.0,
                color: AppColors.ERROR_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ));
  }

  Widget _addMemberWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.75,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.ADD_MEMBER_TEXT.toUpperCase(),
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.25,
      paddingTop: 11.5,
      paddingBottom: 11.5,
      onTap: () {
        if (_searchMemberController.text.trim().isEmpty) {
          setState(() {
            groupMemberBool = false;
          });
        } else {
          setState(() {
            groupMemberBool = true;
          });
          //AppNavigation.navigateTo(context,PrayerGroupListScreen());
        }
      },
    );
  }

//Group Members Row Add Widget
  Widget _groupMembersListTextWidget() {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.075,
          right: MediaQuery.of(context).size.width * 0.075),
      child: Text(
        AppStrings.GROUP_MEMBERS_LIST_TEXT,
        style: TextStyle(
            color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w600),
        textScaleFactor: 1.18,
      ),
    );
  }

  //Add Group Members List
  Widget _groupMembersListWidget(int groupMemberIndex) {
    return GestureDetector(
      onTap: () {
        print("group members");
        //AppNavigation.navigateTo(context, BibleChapterDetailsScreen());
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: 8.0,
            bottom:
                groupMemberList.length - 1 == groupMemberIndex ? 16.0 : 8.0),
        padding:
            EdgeInsets.only(top: 13.0, bottom: 13.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          color: AppColors.WHITE_COLOR,
          borderRadius: BorderRadius.circular(23.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                groupMemberList[groupMemberIndex].firstName,
                style: TextStyle(
                    fontSize: 14.5,
                    color: AppColors.BLACK_COLOR,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            widget.groupPrayerModel != null
                ? Container()
                : GestureDetector(
                    onTap: () {
                      groupMemberList.removeAt(groupMemberIndex);
                      setState(() {});
                    },
                    child: Icon(
                      CupertinoIcons.delete,
                      color: AppColors.BLACK_COLOR,
                      size: 16,
                    ))
          ],
        ),
      ),
    );
  }

  //Create Group Button Widget
  Widget _createGroupWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.75,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.ADD_TO_PRAYER_GROUP_TEXT.toUpperCase(),
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.25,
      paddingTop: 11.5,
      paddingBottom: 11.5,
      onTap: () {
        memberIds.clear();
        if (_groupTitleController.text.trim().isEmpty) {
          setState(() {
            groupTitleBool = false;
          });
          print(memberIds);
        } else {
          setState(() {
            groupTitleBool = true;
          });
          if (widget.groupPrayerModel != null) {
            widget.groupPrayerModel.member.forEach((element) {
              memberIds.add(element.id);
            });
            print(memberIds);
            baseService.updatePrayerGroup(
                context,
                widget.groupPrayerModel.id,
                _groupTitleController.text,
                memberIds
                    .toString()
                    .replaceAll("[", "")
                    .toString()
                    .replaceAll("]", ""));
          } else {
            groupMemberList.forEach((element) {
              memberIds.add(element.id);
            });
            print(memberIds
                .toString()
                .replaceAll("[", "")
                .toString()
                .replaceAll("]", ""));
            baseService.addPrayerGroup(
                context,
                _groupTitleController.text,
                memberIds
                    .toString()
                    .replaceAll("[", "")
                    .toString()
                    .replaceAll("]", ""));
          }

          //AppNavigation.navigateTo(context,PrayerGroupListScreen());
          // AppNavigation.navigatorPop(context);
        }
      },
    );
  }

  Widget _searchUserWidget(int index) {
    var userProvider = Provider.of<AppUserProvider>(context, listen: true);
    bool inList = false;
    return GestureDetector(
      onTap: () {
        // check = false;
        if (groupMemberList.length > 0)
          groupMemberList.forEach((element) {
            if (userProvider.searchPartnersList[index].id != element.id) {
            } else {
              inList = true;
              Flushbar(
                icon: Icon(
                  FontAwesomeIcons.exclamationCircle,
                  color: AppColors.WHITE_COLOR,
                ),
                flushbarPosition: FlushbarPosition.TOP,
                barBlur: 20.0,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                borderRadius: BorderRadius.circular(8.0),
                messageText: Text(
                  "User is Already Added",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.BUTTON_COLOR,
                duration: Duration(seconds: 2),
              ).show(context);
              // baseService.showToast(
              //     "User is Already Added", AppColors.ERROR_COLOR);
            }
          });
        else {
          inList = true;
          groupMemberList.add(userProvider.searchPartnersList[index]);
        }

        !inList
            ? groupMemberList.add(userProvider.searchPartnersList[index])
            : null;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: 5,
            bottom: 5),
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
                      image:
                          userProvider.searchPartnersList[index].profileImage ==
                                  null
                              ? AssetImage(AssetPaths.NO_IMAGE)
                              : NetworkImage(userProvider
                                  .searchPartnersList[index].profileImage),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text(
                _searchMemberController.text.isEmpty
                    ? userProvider.searchPartnersList[index].firstName
                    : userProvider.searchPartnersList[index].firstName,
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
  Widget _inviteToPrayerAppWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.75,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.INVITE_TO_PRAYER_APP.toUpperCase(),
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.25,
      paddingTop: 11.5,
      paddingBottom: 11.5,
      onTap: () {
        _inviteFriend();
      },
    );
  }

  void _inviteFriend() {
    ShareClass.shareMethod(
        message:
            "Join me on PrayerApp! It is an awesome and secure app we can use to connect with each other in prayer Download it at: ${Platform.isAndroid ? "https://play.google.com/store/apps/details?id=com.fictivestudios.prayer" : "https://apps.apple.com/us/app/prayerapp-invigorate-life/id1594913575"}");
  }

  @override
  void dispose() {
    super.dispose();
    _groupTitleController.dispose();
    _searchMemberController.dispose();
  }
}
