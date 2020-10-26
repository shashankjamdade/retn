class SearchCategoryResponse {
  String message;
  List<CategorySearchData> data;
  bool status;

  SearchCategoryResponse({
    this.message,
    this.data,
    this.status});

  SearchCategoryResponse.fromJson(dynamic json) {
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(CategorySearchData.fromJson(v));
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

class CategorySearchData {
  String category_id;
  String subcategory_id;
  String name;

  CategorySearchData({
    this.category_id,
    this.subcategory_id,
    this.name});

  CategorySearchData.fromJson(dynamic json) {
    category_id = json["category_id"];
    subcategory_id = json["subcategory_id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["category_id"] = category_id;
    map["subcategory_id"] = subcategory_id;
    map["name"] = name;
    return map;
  }
}