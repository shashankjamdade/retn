import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/model/ad_under_package_res.dart';
import 'package:flutter_rentry_new/model/common_response.dart';
import 'package:flutter_rentry_new/model/general_setting_res.dart';
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
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/model/save_favourite_res.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/model/seller_info_res.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';

import 'base_repository.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';

import 'dart:convert';

class HomeRepository extends BaseRepository {
  final http.Client _httpClient;

  HomeRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();


  Future<GeneralSettingRes> callGeneralSetting() async {
    bool status = false;
    GeneralSettingRes response;
    int code = 0;
    print("UNDER callGeneralSetting ");
    var res =
        await http.get(BASE_URL + GENERAL_SETTINGS);
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GeneralSettingRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GeneralSettingRes(status: false, message: API_ERROR_MSG);
    }
    return response;
  }

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
      response = new GetCategoryResponse(message: API_ERROR_MSG, status: false);
    }
    return response;
  }

  Future<GetAllPackageListResponse> callGetAllPackageListApi(
      String token) async {
    bool status = false;
    GetAllPackageListResponse response;
    int code = 0;
    print("UNDER callGetAllPackageListApi ${token}");
    var res = await http
        .get(BASE_URL + GET_ALL_PACKAGELIST_API, headers: {"Token": token});
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

  Future<GetNotificationResponse> callGetNotificationListApi(
      String token) async {
    bool status = false;
    GetNotificationResponse response;
    int code = 0;
    print("UNDER callGetNotificationListApi ${token}");
    Map<String, String> mainheader = {
//      "Content-type": "application/json",
      "Token": token
    };
    var res = await http.get(
      BASE_URL + GET_NOTIFICATION_LIST_API,
      headers: mainheader,
    );
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
    print("UNDER callUserProfileApi ${token}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + GET_USER_DATA,
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
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

  Future<CommonResponse> callChangePwd(
      String token, String pwd, String newpwd) async {
    bool status = false;
    CommonResponse response;
    int code = 0;
    print("UNDER callChangePwd ${token}");
    Map<String, String> mainheader = {
//      "Content-type": "application/json",
      "token": token
    };
    var res = await http.post(BASE_URL + UPDATE_PASSWORD,
        headers: mainheader,
        body: {
          "current_password": pwd,
          "new_password": newpwd,
          "confirm_password": newpwd
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
      response = new CommonResponse(msg: API_ERROR_MSG, status: "false");
    }
    return response;
  }

  Future<CommonResponse> callUpdateUser(String token, String username, String aboutus,
      String contact, String email, String address, File imageFile) async {
    bool status = false;
    CommonResponse response;

    if(imageFile !=null){
      var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length(); //imageFile is your image file
      Map<String, String> mainheader = {
        "token": token
      };
      var uri = Uri.parse(BASE_URL + GET_USER_DATA);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFileSign = new http.MultipartFile('profile_picture', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFileSign);
      request.headers.addAll(mainheader);
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['contact'] = contact;
      request.fields['address'] = address;
      var res = await request.send();
      print(res.statusCode);
      res.stream.transform(utf8.decoder).listen((value) {
        print(value);
        response = CommonResponse.fromJson(value);
      });
    }else{
      Map<String, String> mainheader = {
        "token": token
      };
      var res = await http.post(BASE_URL + GET_USER_DATA,
          headers: mainheader,
          body: {
            "username": username,
            "email": email,
            "contact": contact,
            "address": address
          });
      print("PRINTING ${res.body}");
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var status = data["status"];
        print("PRINTING_STATUS ${status}");
        response = CommonResponse.fromJson(data);
        print("-----------${data}");
      } else {
        response = new CommonResponse(msg: API_ERROR_MSG, status: "false");
      }
    }
    return response;
  }

  Future<GetRentTypeResponse> callRentTypeApi(String token) async {
    bool status = false;
    GetRentTypeResponse response;
    print("UNDER callRentTypeApi ${token}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + GET_ALL_RENT_TYPE,
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetRentTypeResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetRentTypeResponse(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }

  Future<SaveFavouriteRes> callSavefavouriteApi(String token, String ad_id) async {
    bool status = false;
    SaveFavouriteRes response;
    print("UNDER callSavefavouriteApi ${token}, ${ad_id}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(
      BASE_URL + SAVE_FAVOURITE,
      headers: mainheader,
      body: {"ad_id": ad_id}
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = SaveFavouriteRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new SaveFavouriteRes(
          message: API_ERROR_MSG, status: false, data: API_ERROR_MSG);
    }
    return response;
  }

  Future<GetMyFavouriteRes> callMyFavouriteListApi(String token) async {
    bool status = false;
    GetMyFavouriteRes response;
    print("UNDER callMyFavouriteListApi ${token}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + MY_FAVOURITE,
      headers: mainheader
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetMyFavouriteRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetMyFavouriteRes(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }

  Future<SellerInfoRes> callSellerInfoApi(String token, String sellerId) async {
    bool status = false;
    SellerInfoRes response;
    print("UNDER callSellerInfoApi ${token}, ${sellerId}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(
      BASE_URL + GET_SELLER_INFO,
      headers: mainheader,
      body: {"seller_id": sellerId}
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = SellerInfoRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new SellerInfoRes(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }


  Future<GetAllChatUserListResponse> callGetAllChatUserApi(String token) async {
    bool status = false;
    GetAllChatUserListResponse response;
    print("UNDER GetAllChatUserListResponse ${token} ");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + GET_CHAT_LIST,
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetAllChatUserListResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetAllChatUserListResponse(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }

  Future<GetAllChatMsgRes> callGetAllChatMsgApi(String token, String indexId, String slug) async {
    bool status = false;
    GetAllChatMsgRes response;
    print("UNDER callGetAllChatMsgApi ${token} , ${BASE_URL + GET_CHAT_LIST+"/${indexId}/${slug}"}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + GET_CHAT_LIST+"/${indexId}/${slug}",
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetAllChatMsgRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetAllChatMsgRes(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }

  Future<GetAllChatMsgRes> callGetSlugChatMsgApi(String token, String slug) async {
    bool status = false;
    GetAllChatMsgRes response;
    print("UNDER callGetAllChatMsgApi ${token} , ${BASE_URL + GET_CHAT_LIST+"/${slug}"}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + GET_CHAT_LIST+"/${slug}",
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetAllChatMsgRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetAllChatMsgRes(
          message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }

  Future<CommonResponse> callSendMsgApi(String token, String adId, String msg,String recieverId,String inboxId) async {
    CommonResponse response;
    print("UNDER callSendMsgApi ${token} , ${BASE_URL + SEND_MESSAGE}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(
      BASE_URL + SEND_MESSAGE,
      headers: mainheader,
      body: {"ad_id":adId, "receiver_id":recieverId, "message":msg, "inbox_id":inboxId}
    );
    print("PRINTING ${res.body}");
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

  Future<GetMyPackageListRes> callGetMyPackageList(String token) async {
    GetMyPackageListRes response;
    print("UNDER callGetMyPackageList ${token} , ${BASE_URL + MY_PACKAGE_LIST}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + MY_PACKAGE_LIST,
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetMyPackageListRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetMyPackageListRes();
    }
    return response;
  }

  Future<AdUnderPackageRes> callAdUnderPackage(String token) async {
    AdUnderPackageRes response;
    print("UNDER callAdUnderPackage ${token} , ${BASE_URL + AD_UNDER_PACKAGE}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + AD_UNDER_PACKAGE,
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = AdUnderPackageRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new AdUnderPackageRes();
    }
    return response;
  }

  Future<GetCustomFieldsResponse> callCustomFields(String token, String subcategory_id) async {
    GetCustomFieldsResponse response;
    print("UNDER callCustomFields ${token} , ${BASE_URL + SUBCATEGORY_CUSTOM_FIELDS}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(
      BASE_URL + SUBCATEGORY_CUSTOM_FIELDS,
      headers: mainheader,
      body: {"subcategory_id":subcategory_id}
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GetCustomFieldsResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GetCustomFieldsResponse();
    }
    return response;
  }

  @override
  void dispose() {}
}
