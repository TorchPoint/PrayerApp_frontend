import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/constants.dart';

import 'package:prayer_hybrid_app/widgets/custom_button.dart';

import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';

class AuthSignUpScreen extends StatefulWidget {
  final PageController pageController;

  AuthSignUpScreen({this.pageController});

  @override
  _AuthSignUpScreenState createState() => _AuthSignUpScreenState();
}

class _AuthSignUpScreenState extends State<AuthSignUpScreen> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _countryCodeController = TextEditingController();
  String emailPattern = Constants.EMAIL_VALIDATION_REGEX;
  RegExp emailRegExp;
  String passwordPattern = Constants.PASSWORD_VALIDATE_REGEX;
  RegExp passwordRegExp;
  bool passwordInvisible = true, confirmPasswordInvisible = true;

  BaseService baseService = BaseService();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: AppColors.BACKGROUND2_COLOR,
        textStyle: TextStyle(
            fontSize: 16,
            color: AppColors.WHITE_COLOR,
            fontWeight: FontWeight.w600),
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          hintStyle: TextStyle(color: AppColors.WHITE_COLOR),
          labelStyle: TextStyle(color: AppColors.WHITE_COLOR),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.WHITE_COLOR,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.WHITE_COLOR, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.WHITE_COLOR, width: 2),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.WHITE_COLOR, width: 2),
          ),
        ),
      ),
      onSelect: (Country country) {
        _countryCodeController.text = "${"+" + country.phoneCode}";
        print('Select country: ${country.phoneCode}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        child: Form(
          key: _signUpKey,
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
              _firstNameWidget(),
              SizedBox(
                height: 14.0,
              ),
              _lastNameWidget(),
              SizedBox(
                height: 14.0,
              ),
              _emailWidget(),
              SizedBox(
                height: 14.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(flex: 0, child: _countryCodesWidget()),
                    SizedBox(
                      width: 6.0,
                    ),
                    Expanded(child: _mobileNumberWidget()),
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              _passwordWidget(),
              SizedBox(
                height: 14.0,
              ),
              _confirmPasswordWidget(),
              SizedBox(
                height: 14.0,
              ),
              _signUpButtonWidget(),
              SizedBox(
                height: 18.0,
              ),
              _alreadyAccountRichTextWidget(),
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

  //First Name Widget
  Widget _firstNameWidget() {
    return CustomTextFormField(
      textController: _firstNameController,
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      hintText: AppStrings.FIRST_NAME_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.NAME_ICON,
      prefixIconWidth: 16.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      onValidate: (value) {
        if (value.trim().isEmpty) {
          return AppStrings.FIRST_NAME_EMPTY_ERROR;
        }
        return null;
      },
    );
  }

  //Last Name Widget
  Widget _lastNameWidget() {
    return CustomTextFormField(
      textController: _lastNameController,
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      hintText: AppStrings.LAST_NAME_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.NAME_ICON,
      prefixIconWidth: 16.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      onValidate: (value) {
        if (value.trim().isEmpty) {
          return AppStrings.LAST_NAME_EMPTY_ERROR;
        }
        return null;
      },
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

  //Mobile Number Widget
  Widget _countryCodesWidget() {
    return CustomTextFormField(
      textController: _countryCodeController,
      containerWidth: MediaQuery.of(context).size.width * 0.3,
      hintText: "+12",
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.MOBILE_ICON,
      prefixIconWidth: 16.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      keyBoardType: TextInputType.phone,
      textFieldReadOnly: true,
      onTextFieldTap: () {
        selectCountry();
      },
      onValidate: (value) {
        if (value.trim().isEmpty) {
          return AppStrings.MOBILE_NUMBER_EMPTY_ERROR;
        }
        return null;
      },
    );
  }

  //First Name Widget
  Widget _mobileNumberWidget() {
    return CustomTextFormField(
      textController: _mobileNoController,
      containerWidth: MediaQuery.of(context).size.width * 0.7,
      hintText: AppStrings.USER_PHONE_NO_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.MOBILE_ICON,
      prefixIconWidth: 16.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      onValidate: (value) {
        if (value.trim().isEmpty) {
          return AppStrings.MOBILE_NUMBER_EMPTY_ERROR;
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
      obscureText: passwordInvisible,
      errorMaxLines: 4,
      suffixIcon: passwordInvisible == true
          ? AssetPaths.VISIBLE_OFF_ICON
          : AssetPaths.VISIBLE_ON_ICON,
      suffixIconWidth: 22.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      onSuffixIconTap: () {
        setState(() {
          passwordInvisible = !passwordInvisible;
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

  //Confirm Password Widget
  Widget _confirmPasswordWidget() {
    return CustomTextFormField(
      textController: _confirmPasswordController,
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      hintText: AppStrings.CONFIRM_PASSWORD_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.PASSWORD_ICON,
      prefixIconWidth: 15.0,
      obscureText: confirmPasswordInvisible,
      errorMaxLines: 4,
      suffixIcon: confirmPasswordInvisible == true
          ? AssetPaths.VISIBLE_OFF_ICON
          : AssetPaths.VISIBLE_ON_ICON,
      suffixIconWidth: 22.0,
      contentPaddingTop: 17.0,
      contentPaddingBottom: 17.0,
      onSuffixIconTap: () {
        setState(() {
          confirmPasswordInvisible = !confirmPasswordInvisible;
        });
      },
      onValidate: (value) {
        passwordRegExp = RegExp(passwordPattern);
        if (value.trim().isEmpty) {
          return AppStrings.CONFIRM_PASSWORD_EMPTY_ERROR;
        } else if (!passwordRegExp.hasMatch(value)) {
          return AppStrings.CONFIRM_PASSWORD_INVALID_ERROR;
        } else if (value != _passwordController.text) {
          return AppStrings.PASSWORD_DIFFERENT_ERROR;
        }
        return null;
      },
    );
  }

  //Sign Up Widget
  Widget _signUpButtonWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.82,
      buttonColor: AppColors.WHITE_COLOR,
      borderColor: AppColors.WHITE_COLOR,
      elevation: true,
      buttonText: AppStrings.SIGN_UP_DASH_TEXT,
      textColor: AppColors.BLACK_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.25,
      paddingTop: 13.0,
      paddingBottom: 13.0,
      onTap: () {
        if (_signUpKey.currentState.validate()) {
          print("sign up");
          baseService.signUpUser(
              context,
              _firstNameController.text,
              _lastNameController.text,
              _emailController.text,
              _mobileNoController.text,
              _passwordController.text,
              _countryCodeController.text);
        }
      },
    );
  }

//Already have account Widget
  Widget _alreadyAccountRichTextWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: AppStrings.ALREADY_HAVE_ACCOUNT_TEXT,
            style: TextStyle(
                color: AppColors.WHITE_COLOR,
                fontSize: 15.0,
                letterSpacing: 1.0),
            children: <TextSpan>[
              TextSpan(
                  text: AppStrings.LOGIN_TEXT,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.WHITE_COLOR,
                    decorationThickness: 2.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.pageController.jumpToPage(4);
                    }),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileNoController.dispose();
    super.dispose();
  }
}
