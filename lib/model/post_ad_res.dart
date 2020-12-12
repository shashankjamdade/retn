class PostAdRes {
  String status;
  String msg;

  PostAdRes({
      this.status, 
      this.msg});

  PostAdRes.fromJson(dynamic json) {
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