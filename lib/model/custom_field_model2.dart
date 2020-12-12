class CustomFieldModel {
  String custome_field_name;
  List<String> custome_field_value;

  CustomFieldModel(
      this.custome_field_name,
      this.custome_field_value);

  CustomFieldModel.fromJson(dynamic json) {
    custome_field_name = json["custome_field_name"];
    custome_field_value = json["custome_field_value"] != null ? json["custome_field_value"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["custome_field_name"] = custome_field_name;
    map["custome_field_value"] = custome_field_value;
    return map;
  }

}