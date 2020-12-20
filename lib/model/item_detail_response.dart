import 'home_response.dart';

class ItemDetailResponse {
  Ad ad;
  List<Others> others;
  List<Category_adslist> similar_ads;
  String title;

  ItemDetailResponse({
      this.ad,
      this.others,
      this.similar_ads,
      this.title});

  ItemDetailResponse.fromJson(dynamic json) {
    ad = json["ad"] != null ? Ad.fromJson(json["ad"]) : null;
    if (json["others"] != null) {
      others = [];
      json["others"].forEach((v) {
        others.add(Others.fromJson(v));
      });
    }
    if (json["similar_ads"] != null) {
      similar_ads = [];
      json["similar_ads"].forEach((v) {
        similar_ads.add(Category_adslist.fromJson(v));
      });
    }
    title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (ad != null) {
      map["ad"] = ad.toJson();
    }
    if (others != null) {
      map["others"] = others.map((v) => v.toJson()).toList();
    }
    if (similar_ads != null) {
      map["similar_ads"] = similar_ads.map((v) => v.toJson()).toList();
    }
    map["title"] = title;
    return map;
  }

}

//class Similar_ads {
//  String id;
//  String title;
//  String slug;
//  String category;
//  String subcategory;
//  String description;
//  String price;
//  String negotiable;
//  String city;
//  String country;
//  String state;
//  String location;
//  String lang;
//  String lat;
//  String postalcode;
//  String tags;
//  String img_1;
//  String img_2;
//  String img_3;
//  String seller;
//  String package;
//  String adminView;
//  String isFeatured;
//  String isStatus;
//  dynamic deleteRequest;
//  String updatedDate;
//  String createdDate;
//  String expiryDate;
//  String catId;
//  String categoryName;
//  String subcatId;
//  String subcategoryName;
//  String seller_id;
//  String firstname;
//  String lastname;
//  String contact;
//  String email;
//  String since;
//
//  Similar_ads({
//      this.id,
//      this.title,
//      this.slug,
//      this.category,
//      this.subcategory,
//      this.description,
//      this.price,
//      this.negotiable,
//      this.city,
//      this.country,
//      this.state,
//      this.location,
//      this.lang,
//      this.lat,
//      this.postalcode,
//      this.tags,
//      this.img_1,
//      this.img_2,
//      this.img_3,
//      this.seller,
//      this.package,
//      this.adminView,
//      this.isFeatured,
//      this.isStatus,
//      this.deleteRequest,
//      this.updatedDate,
//      this.createdDate,
//      this.expiryDate,
//      this.catId,
//      this.categoryName,
//      this.subcatId,
//      this.subcategoryName,
//      this.seller_id,
//      this.firstname,
//      this.lastname,
//      this.contact,
//      this.email,
//      this.since});
//
//  Similar_ads.fromJson(dynamic json) {
//    id = json["id"];
//    title = json["title"];
//    slug = json["slug"];
//    category = json["category"];
//    subcategory = json["subcategory"];
//    description = json["description"];
//    price = json["price"];
//    negotiable = json["negotiable"];
//    city = json["city"];
//    country = json["country"];
//    state = json["state"];
//    location = json["location"];
//    lang = json["lang"];
//    lat = json["lat"];
//    postalcode = json["postalcode"];
//    tags = json["tags"];
//    img_1 = json["img_1"];
//    img_2 = json["img_2"];
//    img_3 = json["img_3"];
//    seller = json["seller"];
//    package = json["package"];
//    adminView = json["adminView"];
//    isFeatured = json["isFeatured"];
//    isStatus = json["isStatus"];
//    deleteRequest = json["deleteRequest"];
//    updatedDate = json["updatedDate"];
//    createdDate = json["createdDate"];
//    expiryDate = json["expiryDate"];
//    catId = json["catId"];
//    categoryName = json["categoryName"];
//    subcatId = json["subcatId"];
//    subcategoryName = json["subcategoryName"];
//    seller_id = json["seller_id"];
//    firstname = json["firstname"];
//    lastname = json["lastname"];
//    contact = json["contact"];
//    email = json["email"];
//    since = json["since"];
//  }
//
//  Map<String, dynamic> toJson() {
//    var map = <String, dynamic>{};
//    map["id"] = id;
//    map["title"] = title;
//    map["slug"] = slug;
//    map["category"] = category;
//    map["subcategory"] = subcategory;
//    map["description"] = description;
//    map["price"] = price;
//    map["negotiable"] = negotiable;
//    map["city"] = city;
//    map["country"] = country;
//    map["state"] = state;
//    map["location"] = location;
//    map["lang"] = lang;
//    map["lat"] = lat;
//    map["postalcode"] = postalcode;
//    map["tags"] = tags;
//    map["img_1"] = img_1;
//    map["img_2"] = img_2;
//    map["img_3"] = img_3;
//    map["seller"] = seller;
//    map["package"] = package;
//    map["adminView"] = adminView;
//    map["isFeatured"] = isFeatured;
//    map["isStatus"] = isStatus;
//    map["deleteRequest"] = deleteRequest;
//    map["updatedDate"] = updatedDate;
//    map["createdDate"] = createdDate;
//    map["expiryDate"] = expiryDate;
//    map["catId"] = catId;
//    map["categoryName"] = categoryName;
//    map["subcatId"] = subcatId;
//    map["subcategoryName"] = subcategoryName;
//    map["seller_id"] = seller_id;
//    map["firstname"] = firstname;
//    map["lastname"] = lastname;
//    map["contact"] = contact;
//    map["email"] = email;
//    map["since"] = since;
//    return map;
//  }
//
//}

