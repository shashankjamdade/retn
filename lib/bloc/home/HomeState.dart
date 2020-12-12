import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/ad_under_package_res.dart';
import 'package:flutter_rentry_new/model/common_response.dart';
import 'package:flutter_rentry_new/model/get_all_chat_msg_res.dart';
import 'package:flutter_rentry_new/model/get_all_chat_user_list_response.dart';
import 'package:flutter_rentry_new/model/get_all_package_list_response.dart';
import 'package:flutter_rentry_new/model/get_category_response.dart';
import 'package:flutter_rentry_new/model/get_custom_fields_response.dart';
import 'package:flutter_rentry_new/model/get_my_favourite_res.dart';
import 'package:flutter_rentry_new/model/get_my_package_list_res.dart';
import 'package:flutter_rentry_new/model/get_notification_response.dart';
import 'package:flutter_rentry_new/model/get_rent_type_response.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/item_detail_response.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/model/location_search_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/payment_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/model/save_favourite_res.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/model/seller_info_res.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';

abstract class HomeState extends Equatable {
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

class UserUpdateResState extends HomeState {
  final res;

  UserUpdateResState({@required this.res});

  @override
  List<CommonResponse> get props => [res];
}

class GetRentTypeResState extends HomeState {
  final res;

  GetRentTypeResState({@required this.res});

  @override
  List<GetRentTypeResponse> get props => [res];
}

class SaveFavResState extends HomeState {
  final res;

  SaveFavResState({@required this.res});

  @override
  List<SaveFavouriteRes> get props => [res];
}

class MyFavListResState extends HomeState {
  final res;

  MyFavListResState({@required this.res});

  @override
  List<GetMyFavouriteRes> get props => [res];
}

class SellerInfoResState extends HomeState {
  final res;

  SellerInfoResState({@required this.res});

  @override
  List<SellerInfoRes> get props => [res];
}

class GetAllChatUserListResState extends HomeState {
  final res;

  GetAllChatUserListResState({@required this.res});

  @override
  List<GetAllChatUserListResponse> get props => [res];
}

class GetAllChatMsgResState extends HomeState {
  final res;

  GetAllChatMsgResState({@required this.res});

  @override
  List<GetAllChatMsgRes> get props => [res];
}

class SendMsgResState extends HomeState {
  final res;

  SendMsgResState({@required this.res});

  @override
  List<CommonResponse> get props => [res];
}

class GetMyPackageListState extends HomeState {
  final res;

  GetMyPackageListState({@required this.res});

  @override
  List<GetMyPackageListRes> get props => [res];
}

class AdUnderPackageState extends HomeState {
  final res;

  AdUnderPackageState({@required this.res});

  @override
  List<AdUnderPackageRes> get props => [res];
}

class CustomFieldsState extends HomeState {
  final res;

  CustomFieldsState({@required this.res});

  @override
  List<GetCustomFieldsResponse> get props => [res];
}

class PostAdsState extends HomeState {
  final res;

  PostAdsState({@required this.res});

  @override
  List<CommonResponse> get props => [res];
}

class PackagePaymentState extends HomeState {
  final res;

  PackagePaymentState({@required this.res});

  @override
  List<PaymentRes> get props => [res];
}
