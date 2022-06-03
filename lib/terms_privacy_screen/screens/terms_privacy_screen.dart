import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';

class TermsPrivacyScreen extends StatefulWidget {
  final String title;

  TermsPrivacyScreen({this.title});

  @override
  _TermsPrivacyScreenState createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen> {
  BaseService baseService = BaseService();
  String content;

  Future getContents(BuildContext context) async {
    await baseService
        .getBaseMethod(context, ApiConst.CONTENT_URL + "?type=${widget.title}",
            loading: true, tokenCheck: true)
        .then((value) {
      if (widget.title == AppStrings.TERMS_CONDITIONS_TEXT) {
        content = value["data"][0]["body"];
      } else {
        content = value["data"][1]["body"];
      }
      setState(() {});
    });
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContents(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Column(
          children: [
            _customAppBar(),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: SingleChildScrollView(child: _termsPrivacyWidget()),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      title: widget.title,
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      isBarImage: true,
      leadingIconSize: 25.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Widget _termsPrivacyWidget() {
    return Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Html(
          data: """<div>
              <p>${content ?? ""}</p>
           
            </div>""",
          style: {
            "p": Style(
                color: AppColors.WHITE_COLOR,
                fontSize: FontSize.medium,
                letterSpacing: 1.2,
                lineHeight: LineHeight(1.3)),
          },
          onLinkTap: (url) {
            //NetworkStrings.launchURL(url);
          },
        ));
  }
}
