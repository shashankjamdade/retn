import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/screens/EditProfileScreen.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/NotificationListScreen.dart';
import 'package:flutter_rentry_new/screens/PackageScreen.dart';
import 'package:flutter_rentry_new/screens/ProfileScreen.dart';
import 'package:flutter_rentry_new/screens/SplashScreen.dart';
import 'package:flutter_rentry_new/screens/postad/ChangePasswordScreen.dart';
import 'package:flutter_rentry_new/screens/postad/ChooseCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/postad/ExplainRentalScreen.dart';
import 'package:flutter_rentry_new/screens/postad/LocationForAdScreen.dart';
import 'package:flutter_rentry_new/screens/postad/RentalPriceScreen.dart';
import 'package:flutter_rentry_new/screens/postad/SelectLocationPostAdScreen.dart';
import 'package:flutter_rentry_new/screens/postad/PostAdsSubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/postad/UploadProductImgScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'inherited/StateContainer.dart';
import 'package:geocoder/geocoder.dart';


void main() {
  runApp(StateContainer(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ScreenOne(),
    );
  }
}

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  bool isLogin = false;
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();

  @override
  void initState() {
    super.initState();
    checkUserLoggedInOrNot(context);
    getMyCurrentLocation();
  }

  getMyCurrentLocation() async {
    debugPrint("LOCATION_FOUND accesssing ");
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_LOCATION_LAT, "${position.latitude}");
    prefs.setString(USER_LOCATION_LONG, "${position.longitude}");
    debugPrint("LOCATION_FOUND ${position.latitude}, ${position.longitude}");
    //access address from lat lng
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    UserLocationSelected userLocationSelected = new UserLocationSelected(
      address: first.addressLine,
      city: first.locality,
      state: first.adminArea,
      coutry: first.countryName,
      mlat: position.latitude.toString(),
      mlng: position.longitude.toString()
    );
    StateContainer.of(context).updateUserLocation(userLocationSelected);
    prefs.setString(USER_LOCATION_ADDRESS, "${first.addressLine}");
    prefs.setString(USER_LOCATION_CITY, "${first.locality}");
    prefs.setString(USER_LOCATION_STATE, "${first.adminArea}");
    prefs.setString(USER_LOCATION_PINCODE, "${first.postalCode}");
    print("@@@@-------${first} ${first.addressLine} : ${first.adminArea}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (_) => authenticationBloc..add(CheckLoggedInEvent()),
      child: BlocListener(
        bloc: authenticationBloc,
        listener: (context, state) {},
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: isLogin ? HomeScreen() : SplashScreen(),
            ),
          );
        }),
      ),
    );
  }

  checkUserLoggedInOrNot(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mobile = prefs.getString(USER_NAME);
    debugPrint("VALlllllllll ${mobile}");
    if (mobile != null && mobile.isNotEmpty) {
      var response =
          LoginResponse.fromJson(jsonDecode(prefs.getString(USER_LOGIN_RES)));
      StateContainer.of(context).updateUserInfo(response);
      setState(() {
        isLogin = true;
      });
    }
  }
}
