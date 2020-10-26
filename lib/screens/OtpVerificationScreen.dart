import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/screens/DashboardScreen.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';

class OtpVerificationScreen extends StatefulWidget {

  String username;
  String usernameType;
  OtpVerificationScreen(this.username, this.usernameType);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  TextEditingController otpController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Add Listener to know when is updated focus
    _focusNode.addListener(_onLoginUserNameFocusChange);
    otpController = TextEditingController();
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
                        "We have sent OTP on ${widget.usernameType} ${widget.username}",
                        style: CommonStyles.getRalewayStyle(
                            space_15, FontWeight.w500, CommonStyles.blue),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(context, space_20),),
                    BtnTextInputWidget(otpController, "OTP", "Verify", false, onVerify,
                            (String value) {
                          if (value.isEmpty) {
                            return "Please enter valid OTP";
                          }
                        }, TextInputType.number),
                    SizedBox(height: getProportionateScreenHeight(context, space_20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Didn\'t recieved OTP??",
                          style: CommonStyles.getRalewayStyle(space_15, FontWeight.w500, CommonStyles.primaryColor),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: space_8, bottom: space_8, left: space_8),
                          child: Text(
                            "RESEND",
                            style: CommonStyles.getRalewayStyle(space_15, FontWeight.w500, CommonStyles.blue),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(context, space_20),),
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
            )

          ],
        )),
      ),
    );
  }

  String makeFieldValidation(String type, String value){
    switch(type){
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

  void onVerify(){
    if(otpController.text.trim().isEmpty){
     showSnakbar(_scaffoldKey, empty_otp);
    }else{
      //API hit
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void redirectToSignup(){

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
