import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';

class CommonAudioVideoIconsContainer extends StatelessWidget {
  final String image;
  final Color containerColor;
  final VoidCallback onTap;
  final double imageWidth;
  final bool shadow;
  CommonAudioVideoIconsContainer({this.image,this.containerColor,this.imageWidth,this.shadow = false,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:78.0,
        height: 78.0,
        decoration: BoxDecoration(
            color: containerColor ?? AppColors.WHITE_COLOR,
            shape: BoxShape.circle,
            boxShadow: shadow ? [
            BoxShadow(
              color: AppColors.BLACK_COLOR.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 2), // changes position of shadow
            ),
            ]
            :
            []
        ),
        child: Center(
          child: Image.asset(image,width: imageWidth,),
        ),
      ),
    );
  }
}
