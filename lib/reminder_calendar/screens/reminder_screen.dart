import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/reminder_calendar/screens/calendar_screen.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:provider/provider.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  BaseService baseService = BaseService();
  List<String> title = [
    "Marriage",
    "Mom",
    "Victoria",
    "Mildred",
    "Thanking God"
  ];
  List<String> message = [
    "Need to pray at 4:30 today",
    "Need to pray at 8:00 today",
    "Need to pray at 1:00 pm tomorrow",
    "Need to pray at 6:00 pm tomorrow",
    "Need to pray at 12:00 pm on 28th Feb"
  ];
  int currentReminderIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    baseService.fetchReminderList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var reminderProvider = Provider.of<ReminderProvider>(context, listen: true);

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
                child: reminderProvider.reminderList == null ||
                        reminderProvider.reminderList.length == 0
                    ? Center(
                        child: Text(
                          "No Reminders Found",
                          style: TextStyle(color: AppColors.WHITE_COLOR),
                        ),
                      )
                    : ListView.builder(
                        itemCount: reminderProvider.reminderList.length ?? 0,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return _reminderContainer(index);
                        })),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      title: AppStrings.REMINDERS_TEXT,
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
      trailingIconPath: AssetPaths.ADD_ICON,
      trailingTap: () {
        AppNavigation.navigateTo(context, CalendarScreen());
      },
    );
  }

  Widget _reminderContainer(int reminderIndex) {
    var reminderProvider = Provider.of<ReminderProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context,
            CalendarScreen(
              reminderModel: reminderProvider.reminderList[reminderIndex],
            ));
      },
      onLongPress: () {
        setState(() {
          currentReminderIndex = reminderIndex;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: reminderIndex == 0 ? 15.0 : 8.0,
            bottom: reminderIndex == title.length - 1 ? 16.0 : 8.0),
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 13.0, bottom: 13.0),
        decoration: BoxDecoration(
            color: reminderIndex == currentReminderIndex
                ? AppColors.BUTTON_COLOR
                : AppColors.WHITE_COLOR,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: reminderIndex == currentReminderIndex
                ? [
                    BoxShadow(
                      color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
                : []),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  reminderProvider.reminderList[reminderIndex].title,
                  style: TextStyle(
                      color: reminderIndex == currentReminderIndex
                          ? AppColors.WHITE_COLOR
                          : AppColors.BLACK_COLOR,
                      fontWeight: FontWeight.w800),
                  textScaleFactor: 1.0,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 1.0,
                ),
                Text(
                    reminderProvider.reminderList[reminderIndex].reminderDate
                        .toString(),
                    style: TextStyle(
                        color: reminderIndex == currentReminderIndex
                            ? AppColors.WHITE_COLOR
                            : AppColors.BLACK_COLOR,
                        fontWeight: FontWeight.w600),
                    textScaleFactor: 1.0),
              ],
            ),
            Spacer(),
            _arrowDeleteIcons(reminderIndex),
          ],
        ),
      ),
    );
  }

  Widget _arrowDeleteIcons(int prayerIndex) {
    var reminderProvider = Provider.of<ReminderProvider>(context, listen: true);
    return currentReminderIndex == prayerIndex
        ? Row(
            children: [
              GestureDetector(
                onTap: () {
                  print("delete");
                  baseService.deleteReminder(context,
                      reminderProvider.reminderList[prayerIndex].id.toString());
                },
                child: Container(
                  color: AppColors.TRANSPARENT_COLOR,
                  child: Padding(
                      padding: EdgeInsets.only(left: 7.5, right: 13.0),
                      child: Image.asset(
                        AssetPaths.DELETE_ICON,
                        width: 12.0,
                      )),
                ),
              ),
            ],
          )
        : Container();
  }
}
