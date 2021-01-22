class AdDeleteRes {
  bool status;
  String message;
  String data;

  AdDeleteRes({
      this.status, 
      this.message, 
      this.data});

  AdDeleteRes.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    data = json["data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    map["data"] = data;
    return map;
  }

}