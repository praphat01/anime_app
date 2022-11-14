class publisher {
  String? status;
  String? desc;
  List<Result>? result;

  publisher({this.status, this.desc, this.result});

  publisher.fromJson(Map<String, dynamic> json) {
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
  String? bookcateId;
  String? bookcateName;
  String? bookCount;

  Result({this.bookcateId, this.bookcateName, this.bookCount});

  Result.fromJson(Map<String, dynamic> json) {
    bookcateId = json['bookcate_id'];
    bookcateName = json['bookcate_name'];
    bookCount = json['book_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookcate_id'] = this.bookcateId;
    data['bookcate_name'] = this.bookcateName;
    data['book_count'] = this.bookCount;
    return data;
  }
}
