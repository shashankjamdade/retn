import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/SingletonClass.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/coupon_res.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/ChatHomeScreen.dart';
import 'package:flutter_rentry_new/screens/postad/MyAdsListScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreen extends StatefulWidget {
  var isRedirectToMyAds = false;
  var isRedirectToChat = false;
  var shouldShowShowcase = false;

  HomeScreen(
      {this.isRedirectToMyAds, this.isRedirectToChat, this.shouldShowShowcase});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  HomeResponse mHomeResponse;
  var loginResponse;
  var token = "";
  var mLat = "";
  var mLng = "";
  CouponRes mCouponRes;
  var isNeedToShowRetry = false;
  GlobalKey postAdKey;
  var shouldShowShowcase = true;
  SharedPreferences prefs;
  var isRedirectToChatLocal = false;

  @override
  void initState() {
    super.initState();
    postAdKey = GlobalKey();
    debugPrint("ENTRY_HOME_SCREEN---------");
    checkShowcaseShowOrNot(context);
    isRedirectToChatLocal = widget.isRedirectToChat;
  }

  void checkShowcaseShowOrNot(BuildContext context) async {
    try {
      prefs = await SharedPreferences.getInstance();
      bool isShowCaseViewed = (prefs.getString(IS_SHOWCASE_VIEWED) != null &&
              prefs.getString(IS_SHOWCASE_VIEWED).isNotEmpty)
          ? true
          : false;
      debugPrint("CHECKINGFORSHOWCASE --> ${isShowCaseViewed}");
      setState(() {
        shouldShowShowcase = isShowCaseViewed;
      });
    } catch (e) {
      debugPrint(
          "EXCEPTION in Homescreen in checkShowcaseShowOrNot ${e.toString()}");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("LISTENING_HOME_CHANGE ------");
    if (state == AppLifecycleState.resumed) {}
  }

  /*@override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    debugPrint("LISTENING_HOME_CHANGE UPDATE");
    if (mHomeResponse != null) {
      var selectedCurrentLoc = StateContainer
          .of(context)
          .mUserLocationSelected;
      var selectedLoc = StateContainer
          .of(context)
          .mUserLocNameSelected;
      if (selectedLoc != null) {
        setState(() {
          mLat = selectedLoc.mlat;
          mLng = selectedLoc.mlng;
        });
        debugPrint("ACCESSING_INHERITED_LOCATION1 ${mLat}, ${mLng} ------");
        if (homeBloc != null) {
          homeBloc
            ..add(
                HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
        }
      } else if (selectedCurrentLoc != null) {
        mLat = selectedCurrentLoc.mlat;
        mLng = selectedCurrentLoc.mlng;
        debugPrint("ACCESSING_INHERITED_LOCATION2 ${mLat}, ${mLng} ------");
        if (homeBloc != null) {
          homeBloc
            ..add(
                HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }*/

  @override
  void didChangeDependencies() {
    var selectedCurrentLoc = StateContainer.of(context).mUserLocationSelected;
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED_HOME ${token}");
    }
    var selectedLoc = StateContainer.of(context).mUserLocNameSelected;
    if (selectedLoc != null) {
      setState(() {
        mLat = selectedLoc.mlat;
        mLng = selectedLoc.mlng;
      });
      debugPrint("ACCESSING_INHERITED_LOCATION1 ${mLat}, ${mLng} ------");
      if (homeBloc != null) {
        homeBloc
          ..add(HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
      }
    } else if (selectedCurrentLoc != null) {
      mLat = selectedCurrentLoc.mlat;
      mLng = selectedCurrentLoc.mlng;
      debugPrint("ACCESSING_INHERITED_LOCATION2 ${mLat}, ${mLng} ------");
//      if (mHomeResponse == null) {
//        homeBloc
//          ..add(
//              HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
//      }
    } else {
      storeResInPrefs(context);
    }
    /* if (mLat != null && mLat.isNotEmpty) {
      new HomeRepository()
          .callCouponRes(mLat, mLng)
          .then((value) => resetUiAgain(value));
    }*/
    super.didChangeDependencies();
  }

  void storeResInPrefs(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        prefs.setString(USER_LOCATION_LAT, "${position.latitude}");
        prefs.setString(USER_LOCATION_LONG, "${position.longitude}");
        debugPrint(
            "LOCATION_FOUND ${position.latitude}, ${position.longitude}");
        //access address from lat lng
        final coordinates =
            new Coordinates(position.latitude, position.longitude);
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

        prefs.setBool(IS_LOGGEDIN, true);
        debugPrint(
            "PREFS_STORED_LOGIN-----> ${prefs.getString(USER_LOCATION_ADDRESS)}");
        mLat = position.latitude.toString();
        mLng = position.longitude.toString();
        // if (mHomeResponse == null && isNeedToShowRetry) {
        //   homeBloc
        //     ..add(
        //         HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
        // }
      } else {
        //Show dialog for location permission
      }
    } catch (e) {
      debugPrint("EXCEPTION in Loginscreen in storeResInPrefs ${e.toString()}");
    }
  }

  resetUiAgain(CouponRes couponRes) {
    mCouponRes = couponRes;
    if (mHomeResponse != null) {
      return ((shouldShowShowcase == false)
          ? ShowCaseWidget(
              onStart: (index, key) {
                debugPrint('onStart: $index, $key');
              },
              onComplete: (index, key) {
                debugPrint('onComplete1: $index, $key');
                if (prefs != null) {
                  debugPrint('onComplete1: SAVED');
                  prefs.setString(IS_SHOWCASE_VIEWED, "true");
                  shouldShowShowcase = true;
                }
              },
              builder: Builder(
                  builder: (context) =>
                      getHomeShowcaseUI(mHomeResponse, context)),
              autoPlay: false,
              autoPlayDelay: Duration(seconds: 3),
              autoPlayLockEnable: false,
            )
          : getHomeUI(mHomeResponse, context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      child: BlocProvider(
        create: (context) => homeBloc
          ..add(HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng)),
        child: BlocListener(
            cubit: homeBloc,
            listener: (context, state) {
              if (state is HomeResState) {
//              var screenHeight = MediaQuery.of(context).size.height;
//              debugPrint("SCREEN_HEIGHT--> ${screenHeight}");
//              Fluttertoast.showToast(
//                  msg: "${screenHeight}",
//                  toastLength: Toast.LENGTH_SHORT,
//                  gravity: ToastGravity.BOTTOM,
//                  timeInSecForIosWeb: 1,
//                  backgroundColor: Colors.black,
//                  textColor: Colors.white,
//                  fontSize: space_14);
                if (state.res.status) {
                  //Set true for homepage loaded
                  SingletonClass().setIsHomeLoaded("true");
                  // StateContainer.of(context).updateHomePageLoaded("true");
                  isNeedToShowRetry = false;
                  mHomeResponse = state.res;
                  if (widget.isRedirectToMyAds != null &&
                      widget.isRedirectToMyAds) {
                    widget.isRedirectToMyAds = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAdsListScreen()),
                    );
                  } else if (isRedirectToChatLocal != null &&
                      isRedirectToChatLocal) {
                    debugPrint("REDIRECTING...to chat");
                    isRedirectToChatLocal = false;
                    isRedirectToChatLocal = null;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatHomeScreen()),
                    );
                  }
                } else {
                  if (state.res.message != null &&
                      state.res.message != API_ERROR_MSG_RETRY) {
                    isNeedToShowRetry = false;
                    homeBloc
                      ..add(HomeReqAuthenticationEvent(
                          token: token, lat: mLat, lng: mLng));
                  } else {
                    isNeedToShowRetry = true;
                  }
                }
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeResState && state.res is HomeResponse) {
                  if (state.res.status) {
                    return ((shouldShowShowcase == false)
                        ? ShowCaseWidget(
                            onStart: (index, key) {
                              debugPrint('onStart: $index, $key');
                            },
                            onComplete: (index, key) {
                              debugPrint('onComplete1: $index, $key');
                              if (prefs != null) {
                                debugPrint('onComplete1: SAVED');
                                prefs.setString(IS_SHOWCASE_VIEWED, "true");
                                shouldShowShowcase = true;
                              }
                            },
                            builder: Builder(
                                builder: (context) =>
                                    getHomeShowcaseUI(state.res, context)),
                            autoPlay: false,
                            autoPlayDelay: Duration(seconds: 3),
                            autoPlayLockEnable: false,
                          )
                        : getHomeUI(state.res, context));
                  } else {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          CommonAppbarWidget(app_name, skip_for_now, () {
                            onSearchLocation(context);
                          }),
                          Expanded(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Something went wrong!!',
                                    style: CommonStyles.getRalewayStyle(
                                        space_16,
                                        FontWeight.w500,
                                        Colors.black),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      homeBloc
                                        ..add(HomeReqAuthenticationEvent(
                                            token: token,
                                            lat: mLat,
                                            lng: mLng));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(space_15),
                                      child: Text(
                                        'RETRY',
                                        style: TextStyle(
                                          fontSize: space_18,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w700,
                                          color: CommonStyles.primaryColor,
                                          decoration: TextDecoration.underline,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          decorationColor:
                                              CommonStyles.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  );
                }
              },
            )),
      ),
    );
  }

  Widget getHomeUI(HomeResponse homeResponse, BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                child: Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  child: Container(
                      child: RefreshIndicator(
                    onRefresh: () {
                      homeBloc
                        ..add(HomeReqAuthenticationEvent(
                            token: token, lat: mLat, lng: mLng));
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        BannerImgCarousalWidget(homeResponse),
                        Container(
                            child:
                                RichTextTitleBtnWidget("TOP", "CATEGORIES", () {
                          redirectToCategoryList(context);
                        })),
                        SizedBox(
                          height: space_15,
                        ),
                        CategoryGridWidget(homeResponse),
                        SizedBox(
                          height: space_25,
                        ),
//                        Container(
//                            child: RichTextTitleBtnWidget("TOP", "OFFERS", () {
//                          redirectToOfferList(context);
//                        })),
//                        SizedBox(
//                          height: space_15,
//                        ),
//                        mCouponRes != null
//                            ? Align(
//                                alignment: Alignment.topLeft,
//                                child: BannersCarousalWidget(mCouponRes))
//                            : Container(
//                                height: 0,
//                                width: 0,
//                              ),
//                        SizedBox(
//                          height: mCouponRes != null ? space_15 : 0,
//                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: homeResponse.data.category_ads != null
                                ? homeResponse.data.category_ads.length
                                : 0,
                            itemBuilder: (context, parentPos) {
                              return Column(
                                children: [
                                  Container(
                                    height: space_370,
                                    color: CommonStyles.blue.withOpacity(0.1),
                                    child: Column(
                                      children: [
                                        RichTextTitleBtnWidget(
                                            "TOP",
                                            homeResponse
                                                .data
                                                .category_ads[parentPos]
                                                .category_name, () {
                                          onViewAllClick(
                                              context,
                                              TYPE_FURNITURE,
                                              homeResponse
                                                  .data
                                                  .category_ads[parentPos]
                                                  .category_adslist[0]
                                                  .category,
                                              homeResponse
                                                  .data
                                                  .category_ads[parentPos]
                                                  .category_name);
                                        }),
                                        Container(
                                          height: space_280,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: homeResponse
                                                  .data
                                                  .category_ads[parentPos]
                                                  .category_adslist
                                                  .length,
                                              itemBuilder: (context, childPos) {
                                                return Container(
                                                    height: space_300,
                                                    child: ItemCardWidget(
                                                        category_adslist: homeResponse
                                                                .data
                                                                .category_ads[
                                                                    parentPos]
                                                                .category_adslist[
                                                            childPos]));
                                              }),
                                        ),
                                        SizedBox(
                                          height: space_20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: space_20,
                                  ),
                                ],
                              );
                            }),
                        SizedBox(
                          height: space_90,
                        ),
                      ],
                    ),
                  )),
                )
              ],
            )),
            CommonBottomNavBarHomeWidget(
                postKey: postAdKey, shouldShowShowcase: shouldShowShowcase),
          ],
        ),
      ),
    );
  }

  Widget getHomeShowcaseUI(HomeResponse homeResponse, BuildContext context) {
    if (!shouldShowShowcase) {
      debugPrint("ENTRY_HOME_SCREEN--------- ${shouldShowShowcase}");
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([postAdKey]));
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                child: Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  child: Container(
                      child: RefreshIndicator(
                    onRefresh: () {
                      homeBloc
                        ..add(HomeReqAuthenticationEvent(
                            token: token, lat: mLat, lng: mLng));
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        BannerImgCarousalWidget(homeResponse),
                        Container(
                            child:
                                RichTextTitleBtnWidget("TOP", "CATEGORIES", () {
                          redirectToCategoryList(context);
                        })),
                        SizedBox(
                          height: space_15,
                        ),
                        CategoryGridWidget(homeResponse),
                        SizedBox(
                          height: space_25,
                        ),
//                        Container(
//                            child: RichTextTitleBtnWidget("TOP", "OFFERS", () {
//                          redirectToOfferList(context);
//                        })),
//                        SizedBox(
//                          height: space_15,
//                        ),
//                        mCouponRes != null
//                            ? Align(
//                                alignment: Alignment.topLeft,
//                                child: BannersCarousalWidget(mCouponRes))
//                            : Container(
//                                height: 0,
//                                width: 0,
//                              ),
//                        SizedBox(
//                          height: mCouponRes != null ? space_15 : 0,
//                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: homeResponse.data.category_ads != null
                                ? homeResponse.data.category_ads.length
                                : 0,
                            itemBuilder: (context, parentPos) {
                              return Column(
                                children: [
                                  Container(
                                    height: space_370,
                                    color: CommonStyles.blue.withOpacity(0.1),
                                    child: Column(
                                      children: [
                                        RichTextTitleBtnWidget(
                                            "TOP",
                                            homeResponse
                                                .data
                                                .category_ads[parentPos]
                                                .category_name, () {
                                          onViewAllClick(
                                              context,
                                              TYPE_FURNITURE,
                                              homeResponse
                                                  .data
                                                  .category_ads[parentPos]
                                                  .category_adslist[0]
                                                  .category,
                                              homeResponse
                                                  .data
                                                  .category_ads[parentPos]
                                                  .category_name);
                                        }),
                                        Container(
                                          height: space_280,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: homeResponse
                                                  .data
                                                  .category_ads[parentPos]
                                                  .category_adslist
                                                  .length,
                                              itemBuilder: (context, childPos) {
                                                return Container(
                                                    height: space_300,
                                                    child: ItemCardWidget(
                                                        category_adslist: homeResponse
                                                                .data
                                                                .category_ads[
                                                                    parentPos]
                                                                .category_adslist[
                                                            childPos]));
                                              }),
                                        ),
                                        SizedBox(
                                          height: space_20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: space_20,
                                  ),
                                ],
                              );
                            }),
                        SizedBox(
                          height: space_90,
                        ),
                      ],
                    ),
                  )),
                )
              ],
            )),
            CommonBottomNavBarHomeShowCaseWidget(
                postKey: postAdKey, shouldShowShowcase: shouldShowShowcase)
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60.0);
    path.quadraticBezierTo(size.width, size.height - 60, size.width / 2, 0);

//    path.lineTo(size.height, size.height);
//    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[800];
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
