class SearchSubCategoryResponse {
  String message;
  CategoryResData data;
  bool status;

  SearchSubCategoryResponse({
      this.message, 
      this.data, 
      this.status});

  SearchSubCategoryResponse.fromJson(dynamic json) {
    message = json["message"];
    data = json["data"] != null ? CategoryResData.fromJson(json["data"]) : null;
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

class CategoryResData {
  List<CategoryObj> category;
  List<CategoryObj> subcategory;

  CategoryResData({
      this.category, 
      this.subcategory});

  CategoryResData.fromJson(dynamic json) {
    if (json["category"] != null) {
      category = [];
      json["category"].forEach((v) {
        category.add(CategoryObj.fromJson(v));
      });
    }
    if (json["subcategory"] != null) {
      subcategory = [];
      json["subcategory"].forEach((v) {
        subcategory.add(CategoryObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (category != null) {
      map["category"] = category.map((v) => v.toJson()).toList();
    }
    if (subcategory != null) {
      map["subcategory"] = subcategory.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

//class Subcategory {
//  String id;
//  String name;
//
//  Subcategory({
//      this.id,
//      this.name});
//
//  Subcategory.fromJson(dynamic json) {
//    id = json["id"];
//    name = json["name"];
//  }
//
//  Map<String, dynamic> toJson() {
//    var map = <String, dynamic>{};
//    map["id"] = id;
//    map["name"] = name;
//    return map;
//  }
//
//}

class CategoryObj {
  String id;
  String name;

  CategoryObj({
      this.id, 
      this.name});

  CategoryObj.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }

}