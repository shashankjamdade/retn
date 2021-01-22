import 'home_response.dart';

class GetMyFavouriteRes {
  bool status;
  String message;
  List<Category_adslist> data;

  GetMyFavouriteRes({
      this.status, 
      this.message, 
      this.data});

  GetMyFavouriteRes.fromJson(dynamic json) {
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

class GetFavouriteData {
  String id;
  String ad_id;
  String user_id;
  String created_date;
  String pid;
  String title;
  String slug;
  String img_1;
  String cat_id;
  String category_name;
  String subcat_id;
  String subcategory_name;

  GetFavouriteData({
      this.id, 
      this.ad_id, 
      this.user_id, 
      this.created_date, 
      this.pid, 
      this.title, 
      this.slug, 
      this.img_1, 
      this.cat_id, 
      this.category_name, 
      this.subcat_id, 
      this.subcategory_name});

  GetFavouriteData.fromJson(dynamic json) {
    id = json["id"];
    ad_id = json["ad_id"];
    user_id = json["user_id"];
    created_date = json["created_date"];
    pid = json["pid"];
    title = json["title"];
    slug = json["slug"];
    img_1 = json["img_1"];
    cat_id = json["cat_id"];
    category_name = json["category_name"];
    subcat_id = json["subcat_id"];
    subcategory_name = json["subcategory_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["ad_id"] = ad_id;
    map["user_id"] = user_id;
    map["created_date"] = created_date;
    map["pid"] = pid;
    map["title"] = title;
    map["slug"] = slug;
    map["img_1"] = img_1;
    map["cat_id"] = cat_id;
    map["category_name"] = category_name;
    map["subcat_id"] = subcat_id;
    map["subcategory_name"] = subcategory_name;
    return map;
  }

}