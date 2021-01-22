import 'package:flutter_rentry_new/model/home_response.dart';

class MyAdsListRes {
  bool status;
  String message;
  List<Category_adslist> data;

  MyAdsListRes({
      this.status, 
      this.message, 
      this.data});

  MyAdsListRes.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Category_adslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
