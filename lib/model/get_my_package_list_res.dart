class GetMyPackageListRes {
  bool status;
  String message;
  List<GetMyPackageData> data;

  GetMyPackageListRes({
      this.status, 
      this.message, 
      this.data});

  GetMyPackageListRes.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(GetMyPackageData.fromJson(v));
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

class GetMyPackageData {
  String title;
  String package_start_date;
  String package_expiry_date;
  String no_of_posts;
  String used;
  String due;
  String amount;
  String created_at;
  dynamic updatedAt;

  GetMyPackageData({
      this.title,
      this.package_start_date,
      this.package_expiry_date,
      this.no_of_posts, 
      this.used, 
      this.due, 
      this.amount, 
      this.created_at, 
      this.updatedAt});

  GetMyPackageData.fromJson(dynamic json) {
    title = json["title"];
    package_start_date = json["package_start_date"];
    package_expiry_date = json["package_expiry_date"];
    no_of_posts = json["no_of_posts"];
    used = json["used"];
    due = json["due"];
    amount = json["amount"];
    created_at = json["created_at"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["package_start_date"] = package_start_date;
    map["package_expiry_date"] = package_expiry_date;
    map["no_of_posts"] = no_of_posts;
    map["used"] = used;
    map["due"] = due;
    map["amount"] = amount;
    map["created_at"] = created_at;
    map["updatedAt"] = updatedAt;
    return map;
  }

}