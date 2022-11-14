class getuni {
  String? total;
  String? status;
  String? desc;
  List<Result>? result;

  getuni({this.status, this.desc, this.result});

  getuni.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    desc = json['desc'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
      total = json['total'];
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
  String? uniName;
  String? uniId;
  String? uniSname;
  String? uniLink;
  String? t4Id;
  String? facebook;
  String? imgLink;

  Result(
      {this.uniName,
      this.uniId,
      this.uniSname,
      this.uniLink,
      this.t4Id,
      this.facebook,
      this.imgLink});

  Result.fromJson(Map<String, dynamic> json) {
    uniName = json['uni_name'];
    uniId = json['uni_id'];
    uniSname = json['uni_sname'];
    uniLink = json['uni_link'];
    t4Id = json['t4_id'];
    facebook = json['facebook'];
    imgLink = json['imgLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uni_name'] = this.uniName;
    data['uni_id'] = this.uniId;
    data['uni_sname'] = this.uniSname;
    data['uni_link'] = this.uniLink;
    data['t4_id'] = this.t4Id;
    data['facebook'] = this.facebook;
    data['imgLink'] = this.imgLink;
    return data;
  }
}
