import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialAuthenticationEvent extends AuthenticationEvent{}
class CheckLoggedInEvent extends AuthenticationEvent{}
class ProgressAuthenticationEvent extends AuthenticationEvent{}
class NonProgressAuthenticationEvent extends AuthenticationEvent{}

class LoginReqAuthenticationEvent extends AuthenticationEvent{
  final String emailOrMobile;
  final String password;
  LoginReqAuthenticationEvent(
      {@required this.emailOrMobile, @required this.password});

  @override
  List<Object> get props => [emailOrMobile, password];
}

class SocialLoginReqAuthenticationEvent extends AuthenticationEvent{
  final String emailOrMobile;
  SocialLoginReqAuthenticationEvent(
      {@required this.emailOrMobile});

  @override
  List<Object> get props => [emailOrMobile];
}

class RegisterReqAuthenticationEvent extends AuthenticationEvent{
  final String name;
  final String mobile;
  final String email;
  final String password;
  final String loginType;
  final String otp;
  final String deviceToken;
  RegisterReqAuthenticationEvent(
      {@required this.name, @required this.mobile, @required this.email, @required this.password, @required this.loginType, @required this.otp, @required this.deviceToken});

  @override
  List<Object> get props => [name, mobile, email, password, otp, deviceToken];
}


class OtpVerifyReqAuthenticationEvent extends AuthenticationEvent{}

class SuccessAuthenticationEvent extends AuthenticationEvent{}
class FailureAuthenticationEvent extends AuthenticationEvent{}

class LoginInViaFacebookEvent extends AuthenticationEvent {}
class LoginInViaGoogleEvent extends AuthenticationEvent {}
