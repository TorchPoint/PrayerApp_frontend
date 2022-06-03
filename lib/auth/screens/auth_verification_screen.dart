import 'package:flutter/material.dart';

import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';

class VerificationScreen extends StatefulWidget {
  final bool emailVerificationCheck;

  final String userData;

  VerificationScreen({this.emailVerificationCheck, this.userData});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController otpController = TextEditingController();
  BaseService baseService = BaseService();

  @override
  void dispose() {
    // TODO: implement dispose
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: CustomBackgroundContainer(
            child: Column(
              children: [
                _prayerImageWidget(),
                const SizedBox(
                  height: 50,
                ),
                _enterOtpText(),
                const SizedBox(
                  height: 20,
                ),
                _pinCodeField(),
                const SizedBox(
                  height: 30,
                ),
                _verifyButtonWidget(),
                const SizedBox(
                  height: 30,
                ),
                _reSendWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _prayerImageWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.15,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPaths.FOREGROUND_IMAGE),
              fit: BoxFit.contain)),
    );
  }

  Widget _pinCodeField() {
    return PinCodeTextField(
      maxLength: 6,
      pinBoxWidth: 50,
      controller: otpController,
      defaultBorderColor: AppColors.BACKGROUND1_COLOR,
      keyboardType: TextInputType.number,
      pinBoxRadius: 10,
      errorBorderColor: AppColors.ERROR_COLOR,
      highlightPinBoxColor: AppColors.WHITE_COLOR,
      hasTextBorderColor: AppColors.BACKGROUND1_COLOR,
      hasUnderline: false,
      pinTextStyle:
          TextStyle(fontSize: 20, color: AppColors.SETTINGS_OPTIONS_COLOR),
      onDone: (String str) {},
      onTextChanged: (String str) {},
    );
  }

  Widget _verifyButtonWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.38,
      buttonColor: AppColors.WHITE_COLOR,
      borderColor: AppColors.WHITE_COLOR,
      buttonText: AppStrings.VERIFY_OTP,
      textColor: AppColors.BLACK_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.27,
      paddingTop: 11.0,
      paddingBottom: 11.0,
      onTap: () {
        if (otpController.text.trim().isEmpty) {
          baseService.showToast(
              "Check your email for verification code", AppColors.RED_COLOR);
        } else {
          widget.emailVerificationCheck == false
              ? baseService
                  .verifyUserUsingOTP(
                      context, widget.userData, otpController.text)
                  .then((value) {
                  debugPrint("Print:" + value.toString());
                })
              : baseService.verifyForgetPasswordUsingEmail(
                  context, widget.userData, otpController.text);
          print("verfiy");
        }
      },
    );
  }

  Widget _enterOtpText() {
    return Text(
      AppStrings.ENTER_OTP,
      style: TextStyle(
          color: AppColors.WHITE_COLOR,
          fontWeight: FontWeight.w500,
          fontSize: 20),
    );
  }

  Widget _reSendWidget() {
    return GestureDetector(
      onTap: () {
        if (widget.emailVerificationCheck == false) {
          baseService.reSendVerification(context, widget.userData);
        } else {
          baseService.forgetPassword(context, widget.userData);
        }
      },
      child: Text(
        AppStrings.RESEND_OTP,
        style: TextStyle(
          color: AppColors.WHITE_COLOR,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
