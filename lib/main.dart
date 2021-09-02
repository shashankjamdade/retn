import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/UserStatusObj.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/ChatHomeScreen.dart';
import 'package:flutter_rentry_new/screens/CouponListScreen.dart';
import 'package:flutter_rentry_new/screens/EditProfileScreen.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/LaunchScreen.dart';
import 'package:flutter_rentry_new/screens/LoginScreen.dart';
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
import 'package:flutter_rentry_new/utils/PermissionService.dart';
import 'package:flutter_rentry_new/utils/PushNotificationsManager.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'bloc/authentication/AuthenticationBloc.dart';
import 'fcm/fcm-service.dart';
import 'inherited/StateContainer.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:place_picker/place_picker.dart';

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/SingletonClass.dart';

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
  await Firebase.initializeApp();
  // final appleSignInAvailable = await AppleSignInAvailable.check();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(StateContainer(child: MyApp()));
  });
  setFirebase();
}

void setFirebase() {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@drawable/ic_appicon');

  var initializationSettingsIOS = new IOSInitializationSettings(
      /*onDidReceiveLocalNotification: (int id, String title, String body, String payload){
        return showDialog(
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
      }*/
      );
  // var initializationSettingsIOS = new IOSInitializationSettings();

  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelect);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _firebaseMessaging.configure(
    onBackgroundMessage: myBackgroundMessageHandler,
    onMessage: (message) async {
      debugPrint("FCM_PUSH_onmsg1: $message");
    },
    onLaunch: (message) async {
      debugPrint("FCM_PUSH_onLaunch: $message");
    },
    onResume: (message) async {
      debugPrint("FCM_PUSH_onResume: $message");
    },
  );

  _firebaseMessaging.getToken().then((String token) {
    print("Push Messaging token: $token");
    // Push messaging to this token later
  });
  // FcmService().init();
}

void redirectToChatScreen() {

}

Future<String> onSelect(String data) async {
  print("onSelectNotification $data");
}

//updated myBackgroundMessageHandler
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  debugPrint("BackgroundMsg..................********@@@@@@@@@ message: $message");
  int msgId = int.tryParse(message["data"]["msgId"].toString()) ?? 1;
  print("msgId ${Platform.isIOS? message['title'] : message['data']['title']}, ${ Platform.isIOS? message['message'] : message['data']['message']}, PAYLOAD-> ${Platform.isIOS? message['notification_type'] : message["data"]["notification_type"]}");
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channelid', 'flutterfcm', 'your channel description',ticker: 'ticker', icon: "ic_notification_icon",
      playSound: true, enableLights: true, enableVibration: true,
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: true, presentAlert: true);
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.show(msgId,  Platform.isIOS? message['title'] : message['data']['title'],
      Platform.isIOS? message['message'] : message['data']['message'], platformChannelSpecifics,
      payload:  Platform.isIOS? message['notification_type'] : message["data"]["notification_type"]);
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
  // PushNotificationsManager Notification = PushNotificationsManager();

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging().deleteInstanceID();
    // Notification.init();
    // FcmService().init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentozo',
      debugShowCheckedModeBanner: false,
      home: ScreenOne(false),
      // home: TakePictureScreen(),
    );
  }
}

class ScreenOne extends StatefulWidget {
  bool isClrData = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var mFcmToken = "";

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
  SharedPreferences prefs;
  String _message = '';

  _register() {
    _firebaseMessaging.getToken().then((token){
      if(token!=null && token?.isNotEmpty){
        var mFcmToken = token;
        debugPrint("FCM_TOKEN GETTOKEN -> ${mFcmToken}");
      }
    });
    _firebaseMessaging.onTokenRefresh.listen((token) {
      if(token!=null && token?.isNotEmpty) {
        var mFcmToken = token;
        debugPrint("FCM_TOKEN REFRESH -> ${mFcmToken}");
      }
    });
  }

  Map modifyNotificationJson(Map<String,dynamic> msg){
    msg['data'] = Map.from(msg ?? {});
    msg['notification'] = msg['aps']['alert'];
    return msg;
  }

