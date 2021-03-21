import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/model/ad_delete_res.dart';
import 'package:flutter_rentry_new/model/ad_under_package_res.dart';
import 'package:flutter_rentry_new/model/common_response.dart';
import 'package:flutter_rentry_new/model/coupon_res.dart';
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
import 'package:flutter_rentry_new/model/google_places_res.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/item_detail_response.dart';
import 'package:flutter_rentry_new/model/my_ads_edit_res.dart';
import 'package:flutter_rentry_new/model/my_ads_list_res.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/model/location_search_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/new_chatlist_res.dart';
import 'package:flutter_rentry_new/model/new_inbox_chat_res.dart';
import 'package:flutter_rentry_new/model/payment_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/model/save_favourite_res.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/model/seller_info_res.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:gson/gson.dart';
import 'package:http/io_client.dart';

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

  makeHttpSecure() {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    var http = new IOClient(ioc);
    return http;
  }

  Future<GeneralSettingRes> callGeneralSetting() async {
    bool status = false;
    GeneralSettingRes response;
    int code = 0;
    //http secure connection
    var http = makeHttpSecure();
    print("UNDER callGeneralSetting ");
    var res = await http.get(BASE_URL + GENERAL_SETTINGS);
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

  Future<HomeResponse> callHomeApi(String token, String lat, String lng) async {
    bool status = false;
    HomeResponse response;
    int code = 0;
    //http secure connection
    var http = makeHttpSecure();
    print("UNDER callHomeApi ${BASE_URL + HOMEPAGE_API}, body--> ${lat} ${lng}");
    var res = await http.post(BASE_URL + HOMEPAGE_API,
        headers: {"Token": token}, body: {"lat": lat, "lng": lng});
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
    //http secure connection
    var http = makeHttpSecure();
    print(
        "UNDER callItemDetailApi ${BASE_URL}${ITEMDETAIL_API}?title=${categoryName}");
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
    //http secure connection
    var http = makeHttpSecure();
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
    //http secure connection
    var http = makeHttpSecure();
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
    //http secure connection
    var http = makeHttpSecure();
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
      String lng,
      String filter_subcategory_id,
      String filter_custome_filed_id,
      String filter_min,
      String filter_max,
      String priceSort,
      String ads_title) async {
    bool status = false;
    NearbySubChildCategoryListResponse response;
    int code = 0;
    //http secure connection
    var http = makeHttpSecure();
    print(
        "UNDER NearbySubChildCategoryListResponse ${categoryId} ${BASE_URL + ADS_SEARCH_API}");
    print("PRINTING_REQ NearbySubChild --> ${"category_id " + categoryId + ",subcategory_id " + subCategoryId + ",radius" + radius + ",lat" + lat + ",lng" + lng + ""
        ", filter_subcategory_id ${filter_subcategory_id}, filter_custome_filed_id ${filter_custome_filed_id}, priceSort ${priceSort}, ads_title ${ads_title}"
        "filter_min ${filter_min}, filter_max ${filter_max}"}");
    print("-------");
    var res = await http.post(BASE_URL + ADS_SEARCH_API, headers: {
      "Token": token
    }, body: {
      "category_id": categoryId,
      "subcategory_id":
          ads_title != null && ads_title.isNotEmpty ? "" : subCategoryId,
//      "radius": radius,
      "lat": lat,
      "lng": lng,
      "filter_subcategory_id": filter_subcategory_id,
      "filter_custome_filed_id": filter_custome_filed_id,
      "filter_min": filter_min,
      "filter_max": filter_max,
      "sort_by_price": priceSort,
      "ads_title": ads_title!=null && ads_title.isNotEmpty? ads_title:"",
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
    //http secure connection
    var http = makeHttpSecure();
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
    //http secure connection
    var http = makeHttpSecure();
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
    //http secure connection
    var http = makeHttpSecure();
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
    //http secure connection
    var http = makeHttpSecure();
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
    //http secure connection
    var http = makeHttpSecure();
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

  Future<CommonResponse> callUpdateUser(
      String token,
      String username,
      String aboutus,
      String contact,
      String email,
      String address,
      File imageFile,
      String profile_setting) async {
    bool status = false;
    CommonResponse response;
    debugPrint("SETTINGS ${profile_setting}");
    address = "dummy";
    if (imageFile != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length(); //imageFile is your image file
      Map<String, String> mainheader = {"token": token};
      var uri = Uri.parse(BASE_URL + GET_USER_DATA);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFileSign = new http.MultipartFile(
          'profile_picture', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFileSign);
      request.headers.addAll(mainheader);
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['contact'] = contact;
      request.fields['address'] = address;
      request.fields['profile_setting'] = profile_setting;
      var res = await request.send();
      var resss = await http.Response.fromStream(res);
      debugPrint("PRRRR ${resss.body}");
      response =  CommonResponse.fromJson(json.decode(resss.body));
    } else {
      //http secure connection
      var http = makeHttpSecure();
      Map<String, String> mainheader = {"token": token};
      var res = await http.post(BASE_URL + GET_USER_DATA,
          headers: mainheader,
          body: {
            "username": username,
            "email": email,
            "contact": contact,
            "address": address,
            "profile_setting": profile_setting
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

  Future<SaveFavouriteRes> callSavefavouriteApi(
      String token, String ad_id) async {
    bool status = false;
    SaveFavouriteRes response;
    print("UNDER callSavefavouriteApi ${token}, ${ad_id}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(BASE_URL + SAVE_FAVOURITE,
        headers: mainheader, body: {"ad_id": ad_id});
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
    var res = await http.get(BASE_URL + MY_FAVOURITE, headers: mainheader);
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
    var res = await http.post(BASE_URL + GET_SELLER_INFO,
        headers: mainheader, body: {"seller_id": sellerId});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = SellerInfoRes.fromJson(data);
      print("-----------${data}");
    } else {
      response =
          new SellerInfoRes(message: API_ERROR_MSG, status: false, data: null);
    }
    return response;
  }

  Future<NewChatlistRes> callGetAllChatUserApi(String token) async {
    NewChatlistRes response;
    print("UNDER NewChatlistRes ${token} ");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + GET_NEW_CHAT_LIST /*+ GET_CHAT_LIST*/,
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      response = NewChatlistRes.fromJson(data);
      print("-----------${data}");
    } else {
      response =
          new NewChatlistRes(msg: API_ERROR_MSG, status: "false", data: null);
    }
    return response;
  }

  Future<NewInboxChatRes> callGetAllChatMsgApi(
      String token, String indexId, String adId) async {
    NewInboxChatRes response;
    print(
        "UNDER callGetAllChatMsgApi ${BASE_URL + NEW_INBOX_CHAT + "/${adId}/${indexId}"} ${token}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + NEW_INBOX_CHAT + "/${adId}/${indexId}",
      headers: mainheader,
    );
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      response = NewInboxChatRes.fromJson(data);
      print("-----------${data}");
    } else {
      response =
          new NewInboxChatRes(msg: API_ERROR_MSG, status: "false", data: null);
    }
    return response;
  }

  Future<GetAllChatMsgRes> callGetSlugChatMsgApi(
      String token, String slug) async {
    bool status = false;
    GetAllChatMsgRes response;
    print(
        "UNDER callGetSlugChatMsgApi ${BASE_URL + GET_CHAT_LIST + "/${slug}"},  ${token} , ");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
      BASE_URL + GET_CHAT_LIST + "/${slug}",
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

  Future<CommonResponse> callSendMsgApi(String token, String adId, String msg,
      String recieverId, String inboxId) async {
    CommonResponse response;
    print(
        "UNDER callSendMsgApi ${adId}, ${recieverId}, ${inboxId}, ${msg}, ${token} , ${BASE_URL + SEND_MESSAGE}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(BASE_URL + SEND_MESSAGE,
        headers: mainheader,
        body: {
          "ad_id": adId,
          "receiver_id": recieverId,
          "message": msg,
          "inbox_id": inboxId
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
    return response;
  }

  Future<GetMyPackageListRes> callGetMyPackageList(String token) async {
    GetMyPackageListRes response;
    print(
        "UNDER callGetMyPackageList ${token} , ${BASE_URL + MY_PACKAGE_LIST}");
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

  Future<GetCustomFieldsResponse> callCustomFields(
      String token, String subcategory_id) async {
    GetCustomFieldsResponse response;
    print(
        "UNDER callCustomFields  ${BASE_URL + SUBCATEGORY_CUSTOM_FIELDS}, ${subcategory_id}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(BASE_URL + SUBCATEGORY_CUSTOM_FIELDS,
        headers: mainheader, body: {"subcategory_id": subcategory_id});
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

  Future<CommonResponse> callPostAds(
      String token, AdPostReqModel adPostReqModel) async {
    CommonResponse response;

    debugPrint("ADPOST_REQ custfield --> ${adPostReqModel.customFields}");

    Map<String, String> mainheader = {"token": token};
    var uri = Uri.parse(BASE_URL + POST_ADS);
    var request = new http.MultipartRequest("POST", uri);

    if (adPostReqModel.imgPath1.isNotEmpty && adPostReqModel.img1 != null) {
      debugPrint("ADPOST_REQ entry img1");
      var stream = new http.ByteStream(
          DelegatingStream.typed(adPostReqModel.img1.openRead()));
      var length = await adPostReqModel.img1.length(); //imageFile is your image
      var multipartFileSign = new http.MultipartFile('img_1', stream, length,
          filename: basename(adPostReqModel.img1.path));
      request.files.add(multipartFileSign);
      debugPrint("ADPOST_REQ end img1 ");
    }
    if (adPostReqModel.imgPath2.isNotEmpty && adPostReqModel.img2 != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(adPostReqModel.img2.openRead()));
      var length = await adPostReqModel.img2.length(); //imageFile is your image
      var multipartFileSign = new http.MultipartFile('img_2', stream, length,
          filename: basename(adPostReqModel.img2.path));
      request.files.add(multipartFileSign);
    }
    if (adPostReqModel.imgPath3.isNotEmpty && adPostReqModel.img3 != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(adPostReqModel.img3.openRead()));
      var length = await adPostReqModel.img3.length(); //imageFile is your image
      var multipartFileSign = new http.MultipartFile('img_3', stream, length,
          filename: basename(adPostReqModel.img3.path));
      request.files.add(multipartFileSign);
    }
    request.headers.addAll(mainheader);
    request.fields['category'] = adPostReqModel.categoryId;
    request.fields['subcategory'] = adPostReqModel.subCategoryId;
    request.fields['title'] = adPostReqModel.title;
    request.fields['price'] = adPostReqModel.price;
    request.fields['tags'] = adPostReqModel.tags;
    request.fields['description'] = adPostReqModel.desc;
    request.fields['user_package_id'] = adPostReqModel.packageId;
    request.fields['address'] = adPostReqModel.address;
    request.fields['address-lat'] = adPostReqModel.addresslat;
    request.fields['address-lang'] = adPostReqModel.addresslng;
    request.fields['rent_type_id'] = adPostReqModel.rentTypeId;
    request.fields['custome_field'] = adPostReqModel.customFields;

    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.categoryId}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.subCategoryId}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.title}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.price}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.tags}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.desc}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.packageId}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.address}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.addresslat}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.addresslng}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.rentTypeId}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.customFields}");

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      return CommonResponse(
          status: "success", msg: "Your ad has been created successfully");
    } else {
      var resStr = await res.stream.transform(utf8.decoder);
      resStr.listen((value) {
        print(value);
        response = CommonResponse.fromJson(jsonDecode(value));
        return response;
      });
      debugPrint("END_POSTAD");
    }
