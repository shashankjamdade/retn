import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/item_detail_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/ImagePreviewScreen.dart';
import 'package:flutter_rentry_new/screens/ProfileScreen.dart';
import 'package:flutter_rentry_new/screens/editAds/ChooseCategoryEditAdScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';

class ItemDetailScreen extends StatefulWidget {
  String categoryName;

  ItemDetailScreen({this.categoryName});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  ItemDetailResponse mItemDetailResponse;
  var loginResponse;
  String token = "";
  String userId = "";
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      userId = loginResponse.data.id;
      debugPrint("ACCESSING_INHERITED ${token}, USERID - ${userId}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc
        ..add(ItemDetailReqEvent(
            token: token, categoryName: widget.categoryName)),
      child: BlocListener(
        cubit: homeBloc,
        listener: (context, state) {
          if (state is ItemDetailResState) {
            mItemDetailResponse = state.res;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is ItemDetailResState) {
              // ignore: missing_return
              return setDataToUI(state.res);
            } else {
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  doNothing() {}

  Widget setDataToUI(ItemDetailResponse itemDetailResponse) {
    var mapUrl = getMapUrl(
        double.parse(itemDetailResponse.ad.lat),
        double.parse(itemDetailResponse.ad.lang),
        MediaQuery.of(context).size.width.toInt() - 30,
        getProportionateScreenHeight(context, space_180).toInt());
    var bannerlist = new List<String>();
    if (itemDetailResponse.ad.img_1 != null)
      bannerlist.add(itemDetailResponse.ad.img_1);
    if (itemDetailResponse.ad.img_2 != null)
      bannerlist.add(itemDetailResponse.ad.img_2);
    if (itemDetailResponse.ad.img_3 != null)
      bannerlist.add(itemDetailResponse.ad.img_3);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight:
                        getProportionateScreenHeight(context, space_250),
                    floating: false,
                    pinned: true,
//                    leading: Container(height: space_1, width: space_0),),
//                    leading: IconButton(
//                        icon: Icon(
//                          Icons.arrow_back,
//                          color: Colors.black,
//                        ),
//                        onPressed: () {
//                          Navigator.pop(context);
//                        }),
                    flexibleSpace: InkWell(
                      onTap: () {
                        var imgList = new List<String>();
                        if(itemDetailResponse.ad.img_1!=null && itemDetailResponse.ad.img_1.isNotEmpty)
                          imgList.add(itemDetailResponse.ad.img_1);
                        if(itemDetailResponse.ad.img_2!=null && itemDetailResponse.ad.img_2.isNotEmpty)
                          imgList.add(itemDetailResponse.ad.img_2);
                        if(itemDetailResponse.ad.img_3!=null && itemDetailResponse.ad.img_3.isNotEmpty)
                          imgList.add(itemDetailResponse.ad.img_3);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ImagePreviewScreen(imgList)),
                        );
                      },
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Container(
                            child: Stack(
                          children: [
                            ItemDetailBannerImgCarousalWidget(bannerList: bannerlist),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: space_15, vertical: space_10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: space_30,
                                      width: space_30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child:
                                          Center(child: Icon(Icons.arrow_back)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      new HomeRepository().callSavefavouriteApi(
                                          StateContainer.of(context)
                                              .mLoginResponse
                                              .data
                                              .token,
                                          itemDetailResponse.ad.id);
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                    },
                                    child: Container(
                                      height: space_30,
                                      width: space_30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          isLiked
                                              ? "assets/images/heart.png"
                                              : "assets/images/heart_grey.png",
                                          width: space_15,
                                          height: space_15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                  child: Container(
                      height: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Text(
                              itemDetailResponse.ad.title,
                              style: CommonStyles.getRalewayStyle(
                                  space_20, FontWeight.w600, Colors.black),
                            ),
                            subtitle: Text(
                              itemDetailResponse.ad.slug,
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500, Colors.black),
                            ),
                            trailing: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹ ${itemDetailResponse.ad.price}",
                                    style: CommonStyles.getMontserratStyle(
                                        space_25,
                                        FontWeight.w600,
                                        CommonStyles.blue),
                                  ),
                                  Text(
                                    "${itemDetailResponse.ad.rent_type}",
                                    style: CommonStyles.getRalewayStyle(
                                        space_14,
                                        FontWeight.w500,
                                        Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: space_15,
                          ),
                          InkWell(
                            onTap: (){
                              if (itemDetailResponse.ad.lat != null &&
                                  itemDetailResponse.ad.lang != null &&
                                  itemDetailResponse.ad.lat.isNotEmpty &&
                                  itemDetailResponse.ad.lang.isNotEmpty) {
                                openMap(double.parse(itemDetailResponse.ad.lat),
                                    double.parse(itemDetailResponse.ad.lang));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: space_15),
                              child: Card(
                                elevation: space_3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(space_5)),
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      EdgeInsets.symmetric(vertical: space_15),
                                  decoration: BoxDecoration(
                                      color: CommonStyles.lightGrey,
                                      borderRadius:
                                          BorderRadius.circular(space_5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.location_on,
                                            color: CommonStyles.primaryColor,
                                            size: space_15,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: space_10),
                                          child: Text(
                                            itemDetailResponse.ad.location,
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
                              ),
                            ),
                          ),
                          SizedBox(
                            height: space_25,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: space_15),
                            child: Text(
                              "Description",
                              style: CommonStyles.getRalewayStyle(
                                  space_18, FontWeight.w600, Colors.black),
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
                              itemDetailResponse.ad.description,
                              style: CommonStyles.getRalewayStyle(
                                  space_14,
                                  FontWeight.w500,
                                  Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          SizedBox(
                            height: space_25,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: space_15),
                            child: Text(
                              "Details",
                              style: CommonStyles.getRalewayStyle(
                                  space_18, FontWeight.w600, Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: space_8,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount:
                                  itemDetailResponse?.ad?.custome_field?.length,
                              itemBuilder: (context, pos) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: space_5,
                                      left: space_15,
                                      right: space_15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          itemDetailResponse?.ad
                                              ?.custome_field[pos]?.field_name,
                                          style:
                                              CommonStyles.getMontserratStyle(
                                                  space_15,
                                                  FontWeight.w600,
                                                  CommonStyles.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          itemDetailResponse?.ad
                                              ?.custome_field[pos]?.field_value,
                                          style:
                                              CommonStyles.getMontserratStyle(
                                                  space_15,
                                                  FontWeight.w500,
                                                  Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(
                            height: space_25,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: space_15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Location",
                                  style: CommonStyles.getRalewayStyle(
                                      space_18, FontWeight.w600, Colors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${itemDetailResponse.ad.address}",
                                  style: CommonStyles.getRalewayStyle(space_16,
                                      FontWeight.w600, CommonStyles.blue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: space_10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (itemDetailResponse.ad.lat != null &&
                                  itemDetailResponse.ad.lang != null &&
                                  itemDetailResponse.ad.lat.isNotEmpty &&
                                  itemDetailResponse.ad.lang.isNotEmpty) {
                                openMap(double.parse(itemDetailResponse.ad.lat),
                                    double.parse(itemDetailResponse.ad.lang));
                              }
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: space_15),
                              height: getProportionateScreenHeight(
                                  context, space_180),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(space_15),
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/loader.jpg",
                                  image: mapUrl,
                                  //"https://picsum.photos/250?image=9",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: space_25,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: space_15),
                            child: Text(
                              "Owner Info",
                              style: CommonStyles.getRalewayStyle(
                                  space_18, FontWeight.w600, Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: space_15,
                          ),
                          OwnerInfo(
                            rating: itemDetailResponse.ad.rating != null
                                ? double.parse(itemDetailResponse.ad.rating.avg_rating)
                                : 0,
                            sellerId: itemDetailResponse.ad.seller != null
                                ? itemDetailResponse.ad.seller
                                : "",
                            profilePath:
                                itemDetailResponse.ad.profile_picture != null
                                    ? itemDetailResponse?.ad?.profile_picture
                                    : "",
                            username: itemDetailResponse.ad.username != null
                                ? itemDetailResponse?.ad?.username
                                : "",
                            createdDate: itemDetailResponse.ad.since != null
                                ? itemDetailResponse?.ad?.since
                                : "",
                          ),
                          SizedBox(
                            height: space_30,
                          ),
                          itemDetailResponse
                              .similar_ads!=null && itemDetailResponse
                              .similar_ads?.length>0?Container(
                            height: space_360,
                            color: CommonStyles.blue.withOpacity(0.1),
                            child: Column(
                              children: [
                                RichTextTitleBtnWidget("SIMILAR",
                                    getRichText2ByType(SIMILAR_PRODUCT), () {
                                  itemDetailResponse.similar_ads.length > 0
                                      ? onViewAllClick(
                                          context,
                                          SIMILAR_PRODUCT,
                                          itemDetailResponse.similar_ads[0].category,
                                          itemDetailResponse
                                              .similar_ads[0].category_name)
                                      : doNothing();
                                }),
                                Container(
                                  height: space_280,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: itemDetailResponse
                                          .similar_ads.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            height: space_300,
                                            child: ItemCardWidget(
                                                category_adslist:
                                                    itemDetailResponse
                                                            .similar_ads[
                                                        index]));
                                      }),
                                )
                              ],
                            ),
                          ):Container(height: 0,width: 0,),
                          SizedBox(
                            height: space_15,
                          ),
                          itemDetailResponse
                              .similar_ads!=null && itemDetailResponse
                              .similar_ads?.length>0?Container(
                            height: space_360,
                            color: CommonStyles.blue.withOpacity(0.1),
                            child: Column(
                              children: [
                                RichTextTitleBtnWidget(
                                    "MORE", getRichText2ByType(MORE_PRODUCTS),
                                    () {
                                  itemDetailResponse.seller_all_product.length > 0
                                      ? onViewAllClick(
                                          context,
                                          SIMILAR_PRODUCT,
                                          itemDetailResponse.seller_all_product[0].category,
                                          itemDetailResponse
                                              .seller_all_product[0].category_name)
                                      : doNothing();
                                }),
                                Container(
                                  height: space_280,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          itemDetailResponse.seller_all_product.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            height: space_300,
                                            child: ItemCardWidget(
                                                category_adslist:
                                                    itemDetailResponse
                                                        .seller_all_product[index]));
                                      }),
                                ),
                              ],
                            ),
                          ):Container(height: 0, width: 0,),
                          SizedBox(
                            height: space_180,
                          ),
                        ],
                      ))),
            ),
            CommonBottomNavBarWidget(),
            (itemDetailResponse.ad.seller_id != null &&
                    itemDetailResponse.ad.seller_id == userId)
                ? Container(
                    height: space_0,
                    width: space_0,
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        child: BottomFloatingChatBtnsWidget(
                            itemDetailResponse != null
                                ? itemDetailResponse.ad.id
                                : "",
                            itemDetailResponse != null
                                ? itemDetailResponse.ad.slug
                                : "",
                            itemDetailResponse.ad.contact != null &&
                                    itemDetailResponse.ad.contact.isNotEmpty
                                ? itemDetailResponse.ad.contact
                                : "",
                            itemDetailResponse.ad.seller_id != null &&
                                    itemDetailResponse.ad.seller_id.isNotEmpty
                                ? itemDetailResponse.ad.seller_id
                                : "",
                            itemDetailResponse.ad.profile_setting!=null ? itemDetailResponse.ad.profile_setting:"")),
                  )
          ],
        ),
      ),
    );
  }
}
