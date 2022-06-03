import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/bible/screens/bible_chapter_list_screen.dart';
import 'package:prayer_hybrid_app/models/bible_books_model.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';

class BiblePrayerListScreen extends StatefulWidget {
  final String bibleVersion;

  BiblePrayerListScreen({this.bibleVersion});

  @override
  _BiblePrayerListScreenState createState() => _BiblePrayerListScreenState();
}

class _BiblePrayerListScreenState extends State<BiblePrayerListScreen> {
  List<BibleBooksModel> bibleBooksKingJamesList = [];
  List<BibleBooksModel> bibleBooksRevisedVersionList = [];
  List<BibleBooksModel> bibleBooksHolyBibleList = [];
  BaseService baseService = BaseService();

  String kingJamesUrl =
      "https://api.scripture.api.bible/v1/bibles/${ApiConst.KING_JAMES_VERSION_ID}/books";
  String revisedURL =
      "https://api.scripture.api.bible/v1/bibles/${ApiConst.REVISED_VERSION_ID}/books";
  String holyURL =
      "https://api.scripture.api.bible/v1/bibles/${ApiConst.HOLY_BIBLE_ID}/books";

  Future getBibleBooks() async {
    await baseService
        .getBaseMethodBible(
            context,
            widget.bibleVersion == AppStrings.KING_JAMES
                ? kingJamesUrl
                : widget.bibleVersion == AppStrings.REVISED_VERSION
                    ? revisedURL
                    : widget.bibleVersion == AppStrings.HOLY_BIBLE
                        ? holyURL
                        : "",
            loading: true)
        .then((value) {
      value["data"].forEach((element) {
        if (widget.bibleVersion == AppStrings.KING_JAMES) {
          bibleBooksKingJamesList.add(BibleBooksModel.fromJson(element));
        } else if (widget.bibleVersion == AppStrings.REVISED_VERSION) {
          bibleBooksRevisedVersionList.add(BibleBooksModel.fromJson(element));
        } else if (widget.bibleVersion == AppStrings.HOLY_BIBLE) {
          bibleBooksHolyBibleList.add(BibleBooksModel.fromJson(element));
        }
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getBibleBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Books",
          style: TextStyle(
              color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w600),
          textScaleFactor: 1.55,
        ),
        SizedBox(
          height: 12.0,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.bibleVersion == AppStrings.KING_JAMES
                  ? bibleBooksKingJamesList.length
                  : widget.bibleVersion == AppStrings.REVISED_VERSION
                      ? bibleBooksRevisedVersionList.length
                      : widget.bibleVersion == AppStrings.HOLY_BIBLE
                          ? bibleBooksHolyBibleList.length
                          : 0,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                return _biblePrayersList(index);
              }),
        ),
      ],
    );
  }

  Widget _biblePrayersList(int biblePrayerIndex) {
    return GestureDetector(
      onTap: () {
        if (widget.bibleVersion == AppStrings.KING_JAMES) {
          AppNavigation.navigateTo(
              context,
              BibleChapterListScreen(
                bibleBooksModel: bibleBooksKingJamesList[biblePrayerIndex],
              ));
        } else if (widget.bibleVersion == AppStrings.REVISED_VERSION) {
          AppNavigation.navigateTo(
              context,
              BibleChapterListScreen(
                bibleBooksModel: bibleBooksRevisedVersionList[biblePrayerIndex],
              ));
        } else if (widget.bibleVersion == AppStrings.HOLY_BIBLE) {
          AppNavigation.navigateTo(
              context,
              BibleChapterListScreen(
                bibleBooksModel: bibleBooksHolyBibleList[biblePrayerIndex],
              ));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.075,
            right: MediaQuery.of(context).size.width * 0.075,
            top: 7.5,
            bottom: biblePrayerIndex == bibleBooksKingJamesList.length - 1
                ? 15.0
                : 7.5),
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
                // bibleBooksKingJamesList[biblePrayerIndex].name,

                widget.bibleVersion == AppStrings.KING_JAMES
                    ? bibleBooksKingJamesList[biblePrayerIndex].name
                    : widget.bibleVersion == AppStrings.REVISED_VERSION
                        ? bibleBooksRevisedVersionList[biblePrayerIndex].name
                        : widget.bibleVersion == AppStrings.HOLY_BIBLE
                            ? bibleBooksHolyBibleList[biblePrayerIndex].name
                            : "",
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
