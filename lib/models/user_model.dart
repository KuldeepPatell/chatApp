class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? mobileNumber;
  String? profilepic;

  UserModel(
      {this.uid,
      this.fullname,
      this.email,
      this.mobileNumber,
      this.profilepic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    mobileNumber = map["mobileNumber"];
    profilepic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "mobileNumber": mobileNumber,
      "profilepic": profilepic
    };
  }
}
