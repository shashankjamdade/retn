import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/seller_info_res.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/EditProfileScreen.dart';
import 'package:flutter_rentry_new/screens/PackageScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart'; //for date format

class SellerInfoScreen extends StatefulWidget {
  String sellerId;

  SellerInfoScreen(this.sellerId);

  @override
  _SellerInfoScreenState createState() => _SellerInfoScreenState();
}

class _SellerInfoScreenState extends State<SellerInfoScreen> {
  HomeBloc homeBloc = new HomeBloc();
  SellerInfoRes mSellerInfoRes;
  var loginResponse;
  var token = "";
  var userid = "";
  var createdDate = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_PROFILE_SCREEN---------");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      userid = loginResponse.data.id;
      debugPrint("ACCESSING_INHERITED ${token}, ${userid}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc
        ..add(SellerInfoEvent(token: token, sellerId: widget.sellerId)),
      child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is SellerInfoResState) {
              mSellerInfoRes = state.res;
              var createdDateVar =
                  DateTime.parse("${mSellerInfoRes.data.seller_info.since}");
              createdDate = createdDateVar.toString().split(" ")[0];
              if (createdDate.isNotEmpty) {
                DateFormat dateFormatter = new DateFormat('dd MMM yyyy');
                createdDate = dateFormatter.format(DateTime.parse(createdDate));
              }
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return getProfileUI(state);
            },
          )),
    );
  }

  Widget getProfileUI(HomeState state) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                getContent(state)
              ],
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    );
  }

  Widget getContent(HomeState state) {
    int totalRating = 0;
    double avgRatings = 0.0;
    if (state is SellerInfoResState) {
      mSellerInfoRes = state.res;
      totalRating = mSellerInfoRes?.data?.seller_rating?.star_5 +
          mSellerInfoRes?.data?.seller_rating?.star_4 +
          mSellerInfoRes?.data?.seller_rating?.star_3 +
          mSellerInfoRes?.data?.seller_rating?.star_2 +
          mSellerInfoRes?.data?.seller_rating?.star_1;
      var allRatings = 0;
      allRatings = (mSellerInfoRes?.data?.seller_rating?.star_5 *5) +
           ( mSellerInfoRes?.data?.seller_rating?.star_4 * 4)+
            (mSellerInfoRes?.data?.seller_rating?.star_3 *3)+
            (mSellerInfoRes?.data?.seller_rating?.star_2 *2)+
            (mSellerInfoRes?.data?.seller_rating?.star_1*1);
      if(totalRating>0) {
        avgRatings = allRatings / totalRating.toDouble();
      }
      if (createdDate.isNotEmpty) {
        DateFormat dateFormatter = new DateFormat('dd MMM yyyy');
        createdDate = dateFormatter
            .format(DateTime.parse(mSellerInfoRes.data.seller_info.since));
      }
    }
    return (state is SellerInfoResState)
        ? Expanded(
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
                          image: mSellerInfoRes
                                      .data.seller_info.profile_picture !=
                                  null
                              ? mSellerInfoRes.data.seller_info.profile_picture
                              : "http://rentozo.com/assets/img/user.jpg",
                          fit: BoxFit.fill,
                          width: space_80,
                          height: space_60,
                        ),
                      ),
                    ),
                    title: Text(
                      "${mSellerInfoRes.data.seller_info.username}",
                      style: CommonStyles.getRalewayStyle(
                          space_14, FontWeight.w600, Colors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Member since ${createdDate}",
                          style: CommonStyles.getRalewayStyle(space_12,
                              FontWeight.w500, Colors.black.withOpacity(0.5)),
                        ),
                        RatingBarByRatingWidget(avgRatings),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: space_25,
                  ),
