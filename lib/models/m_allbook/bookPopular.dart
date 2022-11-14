class bookPopular {
  String? status;
  String? desc;
  List<Result>? result;

  bookPopular({this.status, this.desc, this.result});

  bookPopular.fromJson(Map<String, dynamic> json) {
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
  String? uniId;
  String? bookCount;
  String? bookHit;
  String? onlinetype;
  String? bookDesc;
  String? bookTitle;
  String? bookPrice;
  String? bookAuthor;
  String? bookNoOfPage;
  String? booktypeName;
  String? publisherName;
  String? bookIsbn;
  String? bookcateId;
  String? bookcateName;
  String? t2Id;
  String? imgLink;
  String? brbookId;
  String? bookRatings;

  Result(
      {this.bookId,
      this.bookshelfId,
      this.uniId,
      this.bookCount,
      this.bookHit,
      this.onlinetype,
      this.bookDesc,
      this.bookTitle,
      this.bookPrice,
      this.bookAuthor,
      this.bookNoOfPage,
      this.booktypeName,
      this.publisherName,
      this.bookIsbn,
      this.bookcateId,
      this.bookcateName,
      this.t2Id,
      this.imgLink,
      this.brbookId,
      this.bookRatings});

  Result.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookshelfId = json['bookshelf_id'];
    uniId = json['uni_id'];
    bookCount = json['book_count'];
    bookHit = json['book_hit'];
    onlinetype = json['onlinetype'];
    bookDesc = json['book_desc'];
    bookTitle = json['book_title'];
    bookPrice = json['book_price'];
    bookAuthor = json['book_author'];
    bookNoOfPage = json['book_no_of_page'];
    booktypeName = json['booktype_name'];
    publisherName = json['publisher_name'];
    bookIsbn = json['book_isbn'];
    bookcateId = json['bookcate_id'];
    bookcateName = json['bookcate_name'];
    t2Id = json['t2_id'];
    imgLink = json['imgLink'];
    brbookId = json['brbook_id'];
    bookRatings = json['book_ratings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['bookshelf_id'] = this.bookshelfId;
    data['uni_id'] = this.uniId;
    data['book_count'] = this.bookCount;
    data['book_hit'] = this.bookHit;
    data['onlinetype'] = this.onlinetype;
    data['book_desc'] = this.bookDesc;
    data['book_title'] = this.bookTitle;
    data['book_price'] = this.bookPrice;
    data['book_author'] = this.bookAuthor;
    data['book_no_of_page'] = this.bookNoOfPage;
    data['booktype_name'] = this.booktypeName;
    data['publisher_name'] = this.publisherName;
    data['book_isbn'] = this.bookIsbn;
    data['bookcate_id'] = this.bookcateId;
    data['bookcate_name'] = this.bookcateName;
    data['t2_id'] = this.t2Id;
    data['imgLink'] = this.imgLink;
    data['brbook_id'] = this.brbookId;
    data['book_ratings'] = this.bookRatings;
    return data;
  }
}
