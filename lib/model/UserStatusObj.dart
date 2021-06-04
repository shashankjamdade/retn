import 'package:flutter_rentry_new/model/login_response.dart';

class UserStatusObj{
  LoginResponse loginResponse;
  bool isStartupIntroViewed;
  bool isShowCaseViewed;

  UserStatusObj({
    this.loginResponse,
    this.isStartupIntroViewed,
    this.isShowCaseViewed});

}