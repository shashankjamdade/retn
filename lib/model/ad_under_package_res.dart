class AdUnderPackageRes {
  bool status;
  String message;
  List<AdUnderPackageData> data;

  AdUnderPackageRes({
      this.status, 
      this.message, 
      this.data});

  AdUnderPackageRes.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(AdUnderPackageData.fromJson(v));
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

class AdUnderPackageData {
  String package_name;
  String package_price;
  String package_details;
  String package_id;
  String no_of_posts;
  dynamic no_of_days;
  String user_package_id;
  String package_expiry_date;
  String used;
  String due;
  String purchase_button;

  AdUnderPackageData({
      this.package_name, 
      this.package_price, 
      this.package_details, 
      this.package_id, 
      this.no_of_posts, 
      this.no_of_days,
      this.user_package_id, 
      this.package_expiry_date, 
      this.used, 
      this.due, 
      this.purchase_button});

  AdUnderPackageData.fromJson(dynamic json) {
    package_name = json["package_name"];
    package_price = json["package_price"];
    package_details = json["package_details"];
    package_id = json["package_id"];
    no_of_posts = json["no_of_posts"];
    no_of_days = json["no_of_days"];
    user_package_id = json["user_package_id"];
    package_expiry_date = json["package_expiry_date"];
    used = json["used"];
    due = json["due"];
    purchase_button = json["purchase_button"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["package_name"] = package_name;
    map["package_price"] = package_price;
    map["package_details"] = package_details;
    map["package_id"] = package_id;
    map["no_of_posts"] = no_of_posts;
    map["no_of_days"] = no_of_days;
    map["user_package_id"] = user_package_id;
    map["package_expiry_date"] = package_expiry_date;
    map["used"] = used;
    map["due"] = due;
    map["purchase_button"] = purchase_button;
    return map;
  }

}