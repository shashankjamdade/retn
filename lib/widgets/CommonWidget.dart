import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/UserLocNameSelected.dart';
import 'package:flutter_rentry_new/model/filter_res.dart';
import 'package:flutter_rentry_new/model/get_all_package_list_response.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/location_search_response.dart';
import 'package:flutter_rentry_new/model/save_favourite_res.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/model/seller_info_res.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/ChatDetailScreen.dart';
import 'package:flutter_rentry_new/screens/ChatHomeScreen.dart';
import 'package:flutter_rentry_new/screens/FilterScreen.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/ItemDetailScreen.dart';
import 'package:flutter_rentry_new/screens/LoginScreen.dart';
import 'package:flutter_rentry_new/screens/NearByChildSubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/ProfileScreen.dart';
import 'package:flutter_rentry_new/screens/SearchLocationScreen.dart';
import 'package:flutter_rentry_new/screens/SellerInfoScreen.dart';
import 'package:flutter_rentry_new/screens/SubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/UserProfile.dart';
import 'package:flutter_rentry_new/screens/editAds/ChooseCategoryEditAdScreen.dart';
import 'package:flutter_rentry_new/screens/postad/ChooseCategoryScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart'; //for date format

class AuthPageHeaderWidget extends StatelessWidget {
  String text1;
  String text2;
  Function skipFun;

  AuthPageHeaderWidget(this.text1, this.text2, this.skipFun);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(context, space_20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Image.asset(
              "assets/images/app_img.png",
              width: getProportionateScreenWidth(context, space_100),
              height: getProportionateScreenHeight(context, space_100),
            ),
          ),
          // GestureDetector(
          //   onTap: skipFun,
          //   child: Text(
          //     text2,
          //     style: CommonStyles.getRalewayStyle(
          //         space_15, FontWeight.w500, CommonStyles.primaryColor),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CommonAppbarWidget extends StatelessWidget {
  String text1;
  String text2;
  Function onClickSearch;

  CommonAppbarWidget(this.text1, this.text2, this.onClickSearch);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(context, space_90),
      color: CommonStyles.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: space_5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Container(
                width: getProportionateScreenWidth(context, space_80),
                height: getProportionateScreenHeight(context, space_50),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(
                    "assets/images/app_img_white.png",
                    width: getProportionateScreenWidth(context, space_40),
                    height: getProportionateScreenHeight(context, space_20),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchLocationScreen()),
                );
              },
              child: Container(
                height: space_50,
                width: getProportionateScreenWidth(context, space_220),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(space_15),
                  color: Colors.white.withOpacity(0.2),
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
                            child: Text(
                              StateContainer.of(context).mUserLocNameSelected !=
                                      null
                                  ? "${StateContainer.of(context).mUserLocNameSelected.address}"
                                  : StateContainer.of(context)
                                              .mUserLocationSelected !=
                                          null
                                      ? "${StateContainer.of(context).mUserLocationSelected.city}, ${StateContainer.of(context).mUserLocationSelected.state}"
                                      : "Fetching location...",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w500, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchLocationScreen()),
                          );
                        },
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
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//TextField
class NormalTextInputWidget extends StatelessWidget {
  TextEditingController textEditingController;
  String hintText;
  bool isPassword;
  Function validatorFun;
  TextInputType textInputType;

