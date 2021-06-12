import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/coupon_res.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/screens/SplashScreen.dart';
import 'package:flutter_rentry_new/screens/SubCategoryScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Carousal
class BannerImgCarousalWidget extends StatefulWidget {
  HomeResponse homeResponse;

  BannerImgCarousalWidget(this.homeResponse);

  @override
  _BannerImgCorousalWidgetState createState() =>
      _BannerImgCorousalWidgetState();
}

class _BannerImgCorousalWidgetState extends State<BannerImgCarousalWidget> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(context, space_160),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              height: getProportionateScreenHeight(context, space_120),
              child: Stack(
                children: [
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            height: getProportionateScreenHeight(
                                context, space_115),
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        carouselController: _controller,
                        items: widget.homeResponse.data.banner
                            .map((item) => GestureDetector(
                                  onTap: () {
                                    (widget.homeResponse.data.banner[_current]
                                                    .redirect_type !=
                                                null &&
                                            widget
                                                .homeResponse
                                                .data
                                                .banner[_current]
                                                .redirect_type
                                                ?.isNotEmpty &&
                                            widget
                                                    .homeResponse
                                                    .data
                                                    .banner[_current]
                                                    .redirect_type ==
                                                "category" &&
                                            widget
                                                    .homeResponse
                                                    .data
                                                    .banner[_current]
                                                    .category_id !=
                                                null &&
                                            widget
                                                .homeResponse
                                                .data
                                                .banner[_current]
                                                .category_id
                                                ?.isNotEmpty)
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubCategoryScreen(
                                                        categoryId: widget
                                                            .homeResponse
                                                            .data
                                                            .banner[_current]
                                                            .category_id,
                                                        categoryName: widget
                                                            .homeResponse
                                                            .data
                                                            .banner[_current]
                                                            .category)),
                                          )
                                        : launchURL(widget.homeResponse.data
                                            .banner[_current].slug);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(),
                                        height: getProportionateScreenHeight(
                                            context, space_150),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/images/loader.jpg",
                                          image: widget.homeResponse.data
                                              .banner[_current].banner,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: space_15),
                                            child: Text(
                                              widget.homeResponse.data
                                                  .banner[_current].title,
                                              style:
                                                  CommonStyles.getRalewayStyle(
                                                      space_20,
                                                      FontWeight.w900,
                                                      Colors.white),
                                            )),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  /*Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _controller.previousPage();
                            },
                            child: Container(
                              width: space_30,
                              height: space_30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.arrow_left,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _controller.nextPage();
                            },
                            child: Container(
                              width: space_30,
                              height: space_30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )*/
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.homeResponse.data.banner.map((url) {
              int index = widget.homeResponse.data.banner.indexOf(url);
              return _current == index
                  ? Container(
                      width: space_12,
                      height: space_12,
                      decoration: BoxDecoration(
                          border: Border.all(color: CommonStyles.primaryColor),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: space_5,
                          height: space_5,
                          decoration: BoxDecoration(
                              color: CommonStyles.primaryColor,
                              shape: BoxShape.circle),
                        ),
                      ),
                    )
                  : Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CommonStyles.primaryColor,
                      ),
                    );
            }).toList(),
          )
        ],
      ),
    );
  }
}

//Carousal - startup Intro
class IntroImgCarousalWidget extends StatefulWidget {
  List<String> mList;
  SharedPreferences prefs;
  IntroImgCarousalWidget(this.mList, this.prefs);

  @override
  _IntroImgCorousalWidgetState createState() => _IntroImgCorousalWidgetState();
}

class _IntroImgCorousalWidgetState extends State<IntroImgCarousalWidget>
    with SingleTickerProviderStateMixin {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("LIST_IMG--> ${widget.mList[_current]}");
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  height: getFullScreenHeight(context),
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                    if(index == 3){
                      controller.reverse();
                    }else{
                      controller.forward();
                    }
                    // switch (controller.status) {
                    //   case AnimationStatus.completed:
                    //     controller.reverse();
                    //     break;
                    //   case AnimationStatus.dismissed:
                    //     controller.forward();
                    //     break;
                    //   default:
                    // }
                  }),
              carouselController: _controller,
              items: widget.mList
                  .map((item) => GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(),
                              height: double.infinity,
                              child: Image.asset(
                                widget.mList[_current],
                                fit: BoxFit.fill,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _current == 3
              ? SlideTransition(
                  position: offset,
                  child: Container(
                    margin: EdgeInsets.only(bottom: space_10, left: space_15, right: space_15),
                    child: GestureDetector(
                      onTap: (){
                        if(widget.prefs!=null){
                          widget.prefs.setString(IS_INTRO_VIEWED, "true");
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()),
                        );
                      },
                      child: Card(
                        color: CommonStyles.blue,
                        elevation: space_3,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(space_15),
                                child: Text(
                                  "GET STARTED !",
                                  style: CommonStyles.getMontserratStyle(
                                      space_14, FontWeight.w600, Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.mList.map((url) {
                      int index = widget.mList.indexOf(url);
                      return _current == index
                          ? Container(
                              width: space_12,
                              height: space_12,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Container(
                                  width: space_5,
                                  height: space_5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                ),
                              ),
                            )
                          : Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            );
                    }).toList(),
                  ),
                ),
        )
      ],
    ));
  }
}

