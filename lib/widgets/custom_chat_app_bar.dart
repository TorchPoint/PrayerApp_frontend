import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/drawer/drawer_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';

class CustomChatAppBar extends StatelessWidget {
  final Function leadingTap, trailingVideoTap, trailingAudioTap;
  final String title,
      leadingIconPath,
      trailingVideoIconPath,
      trailingAudioIconPath;

  CustomChatAppBar(
      {this.title,
      this.leadingIconPath,
      this.leadingTap,
      this.trailingVideoIconPath,
      this.trailingVideoTap,
      this.trailingAudioIconPath,
      this.trailingAudioTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.only(top: 20.0, bottom: 4.0),
        color: AppColors.TRANSPARENT_COLOR,
        child: Column(
          children: [
            Visibility(
                visible: true,
                child: GestureDetector(
                    onTap: () {
                      AppNavigation.navigateToRemovingAll(
                          context, DrawerScreen());
                    },
                    child: Image.asset(
                      AssetPaths.FOREGROUND_IMAGE,
                      width: 110.0,
                    ))),
            Row(
              children: [
                leadingIconPath != null
                    ? InkWell(
                        onTap: leadingTap,
                        child: Container(
                          width: 22.0,
                          height: 22.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(leadingIconPath),
                                  fit: BoxFit.contain)),
                        ),
                      )
                    : Container(
                        width: 22.0,
                        height: 22.0,
                        color: AppColors.TRANSPARENT_COLOR,
                      ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        title ?? "",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
                trailingVideoIconPath != null
                    ? InkWell(
                        onTap: trailingVideoTap,
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(trailingVideoIconPath),
                                  fit: BoxFit.contain)),
                        ),
                      )
                    : Container(
                        width: 0.0,
                        height: 0.0,
                        color: AppColors.TRANSPARENT_COLOR,
                      ),
                SizedBox(width: 15.0),
                trailingAudioIconPath != null
                    ? InkWell(
                        onTap: trailingAudioTap,
                        child: Container(
                          width: 18.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    trailingAudioIconPath,
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                      )
                    : Container(
                        width: 0.0,
                        height: 0.0,
                        color: AppColors.TRANSPARENT_COLOR,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
