import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          event.subcategory_id, event.radius, event.lat, event.lng);
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
    } else if (event is GetSlugChatMsgEvent) {
      yield ProgressState();
      yield* callGetSlugChatMsgApi(event.token, event.slug);
    }else if (event is SendMsgReqEvent) {
//      yield ProgressState();
      yield* callSendMsgApi(event.token, event.adId, event.msg, event.recieverId, event.inboxId);
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
      String lng) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callNearbySubChildCategoryListApi TOKEN ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final nearbySubChildCategoryListResponse =
          await homeRepository.callNearbySubChildCategoryListApi(
              token, categoryId, subCategoryId, radius, lat, lng);
      debugPrint(
          "nearbySubChildCategoryListResponse ${jsonEncode(nearbySubChildCategoryListResponse)}");
      yield NearbySubChildCategoryListResState(
          res: nearbySubChildCategoryListResponse);
    } catch (e) {
      debugPrint(
          "Exception while nearbySubChildCategoryListResponse ${e.toString()}");
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

  Stream<HomeState> callGetRentTypeApi(
      String token) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetRentTypeApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getRentTypeRes =
      await homeRepository.callRentTypeApi(token);
      debugPrint("callGetRentTypeApi ${jsonEncode(getRentTypeRes)}");
      yield GetRentTypeResState(res: getRentTypeRes);
    } catch (e) {
      debugPrint("Exception while callGetUserProfileApi ${e.toString()}");
    }
  }

  Stream<HomeState> callSaveFavApi(
      String token, String addId) async* {
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

  Stream<HomeState> callGetMyFavApi(
      String token) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callGetMyFavApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final getMyFavRes =
      await homeRepository.callMyFavouriteListApi(token);
      debugPrint("callGetMyFavApi ${jsonEncode(getMyFavRes)}");
      yield MyFavListResState(res: getMyFavRes);
    } catch (e) {
      debugPrint("Exception while callGetMyFavApi ${e.toString()}");
    }
  }

  Stream<HomeState> callSellerInfoApi(
      String token, String sellerId) async* {
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

  Stream<HomeState> callGetAllChatUserListApi(
      String token) async* {
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

  Stream<HomeState> callGetSlugChatMsgApi(
      String token, String slug) async* {
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

  Stream<HomeState> callSendMsgApi(
      String token, String adId, String msg, String recieverId, String inboxId) async* {
    try {
      homeRepository =
      homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callSendMsgApi ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final sendMsgRes =
      await homeRepository.callSendMsgApi(token, adId, msg, recieverId, inboxId);
      debugPrint("callSendMsgApi ${jsonEncode(sendMsgRes)}");
      yield SendMsgResState(res: sendMsgRes);
    } catch (e) {
      debugPrint("Exception while callSendMsgApi ${e.toString()}");
    }
  }

}
