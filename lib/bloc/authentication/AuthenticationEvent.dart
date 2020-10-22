import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialAuthenticationEvent extends AuthenticationEvent{}
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

class RegisterReqAuthenticationEvent extends AuthenticationEvent{
  final String name;
  final String mobile;
  final String email;
  final String password;
  RegisterReqAuthenticationEvent(
      {@required this.name, @required this.mobile, @required this.email, @required this.password});

  @override
  List<Object> get props => [name, mobile, email, password];
}


class OtpVerifyReqAuthenticationEvent extends AuthenticationEvent{}
class SocialLoginReqAuthenticationEvent extends AuthenticationEvent{}

class SuccessAuthenticationEvent extends AuthenticationEvent{}
class FailureAuthenticationEvent extends AuthenticationEvent{}