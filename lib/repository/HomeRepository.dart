import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
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
import 'package:flutter_rentry_new/utils/CommonStyles.dart';

import 'base_repository.dart';
import 'package:http/http.dart' as http;

class HomeRepository extends BaseRepository {
  final http.Client _httpClient;

  HomeRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<HomeResponse> callHomeApi(String token) async {
    bool status = false;
    HomeResponse response;
    int code = 0;
    print("UNDER callHomeApi ");
    var res =
        await http.get(BASE_URL + HOMEPAGE_API, headers: {"Token": token});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = HomeResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new HomeResponse(status: false, message: API_ERROR_MSG);
    }
    return response;
  }

  Future<ItemDetailResponse> callItemDetailApi(
      String token, String categoryName) async {
    bool status = false;
    ItemDetailResponse response;
    int code = 0;
    print("UNDER callItemDetailApi ${categoryName}");
    var res = await http.get(
      BASE_URL + ITEMDETAIL_API + "?title=${categoryName}",
      headers: {"Token": token},
    );
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      response = ItemDetailResponse.fromJson(data);
    } else {
      response = new ItemDetailResponse();
    }
    return response;
  }

  Future<SearchLocationResponse> callLocaitonSearchApi(
      String token, String searchKey) async {
    bool status = false;
    SearchLocationResponse response;
    int code = 0;
    print("UNDER callLocaitonSearchApi -- ${searchKey}");
    var res = await http.post(BASE_URL + LOCATION_SEARCH_API,
        headers: {"Token": token}, body: {"search": searchKey});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = SearchLocationResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response =
          new SearchLocationResponse(status: false, message: API_ERROR_MSG);
    }
    return response;
  }

  Future<SearchCategoryResponse> callSubCategorySearchApi(
      String token, String searchKey) async {
    bool status = false;
    SearchCategoryResponse response;
    int code = 0;
    print(
        "UNDER SearchSubCategoryResponse -- ${searchKey} ${BASE_URL + SEARCH_SUBCATEGORY_LIST_API}");
    var res = await http.post(BASE_URL + SEARCH_SUBCATEGORY_LIST_API,
        headers: {"Token": token}, body: {"search": searchKey});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = SearchCategoryResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response =
          new SearchCategoryResponse(status: false, message: API_ERROR_MSG);
    }
    return response;
  }

  Future<SubCategoryListResponse> callSubCategoryListApi(
      String token, String category_id) async {
    bool status = false;
    SubCategoryListResponse response;
    int code = 0;
    print("UNDER SubCategoryListResponse ${category_id}");
    var res = await http.post(BASE_URL + SUBCATEGORY_LIST_API,
        headers: {"Token": token}, body: {"category_id": category_id});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = SubCategoryListResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response =
          new SubCategoryListResponse(status: false, message: API_ERROR_MSG);
    }
    return response;
  }

  Future<NearbySubChildCategoryListResponse> callNearbySubChildCategoryListApi(
      String token,
      String categoryId,
      String subCategoryId,
      String radius,
      String lat,
      String lng) async {
    bool status = false;
    NearbySubChildCategoryListResponse response;
    int code = 0;
    print(
        "UNDER NearbySubChildCategoryListResponse ${categoryId} ${BASE_URL + ADS_SEARCH_API}");
    print(
        "PRINTING_REQ NearbySubChild --> ${"category_id " + categoryId + ",subcategory_id" + subCategoryId + ",radius" + radius + ",lat" + lat + ",lng" + lng}");
    var res = await http.post(BASE_URL + ADS_SEARCH_API, headers: {
      "Token": token
    }, body: {
      "category_id": categoryId,
      "subcategory_id": subCategoryId,
      "radius": radius,
      "lat": lat,
      "lng": lng,
    });
    print("PRINTING NearbySubChild ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = NearbySubChildCategoryListResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new NearbySubChildCategoryListResponse(
          status: false, message: API_ERROR_MSG);
    }
    return response;
  }

  Future<GetCategoryResponse> callGetCategoryListApi(String token) async {
    bool status = false;
    GetCategoryResponse response;
    int code = 0;
    print("UNDER callGetCategoryListApi ${token}, ${BASE_URL + CATEGORY_API}");
    var res =
        await http.get(BASE_URL + CATEGORY_API, headers: {'Token': token});
    print("PRINTING ${res.body}");
//    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetCategoryResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetCategoryResponse(
          message: API_ERROR_MSG, status: false);
    }
    return response;
  }


  Future<GetAllPackageListResponse> callGetAllPackageListApi(String token) async {
    bool status = false;
    GetAllPackageListResponse response;
    int code = 0;
    print("UNDER callGetAllPackageListApi ${token}");
    var res =
        await http.get(BASE_URL + GET_ALL_PACKAGELIST_API, headers: {"Token": token});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetAllPackageListResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetAllPackageListResponse(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }

  Future<GetNotificationResponse> callGetNotificationListApi(String token) async {
    bool status = false;
    GetNotificationResponse response;
    int code = 0;
    print("UNDER callGetNotificationListApi ${token}");
    Map<String, String> mainheader = {
//      "Content-type": "application/json",
      "Token": token
    };
    var res =
        await http.get(BASE_URL + GET_NOTIFICATION_LIST_API, headers: mainheader,);
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetNotificationResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetNotificationResponse(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }
  Future<UserProfileResponse> callUserProfileApi(String token) async {
    bool status = false;
    UserProfileResponse response;
    int code = 0;
    print("UNDER callUserProfileApi ${token}");
    Map<String, String> mainheader = {
//      "Content-type": "application/json",
      "token": token
    };
    var res =
        await http.get(BASE_URL + GET_USER_DATA, headers: mainheader,);
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = UserProfileResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new UserProfileResponse(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }
  Future<CommonResponse> callChangePwd(String token, String pwd, String newpwd) async {
    bool status = false;
    CommonResponse response;
    int code = 0;
    print("UNDER callChangePwd ${token}");
    Map<String, String> mainheader = {
//      "Content-type": "application/json",
      "token": token
    };
    var res =
        await http.post(BASE_URL + UPDATE_PASSWORD, headers: mainheader, body: {
          "current_password":pwd,
          "new_password":newpwd,
          "confirm_password":newpwd
        });
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CommonResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CommonResponse(
          msg: API_ERROR_MSG, status: "false");
    }
    return response;
  }

  @override
  void dispose() {}
}
