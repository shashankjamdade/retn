import 'package:flutter/material.dart';

class SearchLocationResponse {
  String message;
  List<SearchLocationData> data;
  bool status;

  SearchLocationResponse({
    this.message,
    this.data,
    this.status});

  SearchLocationResponse.fromJson(dynamic json) {
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(SearchLocationData.fromJson(v));
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

class SearchLocationData {
  String name;
  dynamic lat;
  dynamic lng;

  SearchLocationData({
    this.name,
    this.lat,
    this.lng});

  SearchLocationData.fromJson(dynamic json) {
    name = json["name"];
    lat = json["lat"];
    lng = json["lng"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["lat"] = lat;
    map["lng"] = lng;
    return map;
  }

}