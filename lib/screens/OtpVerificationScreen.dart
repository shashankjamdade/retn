import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/model/OtpObj.dart';
import 'package:flutter_rentry_new/model/common_response.dart';
import 'package:flutter_rentry_new/screens/DashboardScreen.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpVerificationScreen extends StatefulWidget {

  String contact;
  String otp_type;
  OtpVerificationScreen(this.contact, this.otp_type);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  TextEditingController otpController;
  HomeBloc homeBloc = new HomeBloc();
  var mOtp = "";

  @override
  void initState() {
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
    return BlocProvider(
      create: (context) => homeBloc..add(SendOtpEvent(contact: widget.contact, otpType: widget.otp_type)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          if(state is SendOtpState){
            if(state.res!=null && state.res.msg!=null && state.res.msg.toString().isNotEmpty){
              showSnakbar(_scaffoldKey, state.res.msg);
            }
          }else if(state is VeifyOtpState){
            if(state.res!=null && state.res.msg!=null && state.res.msg.toString().isNotEmpty){
              if(state.res.status!=null && (state.res.status == "true")){
                Navigator.pop(context, new OtpObj(widget.contact, otpController.text.trim()));
              }
              Fluttertoast.showToast(
                  msg: state.res.msg,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: space_14
              );
              showSnakbar(_scaffoldKey, state.res.msg);
            }
          }
        },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state){
              if(state is SendOtpState){
                return getScreenUi(state.res);
              }else if(state is VeifyOtpState){
                return getScreenUi(state.res);
              }else {
                return getScreenProgressUi();
              }
            },
          )
      ),
    );
  }

  Widget getScreenUi(CommonResponse response){
    return  Scaffold(
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
                            "We have sent OTP on ${widget.contact}",
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
                            }, TextInputType.number,),
                        SizedBox(height: getProportionateScreenHeight(context, space_20),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Didn\'t recieved OTP??",
                              style: CommonStyles.getRalewayStyle(space_15, FontWeight.w500, CommonStyles.primaryColor),
                            ),
                            GestureDetector(
                              onTap: (){
                                homeBloc..add(SendOtpEvent(contact: widget.contact, otpType: widget.otp_type));
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: space_8, bottom: space_8, left: space_8),
                                child: Text(
                                  "RESEND",
                                  style: CommonStyles.getRalewayStyle(space_15, FontWeight.w500, CommonStyles.blue),
                                ),
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

  Widget getScreenProgressUi(){
    return  Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
            child: Column(
              children: [
                AuthPageHeaderWidget(app_name, skip_for_now, skipFun),
               Expanded(
                 child: Container(
                   color: Colors.white,
                   child: Center(
                     child: CircularProgressIndicator(),
                   ),
                 ),
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
      debugPrint("OTP_CALL --> ${widget.contact}, ${otpController.text.trim()}");
     homeBloc..add(VerifyOtpEvent(contact:widget.contact, otp: otpController.text.trim()));
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
