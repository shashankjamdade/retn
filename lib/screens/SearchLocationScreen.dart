import 'package:flutter/material.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';

class SearchLocationScreen extends StatefulWidget {
  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: CommonStyles.primaryColor,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: space_15, vertical: space_10),
                    child: Container(
                      height: space_50,
                      width: getProportionateScreenWidth(context, space_220),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_15),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: space_5),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 9,
                            child: Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: space_5),
                                  child: Text(
                                    "Bhopal sdfs dsfsdf sd sdf sdf s",
                                    style: CommonStyles.getRalewayStyle(
                                        space_12, FontWeight.w500, Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: CommonStyles.primaryColor,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: space_15, vertical: space_10),
                    child: Container(
                      height: space_50,
                      width: getProportionateScreenWidth(context, space_220),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_15),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: space_5),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: space_5),
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: Colors.white),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
//                          contentPadding:
//                          EdgeInsets.only(left: space_15, bottom: space_15, top: space_15, right: space_15),
                                        hintText: "Search By Location..."),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(space_15),
                                      bottomRight: Radius.circular(space_15))),
                              child: Center(
                                  child: Icon(
                                Icons.search,
                                color: CommonStyles.primaryColor,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: space_25, horizontal: space_15),
                      child: FlatButton.icon(
                          onPressed: () {},
                          icon: ImageIcon(AssetImage("assets/images/bottom_nav_nearby.png"), color: CommonStyles.blue,),
                          label: Text(
                            "Use your current location",
                            style: CommonStyles.getRalewayStyle(
                                space_15, FontWeight.w600, Colors.black),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: space_35),
                      child:  Text(
                        "TOP CATEGORIES",
                        style: CommonStyles.getRalewayStyle(
                            space_14, FontWeight.w500, CommonStyles.blue),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: space_25),
                      child: ListView.builder(
                          itemCount: 15,
                          itemBuilder: (context, pos) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: space_10, horizontal: space_15),
                              child: Text(
                                "Cars",
                                style: CommonStyles.getRalewayStyle(
                                    space_14, FontWeight.w500, Colors.black87),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    );
  }
}
