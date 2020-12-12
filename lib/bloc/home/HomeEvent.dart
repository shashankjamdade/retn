import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';

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


class GetCategoryListEvent extends HomeEvent{
  final String token;
  GetCategoryListEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}


class GetAllPackageListEvent extends HomeEvent{
  final String token;
  GetAllPackageListEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}


class GetNotificationListEvent extends HomeEvent{
  final String token;
  GetNotificationListEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}


class GetUserProfileDataEvent extends HomeEvent{
  final String token;
  GetUserProfileDataEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}


class ChangePwdEvent extends HomeEvent{
  final String token;
  final String pwd;
  final String newpwd;
  ChangePwdEvent(
      {@required this.token, @required this.pwd, @required this.newpwd});

  @override
  List<Object> get props => [token];
}

class UserUpdateEvent extends HomeEvent{
  final String token;
  final String username;
  final String aboutus;
  final String contact;
  final String email;
  final String address;
  final File image;
  UserUpdateEvent(
      {@required this.token, @required this.username, @required this.aboutus, @required this.contact, @required this.email, @required this.address, @required this.image});

  @override
  List<Object> get props => [token];
}

class GetRentTypeEvent extends HomeEvent{
  final String token;

  GetRentTypeEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}


class SaveFavEvent extends HomeEvent{
  final String token;
  final String addId;

  SaveFavEvent(
      {@required this.token, @required this.addId});

  @override
  List<Object> get props => [token, addId];
}


class GetMyFavListEvent extends HomeEvent{
  final String token;

  GetMyFavListEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}

class SellerInfoEvent extends HomeEvent{
  final String token;
  final String sellerId;

  SellerInfoEvent(
      {@required this.token, @required this.sellerId});

  @override
  List<Object> get props => [token, sellerId];
}

class GetAllChatUserEvent extends HomeEvent{
  final String token;

  GetAllChatUserEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}

class GetAllChatMsgEvent extends HomeEvent{
  final String token;
  final String indexId;
  final String slug;

  GetAllChatMsgEvent(
      {@required this.token, @required this.indexId, @required this.slug});

  @override
  List<Object> get props => [token, indexId, slug];
}

class GetSlugChatMsgEvent extends HomeEvent{
  final String token;
  final String slug;

  GetSlugChatMsgEvent(
      {@required this.token, @required this.slug});

  @override
  List<Object> get props => [token, slug];
}

class SendMsgReqEvent extends HomeEvent{
  final String token;
  final String adId;
  final String msg;
  final String recieverId;
  final String inboxId;

  SendMsgReqEvent(
      {@required this.token, @required this.adId, @required this.msg, @required this.recieverId, @required this.inboxId});

  @override
  List<Object> get props => [token, adId, msg, recieverId, inboxId];
}

class GetMyPackageEvent extends HomeEvent{
  final String token;


  GetMyPackageEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}

class AdUnderPackageEvent extends HomeEvent{
  final String token;

  AdUnderPackageEvent(
      {@required this.token});

  @override
  List<Object> get props => [token];
}

class CustomFieldsEvent extends HomeEvent{
  final String token;
  final String subCategoryId;

  CustomFieldsEvent(
      {@required this.token, @required this.subCategoryId});

  @override
  List<Object> get props => [token, subCategoryId];
}

class PostAdsEvent extends HomeEvent{
  final String token;
  final AdPostReqModel adPostReqModel;

  PostAdsEvent(
      {@required this.token, @required this.adPostReqModel});

  @override
  List<Object> get props => [token, adPostReqModel];
}

class PackagePaymentEvent extends HomeEvent{
  final String token;
  final String packageId;
  final String amt;
  final String pgRes;

  PackagePaymentEvent(
      {@required this.token, @required this.packageId, this.amt, this.pgRes});

  @override
  List<Object> get props => [token, packageId, amt, pgRes];
}
