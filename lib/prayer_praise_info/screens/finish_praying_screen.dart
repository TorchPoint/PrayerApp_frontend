import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:prayer_hybrid_app/add_prayer/screens/add_prayer_screen.dart';
import 'package:prayer_hybrid_app/common_classes/share_class.dart';
import 'package:prayer_hybrid_app/models/prayer_model.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/bible_promises_dialog_screen.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/stop_watch_alert_screen.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_gesture_detector_container.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../main.dart';

class FinishPrayingScreen extends StatefulWidget {
  PrayerModel prayerModel;

  FinishPrayingScreen({this.prayerModel});

  @override
  _FinishPrayingScreenState createState() => _FinishPrayingScreenState();
}

class _FinishPrayingScreenState extends State<FinishPrayingScreen> {
  bool answerTick = false;
  StopWatchAlertScreen stopWatchAlertScreen = StopWatchAlertScreen();
  BaseService baseService = BaseService();
  BiblePromisesDialogScreen _biblePromisesDialogScreen =
      BiblePromisesDialogScreen();

  Future apiTimerAPI() async {
    await BaseService()
        .getBaseMethod(context, ApiConst.TIME_FCM, tokenCheck: true)
        .then((value) {
      print(value);
    });
  }

  StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    mode: StopWatchMode.countDown,
    onChangeRawSecond: (value) async {
      if (value == 5) {
        //apiTimerAPI();
        await BaseService()
            .getBaseMethod(
          navigatorKey.currentContext,
          ApiConst.TIME_FCM,
          tokenCheck: true,
          loading: false,
        )
            .then((value) {
          print(value);
        });
        print("HELLO" + value.toString());
      }
    },
  );
  int value;
  String displayTime;
  Duration initialTimer = new Duration();
  bool isPicked = false;
  bool isTimePicked = false;
  bool isStart = false;
  var newTime;

  pickTimer(BuildContext context) {
    return showCupertinoModalBottomSheet(
      backgroundColor: AppColors.BACKGROUND1_COLOR,
      context: context,
      animationCurve: Curves.easeInOutExpo,
      bounce: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      expand: false,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: initialTimer,
                onTimerDurationChanged: (Duration changedTimer) {
                  setState(() {
                    initialTimer = changedTimer;
                  });
                },
              ),
              isStart
                  ? GestureDetector(
                      onTap: () {
                        if (isTimePicked == false) {
                          _stopWatchTimer
                              .setPresetSecondTime(initialTimer.inSeconds);
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                        }
                        setState(() {
                          isTimePicked = true;
                          isStart = false;
                        });
                        print(isPicked);
                        AppNavigation.navigatorPop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.10,
                            vertical: 12.0),
                        decoration: BoxDecoration(
                          color: AppColors.BUTTON_COLOR,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(1, 8), // Shadow position
                            ),
                          ],
                        ),
                        child: Text(
                          "Start Prayer",
                          style: TextStyle(
                              color: AppColors.WHITE_COLOR,
                              fontWeight: FontWeight.w800),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0.0),
                        child: Text(
                          widget.prayerModel.title ??
                              AppStrings.PRAYER_TITLE_TEXT,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0.0),
                        child: Text(
                          widget.prayerModel.name ?? "",
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
                        height: 6.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            right: MediaQuery.of(context).size.width * 0.06),
                        child: Text(widget.prayerModel.description ?? "",
                            style: TextStyle(
                                color: AppColors.WHITE_COLOR,
                                fontWeight: FontWeight.w700,
                                height: 1.4),
                            textScaleFactor: 1.05),
                      ),

                      // _stopWatchImageWidget(),
                      StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
                        builder: (context, snap) {
                          value = snap.data;
                          displayTime = StopWatchTimer.getDisplayTime(value,
                              milliSecond: false);

                          // print("Display Time"+displayTime.toString().split(":")[2]);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _hoursContainer(context,
                                      displayTime.substring(0, 2).toString()),
                                  SizedBox(width: 15.0),
                                  _minutesContainer(context,
                                      displayTime.substring(3, 5).toString()),
                                  SizedBox(width: 15.0),
                                  _secondsContainer(context,
                                      displayTime.substring(6, 8).toString())
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              isTimePicked
                                  ? Container()
                                  : Center(child: _pickTimeContainer(context)),
                              SizedBox(
                                height: 20,
                              ),
                              isPicked
                                  ? _prayNowContainer(context)
                                  : Container(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
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
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: _editPrayerWidget(),
              ),
            ],
          )),
    );
  }

  //Hours Container
  Widget _hoursContainer(BuildContext context, String hours) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.19,
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
        color: AppColors.BUTTON_COLOR,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(1, 8), // Shadow position
          ),
        ],
      ),
      child: Center(
          child: Text(
        hours.toString(),
        style: TextStyle(
            color: AppColors.WHITE_COLOR,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0),
        textScaleFactor: 2.8,
      )),
    );
  }

