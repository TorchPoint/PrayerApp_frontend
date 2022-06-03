
import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/drawer/drawer_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';

class CustomAppBar extends StatelessWidget {
  final Function leadingTap, trailingTap;
  final String title, leadingIconPath, trailingIconPath;
  final bool isBarImage;
  final double titleTextSize, paddingTop, trailingIconSize, leadingIconSize;

  CustomAppBar(
      {this.title,
      this.leadingIconPath,
      this.leadingTap,
      this.trailingIconPath,
      this.trailingIconSize,
      this.leadingIconSize,
      this.isBarImage = true,
      this.titleTextSize,
      this.paddingTop,
      this.trailingTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.only(top: paddingTop ?? 10.0, bottom: 4.0),
        color: AppColors.TRANSPARENT_COLOR,
        child: Column(
          children: [
            Visibility(
                visible: isBarImage,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: GestureDetector(
                        onTap: () {
                          AppNavigation.navigateToRemovingAll(
                              context, DrawerScreen());
                        },
                        child: Image.asset(
                          AssetPaths.FOREGROUND_IMAGE,
                          width: 110.0,
                        ))
                )),
            Row(
              children: [
                leadingIconPath != null
                    ? GestureDetector(
                        onTap: leadingTap,
                        child: Container(
                          width: 22.0,
                          height: 22.0,
                          margin: EdgeInsets.only(top: 2.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(leadingIconPath),
                                  fit: BoxFit.contain)),
                        ))
                    : Container(
                        width: 22.0,
                        height: 22.0,
                        color: AppColors.TRANSPARENT_COLOR,
                      ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 2.5),
                      child: Text(
                        title ?? "",
                        textAlign: TextAlign.center,
                        textScaleFactor: titleTextSize ?? 1.5,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
                trailingIconPath != null
                    ? GestureDetector(
                        onTap: trailingTap,
                        child: Container(
                          width: 22.0,
                          height: 22.0,
                          margin: EdgeInsets.only(top: 2.5),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(trailingIconPath),
                                  fit: BoxFit.contain)),
                        ))
                    : Container(
                        width: 22.0,
                        height: 22.0,
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
