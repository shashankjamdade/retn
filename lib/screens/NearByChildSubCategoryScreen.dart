import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/Constants.dart';
import 'package:flutter_rentry/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';
import 'package:flutter_rentry/widgets/ListItemCardWidget.dart';

class NearByChildSubCategoryScreen extends StatefulWidget {
  @override
  _NearByChildSubCategoryScreenState createState() => _NearByChildSubCategoryScreenState();
}

class _NearByChildSubCategoryScreenState extends State<NearByChildSubCategoryScreen> {
  TrackingScrollController controller = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height -  getProportionateScreenHeight(context, space_160) - getProportionateScreenHeight(context, 24.0)) / 2;
    final double itemWidth = size.width / 2;

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
                Container(
                  margin: EdgeInsets.only(
                    left: space_15,
                      top: getProportionateScreenHeight(context, space_15)),
                  child: Row(
                    children: [
                      Text("BROWSE BY NEARME", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w800, Colors.black),),
                     ],
                  ),
                ),
                SizedBox(height: space_15,),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        child:  GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (getProportionateScreenWidth(context, space_230) / (Platform.isIOS ? getProportionateScreenHeight(context, space_300) : getProportionateScreenHeight(context, space_370))),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              height: space_280,
                              width: space_230,
                              child: ItemCardNoMarginWidget(),
                            );
                          },
                        ),

                      ),
                      SizedBox(height: space_110,)
                    ],
                  ),
                ),
              ],
            )),
            CommonBottomNavBarWidget(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  child: BottomFloatingFilterBtnsWidget()),
            )
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}
}
