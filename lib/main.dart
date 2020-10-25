import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(StateContainer(child: MyApp()));
//  runApp(SharedPreferencesDemo());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mobile;
  AuthenticationBloc authenticationBloc = new AuthenticationBloc();

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
      create: (_) => authenticationBloc..add(CheckLoggedInEvent()),
      child: BlocListener(
        bloc: authenticationBloc,
        listener: (context, state) {
          if (state is CheckLoggedInState) {
            if (state.obj) {
            } else {}
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is CheckLoggedInState) {
              debugPrint("SNAP-------- ${state.obj}");
              if (state.obj) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Rentry',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: HomeScreen(),
                );
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Rentry',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: HomeScreen(),
                );
              }
            } else {
              return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ));
            }
          },
        ),
      ),
    );
  }
}

Future<String> checkUserLoggedInOrNot(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userStatus = prefs.getString('userStatus');
  bool flag = prefs.getBool(IS_LOGGEDIN);
  var mobile = prefs.getString(USER_NAME);
  mobile = mobile != null && mobile.isNotEmpty ? mobile : "";
  debugPrint("PREFS_READ -- ${userStatus}");
  if (mobile.isNotEmpty) {
    var response =
        LoginResponse.fromJson(jsonDecode(prefs.getString(USER_LOGIN_RES)));
    StateContainer.of(context).updateUserInfo(response);
  }
  return mobile;
}

class SharedPreferencesDemo extends StatefulWidget {
  SharedPreferencesDemo({Key key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<int> _counter;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SharedPreferences Demo"),
        ),
        body: Center(
            child: FutureBuilder<int>(
                future: _counter,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                              'This should persist across restarts.',
                        );
                      }
                  }
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}