  void getMessage() {
    debugPrint('Setting_FCM_NOTIF_main#################################');
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          debugPrint('FCM_PUSH_onmsg $message');
      if(Platform.isIOS){
        message = modifyNotificationJson(message);
      }
      displayNotification(message);
      return;
    }, onResume: (Map<String, dynamic> message) async {
      debugPrint('FCM_PUSH_onresume $message');
      if(Platform.isIOS){
        displayNotification(message);
      }
      setState(() => _message = message["notification"]["title"] );
    }, onLaunch: (Map<String, dynamic> message) async {
      print('FCM_PUSH_onLaunch $message');
      setState(() => _message = message["notification"]["title"]);
    });
    if(Platform.isIOS){
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        alert: true,
        provisional: true,
        badge: true,
        sound: true,
      ));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print('Hello_REGISTERED....************************************');
      });
    }
  }

  _showLocationPermissionDialog(BuildContext context) {
    VoidCallback continueCallBack = () => {
      Navigator.of(context).pop(),
      prefs?.setString("loc", "showed"),
      getMyCurrentLocation()
    };
    BlurryLocationInfoDialog alert = BlurryLocationInfoDialog(
        "USER CONSENT", "", continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
//    checkUserLoggedInOrNot(context);
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/ic_appicon');

    var initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidRecieveLocalNotification,
    );
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    getMessage();
    _register();
    getMyCurrentLocation();
  }

  getMyCurrentLocation() async {
    debugPrint("LOCATION_FOUND accesssing ");
    prefs = await SharedPreferences.getInstance();
    if(prefs?.getString("loc") !=null && prefs?.getString("loc")?.isNotEmpty){
      /*PermissionService().requestPermission(
          onPermissionDenied: () {
        // prefs?.setString("loc", "");
        // openAppSettings();
      });*/
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
      if (await Permission.camera.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
      Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
    }else{
      _showLocationPermissionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (_) => authenticationBloc
        ..add(widget.isClrData ? MakeLogout() : CheckLoggedInEvent()),
      child: BlocListener(
        cubit: authenticationBloc,
        listener: (context, state) {
          if (state.obj != null &&
              state.obj is UserStatusObj &&
              state.obj.loginResponse != null) {
            debugPrint('SHOWCASE_STATUS: ${state.obj.isShowCaseViewed}');
            StateContainer.of(context).updateUserInfo(state.obj.loginResponse);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is LogoutAuthentucateState) {
            return LoginScreen();
          } else if (state is CheckLoggedInState) {
            if (state.obj != null && state.obj is UserStatusObj) {
              if (state.obj.isStartupIntroViewed) {
                if (state.obj.loginResponse != null) {
                  return HomeScreen(
                    shouldShowShowcase: state.obj.isShowCaseViewed,
                  );
                } else {
                  return LoginScreen();
                }
              } else {
                //Startup intro
                return StartupIntroScreen(
                  prefs: prefs,
                );
              }
            } else {
              return LoginScreen();
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
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future displayNotification(Map<String, dynamic> message) async {
    debugPrint("Inside_NOTIF_DISPLAY ${message}");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',ticker: 'ticker',
        playSound: true,enableLights: true, enableVibration: true, icon: "ic_notification_icon",
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: true, presentAlert: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      Platform.isIOS? message['title'] : message['data']['title'],
      Platform.isIOS? message['message'] :message['data']['message'],
      platformChannelSpecifics,
      payload: Platform.isIOS? message['notification_type'] :message['data']['notification_type'],
    );
  }

  Future onSelectNotification(String payload) async {
    debugPrint("......INSIDE NOTIFICATION_SELECT method....... ${payload}");
    if (payload != null) {
      debugPrint('notification payload: ${ payload == "chat"} ' + payload);
      if(payload == "chat"){
        try{
          debugPrint("REDIRECTING TO DIRECT CHAT");
          if(SingletonClass().isHomePageLoaded!=null && SingletonClass().isHomePageLoaded?.isNotEmpty){
            debugPrint("REDIRECTING TO DIRECT CHAT222222");
            if(SingletonClass().isChatPageLoaded!=null && SingletonClass().isChatPageLoaded?.isNotEmpty){
              // redirectToChatScreen();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      isRedirectToChat: true,
                    ))
              );
            }else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatHomeScreen())
              );
            }
          } else {
            redirectToChatScreen();
          }
        }on Exception catch (_){
          debugPrint("REDIRECTING EXXXXXX");
        }
      }else{
        debugPrint("REDIRECTING TO ONLY HOME");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()),
              (route) => false,
        );
      }
    }else{
      debugPrint("......OUTSIDE_ELSE NOTIFICATION_SELECT method....... ${payload}");
    }
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  redirectToChatScreen() {
    debugPrint("REDIRECTING thorugh HOME to CHAT");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
              isRedirectToChat: true,
            ))
    );
    /*Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(
                isRedirectToChat: true,
              )),
      (route) => false,
    );*/
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

class StartupIntroScreen extends StatefulWidget {
  SharedPreferences prefs;

  StartupIntroScreen({Key key, this.prefs}) : super(key: key);

  @override
  _StartupIntroScreenState createState() => _StartupIntroScreenState();
}

