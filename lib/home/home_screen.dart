import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/add_praise/screens/add_praise_screen.dart';
import 'package:prayer_hybrid_app/add_prayer/screens/add_prayer_screen.dart';
import 'package:prayer_hybrid_app/bible/screens/bible_tab_screen.dart';
import 'package:prayer_hybrid_app/home/widgets/custom_pray_option_container.dart';
import 'package:prayer_hybrid_app/prayer_group/screens/prayer_group_list_screen.dart';
import 'package:prayer_hybrid_app/prayer_partner/screens/prayer_partner_list_screen.dart';
import 'package:prayer_hybrid_app/prayer_praise_info/screens/prayer_praise_tab_screen.dart';
import 'package:prayer_hybrid_app/subscription/screens/buy_now_subscription.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(
          flex: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _prayNowCategoryWidget(),
            _addPrayerCategoryWidget(),
          ],
        ),
        Spacer(
          flex: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bibleCategoryWidget(),
            _addPraiseCategoryWidget(),
          ],
        ),
        Spacer(
          flex: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _prayerPartnersWithoutSubscriptionCategoryWidget(),
            _prayerGroupCategoryWidget(),
          ],
        ),
        Spacer(
          flex: 2,
        ),
      ],
    );
  }

  //Pray Now Category Widget
  Widget _prayNowCategoryWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context, PrayerPraiseTabScreen(tabInitialIndex: 0));
      },
      child: CustomPrayOptionContainer(
          title: AppStrings.PRAY_NOW_TEXT,
          imagePath: AssetPaths.PRAY_NOW_IMAGE),
    );
  }

  //Add Prayer Category Widget
  Widget _addPrayerCategoryWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context,
            AddPrayerScreen(
                prayerButtonText: AppStrings.ADD_PRAYER_TEXT.toUpperCase()));
      },
      child: CustomPrayOptionContainer(
          title: AppStrings.ADD_PRAYER_TEXT,
          imagePath: AssetPaths.ADD_PRAYER_IMAGE),
    );
  }

  //The Bible Category Widget
  Widget _bibleCategoryWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(context, BibleTabScreen());
      },
      child: CustomPrayOptionContainer(
        title: AppStrings.BIBLE_TEXT,
        imagePath: AssetPaths.BIBLE_IMAGE,
        imageWidth: 45.0,
        imageHeight: 45.0,
      ),
    );
  }

  //Add Praise Category Widget
  Widget _addPraiseCategoryWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context,
            AddPraiseScreen(
                praiseButtonText: AppStrings.ADD_PRAISE_TEXT.toUpperCase()));
      },
      child: CustomPrayOptionContainer(
        title: AppStrings.ADD_PRAISE_TEXT,
        imagePath: AssetPaths.ADD_PRAISE_IMAGE,
        imageWidth: 70.0,
        imageHeight: 70.0,
      ),
    );
  }

  //Prayer Partners Without Subscription Widget
  Widget _prayerPartnersWithoutSubscriptionCategoryWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(context, PrayerPartnerListScreen());
      },
      child: CustomPrayOptionContainer(
          title: AppStrings.PRAYER_PARTNERS_TEXT,
          imagePath: AssetPaths.PRAYER_PARTNER_WITHOUT_SUBSCRIPTION_IMAGE),
    );
  }

  //Prayer Group Category Widget
  Widget _prayerGroupCategoryWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(context, PrayerGroupListScreen());
      },
      child: CustomPrayOptionContainer(
          title: AppStrings.PRAYER_GROUPS_TEXT,
          imagePath: AssetPaths.PRAYER_GROUP_IMAGE),
    );
  }

// //Prayer Partners Subscription Category Widget
// Widget _prayerPartnersSubscriptionCategoryWidget()
// {
//   return GestureDetector(
//       onTap: (){
//         AppNavigation.navigateTo(context, BuyNowSubscription());
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width*0.39,
//         height: MediaQuery.of(context).size.height*0.2,
//         decoration: BoxDecoration(
//             color: AppColors.WHITE_COLOR,
//             borderRadius: BorderRadius.circular(10.0)
//         ),
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Container(
//                 width: MediaQuery.of(context).size.width*0.19,
//                 height: MediaQuery.of(context).size.height*0.09,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0)),
//                   image: DecorationImage(
//                       image: AssetImage(AssetPaths.SUBSCRIPTION_TEXT_IMAGE),
//                       fit: BoxFit.fill
//                   ),
//                 ),
//               ),
//             ),
//
//             Column(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width*0.39,
//                   height: MediaQuery.of(context).size.height*0.113,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width*0.12,
//                         height: MediaQuery.of(context).size.height*0.065,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: AssetImage(AssetPaths.PRAYER_PARTNER_SUBSCRIPTION_IMAGE),
//                                 fit: BoxFit.contain
//                             )
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 6.0,),
//                 Expanded(
//                   child: Padding(
//                       padding: EdgeInsets.only(left: 2.0,right: 2.0),
//                       child: Text(AppStrings.PRAYER_PARTNERS_TEXT,style:TextStyle(color: AppColors.BLACK_COLOR,fontWeight: FontWeight.w700),textScaleFactor:1.1,overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,)
//                   ),
//                 )
//
//               ],
//             ),
//           ],
//         ),
//       )
//   );
// }

}
