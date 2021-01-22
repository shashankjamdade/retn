import 'package:flutter_rentry_new/model/filter_res.dart';

import 'home_response.dart';

class NearbySubChildCategoryListResponse {
  String message;
  NearbyData data;
  bool status;

  NearbySubChildCategoryListResponse({
    this.message,
    this.data,
    this.status});

  NearbySubChildCategoryListResponse.fromJson(dynamic json) {
    message = json["message"];
    data = json["data"] != null ? NearbyData.fromJson(json["data"]) : null;
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = message;
    if (data != null) {
      map["data"] = data.toJson();
    }
    map["status"] = status;
    return map;
  }

}



class NearbyData {
  FilterRes filter;
  List<Category_adslist> ad_list;

  NearbyData({
    this.filter,
    this.ad_list});

  NearbyData.fromJson(dynamic json) {
    filter = json["filter"] != null ? FilterRes.fromJson(json["filter"]) : null;
    if (json["ad_list"] != null) {
      ad_list = [];
      json["ad_list"].forEach((v) {
        ad_list.add(Category_adslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (filter != null) {
      map["filter"] = filter.toJson();
    }
    if (ad_list != null) {
      map["ad_list"] = ad_list.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