class _StartupIntroScreenState extends State<StartupIntroScreen>  with SingleTickerProviderStateMixin {
  List<String> mList = List();
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();
  final CarouselController _controller = CarouselController();
  int _current = 0;
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
    mList.add("assets/images/splash1.png");
    mList.add("assets/images/splash2.png");
    mList.add("assets/images/splash3.png");
    mList.add("assets/images/splash4.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        height: getFullScreenHeight(context),
                        enableInfiniteScroll: false,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                          if(index == 3){
                            controller.reverse();
                          }else{
                            controller.forward();
                          }
                          // switch (controller.status) {
                          //   case AnimationStatus.completed:
                          //     controller.reverse();
                          //     break;
                          //   case AnimationStatus.dismissed:
                          //     controller.forward();
                          //     break;
                          //   default:
                          // }
                        }),
                    carouselController: _controller,
                    items: mList
                        .map((item) => GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(),
                            height: double.infinity,
                            child: Image.asset(
                              mList[_current],
                              fit: BoxFit.fill,
                              height: double.infinity,
                              width: double.infinity,
                                gaplessPlayback: true
                            ),
                          ),
                        ],
                      ),
                    ))
                        .toList(),
                  ),
                ],
              ),
                Align(
                alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: (){
                      if(widget.prefs!=null){
                        widget.prefs.setString(IS_INTRO_VIEWED, "true");
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "SKIP", style: CommonStyles.getMontserratStyle(space_15, FontWeight.w500, Colors.white),
                    )
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _current == 3
                    ? SlideTransition(
                  position: offset,
                  child: Container(
                    margin: EdgeInsets.only(bottom: space_10, left: space_15, right: space_15),
                    child: GestureDetector(
                      onTap: (){
                        if(widget.prefs!=null){
                          widget.prefs.setString(IS_INTRO_VIEWED, "true");
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Card(
                        color: CommonStyles.blue,
                        elevation: space_3,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(space_15),
                                child: Text(
                                  "GET STARTED !",
                                  style: CommonStyles.getMontserratStyle(
                                      space_14, FontWeight.w600, Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: mList.map((url) {
                      int index = mList.indexOf(url);
                      return _current == index
                          ? Container(
                        width: space_12,
                        height: space_12,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Container(
                            width: space_5,
                            height: space_5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle),
                          ),
                        ),
                      )
                          : Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          )),
    );
    // return Scaffold(body: IntroImgCarousalWidget(mList, widget.prefs));
    // return BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //     builder: (context, state) {
    //       return Scaffold(body: IntroImgCarousalWidget(mList, widget.prefs));
    //     });
  }
}
// IntroImgCarousalWidget(mList, widget.prefs);

class BlurryLocationInfoDialog extends StatelessWidget {
  String title;
  String content;
  VoidCallback continueCallBack;

  BlurryLocationInfoDialog(this.title, this.content, this.continueCallBack);

  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: space_15, vertical: space_15),
                  child: Text(
                    title,
                    style: CommonStyles.getMontserratStyle(space_15, FontWeight.w600, Colors.black),
                  ),
                ),
                IconButton(icon: Icon(Icons.close, color: Colors.black,), onPressed: (){
                  Navigator.of(context).pop();
                })
              ],
            ),
            SizedBox(height: space_15,),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: space_15),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    RichText(
                      text: new TextSpan(
                        text: PERMISSION_CONSENT_MSG1,
                        style: CommonStyles.getMontserratStyle(space_15, FontWeight.w500, Colors.black),
                        children: <TextSpan>[
                          new TextSpan(
                            text: PERMISSION_CONSENT_MSG2,
                            style: CommonStyles.getMontserratStyle(space_15, FontWeight.w600, Colors.black),
                          ),
                          new TextSpan(
                            text: PERMISSION_CONSENT_MSG3,
                            style: CommonStyles.getMontserratStyle(space_15, FontWeight.w500, Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: space_15,),
                    new Text(
                      PERMISSION_CONSENT_SUBMSG,
                      style: CommonStyles.getMontserratStyle(space_15, FontWeight.w600, Colors.black),
                    ),
                    SizedBox(height: space_15,),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      continueCallBack();
                    },
                    child: Center(child: Container(
                      margin: EdgeInsets.symmetric(vertical: 25),
                        padding: EdgeInsets.symmetric(vertical: space_10, horizontal: space_15),
                        decoration: BoxDecoration(
                            color: CommonStyles.primaryColor
                        ),
                        child: Text("Allow access", style: CommonStyles.getMontserratStyle(space_14, FontWeight.w600, Colors.white),))),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
/*AlertDialog(
          title: new Text(
            title,
            style: CommonStyles.getMontserratStyle(space_15, FontWeight.w600, Colors.black),
          ),
          content: Container(
            height: 400,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: space_15,),
                RichText(
                  text: new TextSpan(
                    text: PERMISSION_CONSENT_MSG1,
                    style: CommonStyles.getMontserratStyle(space_15, FontWeight.w500, Colors.black),
                    children: <TextSpan>[
                      new TextSpan(
                        text: PERMISSION_CONSENT_MSG2,
                        style: CommonStyles.getMontserratStyle(space_15, FontWeight.w600, Colors.black),
                      ),
                      new TextSpan(
                        text: PERMISSION_CONSENT_MSG3,
                        style: CommonStyles.getMontserratStyle(space_15, FontWeight.w500, Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: space_15,),
                new Text(
                  PERMISSION_CONSENT_SUBMSG,
                  style: CommonStyles.getMontserratStyle(space_15, FontWeight.w600, Colors.black),
                ),
                SizedBox(height: space_15,),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Allow"),
              onPressed: () {
                continueCallBack();
              },
            ),
            new FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )*/
}
