import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';

import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';

class BiblePromisesDescriptionScreen extends StatefulWidget {
  String title;
  List qoutes;
  List qouteWriter;

  BiblePromisesDescriptionScreen({this.title, this.qoutes, this.qouteWriter});

  @override
  _BiblePromisesDescriptionScreenState createState() =>
      _BiblePromisesDescriptionScreenState();
}

class _BiblePromisesDescriptionScreenState
    extends State<BiblePromisesDescriptionScreen> {
  PageController pageController = PageController();

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
            Text(
              widget.title,
              style: TextStyle(
                  color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w600),
              textScaleFactor: 2.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            _descriptionContainerWidget(),
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
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Widget _descriptionContainerWidget() {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.8) + 38.0,
      height: MediaQuery.of(context).size.height * 0.30,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: BoxDecoration(
                  color: AppColors.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Center(
                  child: PageView.builder(
                controller: pageController,
                itemCount: widget.qoutes.length,
                itemBuilder: (context, index) {
                  return _quoteDataWidget(index);
                },
              )),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
                onTap: () {
                  pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                },
                child: leftRightContainerWidget(AssetPaths.BACK_ICON)),
          ),
          GestureDetector(
            onTap: () {
              pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: leftRightContainerWidget(AssetPaths.NEXT_ICON),
            ),
          )
        ],
      ),
    );
  }

  Widget _quoteDataWidget(index) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0,top: 20),
      child: Center(
        child: SelectableText(
          widget.qoutes[index] +"\n\n"+ widget.qouteWriter[index],
          style: TextStyle(
              color: AppColors.BLACK_COLOR, fontWeight: FontWeight.w600),
          textScaleFactor: 1.2,
          textAlign: TextAlign.center,
         // maxLines: 7,
          // overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget leftRightContainerWidget(String imagePath) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.BUTTON_COLOR,
          boxShadow: [
            BoxShadow(
              color: AppColors.BLACK_COLOR.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ]),
      child: Center(
          child: Image.asset(
        imagePath,
        width: 8.0,
      )),
    );
  }
}
