class userBookshelf {
  String? status;
  String? des;
  List<InsertKey>? insertKey;
  String? deleteKey;

  userBookshelf({this.status, this.des, this.insertKey, this.deleteKey});

  userBookshelf.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    des = json['des'];
    if (json['insert_key'] != null) {
      insertKey = <InsertKey>[];
      json['insert_key'].forEach((v) {
        insertKey!.add(new InsertKey.fromJson(v));
      });
    }
    deleteKey = json['delete_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['des'] = this.des;
    if (this.insertKey != null) {
      data['insert_key'] = this.insertKey!.map((v) => v.toJson()).toList();
    }
    data['delete_key'] = this.deleteKey;
    return data;
  }
}

class InsertKey {
  String? bookshelfId;
  String? bookDesc;
  String? bookPrice;
  String? bookId;
  String? bookTitle;
  String? bookAuthor;
  String? bookChecksum;
  String? bookNoOfPage;
  String? imgLink;
  String? pdfLink;
  String? publisherName;
  String? t2Id;
  String? bookIsbn;
  String? bookcateName;
  String? bookInstallDate;
  String? booktypeName;
  String? endTime;
  String? bStatus;

  InsertKey(
      {this.bookshelfId,
      this.bookDesc,
      this.bookPrice,
      this.bookId,
      this.bookTitle,
      this.bookAuthor,
      this.bookChecksum,
      this.bookNoOfPage,
      this.imgLink,
      this.pdfLink,
      this.publisherName,
      this.t2Id,
      this.bookIsbn,
      this.bookcateName,
      this.bookInstallDate,
      this.booktypeName,
      this.endTime,
      this.bStatus});

  InsertKey.fromJson(Map<String, dynamic> json) {
    bookshelfId = json['bookshelf_id'];
    bookDesc = json['book_desc'];
    bookPrice = json['book_price'];
    bookId = json['book_id'];
    bookTitle = json['book_title'];
    bookAuthor = json['book_author'];
    bookChecksum = json['book_checksum'];
    bookNoOfPage = json['book_no_of_page'];
    imgLink = json['imgLink'];
    pdfLink = json['pdf_link'];
    publisherName = json['publisher_name'];
    t2Id = json['t2_id'];
    bookIsbn = json['book_isbn'];
    bookcateName = json['bookcate_name'];
    bookInstallDate = json['book_install_date'];
    booktypeName = json['booktype_name'];
    endTime = json['end_time'];
    bStatus = json['b_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookshelf_id'] = this.bookshelfId;
    data['book_desc'] = this.bookDesc;
    data['book_price'] = this.bookPrice;
    data['book_id'] = this.bookId;
    data['book_title'] = this.bookTitle;
    data['book_author'] = this.bookAuthor;
    data['book_checksum'] = this.bookChecksum;
    data['book_no_of_page'] = this.bookNoOfPage;
    data['imgLink'] = this.imgLink;
    data['pdf_link'] = this.pdfLink;
    data['publisher_name'] = this.publisherName;
    data['t2_id'] = this.t2Id;
    data['book_isbn'] = this.bookIsbn;
    data['bookcate_name'] = this.bookcateName;
    data['book_install_date'] = this.bookInstallDate;
    data['booktype_name'] = this.booktypeName;
    data['end_time'] = this.endTime;
    data['b_status'] = this.bStatus;
    return data;
  }
}
