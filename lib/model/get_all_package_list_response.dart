class GetAllPackageListResponse {
  String message;
  List<GetAllPackageData> data;
  bool status;

  GetAllPackageListResponse({
      this.message, 
      this.data, 
      this.status});

  GetAllPackageListResponse.fromJson(dynamic json) {
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(GetAllPackageData.fromJson(v));
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

class GetAllPackageData {
  String id;
  String title;
  String slug;
  String price;
  String detail;
  String no_of_posts;
  String no_of_days;
  String picture;
  String is_active;
  String sort_order;
  String created_date;
  String updated_date;

  GetAllPackageData({
      this.id, 
      this.title, 
      this.slug, 
      this.price, 
      this.detail, 
      this.no_of_posts, 
      this.no_of_days, 
      this.picture, 
      this.is_active, 
      this.sort_order, 
      this.created_date, 
      this.updated_date});

  GetAllPackageData.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    slug = json["slug"];
    price = json["price"];
    detail = json["detail"];
    no_of_posts = json["no_of_posts"];
    no_of_days = json["no_of_days"];
    picture = json["picture"];
    is_active = json["is_active"];
    sort_order = json["sort_order"];
    created_date = json["created_date"];
    updated_date = json["updated_date"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["slug"] = slug;
    map["price"] = price;
    map["detail"] = detail;
    map["no_of_posts"] = no_of_posts;
    map["no_of_days"] = no_of_days;
    map["picture"] = picture;
    map["is_active"] = is_active;
    map["sort_order"] = sort_order;
    map["created_date"] = created_date;
    map["updated_date"] = updated_date;
    return map;
  }

}