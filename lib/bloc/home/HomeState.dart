import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/common_response.dart';
import 'package:flutter_rentry_new/model/get_all_package_list_response.dart';
import 'package:flutter_rentry_new/model/get_category_response.dart';
import 'package:flutter_rentry_new/model/get_notification_response.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/item_detail_response.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/model/location_search_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';

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
  List<SearchLocationResponse> get props => [res];
}

class SubCategorySearchResState extends HomeState {
  final res;
  SubCategorySearchResState({@required this.res});
  @override
  List<SearchCategoryResponse> get props => [res];
}

class SubCategoryListResState extends HomeState {
  final res;
  SubCategoryListResState({@required this.res});
  @override
  List<SubCategoryListResponse> get props => [res];
}

class NearbySubChildCategoryListResState extends HomeState {
  final res;
  NearbySubChildCategoryListResState({@required this.res});
  @override
  List<NearbySubChildCategoryListResponse> get props => [res];
}

class GetAllCategoryListResState extends HomeState {
  final res;
  GetAllCategoryListResState({@required this.res});
  @override
  List<GetCategoryResponse> get props => [res];
}

class GetAllPackageListResState extends HomeState {
  final res;
  GetAllPackageListResState({@required this.res});
  @override
  List<GetAllPackageListResponse> get props => [res];
}

class GetNotificationListResState extends HomeState {
  final res;
  GetNotificationListResState({@required this.res});
  @override
  List<GetNotificationResponse> get props => [res];
}

class GetUserProfileResState extends HomeState {
  final res;
  GetUserProfileResState({@required this.res});
  @override
  List<UserProfileResponse> get props => [res];
}

class ChangePwdResState extends HomeState {
  final res;
  ChangePwdResState({@required this.res});
  @override
  List<CommonResponse> get props => [res];
}
