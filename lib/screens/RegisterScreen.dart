import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
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

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  TextEditingController fullnameController;
  TextEditingController mobileController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confPasswordController;
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();
  BuildContext _context;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);
  String mLoginType = "";
  String mName = "";
  String mEmail = "";
  String mOTP = "";
  bool _obscureText = true;
  bool _obscureText2 = true;
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
    } catch (err) {
      print("EXCEPTION ${err}");
    }
    showSnakbar(_scaffoldKey, "Please fill all required information");
  }

  @override
  void initState() {
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    fullnameController = TextEditingController(text: mName);
    mobileController = TextEditingController();
    emailController = TextEditingController(text:mEmail);
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
              showSnakbar(_scaffoldKey, "Please fill all required information");
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Please provide detail accordingly to create account",
                              style: CommonStyles.getRalewayStyle(
                                  space_15, FontWeight.w500, CommonStyles.blue),
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
                          BtnTextInputWidget(mobileController, "Mobile No.", "Verify", false, onVerifyClick,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter valid mobile no.";
                                }
                              }, TextInputType.emailAddress),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          TextInputWidget(emailController, "Email ID", false, (String value) {
                            if (value.isEmpty) {
                              return "Please enter valid email ID";
                            }
                          }, TextInputType.emailAddress),
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
                                      labelText: "Password",
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
                          BtnTextInputWidget(confPasswordController, "Confirm Password", "Sign Up", true, onSignup,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter valid confirm password";
                                }
                              }, TextInputType.emailAddress),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          Align(
                              alignment: Alignment.center,
                              child: Text("OR", style: CommonStyles.getRalewayStyle(space_18, FontWeight.w600, CommonStyles.primaryColor),)),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: IconButtonWidget("Login with facebook", "assets/images/facebook.png", CommonStyles.blue ,onSocialLogin)),
                              Expanded(child: IconButtonWidget("Login with Google", "assets/images/google.png", CommonStyles.darkAmber ,onSocialGoogleLogin)),
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
    if(mobileController.text.trim().isEmpty){
      showSnakbar(_scaffoldKey, empty_mobile);
    }else{
      //push to verify
      var res = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpVerificationScreen(mobileController.text.trim(), "login")),
      ).then((value) => mOTP = value);
    }
  }
  
  void onSignup(){
    if(fullnameController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_full_name);
    }else if(mobileController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_mobile);
    }else if(emailController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_email);
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
      authenticationBloc..add(RegisterReqAuthenticationEvent(name: fullnameController.text.trim(),
      email: emailController.text.trim(), mobile: mobileController.text.trim(), password: passwordController.text.trim(), loginType: mLoginType, otp: mOTP
      ));
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
}
