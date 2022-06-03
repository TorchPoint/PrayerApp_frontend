class NotificationModel {
  int id;
  int recieverId;
  int senderId;
  int groupId;
  String type;
  Data data;
  String readAt;
  String createdAt;
  String updatedAt;

  NotificationModel(
      {this.id,
        this.recieverId,
        this.senderId,
        this.groupId,
        this.type,
        this.data,
        this.readAt,
        this.createdAt,
        this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recieverId = json['reciever_id'];
    senderId = json['sender_id'];
    groupId = json['group_id'];
    type = json['type'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reciever_id'] = this.recieverId;
    data['sender_id'] = this.senderId;
    data['group_id'] = this.groupId;
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Data {
  String name;
  String image;
  String message;

  Data({this.name, this.image, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['message'] = this.message;
    return data;
  }
}