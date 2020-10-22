import 'package:flutter/material.dart';
import 'package:flutter_rentry/model/login_response.dart';


class StateContainer extends StatefulWidget {
  final Widget child;
  final LoginResponse loginResponse;

  StateContainer({
    @required this.child,
    this.loginResponse,
  });

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