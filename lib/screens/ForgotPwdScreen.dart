import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/model/OtpObj.dart';
import 'package:flutter_rentry_new/model/register_response.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/OtpVerificationScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'DashboardScreen.dart';
import 'LoginScreen.dart';

class ForgotPwdScreen extends StatefulWidget {
  @override
  _ForgotPwdScreenState createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  TextEditingController mobileController;
  TextEditingController passwordController;
  TextEditingController confPasswordController;
  HomeBloc homeBloc = new HomeBloc();
  BuildContext _context;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);
  String mLoginType = "";
  String mName = "";
  String mEmail = "";
  String mOTP = "";
  String mVerifiedMobile = "";
  bool _obscureText = true;
  bool _obscureText2 = true;



  @override
  void initState() {
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    mobileController = TextEditingController();
    passwordController = TextEditingController();
    confPasswordController = TextEditingController();
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
      create: (context) => homeBloc..add(InitialEvent()),
      child: BlocListener(
      bloc: homeBloc,
        listener: (context, state){
          if(state is ForgotPwdState){
            debugPrint("MSG_GOT_REGISTER ${state.res.msg}");
            Fluttertoast.showToast(
                msg: state.res.msg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: space_14
            );
            if(state.res.status is String && state.res.status == "true"){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }else if(state.res.status is bool && state.res.status){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state){
            if(state is RegisterResAuthenticationState){
              return getSignupForm();
            } else if(state is ProgressState){
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Forgot password",
                              style: CommonStyles.getRalewayStyle(
                                  space_15, FontWeight.w500, CommonStyles.blue),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
//                          TextInputWidget(mobileController, "Mobile No.", false, (String value) {
//                            if (value.isEmpty) {
//                              return "Please enter valid mobile no.";
//                            }
//                          }, TextInputType.number),
//                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          BtnTextInputWidget(mobileController, "Mobile No.", "Verify", false, onVerifyClick,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter valid mobile no.";
                                }
                              }, TextInputType.number, isVerified:  mOTP?.isNotEmpty,),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          Container(
                            height: getProportionateScreenHeight(context, space_40),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  child:  TextFormField(
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please enter valid password";
                                      }
                                    },
                                    obscureText: _obscureText,
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: "New Password",
                                      suffixIcon:  IconButton(
                                        icon:Icon(_obscureText ? Icons.visibility:Icons.visibility_off,),
                                        onPressed: _togglePasswordStatus,
                                        color: CommonStyles.primaryColor,
                                      ),
                                      contentPadding: EdgeInsets.all(space_8),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(0.0)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
//                          TextInputWidget(passwordController, "Password", false, (String value) {
//                            if (value.isEmpty) {
//                              return "Please enter valid password";
//                            }
//                          }, TextInputType.text),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          BtnTextInputWidget(confPasswordController, "Confirm Password", "Submit", true, onSignup,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter valid confirm password";
                                }
                              }, TextInputType.emailAddress),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          Align(
                              alignment: Alignment.center,
                              child: Text("OR", style: CommonStyles.getRalewayStyle(space_18, FontWeight.w600, CommonStyles.primaryColor),)),
                          SizedBox(height: getProportionateScreenHeight(context, space_25),),
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
    if(mobileController.text.trim().isEmpty){
      showSnakbar(_scaffoldKey, empty_mobile);
    }else{
      //push to verify
      var res = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpVerificationScreen(mobileController.text.trim(), "login")),
      );
      setState(() {
        if(res!=null && res is OtpObj) {
          mOTP = res.otp;
          mVerifiedMobile = res.mobile;
          debugPrint("VERIFIED ${res.otp}, ${res.mobile}");
        }
      });
    }
  }
  
  void onSignup(){
    if(mVerifiedMobile != mobileController.text.toString()){
      setState(() {
        mOTP = "";
      });
      showSnakbar(_scaffoldKey, verify_mobile);
    }else if(mobileController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_mobile);
    }else if(passwordController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_password);
    }else if(confPasswordController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_conf_password);
    }else if(passwordController.text.trim() != confPasswordController.text.trim()){
     showSnakbar(_scaffoldKey, pwd_no_match);
    }else if(mOTP==null || mOTP.isEmpty){
     showSnakbar(_scaffoldKey, verify_mobile);
    }else{
      //API hit
      debugPrint("OTP -- > ${mOTP}");
      homeBloc..add(ForgotPwdEvent(contact: mobileController.text.trim(), otp: mOTP, confirm_password: passwordController.text.toString().trim()));
    }
  }

  void redirectToLogin(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }



  void skipFun() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
