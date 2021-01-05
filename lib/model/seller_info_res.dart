import 'home_response.dart';

class SellerInfoRes {
  String message;
  SellerData data;
  bool status;

  SellerInfoRes({
      this.message, 
      this.data, 
      this.status});

  SellerInfoRes.fromJson(dynamic json) {
    message = json["message"];
    data = json["data"] != null ? SellerData.fromJson(json["data"]) : null;
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

class SellerData {
  Seller_info seller_info;
  List<Category_adslist> seller_product;
  Seller_rating seller_rating;

  SellerData({
      this.seller_info, 
      this.seller_product,
    this.seller_rating});

  SellerData.fromJson(dynamic json) {
    seller_info = json["seller_info"] != null ? Seller_info.fromJson(json["seller_info"]) : null;
    seller_rating = json["seller_rating"] != null ? Seller_rating.fromJson(json["seller_rating"]) : null;
    if (json["seller_product"] != null) {
      seller_product = [];
      json["seller_product"].forEach((v) {
        seller_product.add(Category_adslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (seller_info != null) {
      map["seller_info"] = seller_info.toJson();
    }
     if (seller_rating != null) {
      map["seller_rating"] = seller_rating.toJson();
    }
    if (seller_product != null) {
      map["seller_product"] = seller_product.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Seller_info {
  String id;
  String username;
  String email;
  String contact;
  String gender;
  String address;
  String profile_picture;
  String since;

  Seller_info({
      this.id, 
      this.username, 
      this.email, 
      this.contact, 
      this.gender, 
      this.address, 
      this.profile_picture, 
      this.since});

  Seller_info.fromJson(dynamic json) {
    id = json["id"];
    username = json["username"];
    email = json["email"];
    contact = json["contact"];
    gender = json["gender"];
    address = json["address"];
    profile_picture = json["profile_picture"];
    since = json["since"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["username"] = username;
    map["email"] = email;
    map["contact"] = contact;
    map["gender"] = gender;
    map["address"] = address;
    map["profile_picture"] = profile_picture;
    map["since"] = since;
    return map;
  }

}


class Seller_rating {
  int star_1;
  int star_2;
  int star_3;
  int star_4;
  int star_5;

  Seller_rating({
    this.star_1,
    this.star_2,
    this.star_3,
    this.star_4,
    this.star_5});

  Seller_rating.fromJson(dynamic json) {
    star_1 = json["star_1"];
    star_2 = json["star_2"];
    star_3 = json["star_3"];
    star_4 = json["star_4"];
    star_5 = json["star_5"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["star_1"] = star_1;
    map["star_2"] = star_2;
    map["star_3"] = star_3;
    map["star_4"] = star_4;
    map["star_5"] = star_5;
    return map;
  }

}