class userBookFavorite {
  String? status;
  String? desc;
  List<Result>? result;

  userBookFavorite({this.status, this.desc, this.result});

  userBookFavorite.fromJson(Map<String, dynamic> json) {
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
  String? bookDesc;
  String? bookHit;
  String? bookTitle;
  String? onlinetype;
  String? bookPrice;
  String? bookAuthor;
  String? bookNoOfPage;
  String? t2Id;
  String? booktypeName;
  String? publisherName;
  String? bookIsbn;
  String? bookCount;
  String? bookcateId;
  String? imgLink;
  String? bookRatings;
  String? bookcateName;
  String? bookcateOrder;
  String? dDC;

  Result(
      {this.bookId,
      this.bookshelfId,
      this.bookDesc,
      this.bookHit,
      this.bookTitle,
      this.onlinetype,
      this.bookPrice,
      this.bookAuthor,
      this.bookNoOfPage,
      this.t2Id,
      this.booktypeName,
      this.publisherName,
      this.bookIsbn,
      this.bookCount,
      this.bookcateId,
      this.imgLink,
      this.bookRatings,
      this.bookcateName,
      this.bookcateOrder,
      this.dDC});

  Result.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookshelfId = json['bookshelf_id'];
    bookDesc = json['book_desc'];
    bookHit = json['book_hit'];
    bookTitle = json['book_title'];
    onlinetype = json['onlinetype'];
    bookPrice = json['book_price'];
    bookAuthor = json['book_author'];
    bookNoOfPage = json['book_no_of_page'];
    t2Id = json['t2_id'];
    booktypeName = json['booktype_name'];
    publisherName = json['publisher_name'];
    bookIsbn = json['book_isbn'];
    bookCount = json['book_count'];
    bookcateId = json['bookcate_id'];
    imgLink = json['imgLink'];
    bookRatings = json['book_ratings'];
    bookcateName = json['bookcate_name'];
    bookcateOrder = json['bookcate_order'];
    dDC = json['DDC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['bookshelf_id'] = this.bookshelfId;
    data['book_desc'] = this.bookDesc;
    data['book_hit'] = this.bookHit;
    data['book_title'] = this.bookTitle;
    data['onlinetype'] = this.onlinetype;
    data['book_price'] = this.bookPrice;
    data['book_author'] = this.bookAuthor;
    data['book_no_of_page'] = this.bookNoOfPage;
    data['t2_id'] = this.t2Id;
    data['booktype_name'] = this.booktypeName;
    data['publisher_name'] = this.publisherName;
    data['book_isbn'] = this.bookIsbn;
    data['book_count'] = this.bookCount;
    data['bookcate_id'] = this.bookcateId;
    data['imgLink'] = this.imgLink;
    data['book_ratings'] = this.bookRatings;
    data['bookcate_name'] = this.bookcateName;
    data['bookcate_order'] = this.bookcateOrder;
    data['DDC'] = this.dDC;
    return data;
  }
}
