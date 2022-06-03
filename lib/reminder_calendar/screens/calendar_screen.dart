import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prayer_hybrid_app/models/reminder_model.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';
import 'package:prayer_hybrid_app/reminder_calendar/screens/time_alert_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  ReminderModel reminderModel;

  CalendarScreen({this.reminderModel});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TextEditingController _addReminderController = TextEditingController();
  bool errorBoolReminder = true, errorBoolFrequency = true;
  String errorMessageReminder = "", errorMessageFrequency = "";
  String currentFrequencyValue;
  List<String> frequencies = ["Once", "Daily", "Weekly", "Monthly"];
  TimeAlertScreen timeAlertScreen = TimeAlertScreen();
  CalendarController _calendarController = CalendarController();
  final GlobalKey<FormState> _addReminderKey = GlobalKey<FormState>();
  String calendarReminerTime;
  var date;
  BaseService baseService = BaseService();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.reminderModel != null) {
      _addReminderController.text = widget.reminderModel.title;
      calendarReminerTime = widget.reminderModel.reminderTime.toString();
      frequencies.forEach((element) {
        if (widget.reminderModel.type.toLowerCase() == element.toLowerCase()) {
          print("match hwa");
          setState(() {
            currentFrequencyValue = element;
          });
        }
      });
    }
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
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _addReminderKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18.0,
                      ),
                      _addReminderTextFormField(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _frequencyWidget(),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: GestureDetector(
                            onTap: () {
                              _remindMeOnMethod();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.time,
                                  color: AppColors.WHITE_COLOR,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  calendarReminerTime != null
                                      ? calendarReminerTime
                                      : AppStrings.REMIND_ME_ON,
                                  style: TextStyle(
                                      color: AppColors.WHITE_COLOR,
                                      fontWeight: FontWeight.w600),
                                  textScaleFactor: 1.3,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02,
                              right: MediaQuery.of(context).size.width * 0.02),
                          child: _calendarWidget()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
        title: AppStrings.REMINDER_TEXT,
        trailingIconPath: AssetPaths.TICK_ICON2,
        leadingIconPath: AssetPaths.BACK_ICON,
        leadingTap: () {
          AppNavigation.navigatorPop(context);
        },
        paddingTop: 20.0,
        trailingTap: () {
          addReminderMethod();
        });
  }

