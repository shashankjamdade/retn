class GooglePlacesRes {
  List<Predictions> predictions;
  String status;

  GooglePlacesRes({
      this.predictions, 
      this.status});

  GooglePlacesRes.fromJson(dynamic json) {
    if (json["predictions"] != null) {
      predictions = [];
      json["predictions"].forEach((v) {
        predictions.add(Predictions.fromJson(v));
      });
    }
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (predictions != null) {
      map["predictions"] = predictions.map((v) => v.toJson()).toList();
    }
    map["status"] = status;
    return map;
  }

}

class Predictions {
  String description;
  List<Matched_substrings> matched_substrings;
  String place_id;
  String reference;
  Structured_formatting structured_formatting;
  List<Terms> terms;
  List<String> types;

  Predictions({
      this.description, 
      this.matched_substrings, 
      this.place_id, 
      this.reference, 
      this.structured_formatting, 
      this.terms, 
      this.types});

  Predictions.fromJson(dynamic json) {
    description = json["description"];
    if (json["matched_substrings"] != null) {
      matched_substrings = [];
      json["matched_substrings"].forEach((v) {
        matched_substrings.add(Matched_substrings.fromJson(v));
      });
    }
    place_id = json["place_id"];
    reference = json["reference"];
    structured_formatting = json["structured_formatting"] != null ? Structured_formatting.fromJson(json["structured_formatting"]) : null;
    if (json["terms"] != null) {
      terms = [];
      json["terms"].forEach((v) {
        terms.add(Terms.fromJson(v));
      });
    }
    types = json["types"] != null ? json["types"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["description"] = description;
    if (matched_substrings != null) {
      map["matched_substrings"] = matched_substrings.map((v) => v.toJson()).toList();
    }
    map["place_id"] = place_id;
    map["reference"] = reference;
    if (structured_formatting != null) {
      map["structured_formatting"] = structured_formatting.toJson();
    }
    if (terms != null) {
      map["terms"] = terms.map((v) => v.toJson()).toList();
    }
    map["types"] = types;
    return map;
  }

}

class Terms {
  int offset;
  String value;

  Terms({
      this.offset, 
      this.value});

  Terms.fromJson(dynamic json) {
    offset = json["offset"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["offset"] = offset;
    map["value"] = value;
    return map;
  }

}

class Structured_formatting {
  String main_text;
  List<Main_text_matched_substrings> main_textmatched_substrings;
  String secondaryText;

  Structured_formatting({
      this.main_text, 
      this.main_textmatched_substrings, 
      this.secondaryText});

  Structured_formatting.fromJson(dynamic json) {
    main_text = json["main_text"];
    if (json["main_textmatched_substrings"] != null) {
      main_textmatched_substrings = [];
      json["main_textmatched_substrings"].forEach((v) {
        main_textmatched_substrings.add(Main_text_matched_substrings.fromJson(v));
      });
    }
    secondaryText = json["secondaryText"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["main_text"] = main_text;
    if (main_textmatched_substrings != null) {
      map["main_textmatched_substrings"] = main_textmatched_substrings.map((v) => v.toJson()).toList();
    }
    map["secondaryText"] = secondaryText;
    return map;
  }

}

class Main_text_matched_substrings {
  int length;
  int offset;

  Main_text_matched_substrings({
      this.length, 
      this.offset});

  Main_text_matched_substrings.fromJson(dynamic json) {
    length = json["length"];
    offset = json["offset"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["length"] = length;
    map["offset"] = offset;
    return map;
  }

}

class Matched_substrings {
  int length;
  int offset;

  Matched_substrings({
      this.length, 
      this.offset});

  Matched_substrings.fromJson(dynamic json) {
    length = json["length"];
    offset = json["offset"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["length"] = length;
    map["offset"] = offset;
    return map;
  }

}