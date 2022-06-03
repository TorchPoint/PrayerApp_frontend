import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/finish_praying_screen.dart';
import 'package:provider/provider.dart';

class PrayersListScreen extends StatefulWidget {
  @override
  _PrayersListScreenState createState() => _PrayersListScreenState();
}

class _PrayersListScreenState extends State<PrayersListScreen> {
  TextEditingController _searchController = TextEditingController();
  int selectIndex = 0;
  BaseService baseService = BaseService();

  @override
  void initState() {
    // TODO: implement initState
    baseService.fetchPrayers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prayerProvider = Provider.of<PrayerProvider>(context, listen: true);
    return Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        _searchTextFormField(),
        SizedBox(
          height: 10.0,
        ),

        Expanded(
          child: prayerProvider.prayerList == null ||
                  prayerProvider.prayerList.length == 0
              ? Center(
                  child: Text(
                    "No Prayers Found",
                    style: TextStyle(color: AppColors.WHITE_COLOR),
                  ),
                )
              : _searchController.text.isEmpty
                  ? ListView.builder(
                      itemCount: prayerProvider.prayerList.length ?? 0,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return _prayersList(index);
                      })
                  : prayerProvider.searchPrayerList?.length == 0
                      ? Center(
                          child: Text(
                            "No Prayers Found",
                            style: TextStyle(color: AppColors.WHITE_COLOR),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              prayerProvider.searchPrayerList?.length ?? 0,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _prayersList(index);
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
          prayerProvider.resetPrayerSearchList();
        } else {
          baseService.searchPrayer(context, val.toString());
        }
      },
    );
  }

  Widget _prayersList(int prayerIndex) {
    var prayerProvider = Provider.of<PrayerProvider>(context, listen: true);
    return GestureDetector(
      onTap: () {
        print("next screen");
        AppNavigation.navigateTo(
            context,
            FinishPrayingScreen(
              prayerModel: prayerProvider.prayerList[prayerIndex],
            ));
      },
      onLongPress: () {
        setState(() {
          selectIndex = prayerIndex;
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
            right: selectIndex == prayerIndex ? 6.0 : 20.0),
        decoration: BoxDecoration(
            color: selectIndex == prayerIndex
                ? AppColors.BUTTON_COLOR
                : AppColors.WHITE_COLOR,
            borderRadius: BorderRadius.circular(23.0),
            boxShadow: selectIndex == prayerIndex
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
                    ? prayerProvider.prayerList[prayerIndex].title
                    : prayerProvider.searchPrayerList[prayerIndex].title,
                style: TextStyle(
                    fontSize: 14.5,
                    color: selectIndex == prayerIndex
                        ? AppColors.WHITE_COLOR
                        : AppColors.BLACK_COLOR,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _arrowDeleteIcons(prayerIndex),
          ],
        ),
      ),
    );
  }

  Widget _arrowDeleteIcons(int prayerIndex) {
    var prayerProvider = Provider.of<PrayerProvider>(context, listen: true);
    return selectIndex == prayerIndex
        ? Row(
            children: [
              GestureDetector(
                onTap: () {
                  print("delete");
                  baseService.deletePrayer(
                      context, prayerProvider.prayerList[prayerIndex].id);
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
