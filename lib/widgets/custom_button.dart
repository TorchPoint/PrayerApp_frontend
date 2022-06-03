import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final double containerWidth,fontSize,paddingTop,paddingBottom;
  final Color buttonColor,textColor,borderColor;
  final Function onTap;
  final String buttonText;
  final FontWeight fontWeight;
  final bool elevation;

  CustomButton({this.containerWidth,this.buttonColor,this.borderColor,this.buttonText,this.textColor,this.fontWeight,this.fontSize,this.paddingTop,this.paddingBottom,this.elevation,this.onTap});

  @override
  Widget build(BuildContext context) {
     return Container(
      width: containerWidth,
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: borderColor ?? AppColors.TRANSPARENT_COLOR,width: 1.5),
        boxShadow: elevation == true ? [
          BoxShadow(
            color: AppColors.BLACK_COLOR.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ]
         :
         [] ,
      ),
      child: Material(
        color: AppColors.TRANSPARENT_COLOR,
        child: InkWell(
          borderRadius: BorderRadius.circular(30.0),

          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(top: paddingTop ?? 10.0,bottom: paddingBottom ?? 10.0),
            child: Text(buttonText,style: TextStyle(color: textColor,fontWeight: fontWeight ?? FontWeight.w500,letterSpacing: 1.0),textScaleFactor: fontSize,textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }
}
