import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/repository/AuthenticationRepository.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepository _authenticationService;
  HomeRepository homeRepository;

  AuthenticationBloc() : super(null) {
    _authenticationService = AuthenticationRepository();
  }

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is InitialAuthenticationEvent) {
      yield InitialAuthenticationState();
    } else if (event is CheckLoggedInEvent) {
      yield* checkLoggedIn();
    } else if (event is MakeLogout) {
      yield* makeLogout();
    } else if (event is LoginReqAuthenticationEvent) {
      yield ProgressAuthenticationState();
      yield* makeLogin(event.emailOrMobile, event.password, event.deviceToken);
    } else if (event is SocialLoginReqAuthenticationEvent) {
      yield ProgressAuthenticationState();
      yield* makeSocialLogin(event.emailOrMobile, event.deviceToken);
    } else if (event is RegisterReqAuthenticationEvent) {
      yield ProgressAuthenticationState();
      yield* makeRegister(RegisterReq(event.name, event.mobile, event.email,
          event.password, event.loginType, event.otp, event.deviceToken, event.reffCode));
    } else if (event is LoginInViaFacebookEvent) {
      yield ProgressAuthenticationState();
      yield* makeFbLogin();
    }else if (event is SendOtpAuthEvent) {
      yield ProgressAuthenticationState();
      yield* callSendOtp(event.contact, event.otpType);
    }
  }

  Stream<AuthenticationState> checkLoggedIn() async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = (prefs.getString(USER_NAME) != null &&
              prefs.getString(USER_NAME).isNotEmpty)
          ? true
          : false;
      if (isLoggedIn) {
        debugPrint("PREFS_READ -- ${prefs.getString(USER_NAME)}");
        var response =
            LoginResponse.fromJson(jsonDecode(prefs.getString(USER_LOGIN_RES)));
        yield CheckLoggedInState(obj: response);
      } else {
        yield CheckLoggedInState(obj: null);
      }
    } catch (e) {
      debugPrint("Exception while checkLoggedIn ${e.toString()}");
    }
  }

  Stream<AuthenticationState> makeLogout() async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      yield LogoutAuthentucateState();
    } catch (e) {
      debugPrint("Exception while makeLogout ${e.toString()}");
    }
  }

  Stream<AuthenticationState> makeLogin(
      String emailOrMobile, String password, String token) async* {
    try {
      final loginResponse =
          await _authenticationService.callLogin(emailOrMobile, password, token);
      yield LoginResAuthenticationState(res: loginResponse);
    } catch (e, stacktrace) {
      debugPrint("Exception while nativeLogin ${e.toString()}\n ${stacktrace}");
    }
  }

  Stream<AuthenticationState> makeSocialLogin(String email, String deviceToken) async* {
    try {
      debugPrint("FB_EMAIL2-->> ${email}");
      final loginResponse = await _authenticationService.callSocialLogin(email, deviceToken);
      yield LoginResAuthenticationState(res: loginResponse);
    } catch (e, stacktrace) {
      debugPrint("Exception while nativeLogin ${e.toString()} \n ${stacktrace.toString()}");
    }
  }

  Stream<AuthenticationState> makeRegister(RegisterReq registerReq) async* {
    try {
      final registerResponse =
          await _authenticationService.callRegister(registerReq);
      yield RegisterResAuthenticationState(res: registerResponse);
    } catch (e, stacktrace) {
      debugPrint("Exception while nativeLogin ${e.toString()} \n ${stacktrace.toString()}");
    }
  }

  Stream<AuthenticationState> makeFbLogin() async* {
    try {
      final loginResponse = await _authenticationService.loginViaFacebook();
      debugPrint(
          "FB_LOGIN_RESStatus-- " + loginResponse.loginStatus.toString());
      yield GoogleFbLoginResAuthenticationState(res: loginResponse);
    } catch (e) {
      debugPrint("Exception while fblogin ${e.toString()}");
    }
  }

  Stream<AuthenticationState> callSendOtp(String contact, String otpType) async* {
    try {
      homeRepository =
     homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "callSendOtp ${contact} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final commonResponse =
      await homeRepository.callSendOtp(contact, otpType);
      debugPrint("callSendOtp ${jsonEncode(commonResponse)}");
      yield SendOtpAuthState(res: commonResponse);
    } catch (e) {
      debugPrint("Exception while callSendOtp ${e.toString()}");
    }
  }
}