//2
class BannersCarousalWidget extends StatefulWidget {
  CouponRes mCouponres;

  BannersCarousalWidget(this.mCouponres);

  @override
  _BannersCorousalWidgetState createState() => _BannersCorousalWidgetState();
}

class _BannersCorousalWidgetState extends State<BannersCarousalWidget> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  List<CouponData> list;

  @override
  void initState() {
    super.initState();
    list = widget.mCouponres.data;
    debugPrint("COUPONLIST--> ${list.length}");
  }

  @override
  Widget build(BuildContext context) {
//    List<int> list = [1, 2, 3, 4, 5];
    return Container(
      height: getProportionateScreenHeight(context, space_250),
      child: Column(
        children: [
          Container(
              height: getProportionateScreenHeight(context, space_200),
              child: Stack(
                children: [
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            height: getProportionateScreenHeight(
                                context, space_180),
                            enlargeCenterPage: true,
                            viewportFraction: 0.7,
                            autoPlay: false,
                            disableCenter: false,
                            initialPage: 1,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        carouselController: _controller,
                        items: list.map((item) {
                          int index = list.indexOf(item);
                          return GestureDetector(
                            onTap: () {
                              launchURL(list[index].slug);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(space_15),
                              child: Container(
                                width: space_250,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(space_15)),
                                height: getProportionateScreenHeight(
                                    context, space_200),
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/loader.jpg",
                                  image: list[index].image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.map((url) {
              int index = list.indexOf(url);
              return _current == index
                  ? Container(
                      width: space_12,
                      height: space_12,
                      decoration: BoxDecoration(
                          border: Border.all(color: CommonStyles.primaryColor),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: space_5,
                          height: space_5,
                          decoration: BoxDecoration(
                              color: CommonStyles.primaryColor,
                              shape: BoxShape.circle),
                        ),
                      ),
                    )
                  : Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CommonStyles.primaryColor,
                      ),
                    );
            }).toList(),
          )
        ],
      ),
    );
  }
}

//3
class BannerImgCarousalWidget2 extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    List<int> list = [1, 2, 3, 4, 5];
    return Container(
        width: double.infinity,
        height: getProportionateScreenHeight(context, space_120),
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: getProportionateScreenHeight(context, space_120),
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              carouselController: _controller,
              items: list
                  .map((item) => Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                            ),
                            height: getProportionateScreenHeight(
                                context, space_150),
                            child: Center(child: Text(item.toString())),
                          ),
                          Positioned(
                            bottom: space_15,
                            child: Text(
                              "Dummy banner",
                              style: CommonStyles.getRalewayStyle(
                                  space_18, FontWeight.w600, Colors.white),
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: space_15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.previousPage();
                      },
                      child: Container(
                        width: space_30,
                        height: space_30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _controller.nextPage();
                      },
                      child: Container(
                        width: space_30,
                        height: space_30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

//4
class ItemDetailBannerImgCarousalWidget extends StatefulWidget {
  List<String> bannerList;

  ItemDetailBannerImgCarousalWidget({this.bannerList});

  @override
  _ItemDetailBannerImgCorousalWidgetState createState() =>
      _ItemDetailBannerImgCorousalWidgetState();
}

class _ItemDetailBannerImgCorousalWidgetState
    extends State<ItemDetailBannerImgCarousalWidget> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(context, space_250),
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: getProportionateScreenHeight(context, space_250),
              child: Stack(
                children: [
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            height: getProportionateScreenHeight(
                                context, space_250),
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        carouselController: _controller,
                        items: widget.bannerList
                            .map((item) => Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: CommonStyles.lightGrey,
                                      ),
                                      height: getProportionateScreenHeight(
                                          context, space_250),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: "assets/images/loader.jpg",
                                        image: widget.bannerList[_current],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.bannerList.map((url) {
                  int index = widget.bannerList.indexOf(url);
                  return _current == index
                      ? Container(
                          width: space_12,
                          height: space_12,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              width: space_5,
                              height: space_5,
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                            ),
                          ),
                        )
                      : Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
