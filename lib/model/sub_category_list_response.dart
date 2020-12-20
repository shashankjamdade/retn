class SubCategoryListResponse {
  String message;
  List<SubCategoryData> data;
  bool status;

  SubCategoryListResponse({
      this.message, 
      this.data, 
      this.status});

  SubCategoryListResponse.fromJson(dynamic json) {
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(SubCategoryData.fromJson(v));
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

class SubCategoryData {
  String id;
  String name;
  String picture;
  dynamic is_selected;

  SubCategoryData({
      this.id, 
      this.name, this.picture, this.is_selected});

  SubCategoryData.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    picture = json["picture"];
    is_selected = json["isSelected"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["picture"] = picture;
    map["is_selected"] = is_selected;
    return map;
  }

}