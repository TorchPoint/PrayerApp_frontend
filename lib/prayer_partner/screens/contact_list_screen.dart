import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_app_bar.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/widgets/custom_text_form_field.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Contact> getContacts = [];
  List<Contact> showContacts;
  List<Contact> showSearchContacts = [];

  @override
  void initState() {
    super.initState();
    getContactsFromDevice();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Column(
          children: [
            _customAppBar(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: showContacts != null
                  ? showContacts.length != 0
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              _searchTextFormField(),
                              const SizedBox(
                                height: 20,
                              ),
                              _searchController.text.isEmpty
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: showContacts.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                              child: Text(showContacts[index]
                                                      .initials() ??
                                                  "")),
                                          title: Text(
                                            showContacts[index].displayName ??
                                                "",
                                            style: TextStyle(
                                                color: AppColors.WHITE_COLOR,
                                                fontWeight: FontWeight.w600),
                                            textScaleFactor: 1.2,
                                          ),
                                          subtitle: Text(
                                            showContacts[index]
                                                    .phones
                                                    .elementAt(0)
                                                    .value ??
                                                "",
                                            style: TextStyle(
                                                color: AppColors.WHITE_COLOR),
                                            textScaleFactor: 1.0,
                                          ),
                                          onTap: () {
                                            print("display name" +
                                                showContacts[index]
                                                    .displayName
                                                    .toString());
                                            print("phone no" +
                                                showContacts[index]
                                                    .phones
                                                    .elementAt(0)
                                                    .value
                                                    .toString());
                                            AppNavigation.navigatorPopData(
                                                context, {
                                              "name": showContacts[index]
                                                  .displayName
                                                  .toString(),
                                              "phone no": showContacts[index]
                                                  .phones
                                                  .elementAt(0)
                                                  .value
                                                  .toString()
                                            });
                                          },
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: showSearchContacts.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                              child: Text(
                                                  showSearchContacts[index]
                                                          .initials() ??
                                                      "")),
                                          title: Text(
                                            showSearchContacts[index]
                                                    .displayName ??
                                                "",
                                            style: TextStyle(
                                                color: AppColors.WHITE_COLOR,
                                                fontWeight: FontWeight.w600),
                                            textScaleFactor: 1.2,
                                          ),
                                          subtitle: Text(
                                            showSearchContacts[index]
                                                    .phones
                                                    .elementAt(0)
                                                    .value ??
                                                "",
                                            style: TextStyle(
                                                color: AppColors.WHITE_COLOR),
                                            textScaleFactor: 1.0,
                                          ),
                                          onTap: () {
                                            print("display name" +
                                                showSearchContacts[index]
                                                    .displayName
                                                    .toString());
                                            print("phone no" +
                                                showSearchContacts[index]
                                                    .phones
                                                    .elementAt(0)
                                                    .value
                                                    .toString());
                                            AppNavigation.navigatorPopData(
                                                context, {
                                              "name": showSearchContacts[index]
                                                  .displayName
                                                  .toString(),
                                              "phone no":
                                                  showSearchContacts[index]
                                                      .phones
                                                      .elementAt(0)
                                                      .value
                                                      .toString()
                                            });
                                          },
                                        );
                                      },
                                    ),
                            ],
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 5.0),
                            child: Text(
                              AppStrings.NO_CONTACT_AVAILABLE,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.WHITE_COLOR),
                              textScaleFactor: 1.3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.SETTINGS_OPTIONS_COLOR),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //Custom App Bar Widget
  Widget _customAppBar() {
    return CustomAppBar(
      title: AppStrings.CONTACT_LIST_TEXT,
      leadingIconPath: AssetPaths.BACK_ICON,
      paddingTop: 20.0,
      leadingTap: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Future<void> getContactsFromDevice() async {
    // Load without thumbnails initially.
    var contacts = (await ContactsService.getContacts(
            withThumbnails: false, iOSLocalizedLabels: false,))
        .toList();
    print("Contacts:${contacts.length}");
    if (contacts != null) {
      contacts.forEach((element) {
        if(element.phones.length!=0){
          getContacts.add(element);
        }
      });
    }
    setState(() {
      showContacts = getContacts;
    });

    print("Contact filter list:${showContacts.length.toString()}");
    // print("Contact filter list:${_contacts[0].phones.elementAt(0).value}");
  }

  Widget _searchTextFormField() {
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
        print(val);
        if (val.length >= 2) {
          showSearchContacts.clear();
          showContacts.forEach((element) {
            if (element.displayName.toLowerCase().contains(val.toLowerCase())) {

              showSearchContacts.add(element);
              setState(() {});
            }
          });
        } else {
          showSearchContacts.clear();
          setState(() {});
        }
      },
    );
  }
}
