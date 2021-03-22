import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialEvent extends HomeEvent {}

class ProgressEvent extends HomeEvent {}

class NonProgressEvent extends HomeEvent {}

class HomeReqAuthenticationEvent extends HomeEvent {
  final String token;
  final String lat;
  final String lng;

  HomeReqAuthenticationEvent({@required this.token, @required this.lat, @required this.lng});

  @override
  List<Object> get props => [token, lat, lng];
}

class HomeReqAuthenticationNoProgressEvent extends HomeEvent {
  final String token;
  final String lat;
  final String lng;

  HomeReqAuthenticationNoProgressEvent({@required this.token, @required this.lat, @required this.lng});

  @override
  List<Object> get props => [token, lat, lng];
}

class ItemDetailReqEvent extends HomeEvent {
  final String token;
  final String categoryName;

  ItemDetailReqEvent({@required this.token, @required this.categoryName});

  @override
  List<Object> get props => [token, categoryName];
}

class LocationSeachReqEvent extends HomeEvent {
  final String token;
  final String seachKey;

  LocationSeachReqEvent({@required this.token, @required this.seachKey});

  @override
  List<Object> get props => [token, seachKey];
}

class SubCategorySearchReqEvent extends HomeEvent {
  final String token;
  final String seachKey;

  SubCategorySearchReqEvent({@required this.token, @required this.seachKey});

  @override
  List<Object> get props => [token, seachKey];
}

class SubCategoryListReqEvent extends HomeEvent {
  final String token;
  final String categoryId;

  SubCategoryListReqEvent({@required this.token, @required this.categoryId});

  @override
  List<Object> get props => [token, categoryId];
}

class NearbySubChildCategoryListReqEvent extends HomeEvent {
  final String token;
  final String categoryId;
  final String radius;
  final String lat;
  final String lng;
  final String subcategory_id;
  final String filter_subcategory_id;
  final String filter_custome_filed_id;
  final String filter_min;
  final String filter_max;
  final String sort_by_price;
  final String ads_title;
  final String page_number;

  NearbySubChildCategoryListReqEvent(
      {@required this.token,
      @required this.categoryId,
      this.subcategory_id,
      @required this.radius,
      @required this.lat,
      @required this.lng,
      @required this.filter_subcategory_id,
      @required this.filter_custome_filed_id,
      @required this.filter_min,
      @required this.filter_max,
      @required this.sort_by_price,
      @required this.ads_title,
      @required this.page_number
      });

  @override
  List<Object> get props =>
      [token, categoryId, subcategory_id, radius, lat, lng, filter_subcategory_id, filter_custome_filed_id, filter_min, filter_max, sort_by_price, ads_title, page_number];
}

class NearbySubChildCategoryListReqNoProgressEvent extends HomeEvent {
  final String token;
  final String categoryId;
  final String radius;
  final String lat;
  final String lng;
  final String subcategory_id;
  final String filter_subcategory_id;
  final String filter_custome_filed_id;
  final String filter_min;
  final String filter_max;
  final String sort_by_price;
  final String ads_title;
  final String page_number;

  NearbySubChildCategoryListReqNoProgressEvent(
      {@required this.token,
      @required this.categoryId,
      this.subcategory_id,
      @required this.radius,
      @required this.lat,
      @required this.lng,
      @required this.filter_subcategory_id,
      @required this.filter_custome_filed_id,
      @required this.filter_min,
      @required this.filter_max,
      @required this.sort_by_price,
      @required this.ads_title,
      @required this.page_number
      });

  @override
  List<Object> get props =>
      [token, categoryId, subcategory_id, radius, lat, lng, filter_subcategory_id, filter_custome_filed_id, filter_min, filter_max, sort_by_price, ads_title, page_number];
}

class GetCategoryListEvent extends HomeEvent {
  final String token;

  GetCategoryListEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class GetAllPackageListEvent extends HomeEvent {
  final String token;

  GetAllPackageListEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class GetNotificationListEvent extends HomeEvent {
  final String token;

  GetNotificationListEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class GetUserProfileDataEvent extends HomeEvent {
  final String token;

  GetUserProfileDataEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class ChangePwdEvent extends HomeEvent {
  final String token;
  final String pwd;
  final String newpwd;

  ChangePwdEvent(
      {@required this.token, @required this.pwd, @required this.newpwd});

  @override
  List<Object> get props => [token];
}

class UserUpdateEvent extends HomeEvent {
  final String token;
  final String username;
  final String aboutus;
  final String contact;
  final String email;
  final String address;
  final String profile_setting;
  final File image;

  UserUpdateEvent(
      {@required this.token,
      @required this.username,
      @required this.aboutus,
      @required this.contact,
      @required this.email,
      @required this.address,
      @required this.profile_setting,
      @required this.image});

  @override
  List<Object> get props => [token];
}

class GetRentTypeEvent extends HomeEvent {
  final String token;

  GetRentTypeEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class SaveFavEvent extends HomeEvent {
  final String token;
  final String addId;

  SaveFavEvent({@required this.token, @required this.addId});

  @override
  List<Object> get props => [token, addId];
}

class GetMyFavListEvent extends HomeEvent {
  final String token;

  GetMyFavListEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class SellerInfoEvent extends HomeEvent {
  final String token;
  final String sellerId;

  SellerInfoEvent({@required this.token, @required this.sellerId});

  @override
  List<Object> get props => [token, sellerId];
}

class GetAllChatUserEvent extends HomeEvent {
  final String token;

  GetAllChatUserEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class GetAllChatMsgEvent extends HomeEvent {
  final String token;
  final String indexId;
  final String adId;

  GetAllChatMsgEvent(
      {@required this.token, @required this.indexId, @required this.adId});

  @override
  List<Object> get props => [token, indexId, adId];
}

class GetAllChatMsgNoProgressEvent extends HomeEvent {
  final String token;
  final String indexId;
  final String adId;

  GetAllChatMsgNoProgressEvent(
      {@required this.token, @required this.indexId, @required this.adId});

  @override
  List<Object> get props => [token, indexId, adId];
}

class GetSlugChatMsgEvent extends HomeEvent {
  final String token;
  final String slug;

  GetSlugChatMsgEvent({@required this.token, @required this.slug});

  @override
  List<Object> get props => [token, slug];
}

class GetSlugChatMsgNoProgressEvent extends HomeEvent {
  final String token;
  final String slug;

  GetSlugChatMsgNoProgressEvent({@required this.token, @required this.slug});

  @override
  List<Object> get props => [token, slug];
}

class SendMsgReqEvent extends HomeEvent {
  final String token;
  final String adId;
  final String msg;
  final String recieverId;
  final String inboxId;

  SendMsgReqEvent(
      {@required this.token,
      @required this.adId,
      @required this.msg,
      @required this.recieverId,
      @required this.inboxId});

  @override
  List<Object> get props => [token, adId, msg, recieverId, inboxId];
}

class GetMyPackageEvent extends HomeEvent {
  final String token;

  GetMyPackageEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class AdUnderPackageEvent extends HomeEvent {
  final String token;

  AdUnderPackageEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class CustomFieldsEvent extends HomeEvent {
  final String token;
  final String subCategoryId;

  CustomFieldsEvent({@required this.token, @required this.subCategoryId});

  @override
  List<Object> get props => [token, subCategoryId];
}

class PostAdsEvent extends HomeEvent {
  final String token;
  final AdPostReqModel adPostReqModel;

  PostAdsEvent({@required this.token, @required this.adPostReqModel});

  @override
  List<Object> get props => [token, adPostReqModel];
}

class PackagePaymentEvent extends HomeEvent {
  final String token;
  final String packageId;
  final String amt;
  final String pgRes;

  PackagePaymentEvent(
      {@required this.token, @required this.packageId, this.amt, this.pgRes});

  @override
  List<Object> get props => [token, packageId, amt, pgRes];
}

class MyAdsEvent extends HomeEvent {
  final String token;

  MyAdsEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class GetMyAdsEditEvent extends HomeEvent {
  final String token;
  final String adId;

  GetMyAdsEditEvent({@required this.token, @required this.adId});

  @override
  List<Object> get props => [token, adId];
}

class DeleteAdEvent extends HomeEvent {
  final String token;
  final String adId;

  DeleteAdEvent({@required this.token, @required this.adId});

  @override
  List<Object> get props => [token, adId];
}

class PostEditAdsEvent extends HomeEvent {
  final String token;
  final AdPostReqModel adPostReqModel;

  PostEditAdsEvent({@required this.token, @required this.adPostReqModel});

  @override
  List<Object> get props => [token, adPostReqModel];
}

class SendOtpEvent extends HomeEvent {
  final String contact;
  final String otpType;

  SendOtpEvent({@required this.contact, @required this.otpType});

  @override
  List<Object> get props => [contact, otpType];
}

class VerifyOtpEvent extends HomeEvent {
  final String contact;
  final String otp;

  VerifyOtpEvent({@required this.contact, @required this.otp});

  @override
  List<Object> get props => [contact, otp];
}

class ForgotPwdEvent extends HomeEvent {
  final String contact;
  final String otp;
  final String confirm_password;

  ForgotPwdEvent(
      {@required this.contact, @required this.otp, this.confirm_password});

  @override
  List<Object> get props => [contact, otp, confirm_password];
}

class RatingEvent extends HomeEvent {
  final String token;
  final String seller_id;
  final String user_id;
  final String rating;

  RatingEvent(
      {@required this.token,@required this.seller_id, @required this.user_id, this.rating});

  @override
  List<Object> get props => [token, seller_id, user_id, rating];
}

class GooglePlaceEvent extends HomeEvent {
  final String token;
  final String query;

  GooglePlaceEvent(
      {@required this.token,@required this.query});

  @override
  List<Object> get props => [token, query];
}

class CouponEvent extends HomeEvent {
  final String lat;
  final String lng;

  CouponEvent(
      {@required this.lat,@required this.lng});

  @override
  List<Object> get props => [lat, lng];
}

class ChatDeleteEvent extends HomeEvent {
  final String inbox_id;

  ChatDeleteEvent(
      {@required this.inbox_id});

  @override
  List<Object> get props => [inbox_id];
}
