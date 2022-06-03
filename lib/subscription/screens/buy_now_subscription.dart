import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/subscription/screens/pay_subscription_screen.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_button.dart';

class BuyNowSubscription extends StatefulWidget {
  @override
  _BuyNowSubscriptionState createState() => _BuyNowSubscriptionState();
}

class _BuyNowSubscriptionState extends State<BuyNowSubscription> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final String monthlyID = 'com.fictivestudios.prayer.monthly_sub';
  final String yearlyID = 'com.fictivestudios.prayer.yearly_sub';
  bool _available, loaded = false;

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      setState(() {
        _purchases.addAll(purchaseDetailsList);
        _handlePurchaseUpdates(purchaseDetailsList);
      });
    }, onDone: () {
      log("DONE");
      _subscription.cancel();
    }, onError: (error) {
      log("Error");
      _subscription.cancel();
      // handle error here.
    });
    loadProductsForSale();
  }

  loadProductsForSale() async {
    _available = await _inAppPurchase.isAvailable();
    if (_available) {
      const Set<String> _kIds = <String>{
        'com.fictivestudios.prayer.monthly_sub',
        'com.fictivestudios.prayer.yearly_sub'
      };

      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_kIds);
      _products = response.productDetails;
      print(_products[0].description);
      print(_products.first.title);
      setState(() {
        loaded = true;
      });
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint(
            '#PurchaseService.loadProductsForSale() notFoundIDs: ${response.notFoundIDs}');
      }
      if (response.error != null) {
        debugPrint(
            '#PurchaseService.loadProductsForSale() error: ${response.error.code + ' - ' + response.error.message}');
      }
    } else {
      debugPrint('#PurchaseService.loadProductsForSale() store not available');
      return null;
    }
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  Future<void> _handlePurchaseUpdates(purchases) async {
    print("in handle purchase");
    purchases.forEach((PurchaseDetails purchaseDetails) async {
      ///
      // print("Local verification"+purchaseDetails.verificationData.serverVerificationData);
      // print("server verification"+purchaseDetails.verificationData.localVerificationData);
      print("purchase status:- ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print('purchase pending');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("Error");
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          print("item already purchased");
          BaseService().createPayment(
            context,
            purchaseDetails.productID,
            purchaseDetails.purchaseID,
            purchaseDetails.verificationData.serverVerificationData,
            purchaseDetails.productID.substring(26),
          );
          print(purchaseDetails.productID);
          print(purchaseDetails.purchaseID);
          print(purchaseDetails.verificationData.serverVerificationData);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print("complete purchase called");
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  _restorePurchase(String user) async {
    await _inAppPurchase.restorePurchases(applicationUserName: user);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: !loaded
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _customAppBar(),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          AppStrings.SELECT_PACKAGE_TEXT,
                          style: TextStyle(
                              color: AppColors.WHITE_COLOR,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                          textScaleFactor: 1.45,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _monthlySubscriptionWidget(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        _annualSubscriptionWidget(),
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
      paddingTop: 20.0,
      leadingTap: () {
        print("Leading tap");
        AppNavigation.navigatorPop(context);
      },
    );
  }

  //Monthly Subscription Widget
  Widget _monthlySubscriptionWidget() {
    return _subscriptionWidget(
      subscriptionTitle:
          loaded ? _products.first?.title.toString().split("(")[0] : "",
      subscriptionAmount: loaded ? _products.first?.price : "",
      desc: loaded ? _products.first?.description : "",
    );
  }

  //Annual Subscription Widget
  Widget _annualSubscriptionWidget() {
    return _subscriptionWidget(
      subscriptionTitle:
          loaded ? _products.last?.title.toString().split("(")[0] : "",
      subscriptionAmount: loaded ? _products.last?.price : "",
      desc: loaded ? _products.last?.description : "",
    );
  }

  //Subscription Widget
  Widget _subscriptionWidget(
      {String subscriptionTitle, String subscriptionAmount, String desc}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      height: MediaQuery.of(context).size.height * 0.23,
      color: AppColors.TRANSPARENT_COLOR,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.82,
            height: MediaQuery.of(context).size.height * 0.20,
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
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: AppColors.BUTTON_COLOR,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        topRight: Radius.circular(6.0)),
                  ),
                  child: Center(
                      child: Text(
                    subscriptionTitle,
                    style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0),
                    textScaleFactor: 1.1,
                    textAlign: TextAlign.center,
                  )),
                ),
                Spacer(
                  flex: 1,
                ),
                Text(
                  subscriptionAmount,
                  style: TextStyle(
                      color: AppColors.BUTTON_COLOR,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0),
                  textScaleFactor: 2.4,
                  textAlign: TextAlign.center,
                ),
                Spacer(
                  flex: 3,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buyNowWidget(subscriptionAmount, subscriptionTitle, desc),
          ),
        ],
      ),
    );
  }

  Widget _buyNowWidget(amount, type, desc) {
    return CustomButton(
      containerWidth: MediaQuery.of(context).size.width * 0.35,
      buttonColor: AppColors.BUTTON_COLOR,
      borderColor: AppColors.BUTTON_COLOR,
      elevation: true,
      buttonText: AppStrings.BUY_NOW_TEXT,
      textColor: AppColors.WHITE_COLOR,
      fontWeight: FontWeight.w700,
      fontSize: 0.9,
      paddingTop: 11.5,
      paddingBottom: 11.5,
      onTap: () {
        print(_products.first.price);
        print(_products.last.price);
        print(type);

        if (type.toString().trim() == "Yearly Subscription") {
          AppNavigation.navigateTo(
              context,
              PaySubscription(
                type: type,
                amount: amount,
                desc: desc,
                productDetails: _products.last,
              ));
        } else {
          AppNavigation.navigateTo(
              context,
              PaySubscription(
                type: type,
                amount: amount,
                desc: desc,
                productDetails: _products.first,
              ));
        }
      },
    );
  }
}
