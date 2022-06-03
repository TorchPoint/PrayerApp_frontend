import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';

class AuthThirdScreen extends StatefulWidget {
  final PageController pageController;
  AuthThirdScreen({this.pageController});

  @override
  _AuthThirdScreenState createState() => _AuthThirdScreenState();
}

class _AuthThirdScreenState extends State<AuthThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.08),
            child: Text(AppStrings.WELCOME_TO_TEXT,style: TextStyle(color: AppColors.WHITE_COLOR,fontWeight: FontWeight.w600,letterSpacing: 1.5),textScaleFactor: 1.6,),
          ),

          _prayerImageWidget(),

          _authHomeImageWidget(),

          Container(
            width: MediaQuery.of(context).size.width*0.78,
            margin: EdgeInsets.only(top: 25.0),
            child: Text(AppStrings.SHARE_PRAYER_TEXT,style: TextStyle(color: AppColors.WHITE_COLOR,fontWeight: FontWeight.w700),textScaleFactor: 1.15,textAlign: TextAlign.center,),
          ),

          Container(
            width: MediaQuery.of(context).size.width*0.81,
            margin: EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _loginButtonWidget(),
                _signUpButtonWidget(),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          )
        ],
      ),
    );
  }

  Widget _prayerImageWidget()
  {
    return Container(
      width: MediaQuery.of(context).size.width*0.42,
      height: MediaQuery.of(context).size.height*0.07,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPaths.FOREGROUND_IMAGE),
              fit: BoxFit.contain
          )
      ),
    );
  }

  Widget _authHomeImageWidget()
  {
    return Container(
      width: MediaQuery.of(context).size.width*0.30,
      height: MediaQuery.of(context).size.height*0.32,
      margin: EdgeInsets.only(top: 25.0),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AssetPaths.AUTH_SECOND_SCREEN_IMAGE),
            fit: BoxFit.fill
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 9,
            offset: Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }


  Widget _loginButtonWidget()
  {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width*0.38,
      buttonColor: AppColors.WHITE_COLOR,
      borderColor: AppColors.WHITE_COLOR,
      elevation: true,
      buttonText: AppStrings.LOGIN_TEXT,
      textColor: AppColors.BLACK_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.27,
      paddingTop: 11.0,
      paddingBottom: 11.0,
      onTap: (){
        print("login");
        widget.pageController.jumpToPage(4);
      },
    );
  }


  Widget _signUpButtonWidget()
  {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width*0.38,
      buttonColor: AppColors.TRANSPARENT_COLOR,
      borderColor: AppColors.WHITE_COLOR,
      buttonText: AppStrings.SIGN_UP_TEXT,
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.27,
      paddingTop: 11.0,
      paddingBottom: 11.0,
      onTap: (){
        print("SignUp");
        widget.pageController.jumpToPage(2);
      },
    );
  }
}
