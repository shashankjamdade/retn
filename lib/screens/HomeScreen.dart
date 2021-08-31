import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/authentication/AuthenticationState.dart';
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
import 'package:location/location.dart';
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
  var mIsShowDummyProgress = false;
  var mFetchRefreshedData = true;
  var _timer;

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
      if (prefs.getString(LOCATION_INFO_LAT) != null &&
          prefs.getString(LOCATION_INFO_LAT).isNotEmpty &&
          prefs.getString(LOCATION_INFO_LNG) != null &&
          prefs.getString(LOCATION_INFO_LNG).isNotEmpty) {
        mLat = prefs.getString(LOCATION_INFO_LAT);
        mLng = prefs.getString(LOCATION_INFO_LNG);
      }
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
    try {
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
        /*if (homeBloc != null) {
          homeBloc
            ..add(
                HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
        }*/
      } else if (selectedCurrentLoc != null) {
        setState(() {
          mLat = selectedCurrentLoc.mlat;
          mLng = selectedCurrentLoc.mlng;
        });
        debugPrint("ACCESSING_INHERITED_LOCATION2 ${mLat}, ${mLng} ------");
//      if (mHomeResponse == null) {
//        homeBloc
//          ..add(
//              HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
//      }
      } else {
        storeResInPrefs(context);
      }
    } catch (e, stacktrace) {
      debugPrint("EXCEPTION_WHILE_HOME1 ${stacktrace?.toString()}");
    }
    super.didChangeDependencies();
  }

  void storeResInPrefs(BuildContext context) async {
    try {
      var isAlreadyApiHit = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs?.getString(USER_LOCATION_LAT)!=null && prefs?.getString(USER_LOCATION_LAT)?.isNotEmpty){
        setState(() {
          mLat = prefs?.getString(USER_LOCATION_LAT);
          mLng = prefs?.getString(USER_LOCATION_LONG);
        });
        isAlreadyApiHit = true;
        homeBloc
          ..add(HomeReqAuthenticationEvent(token: token, lat: prefs?.getString(USER_LOCATION_LAT), lng: prefs?.getString(USER_LOCATION_LONG)));
      }
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.DENIED) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.GRANTED) {
          return;
        }
      }
      _locationData = await location.getLocation().then((locationData) {
        prefs.setString(USER_LOCATION_LAT, "${locationData.latitude}");
        prefs.setString(USER_LOCATION_LONG, "${locationData.longitude}");
        debugPrint(
            "LOCATION_FOUND--from Home--> ${locationData.latitude}, ${locationData.longitude}");
        // setState(() {
          mLat = locationData.latitude.toString();
          mLng = locationData.longitude.toString();
        // });
        //access address from lat lng
        if(!isAlreadyApiHit){
          homeBloc
            ..add(HomeReqAuthenticationEvent(token: token, lat: locationData.latitude.toString(), lng: locationData.longitude.toString()));
        }
        mapAddressFromLatlng(locationData.latitude, locationData.longitude);
      });
    } catch (e, stacktrace) {
      debugPrint("EXCEPTION_WHILE_HOME2 ${stacktrace?.toString()}");
    }
  }

  mapAddressFromLatlng(double lat, double lng) async {
    try {
      final coordinates = new Coordinates(lat, lng);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      UserLocationSelected userLocationSelected = new UserLocationSelected(
          address: first.addressLine,
          city: first.locality,
          state: first.adminArea,
          coutry: first.countryName,
          mlat: lat.toString(),
          mlng: lng.toString());
      StateContainer.of(context).updateUserLocation(userLocationSelected);
      prefs.setString(USER_LOCATION_ADDRESS, "${first.addressLine}");
      prefs.setString(USER_LOCATION_CITY, "${first.locality}");
      prefs.setString(USER_LOCATION_STATE, "${first.adminArea}");
      prefs.setString(USER_LOCATION_PINCODE, "${first.postalCode}");
      prefs.setString(LOCATION_INFO_LAT, "${lat.toString()}");
      prefs.setString(LOCATION_INFO_LNG, "${lng.toString()}");
      print("@@@@-------${first} ${first.addressLine} : ${first.adminArea}");
      prefs.setBool(IS_LOGGEDIN, true);
      debugPrint(
          "PREFS_STORED_LOGIN-----> ${prefs.getString(USER_LOCATION_ADDRESS)}");
    } catch (e, stacktrace) {
      debugPrint(
          "EXCEPTION in Loginscreen in storeResInPrefs ${e.toString()}\n${stacktrace.toString()}");
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
    try {
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
            ..add(
                HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng)),
          child: BlocListener(
              cubit: homeBloc,
              listener: (context, state) {
                if (state is HomeResState) {
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
                        MaterialPageRoute(
                            builder: (context) => ChatHomeScreen()),
                      );
                    }
                  } else {
                    if (state.res.message !=
                            null /*&&
                      state.res.message != API_ERROR_MSG_RETRY*/
                        ) {
                      isNeedToShowRetry = false;
                      // homeBloc
                      //   ..add(HomeReqAuthenticationEvent(
                      //       token: token, lat: mLat, lng: mLng));
                    } else {
                      isNeedToShowRetry = true;
                    }
                  }
                }
              },
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  debugPrint("HOMESCREEN_state ${state} ${mLat}");
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
                      debugPrint("HOMESCREEN_state loading is ${state}");
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
                                            decoration:
                                                TextDecoration.underline,
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
                  } else if (state is SendOtpAuthState) {
                    debugPrint("WHY_SENDOTP_IN_HOME");
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
    } catch (e, stacktrace) {
      debugPrint("EXCEPTION_WHILE_HOME4 ${stacktrace?.toString()}");
    }
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
              postKey: postAdKey,
              shouldShowShowcase: shouldShowShowcase,
              onHomeClick: onHomeBtnClick,
            ),
            mIsShowDummyProgress
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  )
          ],
        ),
      ),
    );
  }

  onHomeBtnClick() {
    debugPrint("HOME_PAGE_SCREEN----->CLICK");
    if (mHomeResponse != null) {
      debugPrint(
          "HOME_PAGE_SCREEN----->FETCHREFRESHDATA ${mFetchRefreshedData}");
      if (mFetchRefreshedData) {
        //API hit
        debugPrint("HOME_PAGE_SCREEN----->API hit ${mFetchRefreshedData}");
        resetRefreshTimer();
        homeBloc
          ..add(HomeReqAuthenticationEvent(token: token, lat: mLat, lng: mLng));
      } else {
        //Dummy progress
        debugPrint("HOME_PAGE_SCREEN----->DUMMY ${mFetchRefreshedData}");
        homeBloc..add(ProgressEvent());
        Future.delayed(const Duration(seconds: 2), () {
          debugPrint("HOME_PAGE_SCREEN----->DUMMYAPI--HomeDummy");
          homeBloc..add(HomeResDummyEvent(homeResponse: mHomeResponse));
        });
      }
    } else {
      debugPrint(
          "HOME_PAGE_SCREEN----->No prev home data ${mFetchRefreshedData}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  resetRefreshTimer() {
    mFetchRefreshedData = false;
    _timer = new Timer.periodic(Duration(seconds: 60), (_) {
      mFetchRefreshedData = true;
    });
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

// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height - 60.0);
//     path.quadraticBezierTo(size.width, size.height - 60, size.width / 2, 0);
//
// //    path.lineTo(size.height, size.height);
// //    path.lineTo(0, size.height);
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint.color = Colors.green[800];
//     paint.style = PaintingStyle.fill;
//
//     var path = Path();
//
//     path.moveTo(0, size.height * 0.9167);
//     path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
//         size.width * 0.5, size.height * 0.9167);
//     path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
//         size.width * 1.0, size.height * 0.9167);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
