import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:prayer_hybrid_app/bible/screens/verses_model.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';

class BibleChapterDetailsScreen extends StatefulWidget {
  final String name, bibleId, verseID;

  BibleChapterDetailsScreen({this.name, this.bibleId, this.verseID});

  @override
  _BibleChapterDetailsScreenState createState() =>
      _BibleChapterDetailsScreenState();
}

class _BibleChapterDetailsScreenState extends State<BibleChapterDetailsScreen> {
  List<VersesModel> verseText;
  BaseService baseService = BaseService();
  String verse;

  Future getVerseDetails() async {
    await baseService
        .getBaseMethodBible(context,
            "https://api.scripture.api.bible/v1/bibles/${widget.bibleId}/verses/${widget.verseID}?content-type=html&include-notes=false&include-titles=false&include-chapter-numbers=false&include-verse-numbers=false&include-verse-spans=false&use-org-id=false",
            loading: true)
        .then((value) {
      // verseText = value["data"]["content"][0]["items"][0]["text"];
      verse = value["data"]["content"];
      print("-----" + verse.toString());
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getVerseDetails();
    super.initState();
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
              height: 15.0,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Html(
                data: verse ?? "",
                shrinkWrap: true,
                style: {
                  "p": Style(
                      textAlign: TextAlign.justify,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      color: AppColors.WHITE_COLOR,
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      lineHeight: LineHeight(1.3)),
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      title: "${widget.name}" ?? "",
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }
}
