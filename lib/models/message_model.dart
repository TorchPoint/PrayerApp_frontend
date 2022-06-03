class MessageModel {
  String firstName;
  String lastName;
  String profileImage;
  int id;
  int senderId;
  int recieverId;
  int groupId;
  String message;

  MessageModel(
      {this.firstName,
      this.lastName,
      this.profileImage,
      this.id,
      this.senderId,
      this.recieverId,
      this.groupId,
      this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    id = json['id'];
    senderId = json['sender_id']??0;
    recieverId = json['reciever_id']??0;
    groupId = json['group_id']??0;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['reciever_id'] = this.recieverId;
    data['group_id'] = this.groupId;
    data['message'] = this.message;
    return data;
  }
}
