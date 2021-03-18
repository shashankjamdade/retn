import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/get_my_favourite_res.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';

class MyFavScreen extends StatefulWidget {


  MyFavScreen();

  @override
  _MyFavScreenState createState() =>
      _MyFavScreenState();
}

class _MyFavScreenState
    extends State<MyFavScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  var loginResponse;
  var token = "";
  var mLat = "";
  var mLng = "";

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
      create: (context) =>
          homeBloc..add(GetMyFavListEvent(token: token)),
      child: BlocListener(
        cubit: homeBloc,
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if(state is MyFavListResState){
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

  Widget setDataToUI(GetMyFavouriteRes res) {
    if(res.data!=null && res.data.length>0){
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
                                  childAspectRatio: getWidthToHeightRatio(context),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                itemCount: res.data.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: space_280,
                                    width: space_230,
                                    child: ItemCardNoMargin2Widget(category_adslist: res.data[index]),
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
//            Align(
//              alignment: Alignment.bottomRight,
//              child: Container(child: BottomFloatingFilterBtnsWidget()),
//            )
            ],
          ),
        ),
      );
    }else{
      return EmptyWidget("No data found");
    }
  }

  void onSearchClick() {}
}
