class check_fav {
  String? status;
  String? desc;
  String? result;

  check_fav({this.status, this.desc, this.result});

  check_fav.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    desc = json['desc'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['desc'] = this.desc;
    data['result'] = this.result;
    return data;
  }
}
