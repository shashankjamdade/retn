
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/item_detail_response.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/model/location_search_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
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
    var res = await http
        .get(BASE_URL + HOMEPAGE_API, headers: {"Token":token});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      if(status){
        response = HomeResponse.fromJson(data);
      }else{
        response = HomeResponse.fromJson(data);
        print("-----------${data}");
      }
    }
    return response;
  }

  Future<ItemDetailResponse> callItemDetailApi(String token, String categoryName) async {
    bool status = false;
    ItemDetailResponse response;
    int code = 0;
    print("UNDER callItemDetailApi ${categoryName}");
    var res = await http
        .get(BASE_URL + ITEMDETAIL_API+ "?title=${categoryName}", headers: {"Token":token}, );
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
//      status = data["status"];
//      print("PRINTING_STATUS ${status}");
//      if(status){
        response = ItemDetailResponse.fromJson(data);
//      }else{
//        response = ItemDetailResponse.fromJson(data);
//        print("-----------${data}");
//      }
    }
    return response;
  }

  Future<SearchLocationResponse> callLocaitonSearchApi(String token, String searchKey) async {
    bool status = false;
    SearchLocationResponse response;
    int code = 0;
    print("UNDER callLocaitonSearchApi -- ${searchKey}");
    var res = await http
        .post(BASE_URL + LOCATION_SEARCH_API, headers: {"Token":token}, body:{"search": searchKey});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      if(status){
        response = SearchLocationResponse.fromJson(data);
      }else{
        response = SearchLocationResponse.fromJson(data);
        print("-----------${data}");
      }
    }
    return response;
  }

  Future<SearchCategoryResponse> callSubCategorySearchApi(String token, String searchKey) async {
    bool status = false;
    SearchCategoryResponse response;
    int code = 0;
    print("UNDER SearchSubCategoryResponse -- ${searchKey} ${BASE_URL + SEARCH_SUBCATEGORY_LIST_API}");
    var res = await http
        .post(BASE_URL + SEARCH_SUBCATEGORY_LIST_API, headers: {"Token":token}, body:{"search": searchKey});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      if(status){
        response = SearchCategoryResponse.fromJson(data);
      }else{
        response = SearchCategoryResponse.fromJson(data);
        print("-----------${data}");
      }
    }
    return response;
  }

  Future<SubCategoryListResponse> callSubCategoryListApi(String token, String category_id) async {
    bool status = false;
    SubCategoryListResponse response;
    int code = 0;
    print("UNDER SubCategoryListResponse ${category_id}");
    var res = await http
        .post(BASE_URL + SUBCATEGORY_LIST_API, headers: {"Token":token}, body:{"category_id": category_id});
    print("PRINTING ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      if(status){
        response = SubCategoryListResponse.fromJson(data);
      }else{
        response = SubCategoryListResponse.fromJson(data);
        print("-----------${data}");
      }
    }
    return response;
  }

  Future<NearbySubChildCategoryListResponse> callNearbySubChildCategoryListApi(String token, String categoryId,
      String subCategoryId, String radius, String lat, String lng) async {
    bool status = false;
    NearbySubChildCategoryListResponse response;
    int code = 0;
    print("UNDER NearbySubChildCategoryListResponse ${categoryId} ${BASE_URL + ADS_SEARCH_API}");
    print("PRINTING_REQ NearbySubChild --> ${ "category_id "+ categoryId+
        ",subcategory_id"+ subCategoryId+
        ",radius"+ radius+
        ",lat"+ lat+
        ",lng"+ lng}");
    var res = await http
        .post(BASE_URL + ADS_SEARCH_API, headers: {"Token":token},
        body:{
          "category_id": categoryId,
          "subcategory_id": subCategoryId,
          "radius": radius,
          "lat": lat,
          "lng": lng,
    }
    );
    print("PRINTING NearbySubChild ${res.body}");
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      print("PRINTING_STATUS ${status}");
      if(status){
        response = NearbySubChildCategoryListResponse.fromJson(data);
      }else{
        response = NearbySubChildCategoryListResponse.fromJson(data);
        print("-----------${data}");
      }
    }
    return response;
  }

  @override
  void dispose() {
  }

}