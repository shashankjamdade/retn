
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry/model/RegisterReq.dart';
import 'package:flutter_rentry/model/home_response.dart';
import 'package:flutter_rentry/model/item_detail_response.dart';
import 'package:flutter_rentry/model/location_search_response.dart';
import 'package:flutter_rentry/model/login_response.dart';
import 'package:flutter_rentry/model/register_response.dart';
import 'package:flutter_rentry/model/search_sub_category_response.dart';
import 'package:flutter_rentry/model/sub_category_list_response.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';

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
    print("UNDER callItemDetailApi ");
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

  Future<SearchSubCategoryResponse> callSubCategorySearchApi(String token, String searchKey) async {
    bool status = false;
    SearchSubCategoryResponse response;
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
        response = SearchSubCategoryResponse.fromJson(data);
      }else{
        response = SearchSubCategoryResponse.fromJson(data);
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

  @override
  void dispose() {
    // TODO: implement dispose
  }

}