class LoginResponse {
  bool status;
  String message;
  Data data;

  LoginResponse({
    this.status,
    this.message,
    this.data});

  LoginResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}

class Data {
  String id;
  String username;
  String firstname;
  String lastname;
  String email;
  String contact;
  String password;
  String gender;
  String country;
  String state;
  String city;
  String address;
  dynamic profilePicture;
  String profileCompleted;
  String isActive;
  String isVerify;
  String isAdmin;
  String token;
  String passwordResetCode;
  String lastIp;
  String adminView;
  String referralcode;
  String updatedDate;
  String createdDate;

  Data({
    this.id,
    this.username,
    this.firstname,
    this.lastname,
    this.email,
    this.contact,
    this.password,
    this.gender,
    this.country,
    this.state,
    this.city,
    this.address,
    this.profilePicture,
    this.profileCompleted,
    this.isActive,
    this.isVerify,
    this.isAdmin,
    this.token,
    this.passwordResetCode,
    this.lastIp,
    this.adminView,
    this.referralcode,
    this.updatedDate,
    this.createdDate});

  Data.fromJson(dynamic json) {
    id = json["id"];
    username = json["username"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    email = json["email"];
    contact = json["contact"];
    password = json["password"];
    gender = json["gender"];
    country = json["country"];
    state = json["state"];
    city = json["city"];
    address = json["address"];
    profilePicture = json["profilePicture"];
    profileCompleted = json["profileCompleted"];
    isActive = json["isActive"];
    isVerify = json["isVerify"];
    isAdmin = json["isAdmin"];
    token = json["token"];
    passwordResetCode = json["passwordResetCode"];
    lastIp = json["lastIp"];
    adminView = json["adminView"];
    referralcode = json["referralcode"];
    updatedDate = json["updatedDate"];
    createdDate = json["createdDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["username"] = username;
    map["firstname"] = firstname;
    map["lastname"] = lastname;
    map["email"] = email;
    map["contact"] = contact;
    map["password"] = password;
    map["gender"] = gender;
    map["country"] = country;
    map["state"] = state;
    map["city"] = city;
    map["address"] = address;
    map["profilePicture"] = profilePicture;
    map["profileCompleted"] = profileCompleted;
    map["isActive"] = isActive;
    map["isVerify"] = isVerify;
    map["isAdmin"] = isAdmin;
    map["token"] = token;
    map["passwordResetCode"] = passwordResetCode;
    map["lastIp"] = lastIp;
    map["adminView"] = adminView;
    map["referralcode"] = referralcode;
    map["updatedDate"] = updatedDate;
    map["createdDate"] = createdDate;
    return map;
  }

}