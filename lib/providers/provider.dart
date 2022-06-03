import 'package:flutter/cupertino.dart';
import 'package:prayer_hybrid_app/models/group_prayer_model.dart';
import 'package:prayer_hybrid_app/models/message_model.dart';
import 'package:prayer_hybrid_app/models/notification_model.dart';
import 'package:prayer_hybrid_app/models/prayer_model.dart';
import 'package:prayer_hybrid_app/models/reminder_model.dart';
import 'package:prayer_hybrid_app/models/user_model.dart';

class AppUserProvider extends ChangeNotifier {
  AppUser _appUser;
  List<AppUser> prayerPartnersList;
  List<AppUser> searchPartnersList;
  List<AppUser> groupMembersList;

  AppUser get appUser => _appUser;

  void setUser(AppUser appUser) {
    _appUser = appUser;
    notifyListeners();
  }

  void restUserProvider() {
    _appUser = null;
    notifyListeners();
  }

  void fetchPrayerPartners(List newPartners) {
    prayerPartnersList = [];
    if (newPartners != null) {
      newPartners.forEach((element) {
        prayerPartnersList.add(AppUser.fromJson(element));
      });
    }
    notifyListeners();
  }

  void fetchSearchListPartners(List newSearchPartners) {
    searchPartnersList = [];
    if (searchPartnersList != null) {
      newSearchPartners.forEach((element) {
        searchPartnersList.add(AppUser.fromJson(element));
      });
    }
    notifyListeners();
  }

  void resetPartnersList() {
    if (prayerPartnersList != null) {
      prayerPartnersList.clear();
    }
    notifyListeners();
  }

  void resetSearchPartnersList() {
    if (searchPartnersList != null) {
      searchPartnersList.clear();
    }
    notifyListeners();
  }
}

class PrayerProvider extends ChangeNotifier {
  PrayerModel _prayerModel;
  List<PrayerModel> prayerList;
  List<PrayerModel> praiseList;
  List<PrayerModel> searchPrayerList;
  List<PrayerModel> searchPraiseList;

  PrayerModel get prayerModel => _prayerModel;

  void resetPrayerProvider() {
    if (praiseList != null) {
      prayerList.clear();
    }
    notifyListeners();
  }

  void restPraise() {
    if (praiseList != null) {
      praiseList.clear();
    }
    notifyListeners();
  }

  void fetchPrayerList(List prayers) {
    prayerList = [];
    if (prayers != null) {
      prayers.forEach((element) {
        prayerList.add(PrayerModel.fromJson(element));
      });
    }
    notifyListeners();
  }

  void fetchPraiseList(List praise) {
    praiseList = [];
    if (praise != null) {
      praise.forEach((element) {
        praiseList.add(PrayerModel.fromJson(element));
      });
    }
    notifyListeners();
  }

  void fetchSearchList(List searchList) {
    searchPraiseList = [];
    searchPrayerList = [];

    if (searchList != null) {
      searchList.forEach((element) {
        if (element["type"] == "praise") {
          searchPraiseList.add(PrayerModel.fromJson(element));
        } else if (element["type"] == "prayer") {
          searchPrayerList.add(PrayerModel.fromJson(element));
        }
      });
    }
    notifyListeners();
  }

  void resetPrayerSearchList() {
    if (searchPrayerList != null) {
      searchPrayerList.clear();
    }
    notifyListeners();
  }

  void resetPraiseSearchList() {
    if (searchPraiseList != null) {
      searchPraiseList.clear();
    }
    notifyListeners();
  }

  void addPrayer(PrayerModel prayerModel) {
    prayerList.add(prayerModel);
    notifyListeners();
  }
}

class ReminderProvider extends ChangeNotifier {
  ReminderModel _reminderModel;

  List<ReminderModel> reminderList;

  ReminderModel get reminderModel => _reminderModel;

  void resetReminderModel() {
    if (reminderList != null) {
      reminderList.clear();
    }
    notifyListeners();
  }

  void fetchReminderList(List reminders) {
    reminderList = [];
    if (reminders != null) {
      reminders.forEach((element) {
        reminderList.add(ReminderModel.fromJson(element));
      });
    }
    notifyListeners();
  }
}

class GroupProvider extends ChangeNotifier {
  GroupPrayerModel groupPrayerModel;

  List<GroupPrayerModel> groupList;
  List<AppUser> groupMembersList;

  void fetchGroups(List groups) {
    groupList = [];

    if (groupList != null) {
      groups.forEach((element) {
        groupList.add(GroupPrayerModel.fromJson(element));
      });
    }
    notifyListeners();
  }

  void resetGroupsList() {
    if (groupList != null) {
      groupList.clear();
    }
    notifyListeners();
  }

  void fetchGroupMembersList(List members) {
    groupMembersList = [];
    if (groupMembersList != null) {
      members.forEach((element) {
        groupMembersList.add(AppUser.fromJson(element));
      });
    }
    notifyListeners();
  }
}

class NotificationProvider extends ChangeNotifier {
  NotificationModel _notificationModel;
  List<NotificationModel> notificationList;

  void fetchNotification(List newNotifications) {
    notificationList = [];
    if (notificationList != null) {
      newNotifications.forEach((element) {
        notificationList.add(NotificationModel.fromJson(element));
      });
    }
    notifyListeners();
  }

  void resetNotificationList() {
    if (notificationList != null) {
      notificationList.clear();
    }
    notifyListeners();
  }
}

class ChatProvider extends ChangeNotifier {
  MessageModel messageModel;
  List<MessageModel> messageList = [];

  void fetchMessages(List newMessages) {
    //messageList = [];
    if (messageList != null) {
      newMessages.forEach((element) {
        messageList.insert(0, MessageModel.fromJson(element));
      });
      notifyListeners();
    }
  }

  void resetMessageList() {
    if (messageList != null) {
      messageList.clear();
    }
    notifyListeners();
  }
}
