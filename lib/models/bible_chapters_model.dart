class BibleChaptersModel {
  String id;
  String bibleId;
  String bookId;
  String number;
  String reference;

  BibleChaptersModel(
      {this.id, this.bibleId, this.bookId, this.number, this.reference});

  BibleChaptersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bibleId = json['bibleId'];
    bookId = json['bookId'];
    number = json['number'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bibleId'] = this.bibleId;
    data['bookId'] = this.bookId;
    data['number'] = this.number;
    data['reference'] = this.reference;
    return data;
  }
}