import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry/inherited/StateContainer.dart';
import 'package:flutter_rentry/model/login_response.dart';
import 'package:flutter_rentry/screens/HomeScreen.dart';
import 'package:flutter_rentry/screens/RegisterScreen.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/Constants.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  TextEditingController mobileEmailController;
  TextEditingController passwordController;
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();

  @override
  void initState() {
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    mobileEmailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    //Dispose Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    super.dispose();
  }

  void _onLoginUserNameFocusChange() {
    //Force updated once if focus changed
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          authenticationBloc..add(InitialAuthenticationEvent()),
      child: BlocListener(
        bloc: authenticationBloc,
        listener: (context, state) {
          if (state is LoginResAuthenticationState) {
//            if (_currentPosition != null && _currentAddress != null) {
//              storeResInPrefs(context, state.res);
//            } else {
////              _getCurrentLocation2();
//            }
          } else if (state is InitialAuthenticationState) {
//            _getCurrentLocation2();
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return getWidgetByState(context, state);
          },
        ),
      ),
    );
  }

  void storeResInPrefs(BuildContext context, LoginResponse res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userStatus', "TT");
    prefs.setString(USER_LOGIN_RES, jsonEncode(res));
//    prefs.setString(USER_LOCATION_ADDRESS, _currentAddress);
//    prefs.setString(USER_LOCATION_LAT, _currentPosition.latitude.toString());
//    prefs.setString(USER_LOCATION_LONG, _currentPosition.longitude.toString());
    prefs.setString(USER_NAME, res.data.username);
    prefs.setString(USER_MOBILE, res.data.contact);
    prefs.setString(USER_EMAIL, res.data.email);
    prefs.setBool(IS_LOGGEDIN, true);
    debugPrint("PREFS_STORED_LOGIN-----> ${prefs.getString(USER_LOCATION_ADDRESS)}");
    StateContainer.of(context).updateUserInfo(res);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Widget getWidgetByState(BuildContext context, AuthenticationState state) {
    debugPrint("STATEis-----> ${state}");
    if (state is InitialAuthenticationState) {
      return getLoginForm(context, showProgress: false);
    } else if (state is ProgressAuthenticationState) {
      //store val in prefs & inherited widget & proceed
      return getLoginForm(context, showProgress: true);
    } else if (state is LoginResAuthenticationState) {
      //store val in prefs & inherited widget & proceed
      return getLoginForm(context, showProgress: false);
    }
  }

  Widget getLoginForm(BuildContext context, {bool showProgress = false}) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
            child: Stack(
          children: [
            AuthPageHeaderWidget(app_name, skip_for_now, skipFun),
            Container(
              margin: EdgeInsets.symmetric(horizontal: space_15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Please provide your login information",
                        style: CommonStyles.getRalewayStyle(
                            space_15, FontWeight.w500, CommonStyles.blue),
                      ),
                    ),
                    SizedBox(
                      height: space_20,
                    ),
                    TextInputWidget(
                        mobileEmailController, "Mobile no / Email ID", false,
                        (String value) {
                      if (value.isEmpty) {
                        return "Please enter valid email/mobile";
                      }
                    }, TextInputType.emailAddress),
                    SizedBox(
                      height: getProportionateScreenHeight(context, space_20),
                    ),
                    BtnTextInputWidget(
                        passwordController, "Password", "Login", true, () {
                      if (mobileEmailController.text.trim().isEmpty) {
                        showSnakbar(_scaffoldKey, empty_username);
                      } else if (passwordController.text.trim().isEmpty) {
                        showSnakbar(_scaffoldKey, empty_password);
                      } else {
                        //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
                        authenticationBloc
                          ..add(LoginReqAuthenticationEvent(
                              emailOrMobile: mobileEmailController.text.trim(),
                              password: passwordController.text.trim()));

//                            BlocProvider.of<AuthenticationBloc>(_context)
//                              ..add(LoginReqAuthenticationEvent(emailOrMobile: mobileEmailController.text.trim(), password: passwordController.text.trim()));
                      }
                    }, (String value) {
                      if (value.isEmpty) {
                        return "Please enter valid password";
                      }
                    }, TextInputType.emailAddress),
                    SizedBox(
                      height: getProportionateScreenHeight(context, space_20),
                    ),
                    Text(
                      "OR",
                      style: CommonStyles.getRalewayStyle(
                          space_18, FontWeight.w600, CommonStyles.primaryColor),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(context, space_20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: IconButtonWidget(
                                "Login with facebook",
                                "assets/images/facebook.png",
                                CommonStyles.blue,
                                onSocialLogin)),
                        Expanded(
                            child: IconButtonWidget(
                                "Login with Google",
                                "assets/images/google.png",
                                CommonStyles.darkAmber,
                                onSocialLogin)),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(context, space_25),
                    ),
                    GestureDetector(
                      onTap: redirectToSignup,
                      child: RichText(
                        text: new TextSpan(
                          text: 'Don\'t have account? ',
                          style: TextStyle(
                              fontSize: space_12,
                              fontFamily: CommonStyles.FONT_RALEWAY,
                              fontWeight: FontWeight.w400,
                              color: CommonStyles.primaryColor),
                          children: <TextSpan>[
                            new TextSpan(
                              text: ' Signup',
                              style: TextStyle(
                                  fontSize: space_15,
                                  fontFamily: CommonStyles.FONT_RALEWAY,
                                  fontWeight: FontWeight.w600,
                                  color: CommonStyles.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: space_70),
                  child: Center(
                    child: Text(
                      rent_pe_tagline,
                      style: TextStyle(
                          fontSize: space_15,
                          fontFamily: CommonStyles.FONT_RALEWAY,
                          fontWeight: FontWeight.w400,
                          color: CommonStyles.primaryColor,
                          decoration: TextDecoration.none),
                    ),
                  ),
                )
              ],
            ),
            showProgress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: space_0,
                    width: space_0,
                  )
          ],
        )),
      ),
    );
  }
  String makeFieldValidation(String type, String value) {
    switch (type) {
      case "username":
        if (value.isEmpty) {
          return "Please enter valid email/mobile";
        }
        break;
      case "password":
        if (value.isEmpty) {
          return "Please enter valid password";
        }
        break;
    }
  }

  void onLogin() {
    if (mobileEmailController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_username);
    } else if (passwordController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_password);
    } else {
      //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
      authenticationBloc
        ..add(LoginReqAuthenticationEvent(
            emailOrMobile: mobileEmailController.text.trim(),
            password: passwordController.text.trim()));
    }
  }

  void redirectToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void onSocialLogin() {}

  void skipFun() {
    //redirect to dashboard
//        MaterialPageRoute(
//        builder: (_) => SecondScreen(),
//        )
  }
}
