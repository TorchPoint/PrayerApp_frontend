import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/widgets/custom_time_picker_spinner.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
class TimeAlertScreen
{
  DateTime reminderTime;

  void timeAlert(BuildContext context,ValueChanged<DateTime> onTimeChanged)
  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.09,right: MediaQuery.of(context).size.width*0.09),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child:Container(
              width: MediaQuery.of(context).size.width*0.82,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                  _timeContainerWidget(context),
                  //SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  _cancelDoneButtonsWidget(context,onTimeChanged),
                  SizedBox(height: MediaQuery.of(context).size.height*0.06,),



                ],
              ),
            )

          );
        }
    );
  }


  Widget _timeContainerWidget(BuildContext context)
  {
      return Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.08,right: MediaQuery.of(context).size.width*0.08),
        child: Container(
          height: MediaQuery.of(context).size.height*0.35,
          width: MediaQuery.of(context).size.width*0.82,
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height*0.11,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.18,
                  height: MediaQuery.of(context).size.height*0.11,
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
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).size.height*0.11,
                left: (MediaQuery.of(context).size.width*0.18)+(MediaQuery.of(context).size.width*0.05),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.18,
                  height: MediaQuery.of(context).size.height*0.11,
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
                ),
              ),
//
              Positioned(
                top:  MediaQuery.of(context).size.height*0.11,
                left: (MediaQuery.of(context).size.width*0.18)+(MediaQuery.of(context).size.width*0.05)+(MediaQuery.of(context).size.width*0.18)+(MediaQuery.of(context).size.width*0.05),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.18,
                  height: MediaQuery.of(context).size.height*0.11,
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
                ),
              ),

              CustomTimePickerSpinner(
                is24HourMode: true,
                alignment: Alignment.center,
                normalTextStyle: TextStyle(
                    fontSize: 35,
                    color: Color(0XFFd6d2d2),
                    fontWeight: FontWeight.w800
                ),
                isShowSeconds: true,
                highlightedTextStyle: TextStyle(
                    fontSize: 35,
                    color: AppColors.WHITE_COLOR,
                    fontWeight: FontWeight.w700
                ),
                spacing: MediaQuery.of(context).size.width*0.05,
                itemHeight: MediaQuery.of(context).size.height*0.11,
                itemWidth: MediaQuery.of(context).size.width*0.18,
                isForce2Digits: true,
                onTimeChange: (time) {
                  print("Time:${time.toString()}");
                  reminderTime = time;

                },
              ),


            ],
          ),
        ),
      );
  }


  Widget _cancelDoneButtonsWidget(BuildContext context,ValueChanged<DateTime> onTimeChanged)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
          containerWidth: MediaQuery.of(context).size.width*0.33,
          buttonColor: AppColors.WHITE_COLOR,
          borderColor: AppColors.BUTTON_COLOR,
          buttonText: AppStrings.CANCEL_TEXT,
          textColor: AppColors.BUTTON_COLOR,
          fontWeight: FontWeight.w700,
          fontSize: 1.2,
          paddingTop: 10.0,
          paddingBottom: 10.0,
          onTap: (){
            AppNavigation.navigatorPop(context);
          },
        ),

        CustomButton(
          containerWidth: MediaQuery.of(context).size.width*0.33,
          buttonColor: AppColors.BUTTON_COLOR,
          borderColor: AppColors.BUTTON_COLOR,
          elevation: true,
          buttonText: AppStrings.DONE_TEXT,
          textColor: AppColors.WHITE_COLOR,
          fontWeight: FontWeight.w700,
          fontSize: 1.2,
          onTap: (){
            AppNavigation.navigatorPop(context);
            onTimeChanged(reminderTime);
          },
        )
      ],
    );
  }


}