  NormalTextInputWidget(this.textEditingController, this.hintText,
      this.isPassword, this.validatorFun, this.textInputType);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(context, space_40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: TextFormField(
              validator: validatorFun,
              obscureText: isPassword,
              controller: textEditingController,
              keyboardType: textInputType,
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextInputWidget extends StatelessWidget {
  TextEditingController textEditingController;
  String labelText;
  bool isPassword;
  Function validatorFun;
  TextInputType textInputType;

  TextInputWidget(this.textEditingController, this.labelText, this.isPassword,
      this.validatorFun, this.textInputType);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(context, space_40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: TextFormField(
              validator: validatorFun,
              obscureText: isPassword,
              controller: textEditingController,
              keyboardType: textInputType,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: labelText,
                contentPadding: EdgeInsets.all(space_8),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(0.0)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BtnTextInputWidget extends StatefulWidget {
  TextEditingController textEditingController;
  String labelText;
  String btnText;
  bool isPassword;
  Function onSubmit;
  Function validatorFun;
  TextInputType textInputType;
  bool isVerified = false;

  BtnTextInputWidget(this.textEditingController, this.labelText, this.btnText,
      this.isPassword, this.onSubmit, this.validatorFun, this.textInputType,
      {this.isVerified = false});

  @override
  _BtnTextInputWidgetState createState() => _BtnTextInputWidgetState();
}

class _BtnTextInputWidgetState extends State<BtnTextInputWidget>
    with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.1).animate(animation);
    animation.addListener(() {
      debugPrint("ANIM - O");
      if (animation.isCompleted) {
        debugPrint("ANIM -R");
        animation.reverse();
      } else {
        debugPrint("ANIM -F");
        animation.forward();
      }
    });
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(context, space_40),
      color: CommonStyles.green,
      child: Container(
          height: getProportionateScreenHeight(context, space_40),
          color: widget.isVerified ? Colors.white : CommonStyles.primaryColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  validator: widget.validatorFun,
                  obscureText: widget.isPassword,
                  controller: widget.textEditingController,
                  keyboardType: widget.textInputType,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: widget.labelText,
                    contentPadding: EdgeInsets.all(space_8),
//                                  enabledBorder: inputBorderDecoration,
//                                  focusedBorder: inputBorderDecoration,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(0.0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              FittedBox(
                child: InkWell(
                  splashColor: CommonStyles.green,
                  hoverColor: CommonStyles.green,
                  highlightColor: CommonStyles.green,
                  onTap: () {
                    animation.repeat(min: 0, max: 1);
                    widget.onSubmit();
                  },
                  child: FadeTransition(
                    opacity: animation,
                    child: Container(
                      padding: EdgeInsets.all(space_8),
                      width: 90.0,
                      child: Center(
                          child: Text(
                        widget.btnText,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: widget.isVerified
                                ? Colors.green
                                : Colors.white),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

//Btns
class IconButtonWidget extends StatelessWidget {
  String btnText;
  String icon;
  Color textColor;
  Function onSubmit;

  IconButtonWidget(this.btnText, this.icon, this.textColor, this.onSubmit);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSubmit,
      child: Card(
        color: Colors.white,
        elevation: space_3,
        child: Container(
          height: getProportionateScreenHeight(context, space_60),
          padding: EdgeInsets.symmetric(vertical: space_8),
          child:
          /*FlatButton.icon(
            color: Colors.transparent,
            icon: ImageIcon(AssetImage(icon,),),
            label: Text(
            btnText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CommonStyles.getRalewayStyle(
                space_12, FontWeight.w500, textColor),
          ),
          )*/

          Container(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    icon,
                    height: getProportionateScreenHeight(context, space_25),
                  ),
                  SizedBox(width: space_10,),
                  Text(
                    btnText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CommonStyles.getRalewayStyle(
                        space_12, FontWeight.w500, textColor),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//RichText
class RichTextTitleWidget extends StatelessWidget {
  String text1;
  String text2;

  RichTextTitleWidget(this.text1, this.text2);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: new TextSpan(
              text: text1,
              style: CommonStyles.getRalewayStyle(
                  space_15, FontWeight.w800, Colors.black),
              children: <TextSpan>[
                new TextSpan(
                    text: ' ${text2}',
                    style: CommonStyles.getRalewayStyle(space_15,
                        FontWeight.w400, Colors.black.withOpacity(0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//2
class RichTextTitleBtnWidget extends StatelessWidget {
  String text1;
  String text2;
  Function onViewAll;

  RichTextTitleBtnWidget(this.text1, this.text2, this.onViewAll);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: space_15),
      margin: EdgeInsets.symmetric(horizontal: space_15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: new TextSpan(
              text: text1,
              style: CommonStyles.getRalewayStyle(
                  space_15, FontWeight.w800, Colors.black),
              children: <TextSpan>[
                new TextSpan(
                    text: ' ${text2}',
                    style: CommonStyles.getRalewayStyle(space_15,
                        FontWeight.w400, Colors.black.withOpacity(0.8))),
              ],
            ),
          ),
          InkWell(
            onTap: onViewAll,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: space_15, vertical: space_10),
              decoration: BoxDecoration(
                  color: CommonStyles.blue,
                  borderRadius: BorderRadius.circular(space_10)),
              child: Center(
                child: Text(
                  "VIEW ALL",
                  style: CommonStyles.getRalewayStyle(
                      space_12, FontWeight.w500, Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//Category grid
class CategoryGridWidget extends StatelessWidget {
  HomeResponse homeResponse;

  CategoryGridWidget(this.homeResponse);

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: space_15),
      elevation: space_3,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(space_15)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: space_15, horizontal: space_15),
        decoration: BoxDecoration(
            gradient: cardGradient(),
            borderRadius: BorderRadius.circular(space_15)),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          primary: false,
          children:
              List.generate(homeResponse?.data?.category?.length, (index) {
            return Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubCategoryScreen(
                            categoryId: homeResponse.data.category[index].id,
                            categoryName:
                                homeResponse.data.category[index].name)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border(
                        top: BorderSide(
                            width: index >= 3 && index < 6 ? space_1 : space_0,
                            color: index >= 3 && index < 6
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        bottom: BorderSide(
                            width: index >= 3 && index < 6 ? space_1 : space_0,
                            color: index >= 3 && index < 6
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        right: BorderSide(
                            width: (index + 1) % 3 == 0 ? space_0 : space_1,
                            color: (index + 1) % 3 == 0
                                ? Colors.transparent
                                : CommonStyles.grey.withOpacity(0.5)),
                      )),
                  child: Container(
                    padding: EdgeInsets.all(space_5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: "assets/images/loader.jpg",
                          image: homeResponse.data.category[index].picture,
                          fit: BoxFit.fill,
                          height: iconSize,
                          width: iconSize,
                        ),
//                        Image.asset("assets/images/ic_category_vehicle.png", height: iconSize, width: iconSize,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: space_5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                              (MediaQuery.of(context).size.width <380.0)?
                                (homeResponse.data.category[index].name.trim().length > 8 ? homeResponse.data.category[index].name.trim().substring(0, 8)+'...' : homeResponse.data.category[index].name.trim()):
                              homeResponse.data.category[index].name.trim(),
                                maxLines: 1,
                                style: CommonStyles.getRalewayStyle(space_12,
                                    FontWeight.w500, CommonStyles.primaryColor),
                              ),
                              Container(
                                  height: space_15,
                                  width: space_15,
                                  margin: EdgeInsets.only(left: space_3),
                                  decoration: BoxDecoration(
                                      color: CommonStyles.primaryColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_right,
                                      color: Colors.white,
                                      size: space_12,
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ItemCardWidget extends StatefulWidget {
  Category_adslist category_adslist;

  ItemCardWidget({this.category_adslist});

  @override
  _ItemCardWidgetState createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
//    isLiked = widget.
    if (widget.category_adslist != null &&
        widget.category_adslist.is_wishlist != null) {
      isLiked = widget.category_adslist.is_wishlist;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                    categoryName: widget.category_adslist.slug,
                  )),
        );
      },
      child: Container(
        height: space_250,
        width: space_180,
        margin: EdgeInsets.only(left: space_10, right: space_0),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: space_5, top: space_8),
              child: Card(
                elevation: space_3,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(space_10)),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(space_10),
                                topLeft: Radius.circular(space_10)),
                            child: Container(
                              width: space_180,
                              height: space_110,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(space_10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/loader.jpg",
                                image: widget.category_adslist.img_1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                new HomeRepository().callSavefavouriteApi(
                                    StateContainer.of(context)
                                        .mLoginResponse
                                        .data
                                        .token,
                                    widget.category_adslist.id);
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: Container(
                                height: space_50,
                                width: space_50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    isLiked
                                        ? "assets/images/heart.png"
                                        : "assets/images/heart_grey.png",
                                    width: space_22,
                                    height: space_22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widget.category_adslist.distance != null
                              ? Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    height: space_30,
                                    padding: EdgeInsets.all(space_5),
                                    decoration: BoxDecoration(
                                      color: CommonStyles.primaryColor
                                          .withOpacity(0.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: space_12,
                                        ),
                                        SizedBox(
                                          width: space_3,
                                        ),
                                        Text(
                                          "${widget.category_adslist.distance} Kms",
                                          style:
                                              CommonStyles.getMontserratStyle(
                                                  space_10,
                                                  FontWeight.w800,
                                                  Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: space_5),
                        child: Text(
                          widget.category_adslist.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CommonStyles.getRalewayStyle(
                              space_14, FontWeight.w800, Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: space_30,
                            child: Text(
                              widget.category_adslist.description,
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w500, Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_5),
                        decoration: BoxDecoration(
                            color: CommonStyles.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.location_on,
                                color: CommonStyles.primaryColor,
                                size: space_15,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.only(right: space_10),
                                child: Text(
                                  widget.category_adslist.location,
                                  style: CommonStyles.getRalewayStyle(
                                      space_12,
                                      FontWeight.w500,
                                      CommonStyles.primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: space_5, right: space_5, bottom: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_8),
                        decoration: BoxDecoration(
                            color: CommonStyles.blue,
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.category_adslist.price}/",
                              style: CommonStyles.getMontserratStyle(
                                  space_15, FontWeight.w800, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.category_adslist.rent_type != null &&
                                      widget
                                          .category_adslist.rent_type.isNotEmpty
                                  ? "${widget.category_adslist.rent_type}"
                                  : "",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w400, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//          Positioned(
//            top: 0.0,
//            left: 0.0,
//            child: Container(
//              height: space_50,
//              width: space_50,
//              decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: Colors.white,
//                  boxShadow: [BoxShadow(color: CommonStyles.grey)]),
//              child: Center(
//                child: Image.asset(
//                  "assets/images/heart.png",
//                  width: space_30,
//                  height: space_30,
//                ),
//              ),
//            ),
//          )
          ],
        ),
      ),
    );
  }
}

class ItemCardNoMarginWidget extends StatefulWidget {
  Category_adslist category_adslist;

  ItemCardNoMarginWidget({this.category_adslist});

  @override
  _ItemCardNoMarginWidgetState createState() => _ItemCardNoMarginWidgetState();
}

class _ItemCardNoMarginWidgetState extends State<ItemCardNoMarginWidget> {
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.category_adslist != null &&
        widget.category_adslist.is_wishlist != null) {
      isLiked = widget.category_adslist.is_wishlist;
    }
  }

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
//    isLiked = widget.
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemDetailScreen(categoryName: widget.category_adslist.slug)),
        );
      },
      child: Container(
        height: space_250,
        width: space_180,
        child: Stack(
          children: [
            Container(
              child: Card(
                elevation: space_3,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(space_10)),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(space_10),
                                topLeft: Radius.circular(space_10)),
                            child: Container(
                              width: space_200,
                              height: space_110,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(space_10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/loader.jpg",
                                image: widget.category_adslist.img_1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                new HomeRepository().callSavefavouriteApi(
                                    StateContainer.of(context)
                                        .mLoginResponse
                                        .data
                                        .token,
                                    widget.category_adslist.id);
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: Container(
                                height: space_50,
                                width: space_50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    isLiked
                                        ? "assets/images/heart.png"
                                        : "assets/images/heart_grey.png",
                                    width: space_22,
                                    height: space_22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widget.category_adslist.distance != null
                              ? Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    height: space_30,
                                    padding: EdgeInsets.all(space_5),
                                    decoration: BoxDecoration(
                                      color: CommonStyles.primaryColor
                                          .withOpacity(0.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: space_12,
                                        ),
                                        SizedBox(
                                          width: space_3,
                                        ),
                                        Text(
                                          "${widget.category_adslist.distance} Kms",
                                          style:
                                              CommonStyles.getMontserratStyle(
                                                  space_10,
                                                  FontWeight.w800,
                                                  Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: space_5),
                        child: Text(
                          widget.category_adslist.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CommonStyles.getRalewayStyle(
                              space_14, FontWeight.w800, Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: space_30,
                            child: Text(
                              widget.category_adslist.description != null
                                  ? widget.category_adslist.description
                                  : "",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w500, Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: space_3,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_3),
                        decoration: BoxDecoration(
                            color: CommonStyles.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.location_on,
                                color: CommonStyles.primaryColor,
                                size: space_15,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.only(right: space_10),
                                child: Text(
                                  widget.category_adslist.location != null
                                      ? widget.category_adslist.location
                                      : "",
                                  style: CommonStyles.getRalewayStyle(
                                      space_12,
                                      FontWeight.w500,
                                      CommonStyles.primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: space_5, right: space_5, bottom: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_8),
                        decoration: BoxDecoration(
                            color: CommonStyles.blue,
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.category_adslist.price}/",
                              style: CommonStyles.getMontserratStyle(
                                  space_15, FontWeight.w800, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.category_adslist.rent_type != null &&
                                      widget
                                          .category_adslist.rent_type.isNotEmpty
                                  ? "${widget.category_adslist.rent_type}"
                                  : "",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w400, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCardNoMargin2Widget extends StatefulWidget {
  Category_adslist category_adslist;

  ItemCardNoMargin2Widget({this.category_adslist});

  @override
  _ItemCardNoMargin2WidgetState createState() =>
      _ItemCardNoMargin2WidgetState();
}

class _ItemCardNoMargin2WidgetState extends State<ItemCardNoMargin2Widget> {
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.category_adslist != null &&
        widget.category_adslist.is_wishlist != null) {
      isLiked = widget.category_adslist.is_wishlist;
    }
  }

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
//    isLiked = widget.
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemDetailScreen(categoryName: widget.category_adslist.slug)),
        );
      },
      child: Container(
        height: space_250,
        width: space_180,
        child: Stack(
          children: [
            Container(
              child: Card(
                elevation: space_3,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(space_10)),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(space_10),
                                topLeft: Radius.circular(space_10)),
                            child: Container(
                              width: space_200,
                              height: space_110,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(space_10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/loader.jpg",
                                image: widget.category_adslist.img_1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                new HomeRepository().callSavefavouriteApi(
                                    StateContainer.of(context)
                                        .mLoginResponse
                                        .data
                                        .token,
                                    widget.category_adslist.ad_id);
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: Container(
                                height: space_50,
                                width: space_50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    isLiked
                                        ? "assets/images/heart.png"
                                        : "assets/images/heart_grey.png",
                                    width: space_22,
                                    height: space_22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widget.category_adslist.distance != null
                              ? Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    height: space_30,
                                    padding: EdgeInsets.all(space_5),
                                    decoration: BoxDecoration(
                                      color: CommonStyles.primaryColor
                                          .withOpacity(0.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: space_12,
                                        ),
                                        SizedBox(
                                          width: space_3,
                                        ),
                                        Text(
                                          "${widget.category_adslist.distance} Kms",
                                          style:
                                              CommonStyles.getMontserratStyle(
                                                  space_10,
                                                  FontWeight.w800,
                                                  Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: space_5),
                        child: Text(
                          widget.category_adslist.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CommonStyles.getRalewayStyle(
                              space_14, FontWeight.w800, Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: space_30,
                            child: Text(
                              widget.category_adslist.description != null
                                  ? widget.category_adslist.description
                                  : "",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w500, Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: space_3,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_3),
                        decoration: BoxDecoration(
                            color: CommonStyles.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.location_on,
                                color: CommonStyles.primaryColor,
                                size: space_15,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.only(right: space_10),
                                child: Text(
                                  widget.category_adslist.location != null
                                      ? widget.category_adslist.location
                                      : "",
                                  style: CommonStyles.getRalewayStyle(
                                      space_12,
                                      FontWeight.w500,
                                      CommonStyles.primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: space_5, right: space_5, bottom: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_8),
                        decoration: BoxDecoration(
                            color: CommonStyles.blue,
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.category_adslist.price}/",
                              style: CommonStyles.getMontserratStyle(
                                  space_15, FontWeight.w800, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.category_adslist.rent_type != null &&
                                      widget
                                          .category_adslist.rent_type.isNotEmpty
                                  ? "${widget.category_adslist.rent_type}"
                                  : "",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w400, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyItemCardNoMarginWidget extends StatefulWidget {
  Category_adslist category_adslist;

  MyItemCardNoMarginWidget({this.category_adslist});

  @override
  _MyItemCardNoMarginWidgetState createState() =>
      _MyItemCardNoMarginWidgetState();
}

class _MyItemCardNoMarginWidgetState extends State<MyItemCardNoMarginWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
//    isLiked = widget.
      if (widget.category_adslist != null &&
          widget.category_adslist.is_wishlist != null) {
        isLiked = widget.category_adslist.is_wishlist;
      }
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChooseCategoryEditAdScreen(widget.category_adslist.id)),
        );
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//                  ItemDetailScreen(categoryName: widget.category_adslist.slug)),
//        );
      },
      child: Container(
        height: space_250,
        width: space_180,
        child: Stack(
          children: [
            Container(
              child: Card(
                elevation: space_3,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(space_10)),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(space_10),
                                topLeft: Radius.circular(space_10)),
                            child: Container(
                              width: space_200,
                              height: space_110,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(space_10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/loader.jpg",
                                image: widget.category_adslist.img_1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                new HomeRepository().callSavefavouriteApi(
                                    StateContainer.of(context)
                                        .mLoginResponse
                                        .data
                                        .token,
                                    widget.category_adslist.id);
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: space_30,
                                        width: space_30,
                                        padding: EdgeInsets.all(space_5),
                                        margin:
                                            EdgeInsets.only(right: space_15),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.redAccent,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseCategoryEditAdScreen(
                                                      widget.category_adslist
                                                          .id)),
                                        );
                                      },
                                      child: Container(
                                        height: space_30,
                                        width: space_30,
                                        padding: EdgeInsets.all(space_5),
                                        margin:
                                            EdgeInsets.only(right: space_15),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: CommonStyles.green,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: Container(
                              height: space_30,
                              width: space_30,
                              padding: EdgeInsets.all(space_5),
                              margin: EdgeInsets.only(right: space_15),
                              decoration: BoxDecoration(
                                color:
                                    CommonStyles.primaryColor.withOpacity(0.5),
                              ),
                              child: FlatButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "2 Kms",
                                    style: CommonStyles.getMontserratStyle(
                                        space_12,
                                        FontWeight.w800,
                                        Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: space_5),
                        child: Text(
                          widget.category_adslist.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CommonStyles.getRalewayStyle(
                              space_14, FontWeight.w800, Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: space_30,
                            child: Text(
                              widget.category_adslist.description != null
                                  ? widget.category_adslist.description
                                  : "",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w500, Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_1),
                        decoration: BoxDecoration(
                            color: CommonStyles.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.location_on,
                                color: CommonStyles.primaryColor,
                                size: space_15,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.only(right: space_10),
                                child: Text(
                                  widget.category_adslist.location != null
                                      ? widget.category_adslist.location
                                      : "",
                                  style: CommonStyles.getRalewayStyle(
                                      space_12,
                                      FontWeight.w500,
                                      CommonStyles.primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: space_5, right: space_5, bottom: space_5),
                        padding: EdgeInsets.symmetric(vertical: space_8),
                        decoration: BoxDecoration(
                            color: CommonStyles.blue,
                            borderRadius: BorderRadius.circular(space_5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.category_adslist.price}/",
                              style: CommonStyles.getMontserratStyle(
                                  space_15, FontWeight.w800, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.category_adslist.rent_type != null &&
                                      widget
                                          .category_adslist.rent_type.isNotEmpty
                                  ? "${widget.category_adslist.rent_type}"
                                  : "",
                              style: CommonStyles.getRalewayStyle(
                                  space_12, FontWeight.w400, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubCategoryItemWidget extends StatelessWidget {
  SubCategoryData subCategoryData;
  String selectedId = "";

  SubCategoryItemWidget({this.subCategoryData, this.selectedId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: space_10, left: space_5, right: space_5),
      child: Card(
        elevation: space_3,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(space_10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(space_10),
          child: Container(
            color: selectedId != null &&
                    selectedId?.isNotEmpty &&
                    subCategoryData?.id == selectedId
                ? CommonStyles.grey.withOpacity(0.5)
                : Colors.white,
            padding: EdgeInsets.all(space_10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: space_50,
                    width: space_50,
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/app_img.png",
                      image: subCategoryData.picture,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: space_10),
                    child: Text(
                      subCategoryData.name,
                      textAlign: TextAlign.center,
                      style: CommonStyles.getRalewayStyle(
                          space_15, FontWeight.w500, Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OwnerInfo extends StatelessWidget {
  String sellerId;
  String profilePath;
  String username;
  String createdDate;
  double rating;
  String sinceDate;

  OwnerInfo({
    this.sellerId,
    this.profilePath = "",
    this.username = "",
    this.createdDate = "",
    this.rating = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (createdDate != null && createdDate.isNotEmpty) {
      DateFormat dateFormatter = new DateFormat('dd MMM yyyy');
      sinceDate = dateFormatter.format(DateTime.parse(createdDate));
    }
    return Container(
      child: ListTile(
        leading: Container(
          height: space_70,
          width: space_70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(space_10),
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/loader.jpg",
              image: profilePath != null
                  ? profilePath
                  : 'https://picsum.photos/250?image=9',
              fit: BoxFit.cover,
              width: space_70,
              height: space_70,
            ),
          ),
        ),
        title: Text(
          username != null ? username : "LOREM BED USERNAME",
          style: CommonStyles.getRalewayStyle(
              space_14, FontWeight.w600, Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Member since ${sinceDate != null ? sinceDate : "24 Aug 2020"}",
              style: CommonStyles.getRalewayStyle(
                  space_12, FontWeight.w500, Colors.black.withOpacity(0.5)),
            ),
            Container(
              child:  RatingBarByRatingWidget(rating),
            )
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SellerInfoScreen(sellerId)),
                );
              },
              child: Container(
                width: space_90,
                padding: EdgeInsets.symmetric(vertical: space_10),
                decoration: BoxDecoration(
                    color: CommonStyles.blue,
                    borderRadius: BorderRadius.circular(space_10)),
                child: Center(
                  child: Text(
                    "View Profile",
                    style: CommonStyles.getRalewayStyle(
                        space_12, FontWeight.w500, Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RatingIndicatorWidget extends StatelessWidget {
  String ratingLable;
  int total;
  int rating;

  RatingIndicatorWidget(this.ratingLable, this.rating, this.total);

  @override
  Widget build(BuildContext context) {
    debugPrint("SELLER_RATING ${ratingLable}, ${total}, ${rating}");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: space_8, vertical: space_5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "${ratingLable}",
              style: CommonStyles.getRalewayStyle(
                  space_10, FontWeight.w500, Colors.black),
            ),
          ),
          Expanded(
              flex: 6,
              child: Container(
                  padding: EdgeInsets.only(right: space_3),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: total > 0 ? total : 1,
                            child: Container(
                              height: space_5,
                              color: CommonStyles.grey.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: rating,
                            child: Container(
                              height: space_5,
                              color: CommonStyles.darkAmber,
                            ),
                          ),
                          Expanded(
                            flex: total - rating,
                            child: Container(
                              height: space_5,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      )
                    ],
                  ))),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${rating} Ratings",
                style: CommonStyles.getMontserratStyle(
                    space_10, FontWeight.w500, Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RatingBarByRatingWidget extends StatelessWidget {
  double rating;

  RatingBarByRatingWidget(this.rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: space_3),
            child: Icon(
              rating == 0.5 ? Icons.star_half : Icons.star,
              color: rating >= 0.5 ? CommonStyles.darkAmber : CommonStyles.grey,
              size: space_12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: space_3),
            child: Icon(
              rating == 1.5 ? Icons.star_half : Icons.star,
              color: rating >= 1.5 ? CommonStyles.darkAmber : CommonStyles.grey,
              size: space_12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: space_3),
            child: Icon(
              rating == 2.5 ? Icons.star_half : Icons.star,
              color: rating >= 2.5 ? CommonStyles.darkAmber : CommonStyles.grey,
              size: space_12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: space_3),
            child: Icon(
              rating == 3.5 ? Icons.star_half : Icons.star,
              color: rating >= 3.5 ? CommonStyles.darkAmber : CommonStyles.grey,
              size: space_12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: space_3),
            child: Icon(
              rating == 4.5 ? Icons.star_half : Icons.star,
              color: rating >= 4.5 ? CommonStyles.darkAmber : CommonStyles.grey,
              size: space_12,
            ),
          ),
        ],
      ),
    );
  }
}

//Filter
class FilterSortByWidget extends StatelessWidget {
  String title;
  String type;
  String selectedValue = "Low to High";
  List<String> sortingList = List();
  Function(String, String) onDropDownValueChanged;

  FilterSortByWidget(this.title, this.type, this.selectedValue,
      this.sortingList, this.onDropDownValueChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              child: Text(
                "By Price",
                style: CommonStyles.getRalewayStyle(
                    space_14, FontWeight.w800, Colors.black),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(right: space_15),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                value: selectedValue,
//                            hint: Text(
//                              "Select Highest Education",
//                              style: TextStyle(color: Colors.black),
//                            ),
                iconSize: 20.0,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
//                  decoration: InputDecoration.collapsed(hintText: ''),
                items: (sortingList != null && sortingList.length > 0)
                    ? sortingList.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Container(
                                padding: EdgeInsets.only(left: space_10),
                                child: Text(
                                  val,
                                  style: CommonStyles.getRalewayStyle(
                                      space_12, FontWeight.w600, Colors.black),
                                )),
                          );
                        },
                      ).toList()
                    : ['No List'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                onChanged: (value) {
                  onDropDownValueChanged(type, value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBarItemWidget extends StatelessWidget {
  String title, assetImg;
  bool isVisible = true;

  BottomBarItemWidget(this.title, this.assetImg, {this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(
                assetImg,
              ),
              color: isVisible ? Colors.white : CommonStyles.primaryColor,
            ),
            Padding(
              padding: EdgeInsets.only(top: space_3),
              child: Text(
                title,
                style: CommonStyles.getRalewayStyle(space_8, FontWeight.w400,
                    isVisible ? Colors.white : CommonStyles.primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommonBottomNavBarHomeWidget extends StatelessWidget {
  GlobalKey postKey;
  bool shouldShowShowcase;
  Function onHomeClick;

  CommonBottomNavBarHomeWidget({this.postKey, this.shouldShowShowcase, this.onHomeClick});

  @override
  Widget build(BuildContext context) {
    debugPrint("COMMONBOTTOMCHECK--> NOOOO");
    return Container(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  height: space_150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: space_80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/bottom_back.png"),
                                fit: BoxFit.fitWidth)),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                       /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()),
                                        );*/
                                        onHomeClick();
                                      },
                                      child: BottomBarItemWidget(
                                        "HOME",
                                        "assets/images/nav_home_icon.png",
                                        isVisible: true,
                                      ))),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StateContainer
                                                                  .of(context)
                                                              .mLoginResponse !=
                                                          null &&
                                                      StateContainer.of(context)
                                                              .mLoginResponse
                                                              .data
                                                              .token !=
                                                          null
                                                  ? ChatHomeScreen()
                                                  : LoginScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget("CHAT",
                                          "assets/images/bottom_nav_chat.png",
                                          isVisible: true))),
                              Expanded(
                                  child: BottomBarItemWidget(
                                "",
                                "assets/images/bottom_nav_nearby.png",
                                isVisible: false,
                              )),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        var currentLoc = StateContainer.of(
                                                        context)
                                                    .mUserLocationSelected !=
                                                null
                                            ? StateContainer.of(context)
                                                .mUserLocationSelected
                                            : null;
                                        if (currentLoc != null) {
                                          StateContainer.of(context)
                                                  .mUserLocNameSelected =
                                              UserLocNameSelected(
                                                  address: currentLoc.city,
                                                  mlat: currentLoc.mlat,
                                                  mlng: currentLoc.mlng);
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NearByChildSubCategoryScreen(
                                                    isFromNearBy: true,
                                                    lat: StateContainer.of(
                                                                    context)
                                                                .mUserLocationSelected !=
                                                            null
                                                        ? StateContainer.of(
                                                                context)
                                                            .mUserLocationSelected
                                                            .mlat
                                                        : "",
                                                    lng: StateContainer.of(
                                                                    context)
                                                                .mUserLocationSelected !=
                                                            null
                                                        ? StateContainer.of(
                                                                context)
                                                            .mUserLocationSelected
                                                            .mlng
                                                        : "",
                                                    radius: LOCATION_RADIUS,
                                                  )),
                                        );
                                      },
                                      child: BottomBarItemWidget("NEARBY",
                                          "assets/images/bottom_nav_nearby.png",
                                          isVisible: true))),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StateContainer
                                                                  .of(context)
                                                              .mLoginResponse !=
                                                          null &&
                                                      StateContainer.of(context)
                                                              .mLoginResponse
                                                              .data
                                                              .token !=
                                                          null
                                                  ? UserProfile()
                                                  : LoginScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget("PROFILE",
                                          "assets/images/bottom_nav_login.png",
                                          isVisible: true))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align (
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StateContainer.of(context).mLoginResponse !=
                                              null &&
                                          StateContainer.of(context)
                                                  .mLoginResponse
                                                  .data
                                                  .token !=
                                              null
                                      ? ChooseCategoryScreen()
                                      : LoginScreen()),
                        );
                      },
                      child: /*(shouldShowShowcase != null &&
                              (!shouldShowShowcase))
                          ? Showcase(
                              key: postKey,
                              title: 'Post Ads',
                              description: 'Click here to post your ads',
                              shapeBorder: CircleBorder(),
                              showArrow: true,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: space_70,
                                      width: space_70,
                                      margin: EdgeInsets.only(top: space_40),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: CommonStyles.lightGrey),
                                      child: Center(
                                        child: ImageIcon(
                                          AssetImage(
                                            "assets/images/bottom_nav_post_rent.png",
                                          ),
                                          color: CommonStyles.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: space_10, bottom: space_5),
                                      child: Text(
                                        "POST RENT",
                                        style: CommonStyles.getRalewayStyle(
                                            space_10,
                                            FontWeight.w400,
                                            Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          :*/ Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: space_70,
                                    width: space_70,
                                    margin: EdgeInsets.only(top: space_40),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: CommonStyles.lightGrey),
                                    child: Center(
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/bottom_nav_post_rent.png",
                                        ),
                                        color: CommonStyles.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: space_10, bottom: space_5),
                                    child: Text(
                                      "POST RENT",
                                      style: CommonStyles.getRalewayStyle(
                                          space_10,
                                          FontWeight.w400,
                                          Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class CommonBottomNavBarHomeShowCaseWidget extends StatelessWidget {
  GlobalKey postKey;
  bool shouldShowShowcase;

  CommonBottomNavBarHomeShowCaseWidget({this.postKey, this.shouldShowShowcase});

  @override
  Widget build(BuildContext context) {
    debugPrint("COMMONBOTTOMCHECK--> ${shouldShowShowcase} ${postKey}");
    return Container(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  height: space_150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: space_80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/bottom_back.png"),
                                fit: BoxFit.fitWidth)),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget(
                                        "HOME",
                                        "assets/images/nav_home_icon.png",
                                        isVisible: true,
                                      ))),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StateContainer
                                                                  .of(context)
                                                              .mLoginResponse !=
                                                          null &&
                                                      StateContainer.of(context)
                                                              .mLoginResponse
                                                              .data
                                                              .token !=
                                                          null
                                                  ? ChatHomeScreen()
                                                  : LoginScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget("CHAT",
                                          "assets/images/bottom_nav_chat.png",
                                          isVisible: true))),
                              Expanded(
                                  child: BottomBarItemWidget(
                                "",
                                "assets/images/bottom_nav_nearby.png",
                                isVisible: false,
                              )),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        var currentLoc = StateContainer.of(
                                                        context)
                                                    .mUserLocationSelected !=
                                                null
                                            ? StateContainer.of(context)
                                                .mUserLocationSelected
                                            : null;
                                        if (currentLoc != null) {
                                          StateContainer.of(context)
                                                  .mUserLocNameSelected =
                                              UserLocNameSelected(
                                                  address: currentLoc.city,
                                                  mlat: currentLoc.mlat,
                                                  mlng: currentLoc.mlng);
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NearByChildSubCategoryScreen(
                                                    isFromNearBy: true,
                                                    lat: StateContainer.of(
                                                                    context)
                                                                .mUserLocationSelected !=
                                                            null
                                                        ? StateContainer.of(
                                                                context)
                                                            .mUserLocationSelected
                                                            .mlat
                                                        : "",
                                                    lng: StateContainer.of(
                                                                    context)
                                                                .mUserLocationSelected !=
                                                            null
                                                        ? StateContainer.of(
                                                                context)
                                                            .mUserLocationSelected
                                                            .mlng
                                                        : "",
                                                    radius: LOCATION_RADIUS,
                                                  )),
                                        );
                                      },
                                      child: BottomBarItemWidget("NEARBY",
                                          "assets/images/bottom_nav_nearby.png",
                                          isVisible: true))),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StateContainer
                                                                  .of(context)
                                                              .mLoginResponse !=
                                                          null &&
                                                      StateContainer.of(context)
                                                              .mLoginResponse
                                                              .data
                                                              .token !=
                                                          null
                                                  ? UserProfile()
                                                  : LoginScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget("PROFILE",
                                          "assets/images/bottom_nav_login.png",
                                          isVisible: true))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align (
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StateContainer.of(context).mLoginResponse !=
                                              null &&
                                          StateContainer.of(context)
                                                  .mLoginResponse
                                                  .data
                                                  .token !=
                                              null
                                      ? ChooseCategoryScreen()
                                      : LoginScreen()),
                        );
                      },
                      child: Showcase(
                              key: postKey,
                              title: 'Post Ads',
                              description: 'Click here to post your ads',
                              shapeBorder: CircleBorder(),
                              showArrow: true,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: space_70,
                                      width: space_70,
                                      margin: EdgeInsets.only(top: space_40),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: CommonStyles.lightGrey),
                                      child: Center(
                                        child: ImageIcon(
                                          AssetImage(
                                            "assets/images/bottom_nav_post_rent.png",
                                          ),
                                          color: CommonStyles.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: space_10, bottom: space_5),
                                      child: Text(
                                        "POST RENT",
                                        style: CommonStyles.getRalewayStyle(
                                            space_10,
                                            FontWeight.w400,
                                            Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CommonBottomNavBarWidget extends StatelessWidget {
  CommonBottomNavBarWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  height: space_150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: space_80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/bottom_back.png"),
                                fit: BoxFit.fitWidth)),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget(
                                        "HOME",
                                        "assets/images/nav_home_icon.png",
                                        isVisible: true,
                                      ))),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StateContainer
                                                                  .of(context)
                                                              .mLoginResponse !=
                                                          null &&
                                                      StateContainer.of(context)
                                                              .mLoginResponse
                                                              .data
                                                              .token !=
                                                          null
                                                  ? ChatHomeScreen()
                                                  : LoginScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget("CHAT",
                                          "assets/images/bottom_nav_chat.png",
                                          isVisible: true))),
                              Expanded(
                                  child: BottomBarItemWidget(
                                "",
                                "assets/images/bottom_nav_nearby.png",
                                isVisible: false,
                              )),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        var currentLoc = StateContainer.of(
                                                        context)
                                                    .mUserLocationSelected !=
                                                null
                                            ? StateContainer.of(context)
                                                .mUserLocationSelected
                                            : null;
                                        if (currentLoc != null) {
                                          StateContainer.of(context)
                                                  .mUserLocNameSelected =
                                              UserLocNameSelected(
                                                  address: currentLoc.city,
                                                  mlat: currentLoc.mlat,
                                                  mlng: currentLoc.mlng);
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NearByChildSubCategoryScreen(
                                                    isFromNearBy: true,
                                                    lat: StateContainer.of(
                                                                    context)
                                                                .mUserLocationSelected !=
                                                            null
                                                        ? StateContainer.of(
                                                                context)
                                                            .mUserLocationSelected
                                                            .mlat
                                                        : "",
                                                    lng: StateContainer.of(
                                                                    context)
                                                                .mUserLocationSelected !=
                                                            null
                                                        ? StateContainer.of(
                                                                context)
                                                            .mUserLocationSelected
                                                            .mlng
                                                        : "",
                                                    radius: LOCATION_RADIUS,
                                                  )),
                                        );
                                      },
                                      child: BottomBarItemWidget("NEARBY",
                                          "assets/images/bottom_nav_nearby.png",
                                          isVisible: true))),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StateContainer
                                                                  .of(context)
                                                              .mLoginResponse !=
                                                          null &&
                                                      StateContainer.of(context)
                                                              .mLoginResponse
                                                              .data
                                                              .token !=
                                                          null
                                                  ? UserProfile()
                                                  : LoginScreen()),
                                        );
                                      },
                                      child: BottomBarItemWidget("PROFILE",
                                          "assets/images/bottom_nav_login.png",
                                          isVisible: true))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StateContainer.of(context).mLoginResponse !=
                                              null &&
                                          StateContainer.of(context)
                                                  .mLoginResponse
                                                  .data
                                                  .token !=
                                              null
                                      ? ChooseCategoryScreen()
                                      : LoginScreen()),
                        );
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: space_70,
                              width: space_70,
                              margin: EdgeInsets.only(top: space_40),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CommonStyles.lightGrey),
                              child: Center(
                                child: ImageIcon(
                                  AssetImage(
                                    "assets/images/bottom_nav_post_rent.png",
                                  ),
                                  color: CommonStyles.primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: space_10, bottom: space_5),
                              child: Text(
                                "POST RENT",
                                style: CommonStyles.getRalewayStyle(
                                    space_10, FontWeight.w400, Colors.white),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BottomFloatingFilterBtnsWidget extends StatelessWidget {
  FilterRes filterRes;
  Function openFilter;
  Function openSortFilter;

  BottomFloatingFilterBtnsWidget(
      this.filterRes, this.openFilter, this.openSortFilter);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: space_100, right: space_10),
      child: Card(
        elevation: space_8,
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(space_30),
              topRight: Radius.circular(space_30),
              bottomRight: Radius.circular(space_30),
              bottomLeft: Radius.circular(space_30),
            )),
        child: Container(
          height: space_120,
          width: space_60,
          padding: EdgeInsets.all(space_10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(space_30),
                topRight: Radius.circular(space_30),
                bottomRight: Radius.circular(space_30),
                bottomLeft: Radius.circular(space_30),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: openSortFilter,
                child: Container(
                  height: space_40,
                  width: space_40,
                  padding: EdgeInsets.all(space_10),
                  decoration: BoxDecoration(
                      color: CommonStyles.primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: ImageIcon(
                      AssetImage(
                        "assets/images/sortby_icon_amber.png",
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: openFilter,
                /*() {
                  openFilter;
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => FilterScreen(filterRes)),
//                  );
                },*/
                child: Container(
                  height: space_40,
                  width: space_40,
                  padding: EdgeInsets.all(space_10),
                  decoration: BoxDecoration(
                      color: CommonStyles.primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: ImageIcon(
                      AssetImage(
                        "assets/images/filter_icon_amber.png",
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BottomFloatingChatBtnsWidget extends StatelessWidget {
  String adId;
  String slug;
  String mobile;
  String sellerId;
  String profile_setting;

  BottomFloatingChatBtnsWidget(
      this.adId, this.slug, this.mobile, this.sellerId, this.profile_setting);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: space_100, right: space_10),
      child: Card(
        elevation: space_8,
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(space_30),
              topRight: Radius.circular(space_30),
              bottomRight: Radius.circular(space_30),
              bottomLeft: Radius.circular(space_30),
            )),
        child: Container(
          height: profile_setting != null &&
                  profile_setting.isNotEmpty &&
                  profile_setting == "public"
              ? space_120
              : space_60,
          width: space_60,
          padding: EdgeInsets.all(space_10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(space_30),
                topRight: Radius.circular(space_30),
                bottomRight: Radius.circular(space_30),
                bottomLeft: Radius.circular(space_30),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              profile_setting != null &&
                      profile_setting.isNotEmpty &&
                      profile_setting == "public"
                  ? GestureDetector(
                      onTap: () {
                        StateContainer.of(context).mLoginResponse != null &&
                                StateContainer.of(context)
                                        .mLoginResponse
                                        .data
                                        .token !=
                                    null
                            ? lauchDialer(mobile)
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                      },
                      child: Container(
                        height: space_40,
                        width: space_40,
                        decoration: BoxDecoration(
                            color: CommonStyles.primaryColor,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: space_0,
                      width: space_0,
                    ),
              GestureDetector(
                onTap: () {
                  StateContainer.of(context).mLoginResponse != null &&
                          StateContainer.of(context)
                                  .mLoginResponse
                                  .data
                                  .token !=
                              null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                    slug: slug,
                                    sellerId: sellerId,
                                    adId: adId,
                                  )),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                },
                child: Container(
                  height: space_40,
                  width: space_40,
                  padding: EdgeInsets.all(space_10),
                  decoration: BoxDecoration(
                      color: CommonStyles.primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: ImageIcon(
                      AssetImage(
                        "assets/images/bottom_nav_chat.png",
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PackageCardWidget extends StatelessWidget {
  GetAllPackageData getAllPackageData;
  Function paynow;

  PackageCardWidget(this.getAllPackageData, this.paynow);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_240,
      width: space_180,
      margin: EdgeInsets.only(left: space_10, right: space_5),
      padding: EdgeInsets.all(space_15),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/package_back.png"),
              fit: BoxFit.fill)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "STATER",
          //   style: CommonStyles.getRalewayStyle(
          //       space_13, FontWeight.w600, Colors.white),
          // ),
          Text(
            "${getAllPackageData.title}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CommonStyles.getMontserratStyle(
                space_22, FontWeight.w900, Colors.white),
          ),
          Text(
            "PACK",
            style: CommonStyles.getRalewayStyle(
                space_13, FontWeight.w500, Colors.white),
          ),
          SizedBox(
            height: space_10,
          ),
          Expanded(
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\u20B9",
                          style: CommonStyles.getRalewayStyle(
                              space_15,
                              FontWeight.w600,
                              CommonStyles.softYellow.withOpacity(0.7)),
                        ),
                        Text(
                          "${getAllPackageData.price}",
                          style: CommonStyles.getMontserratStyle(
                              space_30, FontWeight.w900, Colors.white),
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "",
                          style: CommonStyles.getRalewayStyle(
                              space_15,
                              FontWeight.w500,
                              CommonStyles.softYellow.withOpacity(0.7)),
                        )),
                    Text(
                      "For ${getAllPackageData.no_of_days} days\n${getAllPackageData.no_of_posts} Posts",
                      textAlign: TextAlign.center,
                      style: CommonStyles.getMontserratStyle(
                          space_14, FontWeight.w500, Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: paynow,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: space_15, vertical: space_8),
              decoration: BoxDecoration(
                  color: CommonStyles.blue,
                  borderRadius: BorderRadius.circular(space_10)),
              child: Center(
                child: Text(
                  "CLAIM NOW",
                  style: CommonStyles.getRalewayStyle(
                      space_13, FontWeight.w500, Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  String title;

  EmptyWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            CommonAppbarWidget(app_name, skip_for_now, () {
              onSearchLocation(context);
            }),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: CommonStyles.getMontserratStyle(
                      space_15, FontWeight.w600, Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyAdsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                      'There is no post available!',
                      style: CommonStyles.getRalewayStyle(
                          space_16, FontWeight.w500, Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StateContainer.of(context).mLoginResponse !=
                                              null &&
                                          StateContainer.of(context)
                                                  .mLoginResponse
                                                  .data
                                                  .token !=
                                              null
                                      ? ChooseCategoryScreen()
                                      : LoginScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(space_15),
                        child: Text(
                          'Post Now',
                          style: TextStyle(
                            fontSize: space_18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            color: CommonStyles.primaryColor,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: CommonStyles.primaryColor,
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
      ),
    );
  }
}

class TimeoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                          space_16, FontWeight.w500, Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {},
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
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: CommonStyles.primaryColor,
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
      ),
    );
  }
}

class ProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ProgressNormalAppBarWidget extends StatelessWidget {
  String title;

  ProgressNormalAppBarWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Form(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostAdsCommonAppbar(title: title),
                  Expanded(child: ProgressWidget())
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class ProfileRowWidget extends StatelessWidget {
  String title;
  String iconpath;

  ProfileRowWidget(this.title, this.iconpath);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_60,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(space_15),
                child: ImageIcon(
                  AssetImage(
                    iconpath,
                  ),
                  color: CommonStyles.grey,
                ),
              ),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CommonStyles.getMontserratStyle(
                          space_15, FontWeight.w500, Colors.black),
                    )
                  ],
                ),
              ))
            ],
          ),
          Divider(
            height: space_1,
            thickness: space_1,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
