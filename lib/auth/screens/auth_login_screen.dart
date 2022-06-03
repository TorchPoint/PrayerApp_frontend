import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:prayer_hybrid_app/password/screens/continue_email_screen.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';

import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/constants.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';
import 'package:prayer_hybrid_app/widgets/custom_social_button.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthLoginScreen extends StatefulWidget {
  final PageController pageController;

  AuthLoginScreen({this.pageController});

  @override
  _AuthLoginScreenState createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String emailPattern = Constants.EMAIL_VALIDATION_REGEX;
  RegExp emailRegExp;
  String passwordPattern = Constants.PASSWORD_VALIDATE_REGEX;
  RegExp passwordRegExp;
  bool passwordInVisible = true;
  BaseService baseService = BaseService();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<AppUserProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        child: Form(
          key: _loginKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08),
                child: Text(
                  AppStrings.WELCOME_TO_TEXT,
                  style: TextStyle(
                      color: AppColors.WHITE_COLOR,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5),
                  textScaleFactor: 1.6,
                ),
              ),
              _prayerImageWidget(),
              SizedBox(
                height: 25.0,
              ),
              _emailWidget(),
              SizedBox(
                height: 14.0,
              ),
              _passwordWidget(),
              SizedBox(
                height: 14.0,
              ),
              _loginButtonWidget(),
              SizedBox(
                height: 18.0,
              ),
              _forgetPasswordWidget(),
              SizedBox(
                height: 25.0,
              ),
              Platform.isIOS ? _signInAppleButtonWidget() : Container(),
              Platform.isIOS
                  ? SizedBox(
                      height: 15.0,
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              _signInFacebookButtonWidget(),
              SizedBox(
                height: 15.0,
              ),
              _signInGoogleButtonWidget(),
              SizedBox(
                height: 25.0,
              ),
              _dontHaveAccountRichTextWidget(),
              SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _prayerImageWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      height: MediaQuery.of(context).size.height * 0.07,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPaths.FOREGROUND_IMAGE),
              fit: BoxFit.contain)),
    );
  }

//Email Widget
  Widget _emailWidget() {
    return CustomTextFormField(
      textController: _emailController,
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      hintText: AppStrings.EMAIL_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.EMAIL_ICON,
      prefixIconWidth: 16.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      onValidate: (value) {
        emailRegExp = RegExp(emailPattern);
        if (value.trim().isEmpty) {
          return AppStrings.EMAIL_EMPTY_ERROR;
        } else if (!emailRegExp.hasMatch(value)) {
          return AppStrings.EMAIL_INVALID_ERROR;
        }
        return null;
      },
    );
  }

//Password Widget
  Widget _passwordWidget() {
    return CustomTextFormField(
      textController: _passwordController,
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      hintText: AppStrings.PASSWORD_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.PASSWORD_ICON,
      prefixIconWidth: 15.0,
      obscureText: passwordInVisible,
      errorMaxLines: 4,
      suffixIcon: passwordInVisible == true
          ? AssetPaths.VISIBLE_OFF_ICON
          : AssetPaths.VISIBLE_ON_ICON,
      suffixIconWidth: 22.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      onSuffixIconTap: () {
        setState(() {
          passwordInVisible = !passwordInVisible;
        });
      },
      onValidate: (value) {
        passwordRegExp = RegExp(passwordPattern);
        if (value.trim().isEmpty) {
          return AppStrings.PASSWORD_EMPTY_ERROR;
        } else if (!passwordRegExp.hasMatch(value)) {
          return AppStrings.PASSWORD_INVALID_ERROR;
        }
        return null;
      },
    );
  }

//Login Button Widget
  Widget _loginButtonWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      buttonColor: AppColors.WHITE_COLOR,
      borderColor: AppColors.WHITE_COLOR,
      elevation: true,
      buttonText: AppStrings.LOGIN_TEXT,
      textColor: AppColors.BLACK_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.25,
      paddingTop: 13.0,
      paddingBottom: 13.0,
      onTap: () {
        if (_loginKey.currentState.validate()) {
          print("Login");
          baseService.loginFormUser(context,
              email: _emailController.text.trim(),
              password: _passwordController.text);
          // AppNavigation.navigateTo(context, DrawerScreen());
        }
      },
    );
  }

  Widget _forgetPasswordWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(context, ContinueEmailScreen());
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
        child: Text(
          AppStrings.FORGET_PASSWORD_TEXT,
          style: TextStyle(
            color: AppColors.WHITE_COLOR,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.WHITE_COLOR,
            decorationThickness: 1.0,
          ),
          textScaleFactor: 1.05,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

//Don't have account Widget
  Widget _dontHaveAccountRichTextWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: AppStrings.DONT_HAVE_ACCOUNT_TEXT,
            style: TextStyle(
                color: AppColors.WHITE_COLOR,
                fontSize: 15.0,
                letterSpacing: 1.0),
            children: <TextSpan>[
              TextSpan(
                  text: AppStrings.SIGN_UP_TEXT,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.WHITE_COLOR,
                    decorationThickness: 2.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.pageController.jumpToPage(2);
                    }),
            ],
          )),
    );
  }

  //Sign in With Apple
  Widget _signInAppleButtonWidget() {
    return CustomSocialButton(
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      buttonColor: AppColors.WHITE_COLOR,
      buttonText: AppStrings.SIGN_IN_APPLE_TEXT,
      buttonTextColor: AppColors.BLACK_COLOR,
      iconPath: AssetPaths.APPLE_ICON,
      iconWidth: 20.0,
      iconColor: AppColors.BLACK_COLOR,
      differenceWidth: 10.0,
      onTap: () async {
        print("Sign in with Apple");
        baseService.appleSocialMethod(context);
        // AppNavigation.navigateTo(context, DrawerScreen());
      },
    );
  }

  //Sign in With Facebook
  Widget _signInFacebookButtonWidget() {
    return CustomSocialButton(
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      buttonColor: AppColors.FACEBOOK_BUTTON_COLOR,
      buttonText: AppStrings.SIGN_IN_FACEBOOK_TEXT,
      buttonTextColor: AppColors.WHITE_COLOR,
      iconPath: AssetPaths.FACEBOOK_ICON,
      iconWidth: 14.0,
      iconColor: AppColors.WHITE_COLOR,
      differenceWidth: 16.0,
      onTap: () async {
        print("Sign in with Facebook");
        baseService.fbSocialMethod(context);
      },
    );
  }

  //Sign in With Google
  Widget _signInGoogleButtonWidget() {
    return CustomSocialButton(
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      buttonColor: AppColors.GOOGLE_BUTTON_COLOR,
      buttonText: AppStrings.SIGN_IN_GOOGLE_TEXT,
      buttonTextColor: AppColors.WHITE_COLOR,
      iconPath: AssetPaths.GOOGLE_ICON,
      iconWidth: 22.0,
      iconColor: AppColors.WHITE_COLOR,
      differenceWidth: 10.0,
      onTap: () {
        print("Sign in with Google");
        baseService.googleSocialMethod(context);
        // AppNavigation.navigateTo(context, DrawerScreen());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
