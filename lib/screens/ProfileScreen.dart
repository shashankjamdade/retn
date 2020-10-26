import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: space_15,
                              right: space_15,
                              top: getProportionateScreenHeight(context, space_25)),
                          child: Text(
                            "Owner Info",
                            style: CommonStyles.getRalewayStyle(
                                space_16, FontWeight.w600, Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: space_15,
                        ),
                        ListTile(
                          leading: Container(
                            height: space_80,
                            width: space_60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(space_10),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/app_img.png",
                                image: 'https://picsum.photos/250?image=9',
                                fit: BoxFit.cover,
                                width: space_80,
                                height: space_60,
                              ),
                            ),
                          ),
                          title: Text(
                            "LOREM BED USERNAME",
                            style: CommonStyles.getRalewayStyle(
                                space_14, FontWeight.w600, Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Member since 24 Aug 2020",
                                style: CommonStyles.getRalewayStyle(space_12,
                                    FontWeight.w500, Colors.black.withOpacity(0.5)),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: space_3),
                                      child: Icon(
                                        Icons.star,
                                        color: CommonStyles.darkAmber,
                                        size: space_12,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: space_3),
                                      child: Icon(
                                        Icons.star,
                                        color: CommonStyles.darkAmber,
                                        size: space_12,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: space_3),
                                      child: Icon(
                                        Icons.star,
                                        color: CommonStyles.darkAmber,
                                        size: space_12,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: space_3),
                                      child: Icon(
                                        Icons.star,
                                        color: CommonStyles.darkAmber,
                                        size: space_12,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: space_3),
                                      child: Icon(
                                        Icons.star_half,
                                        color: CommonStyles.darkAmber,
                                        size: space_12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: space_25,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: space_15),
                          child: Text(
                            "About",
                            style: CommonStyles.getRalewayStyle(
                                space_16, FontWeight.w600, Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: space_8,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: space_15),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliq it praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.",
                            style: CommonStyles.getRalewayStyle(space_14,
                                FontWeight.w500, Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        SizedBox(
                          height: space_25,
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: space_15),
                              height:
                                  getProportionateScreenHeight(context, space_230),
                              child: Card(
                                elevation: space_3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(space_15)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(space_10),
                                    child: Container(
                                      padding: EdgeInsets.all(space_15),
                                      decoration: BoxDecoration(
                                          gradient: profileRatingBoxGradient()
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Reviews and Ratings",
                                            style: CommonStyles.getRalewayStyle(
                                                space_16,
                                                FontWeight.w600,
                                                CommonStyles.blue),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "4.5",
                                                            style: CommonStyles
                                                                .getRalewayStyle(
                                                                    space_35,
                                                                    FontWeight.w600,
                                                                CommonStyles.darkAmber),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          SizedBox(
                                                            height: space_8,
                                                          ),
                                                          Container(
                                                            child: Wrap(
                                                              direction:
                                                                  Axis.horizontal,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              space_3),
                                                                  child: Icon(
                                                                    Icons.star,
                                                                    color:CommonStyles.darkAmber,
                                                                    size: space_12,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              space_3),
                                                                  child: Icon(
                                                                    Icons.star,
                                                                    color:CommonStyles.darkAmber,
                                                                    size: space_12,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              space_3),
                                                                  child: Icon(
                                                                    Icons.star,
                                                                    color:CommonStyles.darkAmber,
                                                                    size: space_12,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              space_3),
                                                                  child: Icon(
                                                                    Icons.star,
                                                                    color:CommonStyles.darkAmber,
                                                                    size: space_12,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              space_3),
                                                                  child: Icon(
                                                                    Icons.star_half,
                                                                    color:CommonStyles.darkAmber,
                                                                    size: space_12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            "By 450 Users",
                                                            style: CommonStyles
                                                                .getRalewayStyle(
                                                                    space_10,
                                                                    FontWeight.w600,
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.6)),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 7,
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          RatingIndicatorWidget(),
                                                          RatingIndicatorWidget(),
                                                          RatingIndicatorWidget(),
                                                          RatingIndicatorWidget(),
                                                          RatingIndicatorWidget(),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                              height:
                                  getProportionateScreenHeight(context, space_250),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: space_50,
                                  width: space_150,
                                  child: Card(
                                    elevation: space_3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(space_5)),
                                    child: ClipRRect(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: CommonStyles.blue.withOpacity(0.6),
                                            borderRadius:
                                                BorderRadius.circular(space_5)),
                                        child: Center(
                                          child: Text(
                                            "READ REVIEWS",
                                            style: CommonStyles.getRalewayStyle(
                                                space_14,
                                                FontWeight.w400,
                                                Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: space_25,
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: space_15),
                            child:Text(
                              "Provided Products",
                              style: CommonStyles.getRalewayStyle(
                                  space_16, FontWeight.w600, Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),),
                        SizedBox(
                          height: space_25,
                        ),
                        Container(
                          child: GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio:
                                  (getProportionateScreenWidth(context, space_230) /
                                      (Platform.isIOS
                                          ? getProportionateScreenHeight(
                                              context, space_300)
                                          : getProportionateScreenHeight(
                                              context, space_370))),
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
                        SizedBox(
                          height: space_110,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    );
  }
}
