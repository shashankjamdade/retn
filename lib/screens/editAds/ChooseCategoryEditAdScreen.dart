import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/get_category_response.dart';
import 'package:flutter_rentry_new/model/my_ads_edit_res.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class ChooseCategoryEditAdScreen extends StatefulWidget {
  String myAdId;
  ChooseCategoryEditAdScreen(this.myAdId);
  @override
  _ChooseCategoryEditAdScreenState createState() => _ChooseCategoryEditAdScreenState();
}

class _ChooseCategoryEditAdScreenState extends State<ChooseCategoryEditAdScreen> {
  HomeBloc homeBloc = new HomeBloc();
  MyAdsEditRes mMyAdsEditRes;
  var loginResponse;
  var token = "";

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
      create: (context) => homeBloc..add(GetMyAdsEditEvent(token: token, adId: widget.myAdId)),
      child: BlocListener(
        cubit: homeBloc,
        listener: (context, state) {
          if (state is GetMyAdsEditState) {
            mMyAdsEditRes = state.res;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is GetMyAdsEditState) {
              return getScreenUI(state.res);
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

  getScreenUI(MyAdsEditRes mMyAdsEditRes) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostAdsCommonAppbar(title: "What are you offering?"),
              Padding(
                padding: EdgeInsets.only(
                    left: space_15, top: space_20, bottom: space_20),
                child: Text(
                  "CHOOSE YOUR CATEGORY",
                  style: CommonStyles.getMontserratStyle(
                      space_14, FontWeight.w800, CommonStyles.blue),
                ),
              ),
              EditAdCategoryGridWidget(mMyAdsEditRes),
            ],
          ),
        ),
      ),
    );
  }
}
