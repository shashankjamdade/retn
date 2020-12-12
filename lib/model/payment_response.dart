class PaymentRes {
  String status;
  String msg;

  PaymentRes({
      this.status, 
      this.msg});

  PaymentRes.fromJson(dynamic json) {
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