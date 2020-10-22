
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry/model/RegisterReq.dart';
import 'package:flutter_rentry/model/login_response.dart';
import 'package:flutter_rentry/model/register_response.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';

import 'base_repository.dart';
import 'package:http/http.dart' as http;

class AuthenticationRepository extends BaseRepository {

  final http.Client _httpClient;

  AuthenticationRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();


  Future<LoginResponse> callLogin(String mobileOrEmail, String password) async {
    bool status = false;
    LoginResponse response;
    int code = 0;
    var res = await http
        .post(BASE_URL + LOGIN_API, body: {"email":mobileOrEmail, "password": password});
    print(res.body);
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      if(status){
        debugPrint("LOGINRES -- > ");
        response = LoginResponse.fromJson(data);
        debugPrint("LOGINRES -- > ${jsonEncode(response)}");
      }else{
        response = LoginResponse.fromJson(data);
        print("-----------${data}");
      }
    }
    return response;
  }


  Future<RegisterResponse> callRegister(RegisterReq registerReq) async {
    RegisterResponse response;
    debugPrint("REGISTRATION_REQ-- ${{"username":registerReq.name, "email": registerReq.email, "contact": registerReq.mobile, "password":registerReq.password}}");
    var res = await http
        .post(BASE_URL + REGISTRATION_API, body: {"username":registerReq.name, "email": registerReq.email, "contact": registerReq.mobile, "password":registerReq.password});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      response = RegisterResponse.fromJson(data);
    }else {
      response = RegisterResponse(status: false, message: "${res.statusCode}");
    }
    print("-----------${jsonEncode(response)}");
    return response;
  }


  @override
  void dispose() {
    // TODO: implement dispose
  }

}