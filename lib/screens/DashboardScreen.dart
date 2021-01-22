//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:flutter_rentry/utils/CommonStyles.dart';
//import 'package:flutter_rentry/utils/Constants.dart';
//import 'package:flutter_rentry/utils/my_flutter_app_icons.dart';
//import 'package:flutter_rentry/utils/size_config.dart';
//import 'package:flutter_rentry/widgets/CarousalCommonWidgets.dart';
//import 'package:flutter_rentry/widgets/CommonWidget.dart';
//import 'package:flutter_rentry/widgets/ListItemCardWidget.dart';
//
//class DashboardScreen extends StatefulWidget {
//  @override
//  _DashboardScreenState createState() => _DashboardScreenState();
//}
//
//class _DashboardScreenState extends State<DashboardScreen> {
//  TrackingScrollController controller = TrackingScrollController();
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: SafeArea(
//        child: Container(
//            child: Stack(
//          children: [
//            CommonAppbarWidget(app_name, skip_for_now, () {
//              onSearchLocation(context);
//            }),
//            Container(
//                margin: EdgeInsets.only(
//                    top: getProportionateScreenHeight(context, space_100)),
//                child: ListView(
//                  shrinkWrap: true,
//                  children: [
//                    BannerImgCarousalWidget(null),
//                    Container(
//                        padding: EdgeInsets.symmetric(horizontal: space_15),
//                        child: RichTextTitleWidget("TOP", "CATEGORIES")),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    CategoryGridWidget(),
//                    SizedBox(
//                      height: space_25,
//                    ),
//                    Align(
//                        alignment: Alignment.topLeft,
//                        child: BannersCarousalWidget()),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    Container(
//                      height: space_400,
//                      color: CommonStyles.blue.withOpacity(0.1),
//                      child: Column(
//                        children: [
//                          RichTextTitleBtnWidget(
//                              "TOP", getRichText2ByType(TYPE_FURNITURE), () {
//                            onViewAllClick(context, TYPE_FURNITURE);
//                          }),
//                          Container(
//                            height: space_280,
//                            child: ListView.builder(
//                                scrollDirection: Axis.horizontal,
//                                itemCount: 5,
//                                itemBuilder: (context, index) {
//                                  return Container(
//                                      height: space_300,
//                                      child: ItemCardWidget());
//                                }),
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    Container(
//                      height: space_400,
//                      color: CommonStyles.blue.withOpacity(0.1),
//                      child: Column(
//                        children: [
//                          RichTextTitleBtnWidget(
//                              "TOP", getRichText2ByType(TYPE_VEHICLE), () {
//                            onViewAllClick(context, TYPE_VEHICLE);
//                          }),
//                          Container(
//                            height: space_280,
//                            child: ListView.builder(
//                                scrollDirection: Axis.horizontal,
//                                itemCount: 5,
//                                itemBuilder: (context, index) {
//                                  return Container(
//                                      height: space_300,
//                                      child: ItemCardWidget());
//                                }),
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    Container(
//                      height: space_400,
//                      color: CommonStyles.blue.withOpacity(0.1),
//                      child: Column(
//                        children: [
//                          RichTextTitleBtnWidget(
//                              "TOP", getRichText2ByType(TYPE_ELECTRONICS), () {
//                            onViewAllClick(context, TYPE_ELECTRONICS);
//                          }),
//                          Container(
//                            height: space_280,
//                            child: ListView.builder(
//                                scrollDirection: Axis.horizontal,
//                                itemCount: 5,
//                                itemBuilder: (context, index) {
//                                  return Container(
//                                      height: space_300,
//                                      child: ItemCardWidget());
//                                }),
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    Container(
//                      height: space_400,
//                      color: CommonStyles.blue.withOpacity(0.1),
//                      child: Column(
//                        children: [
//                          RichTextTitleBtnWidget(
//                              "TOP", getRichText2ByType(TYPE_CLOTHS), () {
//                            onViewAllClick(context, TYPE_CLOTHS);
//                          }),
//                          Container(
//                            height: space_280,
//                            child: ListView.builder(
//                                scrollDirection: Axis.horizontal,
//                                itemCount: 5,
//                                itemBuilder: (context, index) {
//                                  return Container(
//                                      height: space_300,
//                                      child: ItemCardWidget());
//                                }),
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    Container(
//                      height: space_400,
//                      color: CommonStyles.blue.withOpacity(0.1),
//                      child: Column(
//                        children: [
//                          RichTextTitleBtnWidget(
//                              "TOP", getRichText2ByType(TYPE_PROPERTIES), () {
//                            onViewAllClick(context, TYPE_PROPERTIES);
//                          }),
//                          Container(
//                            height: space_280,
//                            child: ListView.builder(
//                                scrollDirection: Axis.horizontal,
//                                itemCount: 5,
//                                itemBuilder: (context, index) {
//                                  return Container(
//                                      height: space_300,
//                                      child: ItemCardWidget());
//                                }),
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    Container(
//                      height: space_400,
//                      color: CommonStyles.blue.withOpacity(0.1),
//                      child: Column(
//                        children: [
//                          RichTextTitleBtnWidget(
//                              "TOP", getRichText2ByType(TYPE_SERVICE), () {
//                            onViewAllClick(context, TYPE_SERVICE);
//                          }),
//                          Container(
//                            height: space_280,
//                            child: ListView.builder(
//                                scrollDirection: Axis.horizontal,
//                                itemCount: 5,
//                                itemBuilder: (context, index) {
//                                  return Container(
//                                      height: space_300,
//                                      child: ItemCardWidget());
//                                }),
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: space_15,
//                    ),
//                    Container(
//                      height: space_400,
//                      color: CommonStyles.blue.withOpacity(0.1),
//                      child: Column(
//                        children: [
//                          RichTextTitleBtnWidget(
//                              "TOP", getRichText2ByType(TYPE_FREELANCING), () {
//                            onViewAllClick(context, TYPE_FREELANCING);
//                          }),
//                          Container(
//                            height: space_280,
//                            child: ListView.builder(
//                                scrollDirection: Axis.horizontal,
//                                itemCount: 5,
//                                itemBuilder: (context, index) {
//                                  return Container(
//                                      height: space_300,
//                                      child: ItemCardWidget());
//                                }),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ))
//          ],
//        )),
//      ),
//      floatingActionButton: SizedBox(
//        height: getProportionateScreenHeight(context, space_70),
//        width: getProportionateScreenWidth(context, space_70),
//        child: FloatingActionButton(
//          backgroundColor: Colors.transparent,
//          elevation: 2.0,
//          onPressed: () {},
//          child: Container(
//            height: 85,
//            width: 85,
//            decoration: BoxDecoration(
//                shape: BoxShape.circle, color: CommonStyles.lightGrey),
//            child: ImageIcon(
//              AssetImage(
//                "assets/images/bottom_nav_post_rent.png",
//              ),
//              color: CommonStyles.primaryColor,
//            ),
//          ),
//        ),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      bottomNavigationBar:  Container(
//        height: getProportionateScreenHeight(context, Platform.isIOS?space_100:space_80),
//        decoration: BoxDecoration(
//            color: Colors.white.withOpacity(0.1),
//            image: DecorationImage(
//                image: AssetImage("assets/images/bottom_back.png",), fit: BoxFit.fill,)),
//        padding:  EdgeInsets.only(top: Platform.isIOS?space_25:space_15,),
//        margin: EdgeInsets.only( left: Platform.isIOS?space_10:space_0, right: Platform.isIOS?space_10:space_0,bottom: Platform.isIOS?space_10:space_0,),
//        child:  Container(
//          child: Theme(
//            data: Theme.of(context)
//                .copyWith(canvasColor: Colors.transparent),
//            child: BottomNavigationBar(
//                backgroundColor: Colors.white.withOpacity(0.1),
//                type: BottomNavigationBarType.fixed,
//                currentIndex: 0,
//                items: [
//                  BottomNavigationBarItem(
//                    icon: ImageIcon(
//                      AssetImage(
//                        "assets/images/nav_home_icon.png",
//                      ),
//                      color: Colors.white,
//                    ),
//                    title: Text(
//                      'HOME',
//                      style: CommonStyles.getRalewayStyle(
//                          space_8, FontWeight.w400, Colors.white),
//                    ),
//                    backgroundColor: Colors.white,
//                  ),
//                  BottomNavigationBarItem(
//                      icon: ImageIcon(
//                        AssetImage(
//                          "assets/images/bottom_nav_chat.png",
//                        ),
//                        color: Colors.white,
//                      ),
////                icon: Icon(MyFlutterApp.chat_icon, color: Colors.white,),
//                      title: Text(
//                        'CHAT',
//                        style: CommonStyles.getRalewayStyle(
//                            space_8, FontWeight.w400, Colors.white),
//                      )),
//                  BottomNavigationBarItem(
//                      icon: ImageIcon(
//                        AssetImage(
//                          "assets/images/bottom_nav_post_rent.png",
//                        ),
//                        color: Colors.transparent,
//                      ),
//                      title: Container(
//                          padding: EdgeInsets.only(bottom: getProportionateScreenHeight(context, space_2)),
//                          child: Text(
//                            'POST RENT',
//                            style: CommonStyles.getRalewayStyle(
//                                space_10, FontWeight.w400, Colors.white),
//                          ))),
//                  BottomNavigationBarItem(
//                      icon: ImageIcon(
//                        AssetImage(
//                          "assets/images/bottom_nav_nearby.png",
//                        ),
//                        color: Colors.white,
//                      ),
//                      title: Text(
//                        'NEARBY',
//                        style: CommonStyles.getRalewayStyle(
//                            space_8, FontWeight.w400, Colors.white),
//                      )),
//                  BottomNavigationBarItem(
//                      icon: ImageIcon(
//                        AssetImage(
//                          "assets/images/bottom_nav_login.png",
//                        ),
//                        color: Colors.white,
//                      ),
//                      title: Text(
//                        'LOGIN',
//                        style: CommonStyles.getRalewayStyle(
//                            space_8, FontWeight.w400, Colors.white),
//                      )),
//                ]),
//          ),
//        ),
//      ),
//    );
//  }
//
//  void onSearchClick() {}
//}
//
//class MyClipper extends CustomClipper<Path> {
//  @override
//  Path getClip(Size size) {
//    var path = Path();
//    path.lineTo(0, size.height - 60.0);
//    path.quadraticBezierTo(size.width, size.height - 60, size.width / 2, 0);
//
////    path.lineTo(size.height, size.height);
////    path.lineTo(0, size.height);
//    return path;
//  }
//
//  @override
//  bool shouldReclip(CustomClipper<Path> oldClipper) {
//    return true;
//  }
//}
//
//class CurvePainter extends CustomPainter {
//  @override
//  void paint(Canvas canvas, Size size) {
//    var paint = Paint();
//    paint.color = Colors.green[800];
//    paint.style = PaintingStyle.fill;
//
//    var path = Path();
//
//    path.moveTo(0, size.height * 0.9167);
//    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
//        size.width * 0.5, size.height * 0.9167);
//    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
//        size.width * 1.0, size.height * 0.9167);
//    path.lineTo(size.width, size.height);
//    path.lineTo(0, size.height);
//
//    canvas.drawPath(path, paint);
//  }
//
//  @override
//  bool shouldRepaint(CustomPainter oldDelegate) {
//    return true;
//  }
//}
