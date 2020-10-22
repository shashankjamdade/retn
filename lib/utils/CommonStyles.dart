import 'package:flutter/material.dart';
import 'package:flutter_rentry/utils/size_config.dart';

class CommonStyles{
  //Fonts
  static const String FONT_RALEWAY = "Raleway";
  static const String FONT_MONTSERRAT = "Montserrat";

  //Colors
  static const Color primaryColor = Color(0xFF003863);
  static const Color blue = Color(0xFF0089fa);
  static const Color red = Color(0xFFff2336);
  static const Color lightGrey = Color(0xFFe5eaef);
  static const Color grey = Color(0xFF707070);
  static const Color darkNavyBlue = Color(0xFF003863);
  static const Color lightBlue = Color(0xFF008CFF);
  static const Color darkAmber = Color(0xFFFF8800);
  static const Color lightAmber = Color(0xFFFFC400);
  static const Color softGray = Color(0xFFE6E6E6);
  static const Color secondarygrey = Colors.grey;
  static const Color yellow = Colors.yellow;
  static const Color amber = Colors.amber;


  //styles
  static TextStyle getRalewayStyle(double fontSize, FontWeight fontWeight, Color color){
    return TextStyle(
      fontSize: fontSize,
      fontFamily: FONT_RALEWAY,
      fontWeight:fontWeight,
      color: color,
    );
  }

 static TextStyle getMontserratStyle(double fontSize, FontWeight fontWeight, Color color){
    return TextStyle(
      fontSize: fontSize,
      fontFamily: FONT_MONTSERRAT,
      fontWeight:fontWeight,
      color: color,
    );
  }

// final headingStyle = TextStyle(
//    fontSize: getProportionateScreenWidth(28),
//    fontWeight: FontWeight.bold,
//    color: Colors.black,
//    height: 1.5,
//  );

//  OutlineInputBorder outlineInputBorder() {
//    return OutlineInputBorder(
//      borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
//      borderSide: BorderSide(color: primaryColor),
//    );
//  }

  InputDecorationTheme inputDecorationTheme() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: Colors.white),
      gapPadding: 10,
    );
    return InputDecorationTheme(
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      // if we are define our floatingLabelBehavior in our theme then it's not applayed
      // floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
    );
  }

    //Strings
//  final RegExp emailValidatorRegExp =
//  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//  const String kInvalidEmailError = "Please Enter Valid Email";
//  const String kPassNullError = "Please Enter your password";
//  const String kShortPassError = "Password is too short";
//  const String kMatchPassError = "Passwords don't match";
//  const String kNamelNullError = "Please Enter your name";
//  const String kPhoneNumberNullError = "Please Enter your phone number";
//  const String kAddressNullError = "Please Enter your address";
}

 Gradient cardGradient() =>  LinearGradient(
    colors: [CommonStyles.lightGrey, Colors.white],
    begin: Alignment.bottomRight,
    end: new Alignment(-1.0, -1.0),
);

 Gradient chatHeaderSelectedGradient() =>   LinearGradient(
     begin: Alignment.topRight,
     end: Alignment.bottomLeft,
     colors: [CommonStyles.darkNavyBlue, CommonStyles.lightBlue]);

 Gradient chatHeaderUnSelectedGradient() =>   LinearGradient(
     begin: Alignment.topRight,
     end: Alignment.bottomLeft,
     colors: [CommonStyles.secondarygrey, CommonStyles.secondarygrey]);

Gradient chatMsgGradient() =>   LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [CommonStyles.grey.withOpacity(0.3), CommonStyles.lightGrey.withOpacity(0.6)]);

Gradient profileRatingBoxGradient() =>   LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, CommonStyles.softGray]);

Gradient filterTabSelectedGradient() =>   LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    colors: [CommonStyles.darkAmber, CommonStyles.lightAmber]);

Gradient filterTabUnSelectedGradient() =>   LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    colors: [CommonStyles.lightGrey, CommonStyles.lightGrey]);

const String app_name = "Rentry";
const String skip_for_now = "Skip for now>>";
const String empty_username = "Please enter mobile no or Email";
const String empty_password = "Please enter password";
const String rent_pe_tagline = "Rent pe le, Rent pe de...";
const String empty_otp = "Please enter OTP";
const String empty_full_name = "Please enter full name";
const String empty_mobile = "Please enter mobile no";
const String empty_email = "Please enter email ID";
const String empty_conf_password = "Please enter confirm password";
const String pwd_no_match = "Password didn't match";

//Constant
const String TYPE_FURNITURE = "TYPE_FURNITURE";
const String TYPE_VEHICLE = "TYPE_VEHICLE";
const String TYPE_ELECTRONICS = "TYPE_ELECTRONICS";
const String TYPE_CLOTHS = "TYPE_CLOTHS";
const String TYPE_PROPERTIES = "TYPE_PROPERTIES";
const String TYPE_SERVICE = "TYPE_SERVICE";
const String TYPE_FREELANCING = "TYPE_FREELANCING";
const String SIMILAR_PRODUCT = "SIMILAR_PRODUCT";
const String MORE_PRODUCTS = "MORE_PRODUCTS";
const String USER_LOGIN_RES = "USER_LOGIN_RES";
const String USER_NAME = "USER_NAME";
const String USER_EMAIL = "USER_EMAIL";
const String USER_MOBILE = "USER_MOBILE";
const String IS_LOGGEDIN = "IS_LOGGEDIN";

//API
const String BASE_URL = "http://rentozo.com/api";
const String LOGIN_API = "/login";
const String REGISTRATION_API = "/registration";
const String HOMEPAGE_API = "/homepage";
const String ITEMDETAIL_API = "/productdetails";
const String SUBCATEGORY_LIST_API = "/subcategorylist";
const String SEARCH_SUBCATEGORY_LIST_API = "/searchcategorysubcategory";
const String LOCATION_SEARCH_API = "/localtionsearch";






