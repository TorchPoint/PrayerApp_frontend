import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';

class CustomBackgroundContainer extends StatelessWidget {
  final Widget child;

  CustomBackgroundContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
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
      child: child,
    );
  }
}
