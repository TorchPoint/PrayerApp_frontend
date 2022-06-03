class PrayerModel {
  int id;
  int categoryId;
  int userId;
  String title;
  String name;
  String type;
  String prayerDuration;
  String description;
  String createdAt;
  String updatedAt;
  Category category;

  PrayerModel(
      {this.id,
      this.categoryId,
      this.userId,
      this.title,
      this.name,
      this.type,
      this.prayerDuration,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.category});

  PrayerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    title = json['title'];
    name = json['name'];
    type = json['type'];
    prayerDuration = json['prayer_duration'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['name'] = this.name;
    data['type'] = this.type;
    data['prayer_duration'] = this.prayerDuration;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  int status;
  String createdAt;
  String updatedAt;

  Category({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
