import 'package:flutter/material.dart';

class SearchLocationResponse {
  String message;
  LocationData data;
  bool status;

//  SearchLocationResponse({
//      this.message, 
//      this.data, 
//      this.status});

  SearchLocationResponse.fromJson(dynamic json) {
    message = json["message"];
    data = json["data"] != null ? LocationData.fromJson(json["data"]) : null;
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = message;
    if (data != null) {
      map["data"] = data.toJson();
    }
    map["status"] = status;
    return map;
  }

}

class LocationData {
  List<StateLoc> state;
  List<Cities> cities;

  LocationData({
      this.state, 
      this.cities});

  LocationData.fromJson(dynamic json) {
    if (json["state"] != null) {
      state = [];
      json["state"].forEach((v) {
        state.add(StateLoc.fromJson(v));
      });
    }
    if (json["cities"] != null) {
      cities = [];
      json["cities"].forEach((v) {
        cities.add(Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (state != null) {
      map["state"] = state.map((v) => v.toJson()).toList();
    }
    if (cities != null) {
      map["cities"] = cities.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Cities {
  String id;
  String name;
  String stateId;
  dynamic lat;
  dynamic lng;
  String createdAt;

  Cities({
      this.id, 
      this.name, 
      this.stateId, 
      this.lat, 
      this.lng, 
      this.createdAt});

  Cities.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    stateId = json["stateId"];
    lat = json["lat"];
    lng = json["lng"];
    createdAt = json["createdAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["stateId"] = stateId;
    map["lat"] = lat;
    map["lng"] = lng;
    map["createdAt"] = createdAt;
    return map;
  }

}

class StateLoc {
  String id;
  String name;
  String countryId;
  dynamic lat;
  dynamic lng;
  String createdAt;

  StateLoc({
      this.id, 
      this.name, 
      this.countryId, 
      this.lat, 
      this.lng, 
      this.createdAt});

  StateLoc.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    countryId = json["countryId"];
    lat = json["lat"];
    lng = json["lng"];
    createdAt = json["createdAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["countryId"] = countryId;
    map["lat"] = lat;
    map["lng"] = lng;
    map["createdAt"] = createdAt;
    return map;
  }

}