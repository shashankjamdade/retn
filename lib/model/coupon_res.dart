class CouponRes {
  bool status;
  String message;
  List<CouponData> data;

  CouponRes({
      this.status, 
      this.message, 
      this.data});

  CouponRes.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(CouponData.fromJson(v));
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

class CouponData {
  String id;
  String title;
  String description;
  String image;
  String coupon_code;
  String city_id;
  String slug;
  String created_at;
  String updated_at;
  String cityname;
  String distance;

  CouponData({
      this.id, 
      this.title, 
      this.description, 
      this.image, 
      this.coupon_code, 
      this.city_id, 
      this.slug, 
      this.created_at, 
      this.updated_at, 
      this.cityname, 
      this.distance});

  CouponData.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    image = json["image"];
    coupon_code = json["coupon_code"];
    city_id = json["city_id"];
    slug = json["slug"];
    created_at = json["created_at"];
    updated_at = json["updated_at"];
    cityname = json["cityname"];
    distance = json["distance"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["description"] = description;
    map["image"] = image;
    map["coupon_code"] = coupon_code;
    map["city_id"] = city_id;
    map["slug"] = slug;
    map["created_at"] = created_at;
    map["updated_at"] = updated_at;
    map["cityname"] = cityname;
    map["distance"] = distance;
    return map;
  }

}