class FilterRes {
  List<Subcategory> subcategory;
  List<Customefield> customefield;
  Budget budget;

  FilterRes({
      this.subcategory, 
      this.customefield, 
      this.budget});

  FilterRes.fromJson(dynamic json) {
    if (json["subcategory"] != null) {
      subcategory = [];
      json["subcategory"].forEach((v) {
        subcategory.add(Subcategory.fromJson(v));
      });
    }
    if (json["customefield"] != null) {
      customefield = [];
      json["customefield"].forEach((v) {
        customefield.add(Customefield.fromJson(v));
      });
    }
    budget = json["budget"] != null ? Budget.fromJson(json["budget"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (subcategory != null) {
      map["subcategory"] = subcategory.map((v) => v.toJson()).toList();
    }
    if (customefield != null) {
      map["customefield"] = customefield.map((v) => v.toJson()).toList();
    }
    if (budget != null) {
      map["budget"] = budget.toJson();
    }
    return map;
  }

}

class Budget {
  String max;
  String min;

  Budget({
      this.max, 
      this.min});

  Budget.fromJson(dynamic json) {
    max = json["max"];
    min = json["min"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["max"] = max;
    map["min"] = min;
    return map;
  }

}

class Customefield {
  List<FieldOptions> field_options;
  String category;
  String subcategory;
  String field;
  String name;
  String slug;
  bool isChecked = false;

  Customefield({
      this.field_options,
      this.category, 
      this.subcategory, 
      this.field, 
      this.name, 
      this.slug, this.isChecked});

  Customefield.fromJson(dynamic json) {
    if (json["field_options"] != null) {
      field_options = [];
      json["field_options"].forEach((v) {
        field_options.add(FieldOptions.fromJson(v));
      });
    }
    category = json["category"];
    subcategory = json["subcategory"];
    field = json["field"];
    name = json["name"];
    slug = json["slug"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (field_options != null) {
      map["field_options"] = field_options.map((v) => v.toJson()).toList();
    }
//    map["field_options"] = field_options;
    map["category"] = category;
    map["subcategory"] = subcategory;
    map["field"] = field;
    map["name"] = name;
    map["slug"] = slug;
    return map;
  }

}

class Subcategory {
  String sub_id;
  String sub_name;
  String sub_slug;
  bool isChecked = false;

  Subcategory({
      this.sub_id, 
      this.sub_name, 
      this.sub_slug, this.isChecked});

  Subcategory.fromJson(dynamic json) {
    sub_id = json["sub_id"];
    sub_name = json["sub_name"];
    sub_slug = json["sub_slug"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["sub_id"] = sub_id;
    map["sub_name"] = sub_name;
    map["sub_slug"] = sub_slug;
    return map;
  }

}

class FieldOptions {
  String id;
  String parent_field;
  String name;
  bool isChecked = false;

  FieldOptions({
      this.id,
      this.parent_field,
      this.name, this.isChecked});

  FieldOptions.fromJson(dynamic json) {
    id = json["id"];
    parent_field = json["parent_field"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["parent_field"] = parent_field;
    map["name"] = name;
    return map;
  }

}