import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppDialogs
{
////////////////////// Toast //////////////////////////
  static void showToast({String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  static Widget progressDialog() {
    //  ProgressHUD(
    //   backgroundColor: AppColors.TRANSPARENT_COLOR,
    //   color: AppColors.PRIMARY_COLOR,
    //   borderRadius: 5.0,
    //   loading: true,
    // );
    return CircularProgressIndicator();
  }

  static void progressAlertDialog({BuildContext context}) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: (){
               print("no back button");
               return;
               
            },
            child: Center(
              child: CircularProgressIndicator(
              ),
            ),
          );
        }
    );


    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.28,right: MediaQuery.of(context).size.width*0.28),
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0)
    //         ),
    //         child: Container(
    //           height: MediaQuery.of(context).size.height*0.22,
    //           child: ProgressHUD(
    //             backgroundColor: AppColors.TRANSPARENT_COLOR,
    //             color: AppColors.PRIMARY_COLOR,
    //             //borderRadius: 15.0,
    //             loading: true,
    //           ),
    //         ),
    //
    //
    //       );
    //     }
    // );
  }
}