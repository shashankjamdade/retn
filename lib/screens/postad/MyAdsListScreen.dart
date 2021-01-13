import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/my_ads_list_res.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/repository/HomeRepository.dart';
import 'package:flutter_rentry_new/screens/ItemDetailScreen.dart';
import 'package:flutter_rentry_new/screens/editAds/ChooseCategoryEditAdScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyAdsListScreen extends StatefulWidget {
  @override
  _MyAdsListScreenState createState() => _MyAdsListScreenState();
}

class _MyAdsListScreenState extends State<MyAdsListScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  var loginResponse;
  var token = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc..add(MyAdsEvent(token: token)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is DeleteAdState) {
            if (state.res != null && state.res.message != null) {
//                showSnakbar(_scaffoldKey, state.res.msg);
              Fluttertoast.showToast(
                  msg: state.res.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: space_14);
            }
            if (state.res.status != null && (state.res.status)) {
              homeBloc..add(MyAdsEvent(token: token));
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is GetMyAdsListState) {
              return setDataToUI(state.res);
            } else if (state is DeleteAdState) {
              return ProgressNormalAppBarWidget("My ADs");
            } else {
              return ProgressNormalAppBarWidget("My ADs");
            }
          },
        ),
      ),
    );
  }

  Widget setDataToUI(MyAdsListRes res) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                child: Column(
              children: [
                PostAdsCommonAppbar(title: "My ADs"),
                SizedBox(
                  height: space_15,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (getProportionateScreenWidth(
                                    context, space_230) /
                                (Platform.isIOS
                                    ? getProportionateScreenHeight(
                                        context, space_300)
                                    : getProportionateScreenHeight(
                                        context, space_370))),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          itemCount: res.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: space_280,
                              width: space_230,
                              child:
                                  getMyitemCardNoMarginWidget(res.data[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: space_110,
                      )
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}

  Widget getMyitemCardNoMarginWidget(Category_adslist mCategory_adslist) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemDetailScreen(categoryName: mCategory_adslist.slug)),
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
                                  borderRadius:
                                      BorderRadius.circular(space_10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/app_img_white.png",
                                image: mCategory_adslist.img_1,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            height: space_50,
                            width: space_50,
                            margin:
                                EdgeInsets.only(left: space_15, top: space_8),
                            child: Center(
                              child: mCategory_adslist?.is_status == "0"?ImageIcon(AssetImage("assets/images/approved.png"), size: space_50,):Icon(
                                Icons.watch_later,
                                color: CommonStyles.grey, size: space_50
                              ),
                            ),
                          ),
                          Positioned(
                            top: space_8,
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _showDialog(
                                            context, mCategory_adslist.id);
                                      },
                                      child: Container(
                                        height: space_30,
                                        width: space_30,
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
                                            size: space_15,
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
                                                      mCategory_adslist.id)),
                                        );
                                      },
                                      child: Container(
                                        height: space_30,
                                        width: space_30,
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
                                            size: space_15,
                                          ),
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
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: space_5),
                        child: Text(
                          mCategory_adslist.title,
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
                              mCategory_adslist.description != null
                                  ? mCategory_adslist.description
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
                        height: space_5,
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
                                  mCategory_adslist.location != null
                                      ? mCategory_adslist.location
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
                              "${mCategory_adslist.price}/",
                              style: CommonStyles.getMontserratStyle(
                                  space_15, FontWeight.w800, Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "month",
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

  _showDialog(BuildContext context, String adId) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          // code on continue comes here
          homeBloc..add(DeleteAdEvent(token: token, adId: adId))
        };
    BlurryDialog alert = BlurryDialog(
        "Delete", "Are you sure you want to delete ad?", continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class BlurryDialog extends StatelessWidget {
  String title;
  String content;
  VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);

  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: new Text(
            title,
            style: textStyle,
          ),
          content: new Text(
            content,
            style: textStyle,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                continueCallBack();
              },
            ),
            new FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
