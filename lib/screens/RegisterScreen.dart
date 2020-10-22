import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry/model/register_response.dart';
import 'package:flutter_rentry/screens/HomeScreen.dart';
import 'package:flutter_rentry/screens/OtpVerificationScreen.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/Constants.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';

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

  @override
  void initState() {
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    fullnameController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();
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
          if(state is RegisterResAuthenticationState){
            if(state.res.status){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
            showSnakbar(_scaffoldKey, state.res.message);
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
                          TextInputWidget(mobileController, "Mobile No.", false, (String value) {
                            if (value.isEmpty) {
                              return "Please enter valid mobile no.";
                            }
                          }, TextInputType.number),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          TextInputWidget(emailController, "Email ID", false, (String value) {
                            if (value.isEmpty) {
                              return "Please enter valid email ID";
                            }
                          }, TextInputType.emailAddress),
                          SizedBox(height: getProportionateScreenHeight(context, space_20),),
                          TextInputWidget(passwordController, "Password", false, (String value) {
                            if (value.isEmpty) {
                              return "Please enter valid password";
                            }
                          }, TextInputType.text),
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
                              Expanded(child: IconButtonWidget("Login with Google", "assets/images/google.png", CommonStyles.darkAmber ,onSocialLogin)),
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
    }else{
      //API hit
      authenticationBloc..add(RegisterReqAuthenticationEvent(name: fullnameController.text.trim(),
      email: emailController.text.trim(), mobile: mobileController.text.trim(), password: passwordController.text.trim()
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

  }

  void skipFun() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
