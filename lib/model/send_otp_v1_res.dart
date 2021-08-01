class SendOtpV1Res {
  String msg;
  GeneralData data;
  String status;

  SendOtpV1Res({
      this.msg,
      this.data, 
      this.status});

  SendOtpV1Res.fromJson(dynamic json) {
    msg = json["msg"];
    data = json["data"] != null ? GeneralData.fromJson(json["data"]) : null;
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.toJson();
    }
    map["status"] = status;
    return map;
  }

}

class GeneralData {
  String contact;
  bool is_registered;

  GeneralData({
      this.contact,
      this.is_registered});

  GeneralData.fromJson(dynamic json) {
    contact = json["contact"];
    is_registered = json["is_registered"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["contact"] = contact;
    map["is_registered"] = is_registered;
    return map;
  }

}