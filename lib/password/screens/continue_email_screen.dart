import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/auth/screens/auth_verification_screen.dart';
import 'package:prayer_hybrid_app/password/screens/reset_password_screen.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/constants.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';

class ContinueEmailScreen extends StatefulWidget {
  @override
  _ContinueEmailScreenState createState() => _ContinueEmailScreenState();
}

class _ContinueEmailScreenState extends State<ContinueEmailScreen> {
  final GlobalKey<FormState> _continueKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  BaseService baseService = BaseService();
  String emailPattern = Constants.EMAIL_VALIDATION_REGEX;
  RegExp emailRegExp;

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Column(
          children: [
            _customAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _continueKey,
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      Image.asset(AssetPaths.FOREGROUND_IMAGE, width: 180.0),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      _emailWidget(),
                      SizedBox(height: 20.0),
                      _continueButtonWidget(),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      leadingIconPath: AssetPaths.BACK_ICON,
      isBarImage: false,
      title: AppStrings.WELCOME_TO_TEXT,
      titleTextSize: 1.7,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
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

  Widget _continueButtonWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.45,
      buttonColor: AppColors.WHITE_COLOR,
      borderColor: AppColors.WHITE_COLOR,
      elevation: true,
      buttonText: AppStrings.CONTINUE_TEXT,
      textColor: AppColors.BLACK_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.25,
      paddingTop: 13.0,
      paddingBottom: 13.0,
      onTap: () {
        if (_continueKey.currentState.validate()) {
         baseService.forgetPassword(context, _emailController.text);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }
}
