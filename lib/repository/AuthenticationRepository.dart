import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_rentry_new/model/GoogleFbLoginResponse.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';

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
    var res = await http.post(BASE_URL + LOGIN_API,
        body: {"email": mobileOrEmail, "password": password});
    print(res.body);
    code = res.statusCode;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      status = data["status"];
      if (status) {
        debugPrint("LOGINRES -- > ");
        response = LoginResponse.fromJson(data);
        debugPrint("LOGINRES -- > ${jsonEncode(response)}");
      } else {
        response = LoginResponse.fromJson(data);
        print("-----------${data}");
      }
    } else {
      response = new LoginResponse(status: false, message: API_ERROR_MSG);
    }
    return response;
  }

  Future<RegisterResponse> callRegister(RegisterReq registerReq) async {
    RegisterResponse response;
    debugPrint("REGISTRATION_REQ-- ${{
      "username": registerReq.name,
      "email": registerReq.email,
      "contact": registerReq.mobile,
      "password": registerReq.password
    }}");
    var res = await http.post(BASE_URL + REGISTRATION_API, body: {
      "username": registerReq.name,
      "email": registerReq.email,
      "contact": registerReq.mobile,
      "password": registerReq.password
    });
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      response = RegisterResponse.fromJson(data);
    } else {
      response = RegisterResponse(status: false, message: API_ERROR_MSG);
    }
    print("-----------${jsonEncode(response)}");
    return response;
  }

  //Login Via Facebook
  Future<GoogleFbLoginResponse> loginViaFacebook() async {
    Map userProfile;
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    GoogleFbLoginResponse fbLoginResponse = GoogleFbLoginResponse(
        loginStatus: LOGGEDIN_CANCELLED, map: null, loginType: "fb");
//    debugPrint("ERRMSG "+result.errorMessage);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email,link&access_token=${token}');
        final profile = jsonDecode(graphResponse.body);
        debugPrint("FB_RES " + jsonEncode(graphResponse.body));
        userProfile = profile;
        fbLoginResponse = GoogleFbLoginResponse(
            loginStatus: LOGGEDIN_SUCCESS, map: userProfile, loginType: "fb");
        break;

      case FacebookLoginStatus.cancelledByUser:
        fbLoginResponse = GoogleFbLoginResponse(
            loginStatus: LOGGEDIN_CANCELLED, map: userProfile, loginType: "fb");
        break;
      case FacebookLoginStatus.error:
        fbLoginResponse = GoogleFbLoginResponse(
            loginStatus: LOGGEDIN_ERROR, map: userProfile, loginType: "fb");
        break;
    }

    return fbLoginResponse;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
