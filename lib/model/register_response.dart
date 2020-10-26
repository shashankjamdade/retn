class RegisterResponse {
  bool status;
  String message;

  RegisterResponse({
    this.status,
    this.message});

  RegisterResponse.fromJson(dynamic json) {
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