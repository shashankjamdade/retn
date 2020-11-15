class SaveFavouriteRes {
  String message;
  String data;
  bool status;

  SaveFavouriteRes({
      this.message, 
      this.data, 
      this.status});

  SaveFavouriteRes.fromJson(dynamic json) {
    message = json["message"];
    data = json["data"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = message;
    map["data"] = data;
    map["status"] = status;
    return map;
  }

}