//Minutes Container
  Widget _minutesContainer(BuildContext context, String minutes) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.19,
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
        color: AppColors.BUTTON_COLOR,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(1, 8), // Shadow position
          ),
        ],
      ),
      child: Center(
          child: Text(
        minutes.toString(),
        style: TextStyle(
            color: AppColors.WHITE_COLOR,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0),
        textScaleFactor: 2.8,
      )),
    );
  }

//Seconds Container
  Widget _secondsContainer(BuildContext context, String seconds) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.19,
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
        color: AppColors.BUTTON_COLOR,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(1, 8), // Shadow position
          ),
        ],
      ),
      child: Center(
          child: Text(
        seconds.toString(),
        style: TextStyle(
            color: AppColors.WHITE_COLOR,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0),
        textScaleFactor: 2.8,
      )),
    );
  }

//Pray Now Container
  Widget _prayNowContainer(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // isStart
          //     ? GestureDetector(
          //         onTap: () {
          //           if (isTimePicked == false) {
          //             _stopWatchTimer
          //                 .setPresetSecondTime(initialTimer.inSeconds);
          //             _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          //           }
          //           setState(() {
          //             isTimePicked = true;
          //             isStart = false;
          //           });
          //           print(isPicked);
          //         },
          //         child: Container(
          //           padding: EdgeInsets.symmetric(
          //               horizontal: MediaQuery.of(context).size.width * 0.10,
          //               vertical: 12.0),
          //           decoration: BoxDecoration(
          //             color: AppColors.BUTTON_COLOR,
          //             borderRadius: BorderRadius.circular(25.0),
          //             boxShadow: [
          //               BoxShadow(
          //                 color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
          //                 blurRadius: 8,
          //                 offset: Offset(1, 8), // Shadow position
          //               ),
          //             ],
          //           ),
          //           child: Text(
          //             "Start Prayer",
          //             style: TextStyle(
          //                 color: AppColors.WHITE_COLOR,
          //                 fontWeight: FontWeight.w800),
          //             textScaleFactor: 1.0,
          //           ),
          //         ),
          //       )
          //     : Container(),
          SizedBox(
            height: 10,
          ),
          isStart
              ? Container()
              : GestureDetector(
                  onTap: () {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.10,
                        vertical: 12.0),
                    decoration: BoxDecoration(
                      color: AppColors.BUTTON_COLOR,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(1, 8), // Shadow position
                        ),
                      ],
                    ),
                    child: Text(
                      "End Prayer",
                      style: TextStyle(
                          color: AppColors.WHITE_COLOR,
                          fontWeight: FontWeight.w800),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _pickTimeContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("pick time");
        pickTimer(context);
        setState(() {
          isPicked = true;
          isStart = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.10,
            vertical: 12.0),
        decoration: BoxDecoration(
          color: AppColors.BUTTON_COLOR,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(1, 8), // Shadow position
            ),
          ],
        ),
        child: Text(
          "Pick Prayer Time",
          style: TextStyle(
              color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w800),
          textScaleFactor: 1.0,
        ),
      ),
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
        setState(() {
          answerTick = !answerTick;
        });
        DateTime now = DateTime.now();
        DateTime startTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(initialTimer.toString().split(":")[0]),
            int.parse(initialTimer.toString().split(":")[1]),
            int.parse(initialTimer.toString().split(":")[2].split(".")[0]));
        DateTime endTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(displayTime.toString().split(":")[0]),
          int.parse(displayTime.toString().split(":")[1]),
          int.parse(displayTime.toString().split(":")[2]),
        );
        print(initialTimer.toString().split(":")[2].split(".")[0]);
        print(initialTimer.inMinutes);
        print(initialTimer.inSeconds);
        newTime = startTime.difference(endTime).toString().split(".")[0];
        print(newTime);
        print(startTime
            .difference(endTime)
            .toString()
            .split(":")[2]
            .split(".")[0]);
        baseService.finishPrayer(
            context, widget.prayerModel.id.toString(), newTime ?? "00:00:00");
        //AppNavigation.navigatorPop(context);
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
        _shareMethod();
      },
    );
  }

  Widget _editPrayerWidget() {
    return GestureDetector(
      onTap: () {
        print(widget.prayerModel.name);
        AppNavigation.navigateTo(
            context,
            AddPrayerScreen(
                prayerModel: widget.prayerModel,
                prayerButtonText: AppStrings.UPDATE_PRAYER_TEXT.toUpperCase()));
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
            "${"I would like to share this prayer request with you. Please join me in prayer:\n" + "Title: " + widget.prayerModel.title + "\nName: " + widget.prayerModel.name + "\nDescription: " + widget.prayerModel.description}");
  }
}
