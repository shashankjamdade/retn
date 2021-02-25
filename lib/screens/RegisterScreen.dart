import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/OtpObj.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/OtpVerificationScreen.dart';
import 'package:flutter_rentry_new/screens/PostRegisterScreen.dart';
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

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';

  _register() {
    _firebaseMessaging.getToken().then((token) => mFcmToken = token);
  }

  // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  logininViaGoogle() async {
    try {
      googleSignIn.signOut();
      GoogleSignInAccount googleUsr = await googleSignIn.signIn();
      debugPrint("GOOGLE_SIGNIN_INFO ${googleUsr.email}");
      debugPrint("GOOGLE_SIGNIN_INFO ${googleUsr.displayName}");
      setState(() {
        mLoginType  = LOGINTYPE_GOOGLE;
        mName  = googleUsr.displayName;
        mEmail  = googleUsr.email;
        fullnameController = TextEditingController(text: mName);
        emailController = TextEditingController(text:mEmail);
      });
      onSignup();
    } catch (err) {
      print("EXCEPTION ${err}");
    }
//    showSnakbar(_scaffoldKey, "Please fill all required information");
  }

  @override
  void initState() {
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    fullnameController = TextEditingController(text: mName);
    emailController = TextEditingController(text:mEmail);
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
      create: (context) => authenticationBloc..add(InitialAuthenticationEvent()),
      child: BlocListener(
      bloc: authenticationBloc,
        listener: (context, state){
        if(state is GoogleFbLoginResAuthenticationState){
          debugPrint("GOT_STATE-- "+state.res.loginStatus);
          if (state.res.loginStatus == LOGGEDIN_SUCCESS) {
            //Hit social Login API
            if(state.res.map['email']!=null) {
              setState(() {
                mLoginType  = LOGINTYPE_FB;
                mName = state.res.map['name'];
                mEmail = state.res.map['email'];
                fullnameController = TextEditingController(text: mName);
                emailController = TextEditingController(text:mEmail);
              });
              onSignup();
//              showSnakbar(_scaffoldKey, "Please fill all required information");
            }else{
              showSnakbar(_scaffoldKey, "No email found against your profile, please try again with another account");
            }
          }
        }else if(state is RegisterResAuthenticationState){
            showSnakbar(_scaffoldKey, state.res.message);
            debugPrint("MSG_GOT_REGISTER ${state.res.message}");
            Fluttertoast.showToast(
                msg: state.res.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: space_14
            );
            if(state.res.status){
              storeResInPrefs(context, state.res);
            }
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state){
            if(state is RegisterResAuthenticationState){
              return getSignupForm();
            } else if(state is ProgressAuthenticationState){
              return getSignupForm(showProgress: true);
            } else{
              return getSignupForm();
            }
          },
        ),
      ));
  }

  Widget getSignupForm({bool showProgress = false}){
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
                      margin: EdgeInsets.only(top: getProportionateScreenHeight(context, space_100)),
                      height: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: space_40),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Please provide detail accordingly to create account",
                                style: CommonStyles.getRalewayStyle(
                                    space_15, FontWeight.w500, CommonStyles.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: space_20,
                          ),
                          TextInputWidget(fullnameController, "Full name", false, (String value) {
                            if (value.isEmpty) {
                              return "Please enter valid name";
                            }
                          }, TextInputType.text),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
//                          TextInputWidget(mobileController, "Mobile No.", false, (String value) {
//                            if (value.isEmpty) {
//                              return "Please enter valid mobile no.";
//                            }
//                          }, TextInputType.number),
//                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          TextInputWidget(emailController, "Email ID", false, (String value) {
                            if (value.isEmpty) {
                              return "Please enter valid email ID";
                            }
                          }, TextInputType.emailAddress),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          InkWell(
                            onTap: (){
                              onSignup();
                            },
                            child: Center(child: Container(
                                padding: EdgeInsets.symmetric(vertical: space_10, horizontal: space_15),
                                decoration: BoxDecoration(
                                  color: CommonStyles.primaryColor
                                ),
                                child: Text("Next", style: CommonStyles.getMontserratStyle(space_14, FontWeight.w600, Colors.white),))),
                          ),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          Align(
                              alignment: Alignment.center,
                              child: Text("OR", style: CommonStyles.getRalewayStyle(space_18, FontWeight.w600, CommonStyles.primaryColor),)),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: IconButtonWidget("Signup with facebook", "assets/images/facebook.png", CommonStyles.blue ,onSocialLogin)),
                              Expanded(child: IconButtonWidget("Signup with Google", "assets/images/google.png", CommonStyles.darkAmber ,onSocialGoogleLogin)),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(context, space_25),),
                          GestureDetector(
                            onTap: redirectToLogin,
                            child: Align(
                              alignment: Alignment.center,
                              child: RichText(
                                text: new TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                      fontSize: space_12,
                                      fontFamily: CommonStyles.FONT_RALEWAY,
                                      fontWeight: FontWeight.w400,
                                      color: CommonStyles.primaryColor),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: ' Login',
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
                          ),
                          SizedBox(height: getProportionateScreenHeight(context, space_50),),
                          Align(
                            alignment: Alignment.center,
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
                        ],
                      ),
                    ),
                  ),
                ),
                showProgress?Center(child:
                  CircularProgressIndicator(),):Container(height: space_0, width: space_0,)
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//                Container(
//                  margin: EdgeInsets.only(bottom: space_70),
//                  child: Center(
//                    child:
//                  ),
//                )
//              ],
//            )

              ],
            )),
      ),
    );
  }

  onVerifyClick() async{

  }
  
  void onSignup(){
    if(fullnameController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_full_name);
    }else if(emailController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_email);
    }else if(mFcmToken==null || mFcmToken.isEmpty){
     showSnakbar(_scaffoldKey, fcm_token_missing);
    }else{
      //API hit
      debugPrint("OTP -- > ${mOTP}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostRegisterScreen(fullnameController.text.trim(), emailController.text.trim())),
      );
//      authenticationBloc..add(RegisterReqAuthenticationEvent(name: fullnameController.text.trim(),
//      email: emailController.text.trim(), mobile: mobileController.text.trim(), password: passwordController.text.trim(), loginType: mLoginType, otp: mOTP
//      ,deviceToken: mFcmToken));
    }
  }

  void redirectToLogin(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void onSocialLogin(){
    authenticationBloc..add(LoginInViaFacebookEvent());
  }
  void onSocialGoogleLogin(){
    logininViaGoogle();
  }

  void skipFun() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
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
