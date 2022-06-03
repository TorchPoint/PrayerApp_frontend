import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prayer_hybrid_app/prayer_partner/screens/add_prayer_partner_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/constants.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';


class PaymentCardsScreen extends StatefulWidget {
  @override
  _PaymentCardsScreenState createState() => _PaymentCardsScreenState();
}

class _PaymentCardsScreenState extends State<PaymentCardsScreen> {
  final GlobalKey<FormState> _paymentCardKey = GlobalKey<FormState>();

  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expirationMonthController = TextEditingController();
  TextEditingController _expirationYearController = TextEditingController();
  TextEditingController _cardCvvController = TextEditingController();

  String errorCardNumber="",errorExpirationMonth="",errorExpirationYear="",errorCVV="";
  bool boolCardNumber=true,boolExpirationMonth=true,boolExpirationYear=true,boolCVV=true,boolExpirationGreater = true;

  List cardTypes = [AssetPaths.VISA_CARD_IMAGE,AssetPaths.MASTER_CARD_IMAGE,AssetPaths.UCB_CARD_IMAGE];
  List cardNumbers = [AppStrings.CARD_NUMBER_TEXT,AppStrings.CARD_NUMBER_TEXT2,AppStrings.CARD_NUMBER_TEXT3];

  DateTime datePicked;
  DateTime cardDate;
  String formattedMonth;

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor:AppColors.TRANSPARENT_COLOR,
        resizeToAvoidBottomInset: false,
        body: Form(
          key:  _paymentCardKey,
          child: Column(
            children: [
              _customAppBar(),
              SizedBox(height: 20.0,),
              cardNumber(),
              SizedBox(height: 14.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.44,
                    child: Column(
                      children: [
                        expirationMonth(),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.44,
                    child: Column(
                      children: [
                        expirationYear(),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 14.0,),
              cardCVV(),
              SizedBox(height: 14.0,),
              addCard(),
              SizedBox(height: MediaQuery.of(context).size.height*0.06,),

              Expanded(
                child: Container(
                  color: AppColors.SETTINGS_OPTIONS_COLOR.withOpacity(0.3),
                  //padding: EdgeInsets.only(top:10.0),
                  child:ListView.builder(
                    itemCount: cardTypes.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return cardList(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar()
  {
    return CustomAppBar(
      title: AppStrings.PAYMENT_CARD_TEXT,
      leadingIconPath: AssetPaths.BACK_ICON,
      leadingTap: (){
        print("Leading tap");
        AppNavigation.navigatorPop(context);
      },
    );
  }


  Widget cardNumber()
  {
    return CustomTextFormField(
      textController: _cardNumberController,
      containerWidth: MediaQuery.of(context).size.width*0.85,
      hintText: AppStrings.CARD_NUMBER_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.CARD_NUMBER_ICON,
      prefixIconWidth: 15.0,
      keyBoardType: TextInputType.number,
      textInputFormatter: [Constants.cardNumberMaskFormatter],
      prefixIconColor: AppColors.WHITE_COLOR,
      onValidate: (value){
        if(value.trim().isEmpty)
        {
          return AppStrings.CARD_NUMBER_EMPTY_ERROR;
        }
        else if(value.length != 19)
        {
          return AppStrings.CARD_NUMBER_ERROR;
        }
        return null;
      },
    );
  }

  Widget expirationMonth()
  {
    return CustomTextFormField(
        textController: _expirationMonthController,
        containerWidth: MediaQuery.of(context).size.width*0.4,
        hintText: AppStrings.EXP_MONTH_HINT_TEXT,
        borderRadius: 30.0,
        contentPaddingRight: 0.0,
        prefixIcon: AssetPaths.CALENDAR_ICON,
        prefixIconWidth: 15.0,
        textFieldReadOnly: true,
        prefixIconColor: AppColors.WHITE_COLOR,
        errorMaxLines: 2,
        onValidate: (value) {
          if(value.trim().isEmpty)
          {
            return AppStrings.EXPIRATION_MONTH_ERROR;
          }
          return null;
        },
        onTextFieldTap: ()
        {
          print("ok");
          getExpirationMonth();
        },
    );
  }

  Widget expirationYear()
  {
    return CustomTextFormField(
        textController: _expirationYearController,
        containerWidth: MediaQuery.of(context).size.width*0.4,
        hintText: AppStrings.EXP_YEAR_HINT_TEXT,
        borderRadius: 30.0,
        contentPaddingRight: 0.0,
        prefixIcon: AssetPaths.CALENDAR_ICON,
        prefixIconWidth: 15.0,
        textFieldReadOnly: true,
        prefixIconColor: AppColors.WHITE_COLOR,
        errorMaxLines: 2,
        onValidate: (value){
          if(value.trim().isEmpty)
          {
            return AppStrings.EXPIRATION_YEAR_ERROR;
          }
          return null;
        },
        onTextFieldTap: ()
        {
          getExpirationYear();
        },
    );
  }

  Widget cardCVV()
  {
    return CustomTextFormField(
      textController: _cardCvvController,
      containerWidth: MediaQuery.of(context).size.width*0.85,
      hintText: AppStrings.CARD_CVV_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingRight: 0.0,
      prefixIcon: AssetPaths.CARD_CVV_ICON,
      prefixIconWidth: 15.0,
      keyBoardType: TextInputType.number,
      textInputFormatter:[
        LengthLimitingTextInputFormatter(3),
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      prefixIconColor: AppColors.WHITE_COLOR,
      onValidate: (value){
        if(value.trim().isEmpty)
        {
          return AppStrings.CVV_EMPTY_ERROR;
        }
        else if(value.length != 3)
        {
          return AppStrings.CVV_ERROR;
        }
        return null;
      },

    );
  }

  Widget addCard()
  {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width*0.38,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.ADD_CARD_TEXT,
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.25,
      paddingTop: 10.0,
      paddingBottom: 10.0,
      onTap: (){
        if(_paymentCardKey.currentState.validate())
        {
          paymentValidation();
        }
      },
    );
  }

  void paymentValidation()
  {
    //For Check of expiration date greater than current date
    if(_expirationMonthController.text.isNotEmpty && _expirationYearController.text.isNotEmpty)
    {
      if(int.parse(_expirationYearController.text) == DateTime.now().year)
      {
        if(int.parse(_expirationMonthController.text) < DateTime.now().month)
        {
          expirationGreaterError();
        }
        else
        {
          goToPrayerPartnerScreen();
        }
      }
      else
      {
        goToPrayerPartnerScreen();
      }
    }
  }

  void goToPrayerPartnerScreen()
  {
    AppNavigation.navigateTo(context, AddPrayerPartnerScreen());
  }




  void getExpirationMonth() async
  {

    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(AppStrings.DONE_TEXT, style: TextStyle(color: AppColors.BUTTON_COLOR.withOpacity(0.8))),
        cancel:  Text(AppStrings.CANCEL_TEXT, style: TextStyle(color: AppColors.MOST_DARK_GREY_COLOR)),
      ),
      dateFormat: AppStrings.MONTH_NAME_FORMAT_MMMM,
      locale:DateTimePickerLocale.en_us ,
      onChange: (dateTime, List<int> index) {
      },
      onConfirm: (dateTime, List<int> index) {
        formattedMonth = DateFormat(AppStrings.MONTH_NUMBER_FORMAT_MM).format(dateTime);
        print("Month:"+formattedMonth);
        _expirationMonthController.text = formattedMonth;
      },
    );
  }


  void getExpirationYear() async
  {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime(DateTime.now().year),
      maxDateTime: DateTime(DateTime.now().add(Duration(days: 10950)).year),
      initialDateTime: DateTime(_expirationYearController.text == "" ? DateTime.now().year : int.parse(_expirationYearController.text)),
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(AppStrings.DONE_TEXT, style: TextStyle(color: AppColors.BUTTON_COLOR.withOpacity(0.8))),
        cancel:  Text(AppStrings.CANCEL_TEXT, style: TextStyle(color: AppColors.MOST_DARK_GREY_COLOR)),
      ),
      dateFormat: AppStrings.YEAR_FORMAT_YYYY,
      locale:DateTimePickerLocale.en_us ,
      onChange: (dateTime, List<int> index) {
      },
      onConfirm: (dateTime, List<int> index) {
        _expirationYearController.text = dateTime.year.toString();
      },
    );
  }


  Widget cardList(int index)
  {
  return Container(
      width: MediaQuery.of(context).size.width*0.9,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05,top:index == 0 ? 20.0 : 10.0,bottom: index == cardTypes.length-1 ? 20.0 :10.0),
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.02,bottom: MediaQuery.of(context).size.height*0.02),
      decoration: BoxDecoration(
        color: AppColors.WHITE_COLOR,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.SETTINGS_OPTIONS_COLOR.withOpacity(0.3),
            blurRadius: 7.0, // has the effect of softening the shadow
            spreadRadius: 3.5,
            offset: Offset(2.5,2.5),
          )
        ],
      ),
      child: Row(
        children: [
          Image.asset(cardTypes[index],width: 50.0,),
          SizedBox(width: 15.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cardNumbers[index],style: TextStyle(color: AppColors.MOST_DARK_GREY_COLOR),textScaleFactor: 1.05,),
              Text(AppStrings.CARD_DATE_TEXT,style: TextStyle(color: AppColors.MOST_DARK_GREY_COLOR),textScaleFactor: 1.05,)
            ],
          )
        ],
      )
  );
}

  void expirationGreaterError()
  {
  Flushbar(
    icon: Icon(
      FontAwesomeIcons.exclamationCircle,
      color: AppColors.WHITE_COLOR,
    ),
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    borderRadius: BorderRadius.circular(8.0),
    messageText: Text(
      AppStrings.EXPIRATION_DATE_GREATER_ERROR,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: AppColors.BUTTON_COLOR,
    duration: Duration(seconds:  2),
  ).show(context);
}




@override
void dispose() {
  super.dispose();
  _cardNumberController.dispose();
  _cardCvvController.dispose();
  _expirationMonthController.dispose();
  _expirationYearController.dispose();
}

}
