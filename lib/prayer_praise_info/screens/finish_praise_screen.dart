import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/add_praise/screens/add_praise_screen.dart';
import 'package:prayer_hybrid_app/common_classes/share_class.dart';
import 'package:prayer_hybrid_app/models/prayer_model.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/bible_promises_dialog_screen.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/stop_watch_alert_screen.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_gesture_detector_container.dart';

class FinishPraiseScreen extends StatefulWidget {
  PrayerModel praiseModel;

  FinishPraiseScreen({this.praiseModel});

  @override
  _FinishPraiseScreenState createState() => _FinishPraiseScreenState();
}

class _FinishPraiseScreenState extends State<FinishPraiseScreen> {
  bool answerTick = true;
  StopWatchAlertScreen stopWatchAlertScreen = StopWatchAlertScreen();
  BiblePromisesDialogScreen _biblePromisesDialogScreen =
      BiblePromisesDialogScreen();
  var time;
  BaseService baseService = BaseService();

  @override
  void initState() {
    // TODO: implement initState
    time = widget.praiseModel.prayerDuration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
          backgroundColor: AppColors.TRANSPARENT_COLOR,
          body: Column(
            children: [
              _customAppBar(),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                      child: Text(
                        widget.praiseModel.title ??
                            AppStrings.PRAISE_TITLE_TEXT,
                        style: TextStyle(
                            color: AppColors.WHITE_COLOR,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0),
                        textScaleFactor: 1.8,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                      child: Text(
                        widget.praiseModel.name ?? "",
                        style: TextStyle(
                            color: AppColors.WHITE_COLOR,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0),
                        textScaleFactor: 1.1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06,
                              right: MediaQuery.of(context).size.width * 0.06),
                          child: Text(widget.praiseModel.description ?? "",
                              style: TextStyle(
                                  color: AppColors.WHITE_COLOR,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4),
                              textScaleFactor: 1.05),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Text(
                      "Prayer Time: ${time ?? "00:00:00"}",
                      style: TextStyle(
                          color: AppColors.WHITE_COLOR,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _biblePromisesWidget(),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _answeredPromisesWidget(),
                        _sharePromisesWidget(),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    _editPraiseWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  //Stop Watch Timer Widget
  Widget _stopWatchImageWidget() {
    return GestureDetector(
      onTap: () {
        print("Stop Watch Image Widget");
        stopWatchAlertScreen.stopWatchAlert(context);
        print(stopWatchAlertScreen.displayTime);
        print(widget.praiseModel.prayerDuration);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.11,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPaths.STOP_WATCH_IMAGE),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  //Bible Promises Widget
  Widget _biblePromisesWidget() {
    return CustomGestureDetectorContainer(
      buttonColor: AppColors.BUTTON_COLOR,
      title: AppStrings.BIBLE_PROMISES_TEXT,
      containerVertical: 11.0,
      containerHorizontal: 21.0,
      borderRadius: 22.0,
      textSize: 0.95,
      onTap: () {
        print("Bible Promises");
        _biblePromisesDialogScreen.showDialogMethod(context: context);
      },
    );
  }

  //Answered Widget
  Widget _answeredPromisesWidget() {
    return CustomGestureDetectorContainer(
      buttonColor: AppColors.BUTTON_COLOR,
      title: AppStrings.ANSWERED_TEXT,
      containerVertical: answerTick == true ? 9.0 : 12.0,
      containerHorizontal: answerTick == true ? 21.0 : 34.0,
      borderRadius: 22.0,
      textSize: 0.95,
      suffixImagePath: answerTick == true ? AssetPaths.ANSWERED_ICON : null,
      onTap: () {
        print("Answered");
        baseService.finishPrayer(context, widget.praiseModel.id.toString(), "");
      },
    );
  }

  //Share Widget
  Widget _sharePromisesWidget() {
    return CustomGestureDetectorContainer(
      buttonColor: AppColors.BUTTON_COLOR,
      title: AppStrings.SHARE_TEXT,
      containerVertical: 9.0,
      containerHorizontal: 29.0,
      borderRadius: 22.0,
      textSize: 0.95,
      suffixImagePath: AssetPaths.SHARE_ICON,
      onTap: () {
        print("Share");
        _shareMethod();
      },
    );
  }

  Widget _editPraiseWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context,
            AddPraiseScreen(
              praiseModel: widget.praiseModel,
              praiseButtonText: AppStrings.UPDATE_PRAISE_TEXT.toUpperCase(),
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.BUTTON_COLOR,
        padding: EdgeInsets.only(top: 11.0, bottom: 11.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.EDIT_TEXT.toUpperCase(),
              style: TextStyle(
                  color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w700),
              textScaleFactor: 0.95,
            ),
            SizedBox(
              width: 6.0,
            ),
            Image.asset(
              AssetPaths.EDIT_ICON,
              width: 18.0,
            )
          ],
        ),
      ),
    );
  }

  void _shareMethod() {
    ShareClass.shareMethod(
        message:
            "${"Join me in praising the Lord:\n" + "Title: " + widget.praiseModel.title + "\nName: " + widget.praiseModel.name + "\nDescription: " + widget.praiseModel.description}");
  }
}
