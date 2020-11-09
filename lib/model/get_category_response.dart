class GetCategoryResponse {
  bool status;
  String message;
  List<CategoryData> data;

  GetCategoryResponse({
      this.status, 
      this.message, 
      this.data});

  GetCategoryResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(CategoryData.fromJson(v));
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

class CategoryData {
  String id;
  String name;
  String slug;
  String description;
  String picture;
  String status;
  String topCategory;
  String showOnHome;
  String createdAt;

  CategoryData({
      this.id,
      this.name,
      this.slug,
      this.description,
      this.picture,
      this.status,
      this.topCategory,
      this.showOnHome,
      this.createdAt});

  CategoryData.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    slug = json["slug"];
    description = json["description"];
    picture = json["picture"];
    status = json["status"];
    topCategory = json["topCategory"];
    showOnHome = json["showOnHome"];
    createdAt = json["createdAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["slug"] = slug;
    map["description"] = description;
    map["picture"] = picture;
    map["status"] = status;
    map["topCategory"] = topCategory;
    map["showOnHome"] = showOnHome;
    map["createdAt"] = createdAt;
    return map;
  }

}