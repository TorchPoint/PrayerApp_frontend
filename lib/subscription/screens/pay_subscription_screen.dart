import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:prayer_hybrid_app/prayer_group/screens/create_prayer_group_screen.dart';
import 'package:prayer_hybrid_app/prayer_partner/screens/prayer_partner_list_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';

class PaySubscription extends StatefulWidget {
  String amount, type, desc;
  ProductDetails productDetails;

  PaySubscription({this.amount, this.type, this.desc, this.productDetails});

  @override
  _PaySubscriptionState createState() => _PaySubscriptionState();
}

class _PaySubscriptionState extends State<PaySubscription> {
  _makePurchase() {
    // Saved earlier from queryProductDetails().
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: widget.productDetails);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.productDetails.price);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Column(
          children: [
            _customAppBar(),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    widget.type,
                    style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0),
                    textScaleFactor: 1.45,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  _paySubscriptionWidget(),
                ],
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
      leadingTap: () {
        print("Leading tap");
        AppNavigation.navigatorPop(context);
      },
    );
  }

  //Subscription Widget
  Widget _paySubscriptionWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      height: MediaQuery.of(context).size.height * 0.48,
      color: AppColors.TRANSPARENT_COLOR,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.82,
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              color: AppColors.WHITE_COLOR,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.82,
                  height: MediaQuery.of(context).size.height * 0.09,
                  decoration: BoxDecoration(
                    color: AppColors.BUTTON_COLOR,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        topRight: Radius.circular(6.0)),
                  ),
                  child: Center(
                      child: Text(
                    widget.amount,
                    style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0),
                    textScaleFactor: 1.9,
                    textAlign: TextAlign.center,
                  )),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.desc,
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0),
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                )),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buyNowWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buyNowWidget() {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.35,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: widget.amount,
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 0.9,
      paddingTop: 11.5,
      paddingBottom: 11.5,
      onTap: () {
        _makePurchase();

      },
    );
  }
}
