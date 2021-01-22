class RegisterResponse2 {
  bool status;
  String message;

  RegisterResponse2({
      this.status, 
      this.message});

  RegisterResponse2.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    return map;
  }

}