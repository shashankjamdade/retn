import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationBloc.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationEvent.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationState.dart';
import 'package:flutter_rentry/inherited/StateContainer.dart';
import 'package:flutter_rentry/model/login_response.dart';
import 'package:flutter_rentry/screens/ChatDetailScreen.dart';
import 'package:flutter_rentry/screens/ChatHomeScreen.dart';
import 'package:flutter_rentry/screens/ChildSubCategoryScreen.dart';
import 'package:flutter_rentry/screens/DashboardScreen.dart';
import 'package:flutter_rentry/screens/Demo.dart';
import 'package:flutter_rentry/screens/Demo2.dart';
import 'package:flutter_rentry/screens/FilterScreen.dart';
import 'package:flutter_rentry/screens/HomeScreen.dart';
import 'package:flutter_rentry/screens/ItemDetailScreen.dart';
import 'package:flutter_rentry/screens/OtpVerificationScreen.dart';
import 'package:flutter_rentry/screens/ProfileScreen.dart';
import 'package:flutter_rentry/screens/RegisterScreen.dart';
import 'package:flutter_rentry/screens/SearchLocationScreen.dart';
import 'package:flutter_rentry/screens/SearchProductScreen.dart';
import 'package:flutter_rentry/screens/SplashScreen.dart';
import 'package:flutter_rentry/screens/SubCategoryScreen.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  SharedPreferences.setMockInitialValues({});
  runApp(StateContainer(child: MyApp()));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String mobile;

  @override
  void initState() {
    super.initState();
//    setState(() {
//      checkUserLoggedInOrNot(context).then((value) => mobile = value);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (_) => AuthenticationBloc()..add(InitialAuthenticationEvent()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          return FutureBuilder<String>(
              future: checkUserLoggedInOrNot(context),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!=null && snapshot.data.isNotEmpty){
                    debugPrint("SNAP-------- ${snapshot.data}");
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Rentry',
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      home: HomeScreen(),
                    );
                  }else{
                    debugPrint("SNAP-------- ${snapshot.data}");
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Rentry',
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      home: SplashScreen(),
                    );
                  }
                }else{
                  return Center(child: CircularProgressIndicator(),);
                }
              }
          );
        },
      ),
    );
  }
}

Future<String> checkUserLoggedInOrNot(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  bool flag = prefs.getBool(IS_LOGGEDIN);
 var mobile = prefs.getString(USER_MOBILE);
 mobile = mobile!=null && mobile.isNotEmpty?mobile:"";
 debugPrint("PREFS_READ -- ${mobile}");
 if(mobile.isNotEmpty){
   var response = LoginResponse.fromJson(jsonDecode(prefs.getString(USER_LOGIN_RES)));
   StateContainer.of(context).updateUserInfo(response);
 }
  return mobile;
//  LoginResponse response;
//  if(flag){
//    response = LoginResponse.fromJson(jsonDecode(prefs.getString(USER_LOGIN_RES)));
//  }else{
//    response = null;
//  }
//  debugPrint("ISLOGGEDIN-----> ${flag}");
//  return response;
}

class PageSnip extends StatefulWidget {
  @override
  _PageSnipState createState() => _PageSnipState();
}

class _PageSnipState extends State<PageSnip> {

  List<int> list = [1, 2, 3, 4, 5];
  PageController controller = PageController(keepPage: false, viewportFraction: 0.5);
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PageView.builder(
          itemCount: 5,
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, pos) {
            return Container(
              height: 20.0,
              width: 20.0,
              color: Colors.black,
              margin: EdgeInsets.all(5.0),
            );
          }),
    );
  }
}



class YourPage extends StatefulWidget {
  YourPage({Key key}) : super(key: key);

  @override
  _YourPageState createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> {
  ScrollController _scrollController;
  double _scrollPosition;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Position $_scrollPosition pixels'),
      ),
      body: Container(
          child: ListView.builder(
        controller: _scrollController,
        itemCount: 200,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.mood),
            title: Text('Item: $index'),
          );
        },
      )),
    );
  }
}
