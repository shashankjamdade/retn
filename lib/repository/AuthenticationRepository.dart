import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_rentry_new/model/GoogleFbLoginResponse.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:http/io_client.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'base_repository.dart';
import 'package:http/http.dart' as http;
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository extends BaseRepository {
  final http.Client _httpClient;

  AuthenticationRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<LoginResponse> callLogin(String mobileOrEmail, String password, String token) async {
    bool status = false;
    LoginResponse response;
    int code = 0;
    debugPrint("TOKEN--> ${token}");
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var res = await http.post(BASE_URL + LOGIN_API,
        body: {"email": mobileOrEmail, "password": password, "device_token": token});
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

  Future<LoginResponse> callSocialLogin(String email, String deviceToken) async {
    debugPrint("FB_EMAIL3-->> ${email}");
    bool status = false;
    LoginResponse response;
    int code = 0;
    debugPrint("TOKEN--> ${deviceToken}");
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var res = await http.post(BASE_URL + SOCIAL_LOGIN_API,
        body: {"email": email,  "device_token": deviceToken});
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

  Future<LoginResponse> callRegister(RegisterReq registerReq) async {
    LoginResponse response;
    debugPrint("REGISTRATION_REQ-- ${{
      "username": registerReq.name,
      "email": registerReq.email,
      "contact": registerReq.mobile,
      "password": registerReq.password,
      "login_type":registerReq.login_type,
      "otp":registerReq.otp,
      "device_token": registerReq.deviceToken,
      "referralcode": registerReq.reffCode
    }}");
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var res = await http.post(BASE_URL + REGISTRATION_API, body: {
      "username": registerReq.name,
      "email": registerReq.email,
      "contact": registerReq.mobile,
      "password": registerReq.password,
      "login_type": registerReq.login_type,
      "otp": registerReq.otp,
      "device_token": registerReq.deviceToken,
      "referralcode": registerReq.reffCode
    });
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      response = LoginResponse.fromJson(data);
    } else {
      response = LoginResponse(status: false, message: API_ERROR_MSG);
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
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
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

  // Determine if Apple SignIn is available
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<User> appleSignIn() async {
    try {
      FirebaseAuth.instance.signOut();
      final AuthorizationResult appleResult = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        debugPrint("Firebase_APPLE_LOGIN_ERROR ${appleResult.error}");
      }

      final AuthCredential credential = OAuthProvider('apple.com').getCredential(
        accessToken: String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      var firebaseResult = await FirebaseAuth.instance.signInWithCredential(credential);
      User user = firebaseResult.user;

      // Optional, Update user data in Firestore
      // updateUserData(user);
      debugPrint("Firebase_APPLE_LOGIN ${user?.email}");
      debugPrint("Firebase_APPLE_LOGIN_name ${user?.displayName}");
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