//    var resStr = await res.stream.transform(utf8.decoder);
//    resStr.listen((value) {
//      print(value);
//      response = CommonResponse.fromJson(jsonDecode(value));
////      response = CommonResponse.fromJson(value);
//      return response;
//    });
//    debugPrint("END_POSTAD");
//    return response;
  }

  Future<PaymentRes> callPackagePayment(
      String token, String packageId, String amt, String pgRes) async {
    PaymentRes response;
    print("UNDER callPackagePayment ${BASE_URL + PACKAGE_PAYMENT}, ${packageId}, ${amt}");
    Map<String, String> mainheader = {"token": token};
    var res =
        await http.post(BASE_URL + PACKAGE_PAYMENT, headers: mainheader, body: {
      "package_id": packageId,
      "amount": amt,
      "payment_status": "1",
      "gateway_response": pgRes
    });
    print(
        "PRINTING_REQ {package_id: $packageId, amount $amt , payment_status 1 , gateway_response $pgRes}");
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = PaymentRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new PaymentRes();
    }
    return response;
  }

  Future<MyAdsListRes> callGetMyAdsList(String token) async {
    MyAdsListRes response;
    print("UNDER callGetMyAdsList ${token} , ${BASE_URL + GET_MY_ADS}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.get(BASE_URL + GET_MY_ADS, headers: mainheader);
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = MyAdsListRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new MyAdsListRes();
    }
    return response;
  }

  Future<MyAdsEditRes> callGetMyAdEdit(String token, String adId) async {
    MyAdsEditRes response;
    print(
        "UNDER callGetMyAdEdit , ${BASE_URL + GET_AD_EDIT}, ${adId} ");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(BASE_URL + GET_AD_EDIT,
        headers: mainheader, body: {"ad_id": adId});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = MyAdsEditRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new MyAdsEditRes();
    }
    return response;
  }

  Future<AdDeleteRes> callDeleteAd(String token, String adId) async {
    AdDeleteRes response;
    print("UNDER callDeleteAd ${token} , ${BASE_URL + AD_DELETE}, ${adId} ");
    Map<String, String> mainheader = {"token": token};
    var res = await http
        .post(BASE_URL + AD_DELETE, headers: mainheader, body: {"ad_id": adId});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = AdDeleteRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new AdDeleteRes();
    }
    return response;
  }

  Future<CommonResponse> callEditAds(
      String token, AdPostReqModel adPostReqModel) async {
    CommonResponse response;

    debugPrint("EDITPOST_REQ entry");
    Map<String, String> mainheader = {"token": token};
    var uri = Uri.parse(BASE_URL + POST_AD_EDIT_UPDATE);
    var request = new http.MultipartRequest("POST", uri);

    if (adPostReqModel.imgPath1.isNotEmpty && adPostReqModel.img1 != null) {
      debugPrint("ADEDIT_REQ entry img1");
      var stream = new http.ByteStream(
          DelegatingStream.typed(adPostReqModel.img1.openRead()));
      var length = await adPostReqModel.img1.length(); //imageFile is your image
      var multipartFileSign = new http.MultipartFile('img_1', stream, length,
          filename: basename(adPostReqModel.img1.path));
      request.files.add(multipartFileSign);
      debugPrint("ADEDIT_REQ end img1 ");
    }
    if (adPostReqModel.imgPath2.isNotEmpty && adPostReqModel.img2 != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(adPostReqModel.img2.openRead()));
      var length = await adPostReqModel.img2.length(); //imageFile is your image
      var multipartFileSign = new http.MultipartFile('img_2', stream, length,
          filename: basename(adPostReqModel.img2.path));
      request.files.add(multipartFileSign);
    }
    if (adPostReqModel.imgPath3.isNotEmpty && adPostReqModel.img3 != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(adPostReqModel.img3.openRead()));
      var length = await adPostReqModel.img3.length(); //imageFile is your image
      var multipartFileSign = new http.MultipartFile('img_3', stream, length,
          filename: basename(adPostReqModel.img3.path));
      request.files.add(multipartFileSign);
    }
    request.headers.addAll(mainheader);
    request.fields['ad_id'] = adPostReqModel.adId;
    request.fields['category'] = adPostReqModel.categoryId;
    request.fields['subcategory'] = adPostReqModel.subCategoryId;
    request.fields['title'] = adPostReqModel.title;
    request.fields['price'] = adPostReqModel.price;
    request.fields['tags'] = adPostReqModel.tags;
    request.fields['description'] = adPostReqModel.desc;
    request.fields['address'] = adPostReqModel.address;
    request.fields['address-lat'] = adPostReqModel.addresslat;
    request.fields['address-lang'] = adPostReqModel.addresslng;
    request.fields['rent_type_id'] = adPostReqModel.rentTypeId;
    request.fields['custome_field'] = adPostReqModel.customFields;