class Others {
  String id;
  String slug;
  String adId;
  String fieldId;
  String fieldValue;
  String fid;
  String fname;

  Others({
      this.id, 
      this.slug, 
      this.adId, 
      this.fieldId, 
      this.fieldValue, 
      this.fid, 
      this.fname});

  Others.fromJson(dynamic json) {
    id = json["id"];
    slug = json["slug"];
    adId = json["adId"];
    fieldId = json["fieldId"];
    fieldValue = json["fieldValue"];
    fid = json["fid"];
    fname = json["fname"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["slug"] = slug;
    map["adId"] = adId;
    map["fieldId"] = fieldId;
    map["fieldValue"] = fieldValue;
    map["fid"] = fid;
    map["fname"] = fname;
    return map;
  }

}

class Ad {
  String id;
  String title;
  String slug;
  String category;
  String subcategory;
  String description;
  String price;
  String negotiable;
  String city;
  String country;
  String state;
  String location;
  String lang;
  String lat;
  String postalcode;
  String tags;
  String img_1;
  String img_2;
  String img_3;
  String seller;
  String package;
  String adminView;
  String isFeatured;
  String isStatus;
  dynamic deleteRequest;
  String updatedDate;
  String createdDate;
  String expiryDate;
  String catId;
  String categoryName;
  String subcatId;
  String subcategoryName;
  String seller_id;
  String firstname;
  String lastname;
  String contact;
  String email;
  String since;

  Ad({
      this.id, 
      this.title, 
      this.slug, 
      this.category, 
      this.subcategory, 
      this.description, 
      this.price, 
      this.negotiable, 
      this.city, 
      this.country, 
      this.state, 
      this.location, 
      this.lang, 
      this.lat, 
      this.postalcode, 
      this.tags, 
      this.img_1, 
      this.img_2, 
      this.img_3, 
      this.seller, 
      this.package, 
      this.adminView, 
      this.isFeatured, 
      this.isStatus, 
      this.deleteRequest, 
      this.updatedDate, 
      this.createdDate, 
      this.expiryDate, 
      this.catId, 
      this.categoryName, 
      this.subcatId, 
      this.subcategoryName, 
      this.seller_id, 
      this.firstname, 
      this.lastname, 
      this.contact, 
      this.email, 
      this.since});

  Ad.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    slug = json["slug"];
    category = json["category"];
    subcategory = json["subcategory"];
    description = json["description"];
    price = json["price"];
    negotiable = json["negotiable"];
    city = json["city"];
    country = json["country"];
    state = json["state"];
    location = json["location"];
    lang = json["lang"];
    lat = json["lat"];
    postalcode = json["postalcode"];
    tags = json["tags"];
    img_1 = json["img_1"];
    img_2 = json["img_2"];
    img_3 = json["img_3"];
    seller = json["seller"];
    package = json["package"];
    adminView = json["adminView"];
    isFeatured = json["isFeatured"];
    isStatus = json["isStatus"];
    deleteRequest = json["deleteRequest"];
    updatedDate = json["updatedDate"];
    createdDate = json["createdDate"];
    expiryDate = json["expiryDate"];
    catId = json["catId"];
    categoryName = json["categoryName"];
    subcatId = json["subcatId"];
    subcategoryName = json["subcategoryName"];
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
    map["negotiable"] = negotiable;
    map["city"] = city;
    map["country"] = country;
    map["state"] = state;
    map["location"] = location;
    map["lang"] = lang;
    map["lat"] = lat;
    map["postalcode"] = postalcode;
    map["tags"] = tags;
    map["img_1"] = img_1;
    map["img_2"] = img_2;
    map["img_3"] = img_3;
    map["seller"] = seller;
    map["package"] = package;
    map["adminView"] = adminView;
    map["isFeatured"] = isFeatured;
    map["isStatus"] = isStatus;
    map["deleteRequest"] = deleteRequest;
    map["updatedDate"] = updatedDate;
    map["createdDate"] = createdDate;
    map["expiryDate"] = expiryDate;
    map["catId"] = catId;
    map["categoryName"] = categoryName;
    map["subcatId"] = subcatId;
    map["subcategoryName"] = subcategoryName;
    map["seller_id"] = seller_id;
    map["firstname"] = firstname;
    map["lastname"] = lastname;
    map["contact"] = contact;
    map["email"] = email;
    map["since"] = since;
    return map;
  }

}