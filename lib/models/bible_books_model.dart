class BibleBooksModel {
  String id;
  String bibleId;
  String abbreviation;
  String name;
  String nameLong;

  BibleBooksModel(
      {this.id, this.bibleId, this.abbreviation, this.name, this.nameLong});

  BibleBooksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bibleId = json['bibleId'];
    abbreviation = json['abbreviation'];
    name = json['name'];
    nameLong = json['nameLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bibleId'] = this.bibleId;
    data['abbreviation'] = this.abbreviation;
    data['name'] = this.name;
    data['nameLong'] = this.nameLong;
    return data;
  }
}
