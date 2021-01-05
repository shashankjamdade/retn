import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/EditProfileScreen.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/MyFavScreen.dart';
import 'package:flutter_rentry_new/screens/NotificationListScreen.dart';
import 'package:flutter_rentry_new/screens/OtpVerificationScreen.dart';
import 'package:flutter_rentry_new/screens/PackageScreen.dart';
import 'package:flutter_rentry_new/screens/ProfileScreen.dart';
import 'package:flutter_rentry_new/screens/SplashScreen.dart';
import 'package:flutter_rentry_new/screens/postad/ChangePasswordScreen.dart';
import 'package:flutter_rentry_new/screens/postad/ChooseCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/postad/CustomFieldsScreen.dart';
import 'package:flutter_rentry_new/screens/postad/LocationForAdScreen.dart';
import 'package:flutter_rentry_new/screens/postad/RentalPriceScreen.dart';
import 'package:flutter_rentry_new/screens/postad/SelectLocationPostAdScreen.dart';
import 'package:flutter_rentry_new/screens/postad/PostAdsSubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/postad/UploadProductImgScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'inherited/StateContainer.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:place_picker/place_picker.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(StateContainer(child: MyApp()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ScreenOne(false),
    );
  }
}

class ScreenOne extends StatefulWidget {
  bool isClrData = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var mFcmToken = "";

  _registerToken() {
    _firebaseMessaging.getToken().then((token) => mFcmToken = token);
  }

  ScreenOne(this.isClrData);

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  bool isLogin = false;
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  String _message = '';

  _register() {
    _firebaseMessaging.getToken().then((token) => print("TOKEN--> ${token}"));
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          setState(() => _message = message["notification"]["title"]);
          displayNotification(message);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserLoggedInOrNot(context);
    getMyCurrentLocation();
    var initializationSettingsAndroid = new AndroidInitializationSettings(
        '@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    getMessage();
    _register();
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
    if (widget.isClrData) {
      prefs.clear();
    }
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

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Fluttertoast.showToast(
        msg: "Notification Clicked",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future onDidRecieveLocalNotification(int id, String title, String body,
      String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) =>
      new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: "Notification Clicked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            },
          ),
        ],
      ),
    );
  }
}