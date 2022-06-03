import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/bible_promises_description_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';

class BiblePromisesDialogScreen {
  void showDialogMethod({BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                top: MediaQuery.of(context).size.height * 0.1,
                bottom: MediaQuery.of(context).size.height * 0.1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bibleCategoryList(context),
                ],
              ),
            ),
          );
        });
  }

  Widget _bibleCategoryList(BuildContext context) {
    return ListView.builder(
        itemCount: AppStrings.BIBLECATEGORIES.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext ctxt, int index) {
          return _bibleCategoryWidget(context, index);
        });
  }

  Widget _bibleCategoryWidget(BuildContext context, int index) {
    //is liya taka ya list view proper grid view bnjai
    return index.isEven || index == AppStrings.BIBLECATEGORIES.length - 1
        ? Padding(
            padding: EdgeInsets.only(
                top: index == 0 ? 25.0 : 8.0,
                bottom: index == AppStrings.BIBLECATEGORIES.length - 1
                    ? 25.0
                    : 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                _bibleButtonWidget(context, index),
                index != AppStrings.BIBLECATEGORIES.length - 1
                    ? Spacer()
                    : Container(),
                index != AppStrings.BIBLECATEGORIES.length - 1
                    ? _bibleButtonWidget(context, index + 1)
                    : Container(),
                Spacer()
              ],
            ),
          )
        : Container();
  }

  Widget _bibleButtonWidget(BuildContext context, int indexNo) {
    return GestureDetector(
      onTap: () {
        // log("Bible category"+AppStrings.BIBLECATEGORIES[indexNo]);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigateTo(
            context,
            BiblePromisesDescriptionScreen(
                qoutes: AppStrings.BIBLE_PROMISES[indexNo],
                qouteWriter: AppStrings.BIBLE_PROMISE_WRITER[indexNo],
                title: AppStrings.BIBLECATEGORIES[indexNo]));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        padding:
            EdgeInsets.only(top: 14.0, bottom: 14.0, left: 2.0, right: 2.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.BUTTON_COLOR,
            boxShadow: [
              BoxShadow(
                color: AppColors.BLACK_COLOR.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ]),
        child: Center(
            child: Text(
          AppStrings.BIBLECATEGORIES[indexNo],
          style: TextStyle(
              color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w700),
          textScaleFactor: 0.97,
        )),
      ),
    );
  }
}
