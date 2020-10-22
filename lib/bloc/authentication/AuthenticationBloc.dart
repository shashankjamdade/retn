import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/model/RegisterReq.dart';
import 'package:flutter_rentry/repository/AuthenticationRepository.dart';
import 'AuthenticationEvent.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationState.dart';

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
    }else if(event is LoginReqAuthenticationEvent){
      yield ProgressAuthenticationState();
      yield* makeLogin(event.emailOrMobile, event.password);
    }else if(event is RegisterReqAuthenticationEvent){
      yield ProgressAuthenticationState();
      yield* makeRegister(RegisterReq(event.name, event.mobile, event.email, event.password));
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


}
