import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/screens/ForgotPwdScreen.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/RegisterScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

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
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);
  String mName = "";
  String mEmail = "";
  String mFcmToken = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  logininViaGoogle() async {
    try {
      googleSignIn.signOut();
      GoogleSignInAccount googleUsr = await googleSignIn.signIn();
      debugPrint("GOOGLE_SIGNIN_INFO ${googleUsr.email}");
      debugPrint("GOOGLE_SIGNIN_INFO ${googleUsr.displayName}");
      authenticationBloc
        ..add(SocialLoginReqAuthenticationEvent(
            emailOrMobile: googleUsr.email, deviceToken: mFcmToken));
    } catch (err) {
      print("EXCEPTION ${err}");
    }
  }

  _register() {
    _firebaseMessaging.getToken().then((token) => mFcmToken = token);
  }

  @override
  void initState() {
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    mobileEmailController = TextEditingController();
    passwordController = TextEditingController();
    _register();
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
            if (state.res.status) {
              storeResInPrefs(context, state.res);
            }
            showSnakbar(_scaffoldKey, state.res.message);
          } else if (state is InitialAuthenticationState) {
            //try to fetch location
          } else if (state is GoogleFbLoginResAuthenticationState) {
            if (state.res.loginStatus == LOGGEDIN_SUCCESS) {
              //Hit social Login API
              if (state.res.map['email'] != null) {
                authenticationBloc
                  ..add(SocialLoginReqAuthenticationEvent(
                      emailOrMobile: state.res.map['email']));
              } else {
                showSnakbar(_scaffoldKey,
                    "No email found against your profile, please try again with another account");
              }
            }
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        prefs.setString(USER_LOGIN_RES, jsonEncode(res));
        prefs.setString(USER_LOCATION_LAT, "${position.latitude}");
        prefs.setString(USER_LOCATION_LONG, "${position.longitude}");
        debugPrint(
            "LOCATION_FOUND ${position.latitude}, ${position.longitude}");
        //access address from lat lng
        final coordinates =
            new Coordinates(position.latitude, position.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        UserLocationSelected userLocationSelected = new UserLocationSelected(
            address: first.addressLine,
            city: first.locality,
            state: first.adminArea,
            coutry: first.countryName,
            mlat: position.latitude.toString(),
            mlng: position.longitude.toString());
        StateContainer.of(context).updateUserLocation(userLocationSelected);
        prefs.setString(USER_LOCATION_ADDRESS, "${first.addressLine}");
        prefs.setString(USER_LOCATION_CITY, "${first.locality}");
        prefs.setString(USER_LOCATION_STATE, "${first.adminArea}");
        prefs.setString(USER_LOCATION_PINCODE, "${first.postalCode}");
        print("@@@@-------${first} ${first.addressLine} : ${first.adminArea}");

        prefs.setString(USER_NAME, res.data.username);
        prefs.setString(USER_MOBILE, res.data.contact);
        prefs.setString(USER_EMAIL, res.data.email);
        prefs.setBool(IS_LOGGEDIN, true);
        debugPrint(
            "PREFS_STORED_LOGIN-----> ${prefs.getString(USER_LOCATION_ADDRESS)}");
        StateContainer.of(context).updateUserInfo(res);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        //Show dialog for location permission
      }
    } catch (e) {
      debugPrint("EXCEPTION in Loginscreen in storeResInPrefs ${e.toString()}");
    }
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
    } else if (state is GoogleFbLoginResAuthenticationState) {
      if (state.res.loginStatus == LOGGEDIN_SUCCESS) {
        //Hit social Login API
        return getLoginForm(context, showProgress: true);
      } else {
        showSnakbar(
            _scaffoldKey, "Something went wrong, please try again later");
        return getLoginForm(context, showProgress: false);
      }
    }
  }

  Widget getLoginForm(BuildContext context, {bool showProgress = false}) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            AuthPageHeaderWidget(app_name, skip_for_now, skipFun),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: space_15, right: space_15, top: space_70),
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
                                  style: CommonStyles.getRalewayStyle(space_15,
                                      FontWeight.w500, CommonStyles.blue),
                                ),
                              ),
                              SizedBox(
                                height: space_20,
                              ),
                              TextInputWidget(
                                  mobileEmailController,
                                  "Mobile no / Email ID",
                                  false, (String value) {
                                if (value.isEmpty) {
                                  return "Please enter valid email/mobile";
                                }
                              }, TextInputType.emailAddress),
                              SizedBox(
                                height: getProportionateScreenHeight(
                                    context, space_20),
                              ),
                              BtnTextInputWidget(
                                  passwordController, "Password", "Login", true,
                                  () {
                                if (mobileEmailController.text.trim().isEmpty) {
                                  showSnakbar(_scaffoldKey, empty_username);
                                } else if (passwordController.text
                                    .trim()
                                    .isEmpty) {
                                  showSnakbar(_scaffoldKey, empty_password);
                                } else if (mFcmToken == null ||
                                    mFcmToken.trim().isEmpty) {
                                  showSnakbar(_scaffoldKey, fcm_token_missing);
                                } else {
                                  //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
                                  authenticationBloc
                                    ..add(LoginReqAuthenticationEvent(
                                        emailOrMobile:
                                            mobileEmailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        deviceToken: mFcmToken));

//                            BlocProvider.of<AuthenticationBloc>(_context)
//                              ..add(LoginReqAuthenticationEvent(emailOrMobile: mobileEmailController.text.trim(), password: passwordController.text.trim()));
                                }
                              }, (String value) {
                                if (value.isEmpty) {
                                  return "Please enter valid password";
                                }
                              }, TextInputType.emailAddress),
                              SizedBox(
                                height: getProportionateScreenHeight(
                                    context, space_20),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPwdScreen()),
                                  );
                                },
                                child: Text(
                                  "Forgot password?",
                                  style:
                                      CommonStyles.getMontserratDecorationStyle(
                                          space_14,
                                          FontWeight.w600,
                                          CommonStyles.primaryColor,
                                          TextDecoration.underline),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(
                                    context, space_20),
                              ),
                              Text(
                                "OR",
                                style: CommonStyles.getRalewayStyle(space_18,
                                    FontWeight.w600, CommonStyles.primaryColor),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(
                                    context, space_20),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: IconButtonWidget(
                                          "Login with facebook",
                                          "assets/images/facebook.png",
                                          CommonStyles.blue, () {
                                    onSocialLogin("fb", context);
                                  })),
                                  Expanded(
                                      child: IconButtonWidget(
                                          "Login with Google",
                                          "assets/images/google.png",
                                          CommonStyles.darkAmber, () {
                                    onSocialLogin("google", context);
                                  })),
                                ],
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(
                                    context, space_25),
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
                                            fontFamily:
                                                CommonStyles.FONT_RALEWAY,
                                            fontWeight: FontWeight.w600,
                                            color: CommonStyles.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: space_70),
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
                        ),
                      ),
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//                Container(
//                  margin: EdgeInsets.only(bottom: space_70),
//                  child: Center(
//                    child: Text(
//                      rent_pe_tagline,
//                      style: TextStyle(
//                          fontSize: space_15,
//                          fontFamily: CommonStyles.FONT_RALEWAY,
//                          fontWeight: FontWeight.w400,
//                          color: CommonStyles.primaryColor,
//                          decoration: TextDecoration.none),
//                    ),
//                  ),
//                )
//              ],
//            ),
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
              ),
            ),
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
    } else if (mFcmToken == null || mFcmToken.trim().isEmpty) {
      showSnakbar(_scaffoldKey, fcm_token_missing);
    } else {
      //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
      debugPrint("CHECK_TOKEN --> ${mFcmToken}");
      authenticationBloc
        ..add(LoginReqAuthenticationEvent(
            emailOrMobile: mobileEmailController.text.trim(),
            password: passwordController.text.trim(),
            deviceToken: mFcmToken));
    }
  }

  void redirectToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void onSocialLogin(String type, BuildContext context) {
    if (type == "fb") {
      authenticationBloc..add(LoginInViaFacebookEvent());
    } else if (type == "google") {
      logininViaGoogle();
    }
  }

  void skipFun() {
    debugPrint("SKIPPPPPED");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
