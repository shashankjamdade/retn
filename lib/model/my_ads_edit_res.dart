import 'package:flutter_rentry_new/model/get_category_response.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';

import 'get_custom_fields_response.dart';

class MyAdsEditRes {
  bool status;
  String message;
  EditPostData data;

  MyAdsEditRes({
      this.status, 
      this.message, 
      this.data});

  MyAdsEditRes.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] != null ? EditPostData.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}

class EditPostData {
  Post post;
//  dynamic other_detail;
  List<CategoryData> category;
  List<SubCategoryData> subcategory;
  List<CustomFieldsData> customefield;

  EditPostData({
      this.post, 
//      this.other_detail,
      this.category, 
      this.subcategory, 
      this.customefield});

  EditPostData.fromJson(dynamic json) {
    post = json["post"] != null ? Post.fromJson(json["post"]) : null;
//    other_detail = json["other_detail"];
    if (json["category"] != null) {
      category = [];
      json["category"].forEach((v) {
        category.add(CategoryData.fromJson(v));
      });
    }
    if (json["subcategory"] != null) {
      subcategory = [];
      json["subcategory"].forEach((v) {
        subcategory.add(SubCategoryData.fromJson(v));
      });
    }
    if (json["customefield"] != null) {
      customefield = [];
      json["customefield"].forEach((v) {
        customefield.add(CustomFieldsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (post != null) {
      map["post"] = post.toJson();
    }
//    map["other_detail"] = other_detail;
    if (category != null) {
      map["category"] = category.map((v) => v.toJson()).toList();
    }
    if (subcategory != null) {
      map["subcategory"] = subcategory.map((v) => v.toJson()).toList();
    }
    if (customefield != null) {
      map["customefield"] = customefield.map((v) => v.toJson()).toList();
    }
    return map;
  }

}




class Post {
  String id;
  String title;
  String slug;
  String category;
  String subcategory;
  String description;
  String price;
  String location;
  String lang;
  String lat;
  String tags;
  String img_1;
  String img_2;
  String img_3;
  String seller;
  String rent_type_id;
  String package;
  String admin_view;
  String is_featured;
  String is_status;
//  dynamic delete_request;
  String updatedDate;
  String createdDate;
  String expiryDate;
  String cat_id;
  String category_name;
  String subcat_id;
  String subcategory_name;
  String seller_id;
  String firstname;
  String lastname;
  String contact;
  String email;
  String since;

  Post({
      this.id, 
      this.title, 
      this.slug, 
      this.category, 
      this.subcategory, 
      this.description, 
      this.price, 
      this.location, 
      this.lang, 
      this.lat, 
      this.tags, 
      this.img_1, 
      this.img_2, 
      this.img_3, 
      this.seller, 
      this.rent_type_id, 
      this.package, 
      this.admin_view, 
      this.is_featured, 
      this.is_status, 
//      this.delete_request,
      this.updatedDate, 
      this.createdDate, 
      this.expiryDate, 
      this.cat_id, 
      this.category_name, 
      this.subcat_id, 
      this.subcategory_name, 
      this.seller_id, 
      this.firstname, 
      this.lastname, 
      this.contact, 
      this.email, 
      this.since});

  Post.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    slug = json["slug"];
    category = json["category"];
    subcategory = json["subcategory"];
    description = json["description"];
    price = json["price"];
    location = json["location"];
    lang = json["lang"];
    lat = json["lat"];
    tags = json["tags"];
    img_1 = json["img_1"];
    img_2 = json["img_2"];
    img_3 = json["img_3"];
    seller = json["seller"];
    rent_type_id = json["rent_type_id"];
    package = json["package"];
    admin_view = json["admin_view"];
    is_featured = json["is_featured"];
    is_status = json["is_status"];
//    delete_request = json["delete_request"];
    updatedDate = json["updatedDate"];
    createdDate = json["createdDate"];
    expiryDate = json["expiryDate"];
    cat_id = json["cat_id"];
    category_name = json["category_name"];
    subcat_id = json["subcat_id"];
    subcategory_name = json["subcategory_name"];
    seller_id = json["seller_id"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    contact = json["contact"];
    email = json["email"];
    since = json["since"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["slug"] = slug;
    map["category"] = category;
    map["subcategory"] = subcategory;
    map["description"] = description;
    map["price"] = price;
    map["location"] = location;
    map["lang"] = lang;
    map["lat"] = lat;
    map["tags"] = tags;
    map["img_1"] = img_1;
    map["img_2"] = img_2;
    map["img_3"] = img_3;
    map["seller"] = seller;
    map["rent_type_id"] = rent_type_id;
    map["package"] = package;
    map["admin_view"] = admin_view;
    map["is_featured"] = is_featured;
    map["is_status"] = is_status;
//    map["delete_request"] = delete_request;
    map["updatedDate"] = updatedDate;
    map["createdDate"] = createdDate;
    map["expiryDate"] = expiryDate;
    map["cat_id"] = cat_id;
    map["category_name"] = category_name;
    map["subcat_id"] = subcat_id;
    map["subcategory_name"] = subcategory_name;
    map["seller_id"] = seller_id;
    map["firstname"] = firstname;
    map["lastname"] = lastname;
    map["contact"] = contact;
    map["email"] = email;
    map["since"] = since;
    return map;
  }

}