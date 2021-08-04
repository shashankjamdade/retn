import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/OtpObj.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/OtpVerificationScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gson/gson.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DashboardScreen.dart';
import 'LoginScreen.dart';

class PostRegisterScreen extends StatefulWidget {
  String mobile;
  String name;
  String email;
  String socialId;
  String fcmToken;
  bool isRegistered;

  PostRegisterScreen(
      {this.mobile,
      this.name,
      this.email,
      this.socialId,
      this.fcmToken,
      this.isRegistered});

  @override
  _PostRegisterScreenState createState() => _PostRegisterScreenState();
}

class _PostRegisterScreenState extends State<PostRegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  TextEditingController otpController;
  TextEditingController referralCodeController;
  TextEditingController fullnameController;
  TextEditingController emailController;
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();
  BuildContext _context;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);
  String mLoginType = "";
  String mName = "";
  String mEmail = "";
  String mOTP = "";
  String mVerifiedMobile = "";
  String mFcmToken = "";
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool mHavReferalCode = false;
  bool mIsAlreadyRegisted = true;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';

  _register() {
    _firebaseMessaging.getToken().then((token) {
      if (token != null && token?.isNotEmpty) {
        mFcmToken = token;
        debugPrint("FCM_TOKEN GETTOKEN -> ${mFcmToken}");
      }
    });
    _firebaseMessaging.onTokenRefresh.listen((token) {
      if (token != null && token?.isNotEmpty) {
        mFcmToken = token;
        debugPrint("FCM_TOKEN REFRESH -> ${mFcmToken}");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    referralCodeController = TextEditingController();
    otpController = TextEditingController();
    fullnameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    mIsAlreadyRegisted = widget.isRegistered;
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
    _context = context;
    return BlocProvider(
        create: (context) =>
            // authenticationBloc..add(SendOtpV1AuthEvent(contact: widget.mobile, otpType: "login")),
            authenticationBloc..add(InitialAuthenticationEvent()),
        child: BlocListener(
          cubit: authenticationBloc,
          listener: (context, state) {
            if (state is SendOtpAuthState) {
              if (state.res != null &&
                  state.res.msg != null &&
                  state.res.msg.toString().isNotEmpty) {
                showSnakbar(_scaffoldKey, state.res.msg);
              }
              if (state.res != null && state.res.data != null) {
                setState(() {
                  mIsAlreadyRegisted = state.res.data.is_registered;
                });
              }
            } else if (state is GoogleFbLoginResAuthenticationState) {
              debugPrint("GOT_STATE-- " + state.res.loginStatus);
              if (state.res.loginStatus == LOGGEDIN_SUCCESS) {
                //Hit social Login API
                if (state.res.map['email'] != null) {
                  setState(() {
                    mLoginType = LOGINTYPE_FB;
                    mName = state.res.map['name'];
                    mEmail = state.res.map['email'];
                  });
                  showSnakbar(
                      _scaffoldKey, "Please fill all required information");
                } else {
                  showSnakbar(_scaffoldKey,
                      "No email found against your profile, please try again with another account");
                }
              }
            } else if (state is RegisterResAuthenticationState) {
              showSnakbar(_scaffoldKey, state.res.message);
              debugPrint("MSG_GOT_REGISTER ${state.res.message}");
              Fluttertoast.showToast(
                  msg: state.res.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: space_14);
              if (state.res.status) {
                storeResInPrefs(context, state.res);
              }
            } else if (state is LoginResAuthenticationState) {
              showSnakbar(_scaffoldKey, state.res.message);
              debugPrint("MSG_GOT_REGISTER ${state.res.message}");
              Fluttertoast.showToast(
                  msg: state.res.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: space_14);
              if (state.res.status) {
                storeResInPrefs(context, state.res);
              }
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is SendOtpAuthState) {
                return getSignupForm();
              } else if (state is RegisterResAuthenticationState) {
                return getSignupForm();
              } else if (state is ProgressAuthenticationState) {
                return getSignupForm(showProgress: true);
              } else {
                return getSignupForm();
              }
            },
          ),
        ));
  }

  Widget getSignupForm({bool showProgress = false}) {
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
                child: Container(
                  margin: EdgeInsets.only(
                      top: getProportionateScreenHeight(context, space_100)),
                  height: double.infinity,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          !mIsAlreadyRegisted
                              ? "Please provide details to create an account"
                              : "Please verify with OTP to login",
                          style: CommonStyles.getRalewayStyle(
                              space_15, FontWeight.w500, CommonStyles.blue),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(context, space_20),
                      ),
                      TextInputWidget(otpController, "OTP", false,
                          (String value) {
                        if (value.isEmpty) {
                          return "Please enter valid otp";
                        }
                      }, TextInputType.number),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Didn\'t recieved OTP??",
                            style: CommonStyles.getRalewayStyle(space_15,
                                FontWeight.w500, CommonStyles.primaryColor),
                          ),
                          GestureDetector(
                            onTap: () {
                              authenticationBloc
                                ..add(SendOtpV1AuthEvent(
                                    contact: widget.mobile, otpType: "login"));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: space_8, bottom: space_8, left: space_8),
                              child: Text(
                                "RESEND",
                                style: CommonStyles.getRalewayStyle(space_15,
                                    FontWeight.w500, CommonStyles.blue),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      mIsAlreadyRegisted
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: [
                                (widget?.socialId != null &&
                                        widget?.socialId != null)
                                    ? Container(
                                        height: 0,
                                        width: 0,
                                      )
                                    : TextInputWidget(
                                        fullnameController, "Full name", false,
                                        (String value) {
                                        if (value.isEmpty) {
                                          return "Please enter valid name";
                                        }
                                      }, TextInputType.text),
                                (widget?.socialId != null &&
                                        widget?.socialId != null)
                                    ? Container(
                                        height: 0,
                                        width: 0,
                                      )
                                    : SizedBox(
                                        height: getProportionateScreenHeight(
                                            context, space_20),
                                      ),
                                (widget?.socialId != null &&
                                        widget?.socialId != null)
                                    ? Container(
                                        height: 0,
                                        width: 0,
                                      )
                                    : TextInputWidget(
                                        emailController, "Email ID", false,
                                        (String value) {
                                        if (value.isEmpty) {
                                          return "Please enter valid email ID";
                                        }
                                      }, TextInputType.emailAddress),
                                SizedBox(
                                  height: getProportionateScreenHeight(
                                      context, space_20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: space_15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Checkbox(
                                        value: mHavReferalCode,
                                        activeColor: CommonStyles.primaryColor,
                                        onChanged: (value) {
                                          setState(() {
                                            mHavReferalCode = value;
                                          });
                                        },
                                      ),
                                      Expanded(
                                          child: Text(
                                        "I have a referral code",
                                        style: CommonStyles.getMontserratStyle(
                                            space_14,
                                            FontWeight.w400,
                                            Colors.black),
                                      ))
                                    ],
                                  ),
                                ),
                                mHavReferalCode
                                    ? TextInputWidget(referralCodeController,
                                        "Referral code", false, (String value) {
                                        if (value.isEmpty) {
                                          return "Please enter valid referral code";
                                        }
                                      }, TextInputType.text)
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                              ],
                            ),
                      SizedBox(
                        height: getProportionateScreenHeight(context, space_25),
                      ),
                      InkWell(
                        onTap: () {
                          if (mIsAlreadyRegisted) {
                            onLogin();
                          } else {
                            onSignup();
                          }
                        },
                        child: Center(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: space_10, horizontal: space_25),
                                decoration: BoxDecoration(
                                    color: CommonStyles.primaryColor),
                                child: Text(
                                  !mIsAlreadyRegisted ? "Sign Up" : "Login",
                                  style: CommonStyles.getMontserratStyle(
                                      space_14, FontWeight.w600, Colors.white),
                                ))),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(context, space_20),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(context, space_50),
                      ),
                    ],
                  ),
                ),
              ),
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

  void onSignup() {
    if (fullnameController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_full_name);
    } else if (emailController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_email);
    } else if (!emailController.text.trim().contains("@")) {
      showSnakbar(_scaffoldKey, empty_email);
    } else if (widget.mobile.isEmpty) {
      showSnakbar(_scaffoldKey, empty_mobile);
    } else if (otpController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, verify_mobile);
    } else if (referralCodeController.text.trim().isEmpty && mHavReferalCode) {
      showSnakbar(_scaffoldKey, empty_refer_code);
    } else if (mFcmToken == null || mFcmToken.isEmpty) {
      _register();
      showSnakbar(_scaffoldKey, fcm_token_missing);
    } else {
      //API hit
      debugPrint("OTP -- > ${mOTP}");
      authenticationBloc
        ..add(RegisterReqV1AuthenticationEvent(
            name: fullnameController.text.trim(),
            socialId: widget.socialId,
            email: emailController.text.trim(),
            mobile: widget.mobile,
            loginType: mLoginType,
            otp: otpController.text.trim(),
            deviceToken: mFcmToken,
            reffCode: referralCodeController.text.toString() != null &&
                    referralCodeController.text.toString()?.isNotEmpty
                ? referralCodeController.text.toString().trim()
                : ""));
    }
  }

  void onLogin() {
    if (widget.mobile.isEmpty) {
      showSnakbar(_scaffoldKey, empty_mobile);
    } else if (otpController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, verify_mobile);
    } else if (mFcmToken == null || mFcmToken.isEmpty) {
      _register();
      showSnakbar(_scaffoldKey, fcm_token_missing);
    } else {
      //API hit - Login
      debugPrint("OTP -- > ${mOTP}");
      authenticationBloc
        ..add(LoginV1ReqAuthenticationEvent(
            emailOrMobile: widget.mobile,
            otp: otpController.text.trim(),
            deviceToken: mFcmToken));
    }
  }

  void skipFun() {}

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
        Navigator.push(
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
}
