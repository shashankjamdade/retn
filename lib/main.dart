import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/CouponListScreen.dart';
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
import 'package:flutter_rentry_new/utils/PushNotificationsManager.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
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

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
//Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  // If you're going to use other Firebase services in the background, such as Firestore,
//  // make sure you call `initializeApp` before using other Firebase services.
//  await Firebase.initializeApp();
//  print('Handling a background message ${message.messageId}');
//}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(StateContainer(child: MyApp()));
  });
  setFirebase();
}

void setFirebase() {
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettingsIOS = new IOSInitializationSettings();

  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin
      .initialize(initializationSettings,
      onSelectNotification: onSelect);

  final FirebaseMessaging _firebaseMessaging =
  FirebaseMessaging();

  _firebaseMessaging.configure(
    onBackgroundMessage: Platform.isIOS ?
    null : myBackgroundMessageHandler,
    onMessage: (message) async {
      print("onMessage: $message");
    },
    onLaunch: (message) async {
      print("onLaunch: $message");
    },
    onResume: (message) async {
      print("onResume: $message");
    },
  );

  _firebaseMessaging.getToken()
      .then((String token) {
    print("Push Messaging token: $token");
    // Push messaging to this token later
  });

}

Future<String> onSelect(String data) async {
  print("onSelectNotification $data");
}
//updated myBackgroundMessageHandler
Future<dynamic> myBackgroundMessageHandler(Map<String,
    dynamic> message) async {
  print("myBackgroundMessageHandler message: $message");
  int msgId = int.tryParse(message["data"]["msgId"]
      .toString()) ?? 0;
  print("msgId $msgId");
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channelid', 'flutterfcm', 'your channel description',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin
      .show(msgId,
      message["data"]["msgTitle"],
      message["data"]["msgBody"], platformChannelSpecifics,
      payload: message["data"]["data"]);
  return Future<void>.value();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PushNotificationsManager Notification = PushNotificationsManager();

  @override
  void initState() {
    super.initState();
    Notification.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentozo',
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
  bool isLocationAccess = false;
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  String _message = '';

  _register() {
    _firebaseMessaging.getToken().then((token) => print("TOKEN--> ${token}"));
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('FCM_PUSH_onmsg $message');
          setState(() => _message = message["notification"]["title"]);
          displayNotification(message);
          return;
        },
        onResume: (Map<String, dynamic> message) async {
          print('FCM_PUSH_onresume $message');
          setState(() => _message = message["notification"]["title"]);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('FCM_PUSH_onLaunch $message');
          setState(() => _message = message["notification"]["title"]);
        });
  }

  @override
  void initState() {
    super.initState();
//    checkUserLoggedInOrNot(context);
    getMyCurrentLocation();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

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
    setState(() {
      isLocationAccess = true;
      isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (_) => authenticationBloc
        ..add(widget.isClrData ? MakeLogout() : CheckLoggedInEvent()),
      child: BlocListener(
        cubit: authenticationBloc,
        listener: (context, state) {
          if (state.obj != null && state.obj is LoginResponse) {
            StateContainer.of(context).updateUserInfo(state.obj);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is LogoutAuthentucateState) {
            return SplashScreen();
          } else if (state is CheckLoggedInState) {
            if (state.obj != null && state.obj is LoginResponse) {
              return HomeScreen();
            } else {
              return SplashScreen();
            }
          } else {
            return SafeArea(
              child: Scaffold(
                  body: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset("assets/images/app_icon.png"),
                ),
              ) //isLogin ? HomeScreen() : SplashScreen(),
                  ),
            );
          }
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
//      setState(() {
//        isLogin = true;
//      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
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
      message['data']['title'],
      message['data']['message'],
      platformChannelSpecifics,
      payload: message['data']['notification_type'],
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      redirectToChatScreen();
    }
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  redirectToChatScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(
                isRedirectToChat: true,
              )),
      (route) => false,
    );
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              redirectToChatScreen();
            },
          ),
        ],
      ),
    );
  }
}
