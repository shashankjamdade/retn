class GetAllrent_typeResponse {
  String message;
  List<RentTypeData> data;
  bool status;

  GetAllrent_typeResponse({
      this.message, 
      this.data, 
      this.status});

  GetAllrent_typeResponse.fromJson(dynamic json) {
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(RentTypeData.fromJson(v));
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

class RentTypeData {
  String ads_rent_type_id;
  String rent_type;
  String created_at;

  RentTypeData({
      this.ads_rent_type_id, 
      this.rent_type, 
      this.created_at});

  RentTypeData.fromJson(dynamic json) {
    ads_rent_type_id = json["ads_rent_type_id"];
    rent_type = json["rent_type"];
    created_at = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ads_rent_type_id"] = ads_rent_type_id;
    map["rent_type"] = rent_type;
    map["created_at"] = created_at;
    return map;
  }

}