class GetCustomFieldsResponse {
  bool status;
  String message;
  List<CustomFieldsData> data;

  GetCustomFieldsResponse({this.status, this.message, this.data});

  GetCustomFieldsResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(CustomFieldsData.fromJson(v));
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

class CustomFieldsData {
  String cat_id;
  String field;
  String id;
  String name;
  String slug;
  String type;
  String length;
  String default_value = "";
  String default_id = "";
  String required;
  String status;
  List<String> mSelectedValue;
  List<Type_value> type_value;

  CustomFieldsData(
      {this.cat_id,
      this.field,
      this.id,
      this.name,
      this.slug,
      this.type,
      this.length,
      this.default_value,
      this.required,
      this.status,
      this.type_value,
      this.mSelectedValue});

  CustomFieldsData.fromJson(dynamic json) {
    cat_id = json["cat_id"];
    field = json["field"];
    id = json["id"];
    name = json["name"];
    slug = json["slug"];
    type = json["type"];
    length = json["length"];
    default_value = json["default_value"];
    required = json["required"];
    status = json["status"];
    if (json["type_value"] != null) {
      type_value = [];
      json["type_value"].forEach((v) {
        type_value.add(Type_value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cat_id"] = cat_id;
    map["field"] = field;
    map["id"] = id;
    map["name"] = name;
    map["slug"] = slug;
    map["type"] = type;
    map["length"] = length;
    map["default_value"] = default_value;
    map["required"] = required;
    map["status"] = status;
    if (type_value != null) {
      map["type_value"] = type_value.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Type_value {
  String dropdown_id;
  String dropdown_value;
  String name;
  String value;
  String placeholder;
  bool checked = false;
  int is_selected = 0;

  Type_value(
      {this.dropdown_id,
      this.dropdown_value,
      this.name,
      this.value,
      this.placeholder,
      this.checked, this.is_selected});

  Type_value.fromJson(dynamic json) {
    dropdown_id = json["dropdown_id"];
    dropdown_value = json["dropdown_value"];
    name = json["name"];
    value = json["value"];
    placeholder = json["placeholder"];
    checked = json["checked"];
    is_selected = json["is_selected"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["dropdown_id"] = dropdown_id;
    map["dropdown_value"] = dropdown_value;
    map["name"] = name;
    map["value"] = value;
    map["placeholder"] = placeholder;
    map["checked"] = checked;
    map["is_selected"] = is_selected;
    return map;
  }
}
