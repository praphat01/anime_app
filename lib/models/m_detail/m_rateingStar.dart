class rating_star {
  String? status;
  String? desc;
  int? result;

  rating_star({this.status, this.desc, this.result});

  rating_star.fromJson(Map<String, dynamic> json) {
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