//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.categoryId}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.subCategoryId}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.title}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.price}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.tags}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.desc}");
////    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.packageId}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.address}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.addresslat}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.addresslng}");
//    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.rentTypeId}");
    debugPrint("ADPOST_REQ entry --> ${adPostReqModel.customFields}");

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      return CommonResponse(
          status: "success", msg: "Your ad has been updated successfully");
    } else {
      var resStr = await res.stream.transform(utf8.decoder);
      resStr.listen((value) {
        print(value);
        response = CommonResponse.fromJson(jsonDecode(value));
        return response;
      });
      debugPrint("END_EDITAD");
    }
//    var resStr = await res.stream.transform(utf8.decoder);
//    resStr.listen((value) {
//      print(value);
//      response = CommonResponse.fromJson(jsonDecode(value));
////      response = CommonResponse.fromJson(value);
//      return response;
//    });
//    debugPrint("END_POSTAD");
//    return response;
  }

  Future<CommonResponse> callSendOtp(String contact, String otpType) async {
    CommonResponse response;
    print("UNDER callSendOtp ${contact} , ${BASE_URL + SEND_OTP}");
    var res = await http.post(BASE_URL + SEND_OTP,
        body: {"contact": contact, "otp_type": otpType});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CommonResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CommonResponse();
    }
    return response;
  }

  Future<CommonResponse> callVerifyOtp(String contact, String otp) async {
    CommonResponse response;
    print("UNDER callVerifyOtp ${contact} , ${BASE_URL + VERIFY_OTP}");
    var res = await http
        .post(BASE_URL + VERIFY_OTP, body: {"contact": contact, "otp": otp});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CommonResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CommonResponse();
    }
    return response;
  }

  Future<CommonResponse> callForgotPwd(
      String contact, String otp, String confirm_password) async {
    CommonResponse response;
    print("UNDER callSendOtp ${contact} , ${BASE_URL + SEND_OTP}");
    var res = await http.post(BASE_URL + FORGOT_PWD, body: {
      "contact": contact,
      "otp": otp,
      "confirm_password": confirm_password
    });
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CommonResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CommonResponse();
    }
    return response;
  }

  Future<CommonResponse> callRating(
      String token, String seller_id, String user_id, String rating) async {
    CommonResponse response;
    print("UNDER callRating ${seller_id} , ${BASE_URL + RATING}");
    Map<String, String> mainheader = {"token": token};
    var res = await http.post(BASE_URL + RATING,
        headers: mainheader,
        body: {"seller_id": seller_id, "user_id": user_id, "rating": rating});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CommonResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CommonResponse();
    }
    return response;
  }

  Future<GooglePlacesRes> callGooglePlaces(String token, String query) async {
    GooglePlacesRes response;
    print(
        "UNDER callGooglePlaces ${query} , ${GOOGLE_AUTOCOMPLETE1}${query}${GOOGLE_AUTOCOMPLETE2}${GOOGLE_API_KEY}");
//    Map<String, String> mainheader = {"token": token};
    var res = await http.get(
        "${GOOGLE_AUTOCOMPLETE1}${query}${GOOGLE_AUTOCOMPLETE2}${GOOGLE_API_KEY}");
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = GooglePlacesRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new GooglePlacesRes();
    }
    return response;
  }

  Future<CouponRes> callCouponRes(String lat, String lng) async {
    CouponRes response;
    print("UNDER callCouponRes lat ${lat}, lng ${lng} , ${BASE_URL + COUPON}");
    var res =
        await http.post(BASE_URL + COUPON, body: {"lat": lat, "lng": lng});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CouponRes.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CouponRes();
    }
    return response;
  }

  Future<CommonResponse> callChatDelete(String token,String inbox_id) async {
    CommonResponse response;
    print("UNDER callChatDelete inbox_id ${inbox_id} , ${BASE_URL + CHAT_DELETE}");
    Map<String, String> mainheader = {"token": token};
    var res =
        await http.post(BASE_URL + CHAT_DELETE,
            headers: mainheader,
            body: {"inbox_id": inbox_id});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CommonResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CommonResponse();
    }
    return response;
  }

  Future<CommonResponse> callReadChat(String token,String inbox_id) async {
    CommonResponse response;
    print("UNDER callReadChat inbox_id ${inbox_id} , ${BASE_URL + READ_CHAT}");
    Map<String, String> mainheader = {"token": token};
    var res =
        await http.post(BASE_URL + READ_CHAT,
            headers: mainheader,
            body: {"inbox_id": inbox_id});
    print("PRINTING ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var status = data["status"];
      print("PRINTING_STATUS ${status}");
      response = CommonResponse.fromJson(data);
      print("-----------${data}");
    } else {
      response = new CommonResponse();
    }
    return response;
  }

  @override
  void dispose() {}
}
