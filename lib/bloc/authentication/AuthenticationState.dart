import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rentry_new/model/GoogleFbLoginResponse.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';

abstract class AuthenticationState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialAuthenticationState extends AuthenticationState {}
class ProgressAuthenticationState extends AuthenticationState {}
class NonProgressAuthenticationState extends AuthenticationState {}
class SuccessAuthenticationState extends AuthenticationState {
  final obj;
  SuccessAuthenticationState({@required this.obj});
  @override
  List<Object> get props => [obj];
}

class CheckLoggedInState extends AuthenticationState {
  final obj;
  CheckLoggedInState({@required this.obj});
  @override
  List<bool> get props => [obj];
}

class FailedAuthenticationState extends AuthenticationState {
  final obj;
  FailedAuthenticationState({@required this.obj});
  @override
  List<Object> get props => [obj];
}

class LoginResAuthenticationState extends AuthenticationState {
  final res;
  LoginResAuthenticationState({@required this.res});
  @override
  List<LoginResponse> get props => [res];
}

class GoogleFbLoginResAuthenticationState extends AuthenticationState {
  final res;
  GoogleFbLoginResAuthenticationState({@required this.res});
  @override
  List<GoogleFbLoginResponse> get props => [res];
}

class RegisterResAuthenticationState extends AuthenticationState {
  final res;
  RegisterResAuthenticationState({@required this.res});
  @override
  List<LoginResponse> get props => [res];
}

