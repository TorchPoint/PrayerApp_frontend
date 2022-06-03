import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/finish_praise_screen.dart';
import 'package:provider/provider.dart';

class PraiseListScreen extends StatefulWidget {
  @override
  _PraiseListScreenState createState() => _PraiseListScreenState();
}

class _PraiseListScreenState extends State<PraiseListScreen> {
  TextEditingController _searchController = TextEditingController();
  int selectIndex = 0;
  BaseService baseService = BaseService();
  List<String> prayerList = [
    "Test",
    "Marriage",
    "Car",
    "Medical Emergency",
    "Loan"
  ];

  @override
  void initState() {
    // TODO: implement initState
    baseService.fetchPraise(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var praiseProvider = Provider.of<PrayerProvider>(context, listen: true);
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        _searchTextFormField(),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: praiseProvider.praiseList == null ||
                  praiseProvider.praiseList.length == 0
              ? Center(
                  child: Text(
                    "No Praise Found",
                    style: TextStyle(color: AppColors.WHITE_COLOR),
                  ),
                )
              : _searchController.text.isEmpty
                  ? ListView.builder(
                      itemCount: praiseProvider.praiseList?.length ?? 0,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                     // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return _praiseList(index);
                      })
                  : praiseProvider.searchPraiseList.length == 0
                      ? Center(
                          child: Text(
                            "No Praise Found",
                            style: TextStyle(color: AppColors.WHITE_COLOR),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              praiseProvider.searchPraiseList.length ?? 0,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _praiseList(index);
                          }),
        ),
      ],
    );
  }

  Widget _searchTextFormField() {
    var prayerProvider = Provider.of<PrayerProvider>(context, listen: true);
    return CustomTextFormField(
      textController: _searchController,
      containerWidth: MediaQuery.of(context).size.width * 0.85,
      hintText: AppStrings.SEARCH_HINT_TEXT,
      borderRadius: 28.0,
      contentPaddingTop: 13.0,
      contentPaddingBottom: 13.0,
      contentPaddingRight: 8.0,
      contentPaddingLeft: 20.0,
      suffixIcon: AssetPaths.SEARCH_ICON,
      suffixIconWidth: 15,
      hintSize: 15.0,
      textSize: 15.0,
      isCollapsed: true,
      onChange: (val) {
        if (_searchController.text.isEmpty) {
          prayerProvider.resetPraiseSearchList();
        } else {
          baseService.searchPrayer(context, val.toString());
        }
      },
    );
  }

  Widget _praiseList(int praiseIndex) {
    var praiseProvider = Provider.of<PrayerProvider>(context, listen: true);
    return GestureDetector(
      onTap: () {
        print("next screen");
        AppNavigation.navigateTo(
            context,
            FinishPraiseScreen(
              praiseModel: praiseProvider.praiseList[praiseIndex],
            ));
      },
      onLongPress: () {
        setState(() {
          selectIndex = praiseIndex;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: 7.0,
            bottom: 7.0),
        padding: EdgeInsets.only(
            top: 13.0,
            bottom: 13.0,
            left: 20.0,
            right: selectIndex == praiseIndex ? 6.0 : 20.0),
        decoration: BoxDecoration(
            color: selectIndex == praiseIndex
                ? AppColors.BUTTON_COLOR
                : AppColors.WHITE_COLOR,
            borderRadius: BorderRadius.circular(23.0),
            boxShadow: selectIndex == praiseIndex
                ? [
                    BoxShadow(
                      color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
                : []),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _searchController.text.isEmpty
                    ? praiseProvider.praiseList[praiseIndex].title.toString()
                    : praiseProvider.searchPraiseList[praiseIndex].title
                        .toString(),
                style: TextStyle(
                    fontSize: 14.5,
                    color: selectIndex == praiseIndex
                        ? AppColors.WHITE_COLOR
                        : AppColors.BLACK_COLOR,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _arrowDeleteIcons(praiseIndex),
          ],
        ),
      ),
    );
  }

  Widget _arrowDeleteIcons(int praiseIndex) {
    var praiseProvider = Provider.of<PrayerProvider>(context, listen: true);
    return selectIndex == praiseIndex
        ? Row(
            children: [

              GestureDetector(
                onTap: () {
                  baseService.deletePraise(
                      context, praiseProvider.praiseList[praiseIndex].id);
                  print("delete");
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
