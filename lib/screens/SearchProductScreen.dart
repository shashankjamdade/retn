import 'package:flutter/material.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';

class SearchProductScreen extends StatefulWidget {
  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
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
                      padding: EdgeInsets.symmetric(horizontal: space_15, vertical: space_10),
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
                                child: InkWell(
                                  onTap: (){},
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
                              flex: 7,
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
                    Container(
                      color: CommonStyles.primaryColor,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: space_15, vertical: space_10),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(padding: EdgeInsets.symmetric(vertical: space_25, horizontal: space_15),
                      child: Text("Popular Categories", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w600, Colors.black),),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: ListView.builder(
                            itemCount: 15,
                            itemBuilder: (context, pos){
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: space_10, horizontal: space_15),
                              child: Text("Cars", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, Colors.black87),),
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
