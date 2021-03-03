import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
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

class HomeScreen extends StatefulWidget {
  var isRedirectToMyAds = false;
  var isRedirectToChat = false;

  HomeScreen({this.isRedirectToMyAds, this.isRedirectToChat});

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

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_HOME_SCREEN---------");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
    var selectedCurrentLoc = StateContainer.of(context).mUserLocationSelected;
    var selectedLoc = StateContainer.of(context).mUserLocNameSelected;
    if (selectedLoc != null) {
      mLat = selectedLoc.mlat;
      mLng = selectedLoc.mlng;
      debugPrint("ACCESSING_INHERITED_LOCATION ${mLat}, ${mLng} ------");
    } else if (selectedCurrentLoc != null) {
      mLat = selectedCurrentLoc.mlat;
      mLng = selectedCurrentLoc.mlng;
      debugPrint("ACCESSING_INHERITED_LOCATION ${mLat}, ${mLng} ------");
    }
   /* if (mLat != null && mLat.isNotEmpty) {
      new HomeRepository()
          .callCouponRes(mLat, mLng)
          .then((value) => resetUiAgain(value));
    }*/
  }

  resetUiAgain(CouponRes couponRes) {
    mCouponRes = couponRes;
    if (mHomeResponse != null) {
      getHomeUI(mHomeResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      child: BlocProvider(
        create: (context) =>
            homeBloc..add(HomeReqAuthenticationEvent(token: token)),
        child: BlocListener(
            bloc: homeBloc,
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
                mHomeResponse = state.res;
                if (widget.isRedirectToMyAds != null &&
                    widget.isRedirectToMyAds) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAdsListScreen()),
                  );
                } else if (widget.isRedirectToChat != null &&
                    widget.isRedirectToChat) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatHomeScreen()),
                  );
                }
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeResState) {
                  return getHomeUI(state.res);
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

  Widget getHomeUI(HomeResponse homeResponse) {
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
                      homeBloc..add(HomeReqAuthenticationEvent(token: token));
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
            CommonBottomNavBarWidget(),
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