//            Container(
//              margin:
//              EdgeInsets.symmetric(horizontal: space_15),
//              child: Text(
//                "About",
//                style: CommonStyles.getRalewayStyle(
//                    space_16, FontWeight.w600, Colors.black),
//                maxLines: 1,
//                overflow: TextOverflow.ellipsis,
//              ),
//            ),
//            SizedBox(
//              height: space_8,
//            ),
//            Container(
//              margin:
//              EdgeInsets.symmetric(horizontal: space_15),
//              child: Text(
//                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliq it praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.",
//                style: CommonStyles.getRalewayStyle(
//                    space_14,
//                    FontWeight.w500,
//                    Colors.black.withOpacity(0.6)),
//              ),
//            ),
//            SizedBox(
//              height: space_25,
//            ),
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
                                    gradient: profileRatingBoxGradient()),
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
                                                      "${avgRatings}",
                                                      style: CommonStyles
                                                          .getMontserratStyle(
                                                              space_35,
                                                              FontWeight.w600,
                                                              CommonStyles
                                                                  .darkAmber),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    RatingBarByRatingWidget(avgRatings),
                                                    Text(
                                                      "By ${totalRating} Users",
                                                      style: CommonStyles
                                                          .getMontserratStyle(
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
                                                    RatingIndicatorWidget(
                                                      "5",
                                                      mSellerInfoRes
                                                          ?.data
                                                          ?.seller_rating
                                                          ?.star_5,
                                                        totalRating
                                                    ),
                                                    RatingIndicatorWidget(
                                                        "4",
                                                        mSellerInfoRes
                                                            ?.data
                                                            ?.seller_rating
                                                            ?.star_4,
                                                        totalRating
                                                    ),
                                                    RatingIndicatorWidget(
                                                        "3",
                                                        mSellerInfoRes
                                                            ?.data
                                                            ?.seller_rating
                                                            ?.star_3,
                                                        totalRating
                                                    ),
                                                    RatingIndicatorWidget(
                                                        "2",
                                                        mSellerInfoRes
                                                            ?.data
                                                            ?.seller_rating
                                                            ?.star_2,
                                                        totalRating
                                                    ),
                                                    RatingIndicatorWidget(
                                                        "1",
                                                        mSellerInfoRes
                                                            ?.data
                                                            ?.seller_rating
                                                            ?.star_1,
                                                        totalRating
                                                    ),
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
                          child: GestureDetector(
                            onTap: () {
                              showRatingDialog();
                            },
                            child: Container(
                              height: space_50,
                              width: space_150,
                              child: Card(
                                elevation: space_3,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(space_5)),
                                child: ClipRRect(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            CommonStyles.blue.withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(space_5)),
                                    child: Center(
                                      child: Text(
                                        "REVIEW NOW",
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: space_25,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: space_15),
                    child: Text(
                      "Provided Products",
                      style: CommonStyles.getRalewayStyle(
                          space_16, FontWeight.w600, Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                      itemCount: mSellerInfoRes.data.seller_product.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: space_280,
                          width: space_230,
                          child: ItemCardNoMarginWidget(
                              category_adslist:
                                  mSellerInfoRes.data.seller_product[index]),
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
          )
        : Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }

  void showRatingDialog() {
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            icon: const Icon(
              Icons.rate_review,
              size: 100,
              color: CommonStyles.primaryColor,
            ),
            // set your own image/icon widget
            title: "Rate us",
            description: "Tap a star to give your rating.",
            submitButton: "SUBMIT",
            alternativeButton: "",
            // optional
            positiveComment: "We are so happy to hear",
            // optional
            negativeComment: "We're sad to hear",
            // optional
            accentColor: CommonStyles.primaryColor,
            // optional
            onSubmitPressed: (int rating) {
              print("onSubmitPressed: rating = $rating");
              new HomeRepository().callRating(
                  token,
                  mSellerInfoRes?.data?.seller_info?.id,
                  userid,
                  rating.toString());
              Fluttertoast.showToast(
                  msg: "Thanks for rating!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: space_14);
            },
            onAlternativePressed: () {
              print("onAlternativePressed: do something");
              // TODO: maybe you want the user to contact you instead of rating a bad review
            },
          );
        });
  }
}
