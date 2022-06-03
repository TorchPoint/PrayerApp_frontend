import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:prayer_hybrid_app/models/prayer_model.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';

import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddPraiseScreen extends StatefulWidget {
  final String praiseButtonText;
  final PrayerModel praiseModel;

  AddPraiseScreen({this.praiseButtonText, this.praiseModel});

  @override
  _AddPraiseScreenState createState() => _AddPraiseScreenState();
}

class _AddPraiseScreenState extends State<AddPraiseScreen> {
  final GlobalKey<FormState> _addPraiseKey = GlobalKey<FormState>();
  TextEditingController _praiseTitleController = TextEditingController();
  TextEditingController _addNameController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Category currentCategoryValue;
  BaseService baseService = BaseService();

  List<Category> newCategories = [];

  Future getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse(ApiConst.BASE_URL + ApiConst.CATEGORIES_URL);
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = AppColors.BACKGROUND1_COLOR
      ..indicatorColor = AppColors.WHITE_COLOR
      ..textColor = AppColors.WHITE_COLOR
      ..indicatorSize = 35.0
      ..radius = 10.0
      ..maskColor = AppColors.BLACK_COLOR.withOpacity(0.6)
      ..userInteractions = false
      ..dismissOnTap = false;
    EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);

    final http.Response response = await http.get(uri,
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"});

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      Map data = jsonDecode(response.body);

      data["data"].forEach((element) {
        newCategories.add(Category.fromJson(element));
        setState(() {});
      });
      if (widget.praiseModel != null) {
        newCategories.forEach((element) {
          if (widget.praiseModel.category?.name == element.name) {
            setState(() {
              currentCategoryValue = element;
            });
          }
        });
      }
      return data;
    } else {
      EasyLoading.dismiss();
    }
  }

  void loadData() {
    if (widget.praiseModel != null) {
      _addNameController.text = widget.praiseModel.name;
      _praiseTitleController.text = widget.praiseModel.title;
      _descriptionController.text = widget.praiseModel.description;
      getCategories();
    } else {
      getCategories();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
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
              height: 6.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Form(
                  key: _addPraiseKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      _praiseTitleWidget(),
                      SizedBox(height: 25.0),
                      _addNameWidget(),
                      SizedBox(
                        height: 25.0,
                      ),
                      _categoryWidget(),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            AppStrings.DESCRIPTION_TEXT,
                            style: TextStyle(
                                color: AppColors.WHITE_COLOR,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5),
                            textScaleFactor: 1.4,
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      _descriptionWidget(),
                      SizedBox(
                        height: 25.0,
                      ),
                      _addPraiseButtonWidget(),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        print("Leading tap");
        AppNavigation.navigatorPop(context);
      },
      // trailingIconPath: AssetPaths.NOTIFICATION_ICON,
      trailingTap: () {
        print("Notification Icon");
      },
    );
  }

  //Praise Title Widget
  Widget _praiseTitleWidget() {
    return CustomTextFormField(
      textController: _praiseTitleController,
      containerWidth: MediaQuery.of(context).size.width * 0.85,
      hintText: AppStrings.PRAISE_TITLE_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingLeft: 16.0,
      onValidate: (value) {
        if (value.trim().isEmpty) {
          return AppStrings.PRAISE_TITLE_EMPTY_ERROR;
        }
        return null;
      },
    );
  }

  //Add Name Widget
  Widget _addNameWidget() {
    return CustomTextFormField(
      textController: _addNameController,
      containerWidth: MediaQuery.of(context).size.width * 0.85,
      hintText: AppStrings.ADD_NAME_HINT_TEXT,
      borderRadius: 30.0,
      contentPaddingLeft: 16.0,
      // onValidate: (value) {
      //   if (value.trim().isEmpty) {
      //     return AppStrings.ADD_NAME_EMPTY_ERROR;
      //   }
      //   return null;
      // },
    );
  }

  //Category Widget
  Widget _categoryWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return DropdownButtonHideUnderline(
            child: DropdownButtonFormField<Category>(
              iconEnabledColor: AppColors.WHITE_COLOR,
              dropdownColor: AppColors.BACKGROUND2_COLOR,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: AppColors.WHITE_COLOR)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: AppColors.WHITE_COLOR)),
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
                  errorStyle: TextStyle(
                    fontSize: 13.0,
                    color: AppColors.ERROR_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                  errorMaxLines: 2,
                  hintText: AppStrings.CATEGORY_HINT_TEXT,
                  hintStyle: TextStyle(
                    fontSize: 17.0,
                    color: AppColors.WHITE_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.only(
                      top: 14.0, bottom: 14.0, left: 16.0, right: 14.0)),
              isDense: true,
              value: currentCategoryValue,
              // validator: (value) {
              //   if (value == null) {
              //     return AppStrings.CATEGORY_EMPTY_ERROR;
              //   }
              //   return null;
              // },
              onChanged: (Category categoryValue) {
                setState(() {
                  currentCategoryValue = categoryValue;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return newCategories.map((value) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      value.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColors.WHITE_COLOR,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  );
                }).toList();
              },
              items: newCategories.map((Category value) {
                return DropdownMenuItem<Category>(
                  value: value,
                  child: Container(
                    //width: MediaQuery.of(context).size.width*0.6,
                    child: Text(
                      value.name,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: value == currentCategoryValue
                            ? AppColors.WHITE_COLOR
                            : AppColors.WHITE_COLOR,
                        fontWeight: value == currentCategoryValue
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  //Add Description Widget
  Widget _descriptionWidget() {
    return CustomTextFormField(
      textController: _descriptionController,
      containerWidth: MediaQuery.of(context).size.width * 0.85,
      hintText: AppStrings.DESCRIPTION_HINT_TEXT,
      borderRadius: 13.0,
      contentPaddingLeft: 16.0,
      maxLines: 5,
      // onValidate: (value) {
      //   if (value.trim().isEmpty) {
      //     return AppStrings.DESCRIPTION_EMPTY_ERROR;
      //   }
      //   return null;
      // },
    );
  }

  //Add Praise Button Widget
  Widget _addPraiseButtonWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.65,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: widget.praiseButtonText,
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 1.3,
      paddingTop: 12.0,
      paddingBottom: 12.0,
      onTap: () {
        print("praise");

        if (_addPraiseKey.currentState.validate()) {
          if (widget.praiseButtonText ==
              AppStrings.ADD_PRAISE_TEXT.toUpperCase()) {
            baseService.addPraise(
                context,
                currentCategoryValue?.id.toString() ?? "",
                _descriptionController.text,
                _praiseTitleController.text,
                _addNameController.text);
          } else {
            baseService.updatePraise(
                context,
                currentCategoryValue?.id ?? "",
                widget.praiseModel.id,
                _descriptionController.text,
                _praiseTitleController.text,
                _addNameController.text);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _praiseTitleController.dispose();
    _addNameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
  }
}
