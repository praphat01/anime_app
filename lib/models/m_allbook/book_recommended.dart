class book_Recommended {
  String? status;
  String? desc;
  List<Result>? result;

  book_Recommended({this.status, this.desc, this.result});

  book_Recommended.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    desc = json['desc'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['desc'] = this.desc;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? bookId;
  String? bookshelfId;
  String? bid;
  String? bookPrice;
  String? bookDesc;
  String? bookTitle;
  String? bookAuthor;
  String? bookNoOfPage;
  String? booktypeName;
  String? publisherName;
  String? bookIsbn;
  String? bookcateId;
  String? onlinetype;
  String? t2Id;
  String? imgLink;
  String? bookcateName;
  String? bookcateOrder;
  String? dDC;

  Result(
      {this.bookId,
      this.bookshelfId,
      this.bid,
      this.bookPrice,
      this.bookDesc,
      this.bookTitle,
      this.bookAuthor,
      this.bookNoOfPage,
      this.booktypeName,
      this.publisherName,
      this.bookIsbn,
      this.bookcateId,
      this.onlinetype,
      this.t2Id,
      this.imgLink,
      this.bookcateName,
      this.bookcateOrder,
      this.dDC});

  Result.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookshelfId = json['bookshelf_id'];
    bid = json['bid'];
    bookPrice = json['book_price'];
    bookDesc = json['book_desc'];
    bookTitle = json['book_title'];
    bookAuthor = json['book_author'];
    bookNoOfPage = json['book_no_of_page'];
    booktypeName = json['booktype_name'];
    publisherName = json['publisher_name'];
    bookIsbn = json['book_isbn'];
    bookcateId = json['bookcate_id'];
    onlinetype = json['onlinetype'];
    t2Id = json['t2_id'];
    imgLink = json['imgLink'];
    bookcateName = json['bookcate_name'];
    bookcateOrder = json['bookcate_order'];
    dDC = json['DDC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['bookshelf_id'] = this.bookshelfId;
    data['bid'] = this.bid;
    data['book_price'] = this.bookPrice;
    data['book_desc'] = this.bookDesc;
    data['book_title'] = this.bookTitle;
    data['book_author'] = this.bookAuthor;
    data['book_no_of_page'] = this.bookNoOfPage;
    data['booktype_name'] = this.booktypeName;
    data['publisher_name'] = this.publisherName;
    data['book_isbn'] = this.bookIsbn;
    data['bookcate_id'] = this.bookcateId;
    data['onlinetype'] = this.onlinetype;
    data['t2_id'] = this.t2Id;
    data['imgLink'] = this.imgLink;
    data['bookcate_name'] = this.bookcateName;
    data['bookcate_order'] = this.bookcateOrder;
    data['DDC'] = this.dDC;
    return data;
  }
}
