import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
//
//class ChildSubCategoryScreen extends StatefulWidget {
//  @override
//  _ChildSubCategoryScreenState createState() => _ChildSubCategoryScreenState();
//}
//
//class _ChildSubCategoryScreenState extends State<ChildSubCategoryScreen> {
//  TrackingScrollController controller = TrackingScrollController();
//
//  @override
//  Widget build(BuildContext context) {
//    var size = MediaQuery.of(context).size;
//
//    /*24 is for notification bar on Android*/
//    final double itemHeight = (size.height -  getProportionateScreenHeight(context, space_160) - getProportionateScreenHeight(context, 24.0)) / 2;
//    final double itemWidth = size.width / 2;
//
//    return Scaffold(
//      body: SafeArea(
//        child: Stack(
//          children: [
//            Container(
//                child: Column(
//              children: [
//                CommonAppbarWidget(app_name, skip_for_now, () {
//                  onSearchLocation(context);
//                }),
//                Container(
//                  margin: EdgeInsets.only(
//                    left: space_15,
//                      top: getProportionateScreenHeight(context, space_15)),
//                  child: Row(
//                    children: [
//                      Text("BEDS", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w800, CommonStyles.red),),
//                      SizedBox(height: space_15,),
//                      Container(height: space_15, child: VerticalDivider(thickness: space_2, color: CommonStyles.grey, indent: space_3,)),
//                      Text("FURNITURE", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w800, CommonStyles.blue),),
//                      Container(height: space_15, child: VerticalDivider(thickness: space_2, color: CommonStyles.grey, indent: space_3,)),
//                      RichTextTitleWidget("SUB", "CATEGORIES"),
//                    ],
//                  ),
//                ),
//                SizedBox(height: space_15,),
//                Expanded(
//                  child: ListView(
//                    children: [
//                      Container(
//                        child:  GridView.builder(
//                          shrinkWrap: true,
//                          primary: false,
//                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                            childAspectRatio: (getProportionateScreenWidth(context, space_230) / (Platform.isIOS ? getProportionateScreenHeight(context, space_300) : getProportionateScreenHeight(context, space_370))),
//                            crossAxisCount: 2,
//                            crossAxisSpacing: 5.0,
//                            mainAxisSpacing: 5.0,
//                          ),
//                          itemCount: 10,
//                          itemBuilder: (context, index) {
//                            return Container(
//                              height: space_280,
//                              width: space_230,
//                              child: ItemCardNoMarginWidget(),
//                            );
//                          },
//                        ),
//
//                      ),
//                      SizedBox(height: space_110,)
//                    ],
//                  ),
//                ),
//              ],
//            )),
//            CommonBottomNavBarWidget(),
//            Align(
//              alignment: Alignment.bottomRight,
//              child: Container(
//                  child: BottomFloatingFilterBtnsWidget()),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  void onSearchClick() {}
//}
