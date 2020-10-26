import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialEvent extends HomeEvent{}
class ProgressEvent extends HomeEvent{}
class NonProgressEvent extends HomeEvent{}

class HomeReqAuthenticationEvent extends HomeEvent{
  final String token;
  HomeReqAuthenticationEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}

class ItemDetailReqEvent extends HomeEvent{
  final String token;
  final String categoryName;
  ItemDetailReqEvent(
      {@required this.token, @required this.categoryName});

  @override
  List<Object> get props => [token, categoryName];
}

class LocationSeachReqEvent extends HomeEvent{
  final String token;
  final String seachKey;
  LocationSeachReqEvent(
      {@required this.token, @required this.seachKey});

  @override
  List<Object> get props => [token, seachKey];
}

class SubCategorySearchReqEvent extends HomeEvent{
  final String token;
  final String seachKey;
  SubCategorySearchReqEvent(
      {@required this.token, @required this.seachKey});

  @override
  List<Object> get props => [token, seachKey];
}

class SubCategoryListReqEvent extends HomeEvent{
  final String token;
  final String categoryId;
  SubCategoryListReqEvent(
      {@required this.token, @required this.categoryId});

  @override
  List<Object> get props => [token, categoryId];
}

class NearbySubChildCategoryListReqEvent extends HomeEvent{
  final String token;
  final String categoryId;
  final String radius;
  final String lat;
  final String lng;
  final String subcategory_id;
  NearbySubChildCategoryListReqEvent(
      {@required this.token, @required this.categoryId, this.subcategory_id, @required this.radius, @required this.lat, @required this.lng});

  @override
  List<Object> get props => [token, categoryId, subcategory_id, radius, lat, lng];
}
