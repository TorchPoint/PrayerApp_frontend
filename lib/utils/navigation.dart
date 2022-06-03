import 'package:flutter/material.dart';

class AppNavigation {
  static void navigateToRemovingAll(context, Widget widget) async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => widget),
        (Route<dynamic> route) => false);
  }

  static void navigateTo(BuildContext context, Widget widget) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static void navigateReplacement(BuildContext context, Widget widget) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static Future<dynamic> navigateToUpdate(
      BuildContext context, Widget widget) async {
    dynamic value = await Navigator.of(context)
        .push(MaterialPageRoute<dynamic>(builder: (context) => widget));
    //     .then((String value) {
    //   print("Value is"+value.toString());
    //   return value;
    // });
    return value;
  }

  static void navigatorPop(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateCloseDialog(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void navigatorPopTrue(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  static void navigatorPopData(BuildContext context, dynamic data) {
    Navigator.of(context).pop(data);
  }

  static void navigatorPopFalse(BuildContext context) {
    Navigator.of(context).pop(false);
  }
}
