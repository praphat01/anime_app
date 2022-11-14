class userBookHistory {
  String? status;
  String? desc;
  List<Result>? result;

  userBookHistory({this.status, this.desc, this.result});

  userBookHistory.fromJson(Map<String, dynamic> json) {
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
  String? bookTitle;
  String? bookPrice;
  String? bookAuthor;
  String? bookNoOfPage;
  String? booktypeName;
  String? publisherName;
  String? bookIsbn;
  String? t2Id;
  String? imgLink;
  String? bookDesc;
  String? bookcateName;
  String? onlinetype;
  String? id;
  String? userId;
  String? uniId;
  String? startTime;
  String? endTime;
  String? ipAddress;
  String? status;
  String? bStatus;
  String? showStatus;

  Result(
      {this.bookId,
      this.bookshelfId,
      this.bookTitle,
      this.bookPrice,
      this.bookAuthor,
      this.bookNoOfPage,
      this.booktypeName,
      this.publisherName,
      this.bookIsbn,
      this.t2Id,
      this.imgLink,
      this.bookDesc,
      this.bookcateName,
      this.onlinetype,
      this.id,
      this.userId,
      this.uniId,
      this.startTime,
      this.endTime,
      this.ipAddress,
      this.status,
      this.bStatus,
      this.showStatus});

  Result.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookshelfId = json['bookshelf_id'];
    bookTitle = json['book_title'];
    bookPrice = json['book_price'];
    bookAuthor = json['book_author'];
    bookNoOfPage = json['book_no_of_page'];
    booktypeName = json['booktype_name'];
    publisherName = json['publisher_name'];
    bookIsbn = json['book_isbn'];
    t2Id = json['t2_id'];
    imgLink = json['imgLink'];
    bookDesc = json['book_desc'];
    bookcateName = json['bookcate_name'];
    onlinetype = json['onlinetype'];
    id = json['id'];
    userId = json['user_id'];
    uniId = json['uni_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    ipAddress = json['ip_address'];
    status = json['status'];
    bStatus = json['b_status'];
    showStatus = json['show_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['bookshelf_id'] = this.bookshelfId;
    data['book_title'] = this.bookTitle;
    data['book_price'] = this.bookPrice;
    data['book_author'] = this.bookAuthor;
    data['book_no_of_page'] = this.bookNoOfPage;
    data['booktype_name'] = this.booktypeName;
    data['publisher_name'] = this.publisherName;
    data['book_isbn'] = this.bookIsbn;
    data['t2_id'] = this.t2Id;
    data['imgLink'] = this.imgLink;
    data['book_desc'] = this.bookDesc;
    data['bookcate_name'] = this.bookcateName;
    data['onlinetype'] = this.onlinetype;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['uni_id'] = this.uniId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['ip_address'] = this.ipAddress;
    data['status'] = this.status;
    data['b_status'] = this.bStatus;
    data['show_status'] = this.showStatus;
    return data;
  }
}
