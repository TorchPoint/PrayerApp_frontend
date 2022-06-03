import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/chat_audio_video/widgets/common_audio_video_icons_container.dart';
import 'package:prayer_hybrid_app/drawer/drawer_screen.dart';
import 'package:prayer_hybrid_app/models/group_prayer_model.dart';
import 'package:prayer_hybrid_app/models/user_model.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'audio_screen.dart';

class PreCallingScreen extends StatefulWidget {
  String appUser;
  Map message;

  PreCallingScreen({this.appUser, this.message});

  @override
  _PreCallingScreenState createState() => _PreCallingScreenState();
}

class _PreCallingScreenState extends State<PreCallingScreen> {
  BaseService baseService = BaseService();

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              _userName(),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Calling",
                style: TextStyle(
                    color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w600),
                textScaleFactor: 1.2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
              ),
              _callRespondWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userName() {
    return Text(
      widget.appUser ?? "Mark Miller",
      style:
          TextStyle(color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w600),
      textScaleFactor: 2.2,
    );
  }

  Widget _callRespondWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            CommonAudioVideoIconsContainer(
                image: AssetPaths.END_CALL_ICON,
                containerColor: AppColors.RED_COLOR,
                imageWidth: 28.0,
                shadow: true,
                onTap: () async {
                  var userProvider = Provider.of<AppUserProvider>(
                      navigatorKey.currentContext,
                      listen: false);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  baseService.rejectCall(widget.message).then(
                    (value) {
                      String users = prefs.getString("user");
                      var data = jsonDecode(users);
                      userProvider.setUser(AppUser.fromJson(data));
                      print("USER DATA******:" + data.toString());
                      baseService.showToast(
                          value["message"], AppColors.ERROR_COLOR);
                      AppNavigation.navigateToRemovingAll(
                          navigatorKey.currentContext, DrawerScreen());
                      print("REJECT RESPONSE" + value.toString());
                    },
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Reject",
              style: TextStyle(
                  color: AppColors.WHITE_COLOR, fontWeight: FontWeight.bold),
              textScaleFactor: 1.2,
            ),
          ],
        ),
        Column(
          children: [
            CommonAudioVideoIconsContainer(
                image: AssetPaths.END_CALL_ICON,
                containerColor: Colors.green,
                imageWidth: 28.0,
                shadow: true,
                onTap: () {
                  if (widget.message["type"] == "call") {
                    baseService.joinCall(widget.message).then((value) async {
                      var userProvider = Provider.of<AppUserProvider>(
                          navigatorKey.currentContext,
                          listen: false);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (value["status"] == 1) {
                        String users = prefs.getString("user");
                        var data = jsonDecode(users);
                        userProvider.setUser(AppUser.fromJson(data));
                        AppNavigation.navigateTo(
                            navigatorKey.currentState.context,
                            AudioScreen(
                              channelToken: widget.message["token"],
                              appUser: AppUser.fromJson(value["user"]),
                              channelName: widget.message["channel"],
                            ));
                        return value;
                      } else {
                        baseService.showToast(
                            value["message"], AppColors.ERROR_COLOR);
                        AppNavigation.navigateToRemovingAll(
                            navigatorKey.currentContext, DrawerScreen());
                      }
                    });
                  } else if (widget.message["type"] == "group_call") {
                    baseService.joinCall(widget.message).then((value) async {
                      var userProvider = Provider.of<AppUserProvider>(
                          navigatorKey.currentContext,
                          listen: false);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (value["status"] == 1) {
                        String users = prefs.getString("user");
                        var data = jsonDecode(users);

                        userProvider.setUser(AppUser.fromJson(data));
                        AppNavigation.navigateTo(
                            navigatorKey.currentState.context,
                            AudioScreen(
                              channelToken: widget.message["token"],
                              groupPrayerModel:
                                  GroupPrayerModel.fromJson(value["group"]),
                              channelName: widget.message["channel"],
                            ));
                      } else {
                        baseService.showToast(
                            value["message"], AppColors.ERROR_COLOR);
                        AppNavigation.navigateTo(
                            navigatorKey.currentContext, DrawerScreen());
                      }
                    });
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Accept",
              style: TextStyle(
                  color: AppColors.WHITE_COLOR, fontWeight: FontWeight.bold),
              textScaleFactor: 1.2,
            ),
          ],
        ),
      ],
    );
  }
}
