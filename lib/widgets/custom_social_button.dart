import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';



class CustomSocialButton extends StatelessWidget {
  final double containerWidth,iconWidth,differenceWidth;
  final Color buttonColor,buttonTextColor,iconColor;
  final Function onTap;
  final String buttonText,iconPath;

  CustomSocialButton({this.containerWidth,this.buttonColor,this.buttonText,this.buttonTextColor,this.iconPath,this.iconWidth,this.iconColor,this.differenceWidth,this.onTap});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: containerWidth,
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: buttonColor)
      ),
      child: Material(
        color: AppColors.TRANSPARENT_COLOR,
        child: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(top: 13.0,bottom: 13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width*0.07,),
                Image.asset(iconPath,color: iconColor,width: iconWidth),
               SizedBox(width: differenceWidth),
                Expanded(child: Text(buttonText.toString(), style: TextStyle(color: buttonTextColor,fontWeight: FontWeight.w700,letterSpacing: 1.0),textScaleFactor: 1.10,maxLines: 1,overflow: TextOverflow.ellipsis,)),
              ],
            ),
          ),
        ),
      ),
    );


    // return Container(
    //   width: containerWidth,
    //   height: containerHeight,
    //   child: ElevatedButton.icon(
    //     style: ElevatedButton.styleFrom(
    //         primary: buttonColor,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(30.0),
    //               side: BorderSide(color: buttonColor)
    //           ),
    //         elevation: 0.0,
    //         shadowColor: AppColors.TRANSPARENT_COLOR
    //     ),
    //     onPressed: onPressed,
    //     label: Text(labelText,style: TextStyle(color: labelTextColor,fontWeight: FontWeight.w700,letterSpacing: 1.0),textScaleFactor: 1.08),
    //     icon: Image.asset(iconPath,width: iconWidth,color: iconColor,),
    //   ),
    //
    //   // RaisedButton.icon(
    //   //   shape: RoundedRectangleBorder(
    //   //       borderRadius: BorderRadius.circular(30.0),
    //   //       side: BorderSide(color: buttonColor)
    //   //   ),
    //   //   color: buttonColor,
    //   //   elevation: 0.0,
    //   //   highlightElevation: 0.0,
    //   //   onPressed: onPressed,
    //   //   label: Text(labelText,style: TextStyle(color: labelTextColor,fontWeight: FontWeight.w700,letterSpacing: 1.0),textScaleFactor: 1.08),
    //   //   icon: Image.asset(iconPath,width: iconWidth,color: iconColor,),
    //   // ),
    // );
  }
}

