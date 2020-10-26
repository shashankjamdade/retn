import 'home_response.dart';

class NearbySubChildCategoryListResponse {
  String message;
  List<Category_adslist> data;
  bool status;

  NearbySubChildCategoryListResponse({
      this.message, 
      this.data, 
      this.status});

  NearbySubChildCategoryListResponse.fromJson(dynamic json) {
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Category_adslist.fromJson(v));
      });
    }
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = message;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    map["status"] = status;
    return map;
  }

}

