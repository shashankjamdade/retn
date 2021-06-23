import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/get_my_package_list_res.dart';
import 'package:flutter_rentry_new/model/get_notification_response.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
import 'package:intl/intl.dart';  //for date format


class MyPackageListScreen extends StatefulWidget {
  @override
  _MyPackageListScreenState createState() => _MyPackageListScreenState();
}

class _MyPackageListScreenState extends State<MyPackageListScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  GetMyPackageListRes mGetNotificationResponse;
  var loginResponse;
  var token = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_HOME_SCREEN---------");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if(loginResponse!=null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc..add(GetMyPackageEvent(token: token)),
      child: BlocListener(
          cubit: homeBloc,
          listener: (context, state) {
            if(state is GetMyPackageListState){
              mGetNotificationResponse = state.res;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state){
              if(state is GetMyPackageListState){
                return getScreenUI(state.res);
              }else {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(backgroundColor: Colors.white,),
                  ),
                );
              }
            },
          )),
    );
  }

  Widget getScreenUI(GetMyPackageListRes getMyPackageListRes){
    if(getMyPackageListRes.status){
      if(getMyPackageListRes.data!=null && getMyPackageListRes.data.length > 0){
        return  SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                    child: Column(
                      children: [
                        CommonAppbarWidget(app_name, skip_for_now, () {
                          onSearchLocation(context);
                        }),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            primary: true,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: space_60),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: getMyPackageListRes.data.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index){
                                      DateFormat dateFormatter = new DateFormat('dd MMM yyyy');
                                      var startDate = dateFormatter.format(DateTime.parse(getMyPackageListRes.data[index].package_start_date));
                                      var expiryDate = dateFormatter.format(DateTime.parse(getMyPackageListRes.data[index].package_expiry_date));
                                      return Container(
                                        padding: EdgeInsets.all(space_15),
                                        margin: EdgeInsets.only(top: space_10, bottom: space_5, left: space_15, right: space_15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(space_15),
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey,)
                                            ]
                                        ),
                                        child: Text(
                                          "${getMyPackageListRes.data[index].title} \n"
                                              "${startDate} to ${expiryDate}\n"
                                              "No of Post: ${getMyPackageListRes.data[index].no_of_posts}\n"
                                              "Used: ${getMyPackageListRes.data[index].used}\n"
                                              "Due: ${getMyPackageListRes.data[index].due}\n"
                                              "Amount: ${getMyPackageListRes.data[index].amount}", style: CommonStyles.getMontserratStyle(space_15, FontWeight.w500, Colors.black),),
                                      );
                                    }),
                              ),
                              SizedBox(height: space_80,)
                            ],
                          ),
                        ),
                      ],
                    )),
                CommonBottomNavBarWidget(),
              ],
            ),
          ),
        );
      }else{
        return EmptyWidget("No package found");
      }
    }else{
      return Container(
        margin: EdgeInsets.symmetric(horizontal: space_15),
        child: Center(
        child: Text(getMyPackageListRes.message, style: CommonStyles.getMontserratStyle(space_15, FontWeight.w600, Colors.black),),
      ),);
    }
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