//Add Reminder TextForm Field
  Widget _addReminderTextFormField() {
    return CustomTextFormField(
      textController: _addReminderController,
      containerWidth: MediaQuery.of(context).size.width * 0.85,
      hintText: AppStrings.ADD_REMINDER_TITLE_HINT_TEXT,
      borderRadius: 28.0,
      contentPaddingTop: 14.0,
      contentPaddingBottom: 14.0,
      contentPaddingRight: 20.0,
      contentPaddingLeft: 20.0,
      hintSize: 15.0,
      textSize: 15.0,
      isCollapsed: true,
      borderColor: errorBoolReminder == true
          ? AppColors.WHITE_COLOR
          : AppColors.ERROR_COLOR,
      filledColor: AppColors.TRANSPARENT_COLOR,
      hintColor: AppColors.WHITE_COLOR,
      textColor: AppColors.WHITE_COLOR,
      cursorColor: AppColors.WHITE_COLOR,
      onValidate: (value) {
        if (value.trim().isEmpty) {
          return AppStrings.ADD_REMINDER_TITLE_ERROR_TEXT;
        }
        return null;
      },
    );
  }

  //Frequency Widget
  Widget _frequencyWidget() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            iconEnabledColor: AppColors.BLACK_COLOR,
            dropdownColor: AppColors.WHITE_COLOR,
            decoration: InputDecoration(
                isCollapsed: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: AppColors.TRANSPARENT_COLOR)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: AppColors.TRANSPARENT_COLOR)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.ERROR_COLOR, width: 1.3)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.ERROR_COLOR, width: 1.3)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                hintText: AppStrings.SET_FREQUENCY_HINT_TEXT,
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: AppColors.BLACK_COLOR,
                  fontWeight: FontWeight.w500,
                ),
                errorStyle: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.ERROR_COLOR,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: EdgeInsets.only(
                    top: 13.0, bottom: 13.0, left: 20.0, right: 20.0),
                fillColor: AppColors.WHITE_COLOR,
                filled: true),
            isDense: true,
            value: currentFrequencyValue,
            validator: (value) {
              if (value == null) {
                return AppStrings.ADD_FREQUENCY_ERROR_TEXT;
              }
              return null;
            },
            onChanged: (String frequencyValue) {
              print("current categoryValue:" + frequencyValue.toString());
              setState(() {
                currentFrequencyValue = frequencyValue;
              });
            },
            selectedItemBuilder: (BuildContext context) {
              return frequencies.map((value) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                );
              }).toList();
            },
            items: frequencies.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: value == currentFrequencyValue
                          ? AppColors.SETTINGS_OPTIONS_COLOR
                          : AppColors.MENU_TEXT_COLOR,
                      fontWeight: value == currentFrequencyValue
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  //Calendar Widget
  Widget _calendarWidget() {
    return TableCalendar(
      calendarController: _calendarController,
      startDay: DateTime.now(),
      endDay: DateTime.now().add(Duration(days: 365)),
      initialSelectedDay: DateTime.now(),
      weekendDays: [],
      initialCalendarFormat: CalendarFormat.month,
      availableCalendarFormats: {CalendarFormat.month: ''},
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
            color: AppColors.WHITE_COLOR,
            fontSize: 20.0,
            fontWeight: FontWeight.w700),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: AppColors.WHITE_COLOR,
          size: 28.0,
        ),
        leftChevronPadding: EdgeInsets.zero,
        leftChevronMargin:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: AppColors.WHITE_COLOR,
          size: 28.0,
        ),
        rightChevronPadding: EdgeInsets.zero,
        rightChevronMargin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2),
      ),
      calendarStyle: CalendarStyle(outsideDaysVisible: false),
      formatAnimation: FormatAnimation.slide,
      availableGestures: AvailableGestures.horizontalSwipe,
      rowHeight: 65.0,
      builders: CalendarBuilders(dayBuilder: (context, dateTime, lists) {
        return calendarDaysWidget(dateTime);
      }, selectedDayBuilder: (context, dateTime, lists) {
        date = dateTime;
        print(date.toString().substring(0, 11));
        return selectDayWidget(dateTime);
      }, dowWeekdayBuilder: (context, day) {
        return weekDaysWidget(day);
      }, unavailableDayBuilder: (context, dateTime, lists) {
        date = dateTime;
        return unAvailableDayWidget(dateTime);
      }),
    );
  }

  //Calendar Days Widget
  Widget calendarDaysWidget(DateTime dateTime) {
    return Container(
      margin: EdgeInsets.only(right: 6.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: AppColors.WHITE_COLOR,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.4),
            blurRadius: 6,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Center(
        child: Text(
          DateFormat(AppStrings.DAY_FORMAT_DD).format(dateTime),
          style: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontSize: 12.0,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  //Select Day Widget
  Widget selectDayWidget(DateTime dateTime) {
    return Container(
      margin: EdgeInsets.only(right: 6.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: AppColors.BUTTON_COLOR,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.4),
            blurRadius: 6,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Center(
        child: Text(
          DateFormat(AppStrings.DAY_FORMAT_DD).format(dateTime),
          style: TextStyle(
              color: AppColors.WHITE_COLOR,
              fontSize: 12.0,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  //Week Days Widget
  Widget weekDaysWidget(String weekDay) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      padding: EdgeInsets.only(left: 1.5, right: 1.5, top: 1.5, bottom: 1.5),
      margin: EdgeInsets.only(left: 0.5, right: 0.5),
      decoration: BoxDecoration(
          color: AppColors.TRANSPARENT_COLOR,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.WHITE_COLOR)),
      child: Container(
        decoration:
            BoxDecoration(color: AppColors.WHITE_COLOR, shape: BoxShape.circle),
        child: Center(
          child: Text(
            weekDay.substring(0, 2).toUpperCase(),
            style: TextStyle(
                color: AppColors.BLACK_COLOR,
                fontSize: 12.0,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  //UnSelect Day Widget
  Widget unAvailableDayWidget(DateTime dateTime) {
    return Container(
      margin: EdgeInsets.only(right: 6.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          DateFormat(AppStrings.DAY_FORMAT_DD).format(dateTime),
          style: TextStyle(
              color: AppColors.WHITE_COLOR,
              fontSize: 12.0,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _remindMeOnMethod() {
    timeAlertScreen.timeAlert(context, ontimeChanged);
  }

  void ontimeChanged(DateTime reminderTime) {
    if (reminderTime != null) {
      setState(() {
        calendarReminerTime =
            DateFormat(AppStrings.DAY_FORMAT_HH_MM_SS).format(reminderTime);
      });
    }
  }

  void addReminderMethod() {
    if (_addReminderKey.currentState.validate()) {
      if (calendarReminerTime != null) {
        if (widget.reminderModel == null) {
          print("ADD REMINDER");
          baseService.addReminder(
              context,
              _addReminderController.text,
              currentFrequencyValue.toLowerCase(),
              calendarReminerTime,
              date.toString().substring(0, 10));
        } else {
          print("UPDATE REMINDER");
          baseService.updateReminder(
              context,
              _addReminderController.text,
              currentFrequencyValue.toLowerCase(),
              calendarReminerTime,
              date.toString().substring(0, 10),
              widget.reminderModel.id.toString());
        }
      } else {
        reminderTimeError();
      }
    }
  }

  void reminderTimeError() {
    Flushbar(
      icon: Icon(
        FontAwesomeIcons.exclamationCircle,
        color: AppColors.WHITE_COLOR,
      ),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.circular(8.0),
      messageText: Text(
        AppStrings.REMINDER_TIME_ERROR_TEXT,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.BUTTON_COLOR,
      duration: Duration(seconds: 2),
    ).show(context);
  }
}
