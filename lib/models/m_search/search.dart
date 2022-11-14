class searchBook {
  String? status;
  String? desc;
  List<Result>? result;

  searchBook({this.status, this.desc, this.result});

  searchBook.fromJson(Map<String, dynamic> json) {
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
  String? bookDesc;
  String? bookshelfId;
  String? bookPrice;
  String? bookTitle;
  String? bookAuthor;
  String? bookRatings;
  String? bookNoOfPage;
  String? bookCount;
  String? t2Id;
  String? imgLink;
  String? publisherName;
  String? bookIsbn;
  String? bookcateName;
  String? booktypeName;
  String? onlinetype;

  Result(
      {this.bookId,
      this.bookDesc,
      this.bookshelfId,
      this.bookPrice,
      this.bookTitle,
      this.bookAuthor,
      this.bookRatings,
      this.bookNoOfPage,
      this.bookCount,
      this.t2Id,
      this.imgLink,
      this.publisherName,
      this.bookIsbn,
      this.bookcateName,
      this.booktypeName,
      this.onlinetype});

  Result.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookDesc = json['book_desc'];
    bookshelfId = json['bookshelf_id'];
    bookPrice = json['book_price'];
    bookTitle = json['book_title'];
    bookAuthor = json['book_author'];
    bookRatings = json['book_ratings'];
    bookNoOfPage = json['book_no_of_page'];
    bookCount = json['book_count'];
    t2Id = json['t2_id'];
    imgLink = json['imgLink'];
    publisherName = json['publisher_name'];
    bookIsbn = json['book_isbn'];
    bookcateName = json['bookcate_name'];
    booktypeName = json['booktype_name'];
    onlinetype = json['onlinetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['book_desc'] = this.bookDesc;
    data['bookshelf_id'] = this.bookshelfId;
    data['book_price'] = this.bookPrice;
    data['book_title'] = this.bookTitle;
    data['book_author'] = this.bookAuthor;
    data['book_ratings'] = this.bookRatings;
    data['book_no_of_page'] = this.bookNoOfPage;
    data['book_count'] = this.bookCount;
    data['t2_id'] = this.t2Id;
    data['imgLink'] = this.imgLink;
    data['publisher_name'] = this.publisherName;
    data['book_isbn'] = this.bookIsbn;
    data['bookcate_name'] = this.bookcateName;
    data['booktype_name'] = this.booktypeName;
    data['onlinetype'] = this.onlinetype;
    return data;
  }
}
