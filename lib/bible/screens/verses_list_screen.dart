import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:prayer_hybrid_app/bible/screens/bible_chapter_details_screen.dart';
import 'package:prayer_hybrid_app/models/bible_books_model.dart';
import 'package:prayer_hybrid_app/models/bible_verse_id.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';

class VersesListScreen extends StatefulWidget {
  final bibleiD;
  final id;

  VersesListScreen({this.id, this.bibleiD});

  @override
  _VersesListScreenState createState() => _VersesListScreenState();
}

class _VersesListScreenState extends State<VersesListScreen> {
  List<BibleVerseModel> verses = [];
  BaseService baseService = BaseService();
  String content = "";

  Future getVerses(id) async {
    await baseService
        .getBaseMethodBible(context,
            "https://api.scripture.api.bible/v1/bibles/${widget.bibleiD}/chapters/${id}",
            loading: true)
        .then((value) {
      content = value["data"]["content"];
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getVerses(widget.id);
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
              height: 12.0,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Html(
              data: content,
              style: {
                "p": Style(
                    textAlign: TextAlign.justify,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: AppColors.WHITE_COLOR,
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    lineHeight: LineHeight(1.3)),
              },
            ))),
            // Expanded(
            //     child: ListView.builder(
            //         itemCount: verses.length,
            //         shrinkWrap: true,
            //         itemBuilder: (context, index) {
            //           return _versesList(index);
            //         }))
          ],
        ),
      ),
    );
  }

  Widget _customAppBar() {
    return CustomAppBar(
      title: "VERSES",
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Widget _versesList(int bibleChapterIndex) {
    return GestureDetector(
      onTap: () {
        print("bible chapter screen");
        AppNavigation.navigateTo(
            context,
            BibleChapterDetailsScreen(
              verseID: verses[bibleChapterIndex].id,
              bibleId: verses[bibleChapterIndex].bibleId,
              name: verses[bibleChapterIndex].reference,
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: 7.5,
            bottom: bibleChapterIndex == 9 ? 15.0 : 7.5),
        padding:
            EdgeInsets.only(top: 13.0, bottom: 13.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          color: AppColors.WHITE_COLOR,
          borderRadius: BorderRadius.circular(23.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${verses[bibleChapterIndex].reference}",
                style: TextStyle(
                    fontSize: 14.5,
                    color: AppColors.BLACK_COLOR,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
