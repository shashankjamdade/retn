class CommonResponse {
  String status;
  String msg;

  CommonResponse({
      this.status, 
      this.msg});

  CommonResponse.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    return map;
  }

}