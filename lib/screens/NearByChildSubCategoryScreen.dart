import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';

class NearByChildSubCategoryScreen extends StatefulWidget {

  String categoryId , subCategoryId, radius , lat ,lng, categoryName, subCategoryName ;
  bool isFromNearBy;

  NearByChildSubCategoryScreen({this.categoryId= "79", this.subCategoryId = "44", this.radius= "50", this.lat= "23.2599", this.lng= "77.4126", this.isFromNearBy = true, this.categoryName= "CAR", this.subCategoryName= "FURNITURE"});

  @override
  _NearByChildSubCategoryScreenState createState() =>
      _NearByChildSubCategoryScreenState();
}

class _NearByChildSubCategoryScreenState
    extends State<NearByChildSubCategoryScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  var loginResponse;
  var token = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_ITEM_LIST_SCREEN-----${widget.categoryName}---");
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
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) =>
          homeBloc..add(NearbySubChildCategoryListReqEvent(token: token, categoryId: widget.categoryId, subcategory_id: widget.subCategoryId, radius: widget.radius, lat: widget.lat, lng: widget.lng)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if(state is NearbySubChildCategoryListResState){
              return setDataToUI(state.res);
            }else{
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

  Widget setDataToUI(NearbySubChildCategoryListResponse res) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                      widget.isFromNearBy?
                      Text(
                       "BROWSE BY NEARME",
                        style: CommonStyles.getRalewayStyle(
                            space_15, FontWeight.w800, Colors.black),
                      ):
                      Container(
                        margin: EdgeInsets.only(
                            left: space_15,
                            top: getProportionateScreenHeight(context, space_15)),
                        child: widget.subCategoryName!=null && widget.subCategoryName.isNotEmpty?
                        Row(
                          children: [
                            Text(widget.categoryName, style: CommonStyles.getRalewayStyle(space_15, FontWeight.w800, CommonStyles.red),),
                            SizedBox(height: space_15,),
                            Container(height: space_15, child: VerticalDivider(thickness: space_2, color: CommonStyles.grey, indent: space_3,)),
                            Text(widget.subCategoryName, style: CommonStyles.getRalewayStyle(space_15, FontWeight.w800, CommonStyles.blue),),
                            Container(height: space_15, child: VerticalDivider(thickness: space_2, color: CommonStyles.grey, indent: space_3,)),
                            RichTextTitleWidget("SUB", "CATEGORIES"),
                          ],
                        ):
                        Text(widget.categoryName, style: CommonStyles.getRalewayStyle(space_15, FontWeight.w800, CommonStyles.red),),
                      ),
                    ],
                  ),
                ),
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
                              child: ItemCardNoMarginWidget(category_adslist: res.data[index]),
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
            CommonBottomNavBarWidget(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(child: BottomFloatingFilterBtnsWidget()),
            )
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}
}
