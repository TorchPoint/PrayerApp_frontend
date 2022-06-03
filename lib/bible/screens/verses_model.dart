class VersesModel {
  String id;
  String orgId;
  String bookId;
  String chapterId;
  String bibleId;
  String reference;
  String content;
  int verseCount;
  String copyright;
  Next next;
  Next previous;

  VersesModel(
      {this.id,
      this.orgId,
      this.bookId,
      this.chapterId,
      this.bibleId,
      this.reference,
      this.content,
      this.verseCount,
      this.copyright,
      this.next,
      this.previous});

  VersesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orgId = json['orgId'];
    bookId = json['bookId'];
    chapterId = json['chapterId'];
    bibleId = json['bibleId'];
    reference = json['reference'];
    content = json['content'];
    verseCount = json['verseCount'];
    copyright = json['copyright'];
    next = json['next'] != null ? new Next.fromJson(json['next']) : null;
    previous =
        json['previous'] != null ? new Next.fromJson(json['previous']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orgId'] = this.orgId;
    data['bookId'] = this.bookId;
    data['chapterId'] = this.chapterId;
    data['bibleId'] = this.bibleId;
    data['reference'] = this.reference;
    data['content'] = this.content;
    data['verseCount'] = this.verseCount;
    data['copyright'] = this.copyright;
    if (this.next != null) {
      data['next'] = this.next.toJson();
    }
    if (this.previous != null) {
      data['previous'] = this.previous.toJson();
    }
    return data;
  }
}

class Next {
  String id;
  String number;

  Next({this.id, this.number});

  Next.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    return data;
  }
}
