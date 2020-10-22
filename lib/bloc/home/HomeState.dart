import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry/model/home_response.dart';
import 'package:flutter_rentry/model/item_detail_response.dart';
import 'package:flutter_rentry/model/location_search_response.dart';
import 'package:flutter_rentry/model/login_response.dart';
import 'package:flutter_rentry/model/register_response.dart';
import 'package:flutter_rentry/model/search_sub_category_response.dart';
import 'package:flutter_rentry/model/sub_category_list_response.dart';

abstract class HomeState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialHomeState extends HomeState {}
class ProgressState extends HomeState {}
class NonProgressState extends HomeState {}
class SuccessState extends HomeState {
  final obj;
  SuccessState({@required this.obj});
  @override
  List<Object> get props => [obj];
}

class FailedState extends HomeState {
  final obj;
  FailedState({@required this.obj});
  @override
  List<Object> get props => [obj];
}

class HomeResState extends HomeState {
  final res;
  HomeResState({@required this.res});
  @override
  List<HomeResponse> get props => [res];
}

class ItemDetailResState extends HomeState {
  final res;
  ItemDetailResState({@required this.res});
  @override
  List<ItemDetailResponse> get props => [res];
}

class LocationSearchResState extends HomeState {
  final res;
  LocationSearchResState({@required this.res});
  @override
  List<LocationSearchResponse> get props => [res];
}

class SubCategorySearchResState extends HomeState {
  final res;
  SubCategorySearchResState({@required this.res});
  @override
  List<SearchSubCategoryResponse> get props => [res];
}

class SubCategoryListResState extends HomeState {
  final res;
  SubCategoryListResState({@required this.res});
  @override
  List<SubCategoryListResponse> get props => [res];
}
