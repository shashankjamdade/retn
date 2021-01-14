import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/model/get_my_favourite_res.dart';
import 'package:flutter_rentry_new/repository/AuthenticationRepository.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';

import 'HomeState.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository;

  AuthenticationBloc() {
    homeRepository = HomeRepository();
  }

  @override
  HomeState get initialState => InitialHomeState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is InitialEvent) {
      yield InitialHomeState();
    } else if (event is HomeReqAuthenticationEvent) {
      yield ProgressState();
      yield* callHomeApi(event.token);
    } else if (event is ItemDetailReqEvent) {
      yield ProgressState();
      yield* callItemDetailApi(event.token, event.categoryName);
    } else if (event is LocationSeachReqEvent) {
//      yield ProgressState();
      yield* callLocatinoSearchApi(event.token, event.seachKey);
    } else if (event is SubCategorySearchReqEvent) {
//      yield ProgressState();
      yield* callSubCategorySearchApi(event.token, event.seachKey);
    } else if (event is SubCategoryListReqEvent) {
      yield ProgressState();
      yield* callSubCategoryListApi(event.token, event.categoryId);
    } else if (event is NearbySubChildCategoryListReqEvent) {
      yield ProgressState();
      yield* callNearbySubChildCategoryListApi(event.token, event.categoryId,
          event.subcategory_id, event.radius, event.lat, event.lng, event.filter_subcategory_id, event.filter_custome_filed_id,
      event.filter_min, event.filter_max, event.sort_by_price);
    } else if (event is GetCategoryListEvent) {
      yield ProgressState();
      yield* callGetCategoryApi(event.token);
    } else if (event is GetAllPackageListEvent) {
      yield ProgressState();
      yield* callGetAllPackageListApi(event.token);
    } else if (event is GetNotificationListEvent) {
      yield ProgressState();
      yield* callGetNotificationListApi(event.token);
    } else if (event is GetUserProfileDataEvent) {
      yield ProgressState();
      yield* callGetUserProfileApi(event.token);
    } else if (event is ChangePwdEvent) {
      yield ProgressState();
      yield* callChangePwdApi(event.token, event.pwd, event.newpwd);
    } else if (event is UserUpdateEvent) {
      yield ProgressState();
      yield* callUserUpdateApi(event.token, event.username, event.email,
          event.contact, event.address, event.aboutus, event.image);
    } else if (event is GetRentTypeEvent) {
      yield ProgressState();
      yield* callGetRentTypeApi(event.token);
    } else if (event is SaveFavEvent) {
      yield ProgressState();
      yield* callSaveFavApi(event.token, event.addId);
    } else if (event is GetMyFavListEvent) {
      yield ProgressState();
      yield* callGetMyFavApi(event.token);
    } else if (event is SellerInfoEvent) {
      yield ProgressState();
      yield* callSellerInfoApi(event.token, event.sellerId);
    } else if (event is GetAllChatUserEvent) {
      yield ProgressState();
      yield* callGetAllChatUserListApi(event.token);
    } else if (event is GetAllChatMsgEvent) {
      yield ProgressState();
      yield* callGetAllChatMsgApi(event.token, event.indexId, event.slug);
    } else if (event is GetAllChatMsgNoProgressEvent) {
//      yield ProgressState();
      yield* callGetAllChatMsgApi(event.token, event.indexId, event.slug);
    } else if (event is GetSlugChatMsgEvent) {
      yield ProgressState();
      yield* callGetSlugChatMsgApi(event.token, event.slug);
    } else if (event is GetSlugChatMsgNoProgressEvent) {
//      yield ProgressState();
      yield* callGetSlugChatMsgApi(event.token, event.slug);
    } else if (event is SendMsgReqEvent) {
//      yield ProgressState();
      yield* callSendMsgApi(
          event.token, event.adId, event.msg, event.recieverId, event.inboxId);
    } else if (event is SendMsgReqEvent) {
//      yield ProgressState();
      yield* callSendMsgApi(
          event.token, event.adId, event.msg, event.recieverId, event.inboxId);
    } else if (event is GetMyPackageEvent) {
      yield ProgressState();
      yield* callGetMyPackageListApi(event.token);
    } else if (event is AdUnderPackageEvent) {
      yield ProgressState();
      yield* callAdUnderPackageApi(event.token);
    } else if (event is CustomFieldsEvent) {
      yield ProgressState();
      yield* callCustomFields(event.token, event.subCategoryId);
    } else if (event is PostAdsEvent) {
      yield ProgressState();
      yield* callPostAds(event.token, event.adPostReqModel);
    }  else if (event is PostEditAdsEvent) {
      yield ProgressState();
      yield* callPostMyAdEditUpdate(event.token, event.adPostReqModel);
    } else if (event is PackagePaymentEvent) {
      yield ProgressState();
      yield* callPackagePayment(
          event.token, event.packageId, event.amt, event.pgRes);
    } else if (event is MyAdsEvent) {
      yield ProgressState();
      yield* callGetMyAds(event.token);
    } else if (event is DeleteAdEvent) {
      yield ProgressState();
      yield* callDeleteAd(event.token, event.adId);
    } else if (event is GetMyAdsEditEvent) {
      yield ProgressState();
      yield* callGetMyAdEdit(event.token, event.adId);
    }else if (event is SendOtpEvent) {
      yield ProgressState();
      yield* callSendOtp(event.contact, event.otpType);
    }else if (event is VerifyOtpEvent) {
      yield ProgressState();
      yield* callVerifyOtp(event.contact, event.otp);
    }else if (event is ForgotPwdEvent) {
      yield ProgressState();
      yield* callForgotPwd(event.contact, event.otp, event.confirm_password);
    }else if (event is RatingEvent) {
//      yield ProgressState();
      yield* callRating(event.token, event.seller_id, event.user_id, event.rating);
    }else if (event is GooglePlaceEvent) {
//      yield ProgressState();
      yield* callGooglePlace(event.token, event.query);
    }
  }

  Stream<HomeState> callHomeApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "HOME_API_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final homeResponse = await homeRepository.callHomeApi(token);
      debugPrint("HOME_API_CALL_RES ${jsonEncode(homeResponse)}");
      yield HomeResState(res: homeResponse);
    } catch (e) {
      debugPrint("Exception while Home ${e.toString()}");
    }
  }

  Stream<HomeState> callItemDetailApi(
      String token, String categoryName) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "HOME_API_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final itemDetailResponse =
          await homeRepository.callItemDetailApi(token, categoryName);
      debugPrint("ITEMDETAIL_API_CALL_RES ${jsonEncode(itemDetailResponse)}");
      yield ItemDetailResState(res: itemDetailResponse);
    } catch (e) {
      debugPrint("Exception while itemDetail ${e.toString()}");
    }
  }

  Stream<HomeState> callLocatinoSearchApi(
      String token, String searchKey) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "LocatinoSeach_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final locationSearchResponse =
          await homeRepository.callLocaitonSearchApi(token, searchKey);
      debugPrint(
          "LocatinoSeach_API_CALL_RES ${jsonEncode(locationSearchResponse)}");
      yield LocationSearchResState(res: locationSearchResponse);
    } catch (e) {
      debugPrint("Exception while LocatinoSeach ${e.toString()}");
    }
  }

  Stream<HomeState> callSubCategorySearchApi(
      String token, String searchKey) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "SubCategorySeach_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final subCategorySearchResponse =
          await homeRepository.callSubCategorySearchApi(token, searchKey);
      debugPrint(
          "subCategorySearchResponse ${jsonEncode(subCategorySearchResponse)}");
      yield SubCategorySearchResState(res: subCategorySearchResponse);
    } catch (e) {
      debugPrint("Exception while subCategorySearchResponse ${e.toString()}");
    }
  }

  Stream<HomeState> callSubCategoryListApi(
      String token, String categoryId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "SubCategorySeach_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final subCategoryListResponse =
          await homeRepository.callSubCategoryListApi(token, categoryId);
      debugPrint(
          "subCategorySearchResponse ${jsonEncode(subCategoryListResponse)}");
      yield SubCategoryListResState(res: subCategoryListResponse);
    } catch (e) {
      debugPrint("Exception while subCategoryListResponse ${e.toString()}");
    }
  }

  Stream<HomeState> callNearbySubChildCategoryListApi(
      String token,
      String categoryId,
      String subCategoryId,
      String radius,
      String lat,
      String lng,
      String filter_subcategory_id,
      String filter_custome_filed_id,
      String filter_min,
      String filter_max,
      String priceSort,
      ) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callNearbySubChildCategoryListApi TOKEN ${token} ${homeRepository ==
              null ? "NULL" : "NOTNULL"}");
      final nearbySubChildCategoryListResponse =
      await homeRepository.callNearbySubChildCategoryListApi(
          token,
          categoryId,
          subCategoryId,
          radius,
          lat,
          lng,
          filter_subcategory_id,
          filter_custome_filed_id,
          filter_min,
          filter_max,
          priceSort);
      debugPrint(
          "nearbySubChildCategoryListResponse ${jsonEncode(
              nearbySubChildCategoryListResponse)}");
      yield NearbySubChildCategoryListResState(
          res: nearbySubChildCategoryListResponse);
    }catch (e, stacktrace) {
      debugPrint(
          "Exception while nearbySubChildCategoryListResponse ${e.toString()}\n ${stacktrace.toString()}");
    }
  }

  Stream<HomeState> callGetCategoryApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "GetCategoryResponse ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getCategoryResponse =
          await homeRepository.callGetCategoryListApi(token);
      debugPrint("GetCategoryResponse ${jsonEncode(getCategoryResponse)}");
      yield GetAllCategoryListResState(res: getCategoryResponse);
    } catch (e) {
      debugPrint("Exception while GetCategoryResponse ${e.toString()}");
    }
  }

  Stream<HomeState> callGetAllPackageListApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "GetAllPackageListResponse ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getAllPackageListResponse =
          await homeRepository.callGetAllPackageListApi(token);
      debugPrint(
          "GetAllPackageListResponse ${jsonEncode(getAllPackageListResponse)}");
      yield GetAllPackageListResState(res: getAllPackageListResponse);
    } catch (e) {
      debugPrint("Exception while GetAllPackageListResponse ${e.toString()}");
    }
  }

  Stream<HomeState> callGetNotificationListApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetNotificationListApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getNotificationListRes =
          await homeRepository.callGetNotificationListApi(token);
      debugPrint(
          "callGetNotificationListApi ${jsonEncode(getNotificationListRes)}");
      yield GetNotificationListResState(res: getNotificationListRes);
    } catch (e) {
      debugPrint("Exception while callGetNotificationListApi ${e.toString()}");
    }
  }

  Stream<HomeState> callGetUserProfileApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetUserProfileApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getUserProfileRes = await homeRepository.callUserProfileApi(token);
      debugPrint("callGetUserProfileApi ${jsonEncode(getUserProfileRes)}");
      yield GetUserProfileResState(res: getUserProfileRes);
    } catch (e) {
      debugPrint("Exception while callGetUserProfileApi ${e.toString()}");
    }
  }

  Stream<HomeState> callChangePwdApi(
      String token, String pwd, String newPwd) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callChangePwdApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final changePwdRes =
          await homeRepository.callChangePwd(token, pwd, newPwd);
      debugPrint("callChangePwdApi ${jsonEncode(changePwdRes)}");
      yield ChangePwdResState(res: changePwdRes);
    } catch (e) {
      debugPrint("Exception while callChangePwdApi ${e.toString()}");
    }
  }

  Stream<HomeState> callUserUpdateApi(
      String token,
      String username,
      String email,
      String contact,
      String address,
      String aboutus,
      File img) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callUserUpdateApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final changePwdRes = await homeRepository.callUpdateUser(
          token, username, aboutus, contact, email, address, img);
      debugPrint("callUserUpdateApi ${jsonEncode(changePwdRes)}");
      yield ChangePwdResState(res: changePwdRes);
    } catch (e) {
      debugPrint("Exception while callUserUpdateApi ${e.toString()}");
    }
  }

  Stream<HomeState> callGetRentTypeApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetRentTypeApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getRentTypeRes = await homeRepository.callRentTypeApi(token);
      debugPrint("callGetRentTypeApi ${jsonEncode(getRentTypeRes)}");
      yield GetRentTypeResState(res: getRentTypeRes);
    } catch (e) {
      debugPrint("Exception while callGetUserProfileApi ${e.toString()}");
    }
  }

  Stream<HomeState> callSaveFavApi(String token, String addId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callSaveFavApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final saveFavRes =
          await homeRepository.callSavefavouriteApi(token, addId);
      debugPrint("callSaveFavApi ${jsonEncode(saveFavRes)}");
      yield SaveFavResState(res: saveFavRes);
    } catch (e) {
      debugPrint("Exception while callSaveFavApi ${e.toString()}");
    }
  }

  Stream<HomeState> callGetMyFavApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetMyFavApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyFavRes = await homeRepository.callMyFavouriteListApi(token);
      debugPrint("callGetMyFavApi ${jsonEncode(getMyFavRes)}");
      yield MyFavListResState(res: getMyFavRes);
    } catch (e) {
      debugPrint("Exception while callGetMyFavApi ${e.toString()}");
    }
  }

  Stream<HomeState> callSellerInfoApi(String token, String sellerId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callSellerInfoApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyFavRes =
          await homeRepository.callSellerInfoApi(token, sellerId);
      debugPrint("callSellerInfoApi ${jsonEncode(getMyFavRes)}");
      yield SellerInfoResState(res: getMyFavRes);
    } catch (e) {
      debugPrint("Exception while callSellerInfoApi ${e.toString()}");
    }
  }

  Stream<HomeState> callGetAllChatUserListApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetAllChatUserListApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getAllChatUserList =
          await homeRepository.callGetAllChatUserApi(token);
      debugPrint("callGetAllChatUserListApi ${jsonEncode(getAllChatUserList)}");
      yield GetAllChatUserListResState(res: getAllChatUserList);
    } catch (e) {
      debugPrint("Exception while callGetAllChatUserListApi ${e.toString()}");
    }
  }

  Stream<HomeState> callGetAllChatMsgApi(
      String token, String indexId, String slug) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetAllChatMsgApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyFavRes =
          await homeRepository.callGetAllChatMsgApi(token, indexId, slug);
      debugPrint("callGetAllChatMsgApi ${jsonEncode(getMyFavRes)}");
      yield GetAllChatMsgResState(res: getMyFavRes);
    } catch (e) {
      debugPrint("Exception while callGetAllChatMsgApi ${e.toString()}");
    }
  }

  Stream<HomeState> callGetSlugChatMsgApi(String token, String slug) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetSlugChatMsgApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyFavRes =
          await homeRepository.callGetSlugChatMsgApi(token, slug);
      debugPrint("callGetSlugChatMsgApi ${jsonEncode(getMyFavRes)}");
      yield GetAllChatMsgResState(res: getMyFavRes);
    } catch (e) {
      debugPrint("Exception while callGetSlugChatMsgApi ${e.toString()}");
    }
  }

  Stream<HomeState> callSendMsgApi(String token, String adId, String msg,
      String recieverId, String inboxId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callSendMsgApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final sendMsgRes = await homeRepository.callSendMsgApi(
          token, adId, msg, recieverId, inboxId);
      debugPrint("callSendMsgApi ${jsonEncode(sendMsgRes)}");
      yield SendMsgResState(res: sendMsgRes);
    } catch (e, stacktrace) {
      debugPrint("Exception while callSendMsgApi ${e.toString()}\n ${stacktrace}");
    }
  }

  Stream<HomeState> callGetMyPackageListApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetMyPackageListApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyPackageRes = await homeRepository.callGetMyPackageList(token);
      debugPrint("callGetMyPackageListApi ${jsonEncode(getMyPackageRes)}");
      yield GetMyPackageListState(res: getMyPackageRes);
    } catch (e) {
      debugPrint("Exception while callGetMyPackageListApi ${e.toString()}");
    }
  }

  Stream<HomeState> callAdUnderPackageApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callAdUnderPackageApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final adUnderPackageRes = await homeRepository.callAdUnderPackage(token);
      debugPrint("callAdUnderPackageApi ${jsonEncode(adUnderPackageRes)}");
      yield AdUnderPackageState(res: adUnderPackageRes);
    } catch (e) {
      debugPrint("Exception while callAdUnderPackageApi ${e.toString()}");
    }
  }

  Stream<HomeState> callCustomFields(
      String token, String subCategoryId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callCustomFields ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getCustomFieldsRes =
          await homeRepository.callCustomFields(token, subCategoryId);
      debugPrint("callCustomFields ${jsonEncode(getCustomFieldsRes)}");
      yield CustomFieldsState(res: getCustomFieldsRes);
    } catch (e) {
      debugPrint("Exception while callCustomFields ${e.toString()}");
    }
  }

  Stream<HomeState> callPostAds(
      String token, AdPostReqModel adPostReqModel) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callPostAds ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
          await homeRepository.callPostAds(token, adPostReqModel);
      debugPrint("callPostAds ${jsonEncode(commonResponse)}");
      yield PostAdsState(res: commonResponse);
    } catch (e, st) {
      debugPrint("Exception while callPostAds ${e.toString()}");
    }
  }

  Stream<HomeState> callPackagePayment(
      String token, String packageId, String amt, String pgRes) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callPackagePayment ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
          await homeRepository.callPackagePayment(token, packageId, amt, pgRes);
      debugPrint("callPackagePayment ${jsonEncode(commonResponse)}");
      yield PackagePaymentState(res: commonResponse);
    } catch (e) {
      debugPrint("Exception while callPackagePayment ${e.toString()}");
    }
  }

  Stream<HomeState> callGetMyAds(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetMyAds ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyAdsRes = await homeRepository.callGetMyAdsList(token);
      debugPrint("callGetMyAds ${jsonEncode(getMyAdsRes)}");
      yield GetMyAdsListState(res: getMyAdsRes);
    } catch (e) {
      debugPrint("Exception while callGetMyAds ${e.toString()}");
    }
  }

  Stream<HomeState> callGetMyAdEdit(String token, String adId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetMyAdEdit ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyEditAds = await homeRepository.callGetMyAdEdit(token, adId);
      debugPrint("callGetMyAdEdit ${jsonEncode(getMyEditAds)}");
      yield GetMyAdsEditState(res: getMyEditAds);
    } catch (e, stacktrace) {
      debugPrint("Exception while callGetMyAdEdit ${e.toString()} \n ${stacktrace.toString()}");
    }
  }

  Stream<HomeState> callDeleteAd(String token, String adId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callDeleteAd ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonRes = await homeRepository.callDeleteAd(token, adId);
      debugPrint("callDeleteAd ${jsonEncode(commonRes)}");
      yield DeleteAdState(res: commonRes);
    } catch (e) {
      debugPrint("Exception while callDeleteAd ${e.toString()}");
    }
  }

  Stream<HomeState> callPostMyAdEditUpdate(
      String token, AdPostReqModel adPostReqModel) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callPostMyAdEditUpdate ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
      await homeRepository.callEditAds(token, adPostReqModel);
      debugPrint("callPostMyAdEditUpdate ${jsonEncode(commonResponse)}");
      yield PostEditAdsState(res: commonResponse);
    } catch (e) {
      debugPrint("Exception while callPostMyAdEditUpdate ${e.toString()}");
    }
  }


  Stream<HomeState> callSendOtp(String contact, String otpType) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callSendOtp ${contact} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
      await homeRepository.callSendOtp(contact, otpType);
      debugPrint("callSendOtp ${jsonEncode(commonResponse)}");
      yield SendOtpState(res: commonResponse);
    } catch (e) {
      debugPrint("Exception while callSendOtp ${e.toString()}");
    }
  }


  Stream<HomeState> callVerifyOtp(String contact, String otp) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callVerifyOtp ${contact} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
      await homeRepository.callVerifyOtp(contact, otp);
      debugPrint("callVerifyOtp ${jsonEncode(commonResponse)}");
      yield VeifyOtpState(res: commonResponse);
    } catch (e) {
      debugPrint("Exception while callVerifyOtp ${e.toString()}");
    }
  }


  Stream<HomeState> callForgotPwd(String contact, String otp, String confirmPwd) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callForgotPwd ${contact} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
      await homeRepository.callForgotPwd(contact, otp, confirmPwd);
      debugPrint("callForgotPwd ${jsonEncode(commonResponse)}");
      yield ForgotPwdState(res: commonResponse);
    } catch (e) {
      debugPrint("Exception while callForgotPwd ${e.toString()}");
    }
  }


  Stream<HomeState> callRating(String token, String seller_id, String user_id, String rating) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callRating ${seller_id} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
      await homeRepository.callRating(token, seller_id, user_id, rating);
      debugPrint("callRating ${jsonEncode(commonResponse)}");
      yield RatingState(res: commonResponse);
    } catch (e) {
      debugPrint("Exception while callRating ${e.toString()}");
    }
  }


  Stream<HomeState> callGooglePlace(String token, String query) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGooglePlace ${query} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final googlePlacesRes =
      await homeRepository.callGooglePlaces(token, query);
      debugPrint("callGooglePlace ${jsonEncode(googlePlacesRes)}");
      yield GooglePlaceState(res: googlePlacesRes);
    } catch (e) {
      debugPrint("Exception while callGooglePlace ${e.toString()}");
    }
  }


}
