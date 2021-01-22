class UserProfileResponse {
  bool status;
  String message;
  UserProfileData data;

  UserProfileResponse({
      this.status, 
      this.message, 
      this.data});

  UserProfileResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] != null ? UserProfileData.fromJson(json["data"]) : null;
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

class UserProfileData {
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
  String profile_picture;
  String profile_completed;
  String is_active;
  String is_verify;
  String is_admin;
  String token;
  String password_reset_code;
  String last_ip;
  String admin_view;
  String referralcode;
  String updatedDate;
  String created_date;

  UserProfileData({
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
      this.profile_picture, 
      this.profile_completed, 
      this.is_active, 
      this.is_verify, 
      this.is_admin, 
      this.token, 
      this.password_reset_code, 
      this.last_ip, 
      this.admin_view, 
      this.referralcode, 
      this.updatedDate, 
      this.created_date});

  UserProfileData.fromJson(dynamic json) {
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
    profile_picture = json["profile_picture"];
    profile_completed = json["profile_completed"];
    is_active = json["is_active"];
    is_verify = json["is_verify"];
    is_admin = json["is_admin"];
    token = json["token"];
    password_reset_code = json["password_reset_code"];
    last_ip = json["last_ip"];
    admin_view = json["admin_view"];
    referralcode = json["referralcode"];
    updatedDate = json["updatedDate"];
    created_date = json["created_date"];
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
    map["profile_picture"] = profile_picture;
    map["profile_completed"] = profile_completed;
    map["is_active"] = is_active;
    map["is_verify"] = is_verify;
    map["is_admin"] = is_admin;
    map["token"] = token;
    map["password_reset_code"] = password_reset_code;
    map["last_ip"] = last_ip;
    map["admin_view"] = admin_view;
    map["referralcode"] = referralcode;
    map["updatedDate"] = updatedDate;
    map["created_date"] = created_date;
    return map;
  }

}