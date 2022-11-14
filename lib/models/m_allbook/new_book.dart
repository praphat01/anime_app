class bookadded {
  String? status;
  String? desc;
  List<Result>? result;

  bookadded({this.status, this.desc, this.result});

  bookadded.fromJson(Map<String, dynamic> json) {
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
  String? bookInstallDate;
  String? bookPrice;
  String? bookTitle;
  String? bookAuthor;
  String? bookNoOfPage;
  String? booktypeName;
  String? publisherName;
  String? bookIsbn;
  String? bookcateId;
  String? bookcateName;
  String? onlinetype;
  String? t2Id;
  String? imgLink;

  Result(
      {this.bookId,
      this.bookDesc,
      this.bookshelfId,
      this.bookInstallDate,
      this.bookPrice,
      this.bookTitle,
      this.bookAuthor,
      this.bookNoOfPage,
      this.booktypeName,
      this.publisherName,
      this.bookIsbn,
      this.bookcateId,
      this.bookcateName,
      this.onlinetype,
      this.t2Id,
      this.imgLink});

  Result.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookDesc = json['book_desc'];
    bookshelfId = json['bookshelf_id'];
    bookInstallDate = json['book_install_date'];
    bookPrice = json['book_price'];
    bookTitle = json['book_title'];
    bookAuthor = json['book_author'];
    bookNoOfPage = json['book_no_of_page'];
    booktypeName = json['booktype_name'];
    publisherName = json['publisher_name'];
    bookIsbn = json['book_isbn'];
    bookcateId = json['bookcate_id'];
    bookcateName = json['bookcate_name'];
    onlinetype = json['onlinetype'];
    t2Id = json['t2_id'];
    imgLink = json['imgLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['book_desc'] = this.bookDesc;
    data['bookshelf_id'] = this.bookshelfId;
    data['book_install_date'] = this.bookInstallDate;
    data['book_price'] = this.bookPrice;
    data['book_title'] = this.bookTitle;
    data['book_author'] = this.bookAuthor;
    data['book_no_of_page'] = this.bookNoOfPage;
    data['booktype_name'] = this.booktypeName;
    data['publisher_name'] = this.publisherName;
    data['book_isbn'] = this.bookIsbn;
    data['bookcate_id'] = this.bookcateId;
    data['bookcate_name'] = this.bookcateName;
    data['onlinetype'] = this.onlinetype;
    data['t2_id'] = this.t2Id;
    data['imgLink'] = this.imgLink;
    return data;
  }
}
