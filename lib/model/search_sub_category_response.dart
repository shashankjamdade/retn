class SearchSubCategoryResponse {
  String message;
  Data data;
  bool status;

  SearchSubCategoryResponse({
      this.message, 
      this.data, 
      this.status});

  SearchSubCategoryResponse.fromJson(dynamic json) {
    message = json["message"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
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

class Data {
  List<Category> category;
  List<Subcategory> subcategory;

  Data({
      this.category, 
      this.subcategory});

  Data.fromJson(dynamic json) {
    if (json["category"] != null) {
      category = [];
      json["category"].forEach((v) {
        category.add(Category.fromJson(v));
      });
    }
    if (json["subcategory"] != null) {
      subcategory = [];
      json["subcategory"].forEach((v) {
        subcategory.add(Subcategory.fromJson(v));
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

class Subcategory {
  String id;
  String name;

  Subcategory({
      this.id, 
      this.name});

  Subcategory.fromJson(dynamic json) {
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

class Category {
  String id;
  String name;

  Category({
      this.id, 
      this.name});

  Category.fromJson(dynamic json) {
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