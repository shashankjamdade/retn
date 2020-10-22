import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry/screens/DashboardScreen.dart';
import 'package:flutter_rentry/screens/HomeScreen.dart';
import 'package:flutter_rentry/screens/LoginScreen.dart';
import 'package:flutter_rentry/screens/RegisterScreen.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state){
        return Scaffold(
            body: Container(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: CommonStyles.primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: space_200,
                        ),
                        Text(
                          "Welcome to",
                          style: TextStyle(
                              fontSize: space_25,
                              color: Colors.white,
                              fontFamily: CommonStyles.FONT_RALEWAY,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(
                          height: space_60,
                        ),
                        Container(
                          height: getProportionateScreenHeight(
                              context, space_40),
                          child: Image.asset(
                            "assets/images/app_img_white.png", fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          rent_pe_tagline,
                          style: CommonStyles.getRalewayStyle(
                              space_12, FontWeight.w500, Colors.white),
                        ),
                        SizedBox(
                          height: space_80,
                        ),
                        GestureDetector(
                          onTap: () {
                            redirectTo("login", context);
                          },
                          child: Container(
                            width: 200.0,
                            padding: EdgeInsets.symmetric(
                                vertical: space_15, horizontal: space_20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(space_5),
                            ),
                            child: Center(
                              child: RichText(
                                text: new TextSpan(
                                  text: 'Let\'s get started ',
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
                                          fontFamily:
                                          CommonStyles.FONT_RALEWAY,
                                          fontWeight: FontWeight.w600,
                                          color: CommonStyles.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: space_20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
//                          redirectTo("signup", context);
                          },
                          child: RichText(
                            text: new TextSpan(
                              text: 'Don\'t have account? ',
                              style: TextStyle(
                                  fontSize: space_12,
                                  color: Colors.white,
                                  fontFamily: CommonStyles.FONT_RALEWAY,
                                  fontWeight: FontWeight.w400),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Signup',
                                  style: TextStyle(
                                      fontSize: space_15,
                                      color: Colors.white,
                                      fontFamily: CommonStyles.FONT_RALEWAY,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: space_25,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: space_90),
                      child: Center(
                        child: Text(
                          "Skip for now>>",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: space_15,
                              fontFamily: CommonStyles.FONT_RALEWAY,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  void redirectTo(String type, BuildContext context) {
    switch (type) {
      case "login":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
      case "signup":

          Navigator.push(
            context,
              MaterialPageRoute(builder: (_) {
                return  RegisterScreen();
              })
//            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        break;
      case "dashboard":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        break;
    }
  }

  Future<bool> checkUserLoggedInOrNot() async {
    final prefs = await SharedPreferences.getInstance();
    bool flag = prefs.getBool(IS_LOGGEDIN);
    debugPrint("ISLOGGEDIN-----> ${flag}");
    return flag;
  }
}
