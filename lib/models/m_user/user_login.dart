class user_login {
  String? status;
  String? desc;
  List<Result>? result;

  user_login({this.status, this.desc, this.result});

  user_login.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? accesstypeId;
  String? uniId;
  String? facultyId;
  String? majorId;
  String? courseId;
  String? userLoginname;
  String? userPassword;
  String? userName;
  String? userLastname;
  String? userEmail;
  String? userMobileno;
  String? userHomeno;
  String? userAddress;
  String? userCity;
  String? userState;
  String? userPostcode;
  Null? userCountry;
  Null? userCredit;
  String? userDatetime;
  String? endTime;
  String? userAdmin;
  Null? userOtp;
  String? userActivate;
  String? session;
  Null? fbId;
  String? uniName;
  String? uniFullname;
  String? uniSname;

  Result(
      {this.userId,
      this.accesstypeId,
      this.uniId,
      this.facultyId,
      this.majorId,
      this.courseId,
      this.userLoginname,
      this.userPassword,
      this.userName,
      this.userLastname,
      this.userEmail,
      this.userMobileno,
      this.userHomeno,
      this.userAddress,
      this.userCity,
      this.userState,
      this.userPostcode,
      this.userCountry,
      this.userCredit,
      this.userDatetime,
      this.endTime,
      this.userAdmin,
      this.userOtp,
      this.userActivate,
      this.session,
      this.fbId,
      this.uniName,
      this.uniFullname,
      this.uniSname});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    accesstypeId = json['accesstype_id'];
    uniId = json['uni_id'];
    facultyId = json['faculty_id'];
    majorId = json['major_id'];
    courseId = json['course_id'];
    userLoginname = json['user_loginname'];
    userPassword = json['user_password'];
    userName = json['user_name'];
    userLastname = json['user_lastname'];
    userEmail = json['user_email'];
    userMobileno = json['user_mobileno'];
    userHomeno = json['user_homeno'];
    userAddress = json['user_address'];
    userCity = json['user_city'];
    userState = json['user_state'];
    userPostcode = json['user_postcode'];
    userCountry = json['user_country'];
    userCredit = json['user_credit'];
    userDatetime = json['user_datetime'];
    endTime = json['end_time'];
    userAdmin = json['user_admin'];
    userOtp = json['user_otp'];
    userActivate = json['user_activate'];
    session = json['session'];
    fbId = json['fb_id'];
    uniName = json['uni_name'];
    uniFullname = json['uni_fullname'];
    uniSname = json['uni_sname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['accesstype_id'] = this.accesstypeId;
    data['uni_id'] = this.uniId;
    data['faculty_id'] = this.facultyId;
    data['major_id'] = this.majorId;
    data['course_id'] = this.courseId;
    data['user_loginname'] = this.userLoginname;
    data['user_password'] = this.userPassword;
    data['user_name'] = this.userName;
    data['user_lastname'] = this.userLastname;
    data['user_email'] = this.userEmail;
    data['user_mobileno'] = this.userMobileno;
    data['user_homeno'] = this.userHomeno;
    data['user_address'] = this.userAddress;
    data['user_city'] = this.userCity;
    data['user_state'] = this.userState;
    data['user_postcode'] = this.userPostcode;
    data['user_country'] = this.userCountry;
    data['user_credit'] = this.userCredit;
    data['user_datetime'] = this.userDatetime;
    data['end_time'] = this.endTime;
    data['user_admin'] = this.userAdmin;
    data['user_otp'] = this.userOtp;
    data['user_activate'] = this.userActivate;
    data['session'] = this.session;
    data['fb_id'] = this.fbId;
    data['uni_name'] = this.uniName;
    data['uni_fullname'] = this.uniFullname;
    data['uni_sname'] = this.uniSname;
    return data;
  }
}
