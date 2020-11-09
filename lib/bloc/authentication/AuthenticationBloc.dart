import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/model/RegisterReq.dart';
import 'package:flutter_rentry_new/repository/AuthenticationRepository.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationRepository _authenticationService;

  AuthenticationBloc(){
    _authenticationService = AuthenticationRepository();
  }

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if(event is InitialAuthenticationEvent){
      yield InitialAuthenticationState();
    }else if(event is CheckLoggedInEvent){
      yield* checkLoggedIn();
    }else if(event is LoginReqAuthenticationEvent){
      yield ProgressAuthenticationState();
      yield* makeLogin(event.emailOrMobile, event.password);
    }else if(event is RegisterReqAuthenticationEvent){
      yield ProgressAuthenticationState();
      yield* makeRegister(RegisterReq(event.name, event.mobile, event.email, event.password));
    }else if(event is LoginInViaFacebookEvent){
      yield ProgressAuthenticationState();
      yield* makeFbLogin();
    }
  }

  Stream<AuthenticationState> checkLoggedIn() async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = (prefs.getString(USER_NAME)!=null && prefs.getString(USER_NAME).isNotEmpty)?true:false;
      debugPrint("PREFS_READ -- ${prefs.getString(USER_NAME)}");
      yield CheckLoggedInState(obj: isLoggedIn);
    } catch (e) {
      debugPrint("Exception while checkLoggedIn ${e.toString()}");
    }
  }

  Stream<AuthenticationState> makeLogin(String emailOrMobile, String password) async* {
    try {
      final loginResponse = await _authenticationService.callLogin(emailOrMobile, password);
      yield LoginResAuthenticationState(res: loginResponse);
    } catch (e) {
      debugPrint("Exception while nativeLogin ${e.toString()}");
    }
  }

  Stream<AuthenticationState> makeRegister(RegisterReq registerReq) async* {
    try {
      final registerResponse = await _authenticationService.callRegister(registerReq);
      yield RegisterResAuthenticationState(res: registerResponse);
    } catch (e) {
      debugPrint("Exception while nativeLogin ${e.toString()}");
    }
  }

  Stream<AuthenticationState> makeFbLogin() async* {
    try {
      final loginResponse = await _authenticationService.loginViaFacebook();
      debugPrint("FB_LOGIN_RESStatus "+loginResponse.loginStatus.toString());
      yield GoogleFbLoginResAuthenticationState(res: loginResponse);
    } catch (e) {
      debugPrint("Exception while fblogin ${e.toString()}");
    }
  }



}
