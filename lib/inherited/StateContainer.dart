import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/login_response.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final LoginResponse loginResponse;
  final UserLocationSelected userLocationSelected;

  StateContainer(
      {@required this.child, this.loginResponse, this.userLocationSelected});

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  LoginResponse mLoginResponse;
  UserLocationSelected mUserLocationSelected;

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
