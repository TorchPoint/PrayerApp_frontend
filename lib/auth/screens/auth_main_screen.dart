import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/auth/screens/auth_first_screen.dart';
import 'package:prayer_hybrid_app/auth/screens/auth_login_screen.dart';
import 'package:prayer_hybrid_app/auth/screens/auth_second_screen.dart';
import 'package:prayer_hybrid_app/auth/screens/auth_sign_up_screen.dart';
import 'package:prayer_hybrid_app/auth/screens/auth_third_screen.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AuthMainScreen extends StatefulWidget {
  @override
  _AuthMainScreenState createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends State<AuthMainScreen> {
  PageController _authPageController = PageController();
  List<Widget> authWidgetList = [];

  @override
  void initState() {
    super.initState();
    authWidgetList = [
      AuthFirstScreen(pageController: _authPageController),
    //  AuthSecondScreen(pageController: _authPageController),
      AuthThirdScreen(pageController: _authPageController),
      AuthSignUpScreen(pageController: _authPageController),
      AuthLoginScreen(pageController: _authPageController)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _authPageController,
                itemBuilder: (context, index) {
                  return authWidgetList[index];
                },
                itemCount: 4, // Can be null
              ),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: _pageIndicator(),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _pageIndicator() {
    return SmoothPageIndicator(
      controller: _authPageController,
      count: 4,
      effect: WormEffect(
          dotWidth: 10.0,
          dotHeight: 10.0,
          spacing: 6.0,
          dotColor: AppColors.WHITE_COLOR,
          activeDotColor: AppColors.BACKGROUND1_COLOR),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _authPageController.dispose();
  }
}
