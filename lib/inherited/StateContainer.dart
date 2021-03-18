import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/UserLocNameSelected.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/general_setting_res.dart';
import 'package:flutter_rentry_new/model/login_response.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final LoginResponse loginResponse;
  final UserLocationSelected userLocationSelected;
  final UserLocNameSelected userLocNameSelected;
  final GeneralSettingRes generalSettingRes;

  StateContainer(
      {@required this.child,
      this.loginResponse,
      this.userLocationSelected,
      this.generalSettingRes,
      this.userLocNameSelected});

//  static StateContainerState of(BuildContext context) {
//    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
//            as _InheritedStateContainer)
//        .data;
//  }

  static StateContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>().data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  LoginResponse mLoginResponse;
  UserLocationSelected mUserLocationSelected;
  UserLocNameSelected mUserLocNameSelected;
  GeneralSettingRes mGeneralSettingRes;

  void updateUserInfo(LoginResponse loginResponse) {
    if (loginResponse == null) {
      mLoginResponse = loginResponse;
      setState(() {
        mLoginResponse = loginResponse;
      });
    } else {
      setState(() {
        mLoginResponse = loginResponse;
      });
    }
  }

  void updateUserLocation(UserLocationSelected userLocationSelected) {
    if (userLocationSelected == null) {
      mUserLocationSelected = userLocationSelected;
      setState(() {
        mUserLocationSelected = userLocationSelected;
      });
    } else {
      setState(() {
        mUserLocationSelected = userLocationSelected;
      });
    }
  }
  void updateUserSelectedLocation(UserLocNameSelected userLocNameSelected) {
    if (userLocNameSelected == null) {
      mUserLocNameSelected = userLocNameSelected;
      setState(() {
        mUserLocNameSelected = userLocNameSelected;
      });
    } else {
      setState(() {
        mUserLocNameSelected = userLocNameSelected;
      });
    }
  }

  void updateGeneralSetting(GeneralSettingRes generalSettingRes) {
    debugPrint("GENERAL_SETTINGUPDATED - ${jsonEncode(generalSettingRes)}");
    if (generalSettingRes == null) {
      mGeneralSettingRes = generalSettingRes;
      setState(() {
        mGeneralSettingRes = generalSettingRes;
      });
    } else {
      setState(() {
        mGeneralSettingRes = generalSettingRes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
