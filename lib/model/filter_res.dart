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
  String fields_to_category;
  String category;
  String subcategory;
  String field;
  String name;
  String slug;
  bool isChecked = false;

  Customefield({
      this.fields_to_category, 
      this.category, 
      this.subcategory, 
      this.field, 
      this.name, 
      this.slug, this.isChecked});

  Customefield.fromJson(dynamic json) {
    fields_to_category = json["fields_to_category"];
    category = json["category"];
    subcategory = json["subcategory"];
    field = json["field"];
    name = json["name"];
    slug = json["slug"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["fields_to_category"] = fields_to_category;
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