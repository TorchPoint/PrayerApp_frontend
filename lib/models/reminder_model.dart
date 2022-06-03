class ReminderModel {
  int id;
  int userId;
  String reminderDate;
  String title;
  String type;
  String reminderTime;
  String createdAt;
  String updatedAt;

  ReminderModel(
      {this.id,
        this.userId,
        this.reminderDate,
        this.title,
        this.type,
        this.reminderTime,
        this.createdAt,
        this.updatedAt});

  ReminderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reminderDate = json['reminder_date'];
    title = json['title'];
    type = json['type'];
    reminderTime = json['reminder_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['reminder_date'] = this.reminderDate;
    data['title'] = this.title;
    data['type'] = this.type;
    data['reminder_time'] = this.reminderTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}