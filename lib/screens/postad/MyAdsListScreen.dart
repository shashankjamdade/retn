import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/my_ads_list_res.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class MyAdsListScreen extends StatefulWidget {

  @override
  _MyAdsListScreenState createState() =>
      _MyAdsListScreenState();
}

class _MyAdsListScreenState
    extends State<MyAdsListScreen> {
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
      create: (context) =>
          homeBloc..add(MyAdsEvent(token: token)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if(state is GetMyAdsListState){
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

  Widget setDataToUI(MyAdsListRes res) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                child: Column(
              children: [
                PostAdsCommonAppbar(title: "My ADS"),
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
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}
}
