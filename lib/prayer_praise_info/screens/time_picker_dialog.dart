import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimePickerDialog extends StatefulWidget {
  @override
  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    mode: StopWatchMode.countDown,
    //presetMillisecond: StopWatchTimer.getMilliSecFromMinute(2),
    // millisecond => minute.
    // onChange: (value) => print('onChange $value'),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );
  int value;
  String displayTime;
  Duration initialtimer = new Duration();
  bool isPicked = false;
  bool isTimePicked = false;

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
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: initialtimer,
            onTimerDurationChanged: (Duration changedTimer) {
              setState(() {
                initialtimer = changedTimer;
              });
              print(initialtimer.inMinutes.toString());
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.09,
          right: MediaQuery.of(context).size.width * 0.09),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: _stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          value = snap.data;
          displayTime =
              StopWatchTimer.getDisplayTime(value, milliSecond: false);

          // print("Display Time"+displayTime.toString());
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hoursContainer(
                      context, displayTime.substring(0, 2).toString()),
                  SizedBox(width: 15.0),
                  _minutesContainer(
                      context, displayTime.substring(3, 5).toString()),
                  SizedBox(width: 15.0),
                  _secondsContainer(
                      context, displayTime.substring(6, 8).toString())
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              isTimePicked
                  ? Container()
                  : Center(child: _pickTimeContainer(context)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              isPicked ? _prayNowContainer(context) : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
            ],
          );
        },
      ),
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
          GestureDetector(
            onTap: () {
              _stopWatchTimer.setPresetSecondTime(initialtimer.inSeconds);
              _stopWatchTimer.onExecute.add(StopWatchExecute.start);
              // setState(() {
              //   isTimePicked = true;
              // });
              // print(isPicked);
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
                "Start Prayer",
                style: TextStyle(
                    color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w800),
                textScaleFactor: 1.0,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
              DateTime now = DateTime.now();
              DateTime startTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  initialtimer.inHours,
                  initialtimer.inMinutes,
                  initialtimer.inSeconds);
              DateTime endTime = DateTime(
                now.year,
                now.month,
                now.day,
                int.parse(displayTime.toString().split(":")[0]),
                int.parse(displayTime.toString().split(":")[1]),
                int.parse(displayTime.toString().split(":")[2]),
              );
              print(initialtimer.inHours);
              print(initialtimer.inMinutes);
              print(initialtimer.inSeconds);
              print(displayTime.toString().split(":")[0]);
              print(displayTime.toString().split(":")[1]);
              print(displayTime.toString().split(":")[2]);

              print(startTime.difference(endTime).inSeconds.toString());

              AppNavigation.navigatorPop(context);
              // _stopWatchTimer.onExecute
              //     .add(StopWatchExecute.start);
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
                    color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w800),
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
}
