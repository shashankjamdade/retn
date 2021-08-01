import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialAuthenticationEvent extends AuthenticationEvent{}
class CheckLoggedInEvent extends AuthenticationEvent{}
class MakeLogout extends AuthenticationEvent{}
class ProgressAuthenticationEvent extends AuthenticationEvent{}
class NonProgressAuthenticationEvent extends AuthenticationEvent{}

class LoginReqAuthenticationEvent extends AuthenticationEvent{
  final String emailOrMobile;
  final String password;
  final String deviceToken;
  LoginReqAuthenticationEvent(
      {@required this.emailOrMobile, @required this.password, @required this.deviceToken});

  @override
  List<Object> get props => [emailOrMobile, password,deviceToken];
}

class LoginV1ReqAuthenticationEvent extends AuthenticationEvent{
  final String emailOrMobile;
  final String otp;
  final String deviceToken;
  LoginV1ReqAuthenticationEvent(
      {@required this.emailOrMobile, @required this.otp, @required this.deviceToken});

  @override
  List<Object> get props => [emailOrMobile, otp,deviceToken];
}

class SocialLoginReqAuthenticationEvent extends AuthenticationEvent{
  final String emailOrMobile;
  final String deviceToken;
  final String social_id;
  SocialLoginReqAuthenticationEvent(
      {@required this.emailOrMobile, @required this.deviceToken, this.social_id});

  @override
  List<Object> get props => [emailOrMobile, deviceToken, social_id];
}

class RegisterReqAuthenticationEvent extends AuthenticationEvent{
  final String name;
  final String mobile;
  final String email;
  final String password;
  final String loginType;
  final String otp;
  final String deviceToken;
  final String reffCode;
  RegisterReqAuthenticationEvent(
      {@required this.name, @required this.mobile, @required this.email, @required this.password, @required this.loginType, @required this.otp, @required this.deviceToken, @required this.reffCode});

  @override
  List<Object> get props => [name, mobile, email, password, otp, deviceToken, reffCode];
}
class RegisterReqV1AuthenticationEvent extends AuthenticationEvent{
  final String name;
  final String mobile;
  final String email;
  final String password;
  final String loginType;
  final String otp;
  final String deviceToken;
  final String reffCode;
  final String socialId;
  RegisterReqV1AuthenticationEvent(
      {@required this.name, @required this.mobile, @required this.email, @required this.password, @required this.loginType, @required this.otp, @required this.deviceToken, @required this.reffCode, @required this.socialId});

  @override
  List<Object> get props => [name, mobile, email, password, otp, deviceToken, reffCode];
}

class RegisterV1ReqAuthenticationEvent extends AuthenticationEvent{
  final String name;
  final String mobile;
  final String email;
  final String otp;
  final String deviceToken;
  final String reffCode;
  RegisterV1ReqAuthenticationEvent(
      {@required this.name, @required this.mobile, @required this.email, @required this.otp, @required this.deviceToken, @required this.reffCode});

  @override
  List<Object> get props => [name, mobile, email, otp, deviceToken, reffCode];
}


class OtpVerifyReqAuthenticationEvent extends AuthenticationEvent{}

class SuccessAuthenticationEvent extends AuthenticationEvent{}
class FailureAuthenticationEvent extends AuthenticationEvent{}

class LoginInViaFacebookEvent extends AuthenticationEvent {}
class LoginInViaGoogleEvent extends AuthenticationEvent {}


class SendOtpAuthEvent extends AuthenticationEvent {
  final String contact;
  final String otpType;

  SendOtpAuthEvent({@required this.contact, @required this.otpType});

  @override
  List<Object> get props => [contact, otpType];
}

class SendOtpV1AuthEvent extends AuthenticationEvent {
  final String contact;
  final String otpType;

  SendOtpV1AuthEvent({@required this.contact, @required this.otpType});

  @override
  List<Object> get props => [contact, otpType];
}