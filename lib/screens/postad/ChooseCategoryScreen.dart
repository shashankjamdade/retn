import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/get_category_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class ChooseCategoryScreen extends StatefulWidget {
  @override
  _ChooseCategoryScreenState createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  HomeBloc homeBloc = new HomeBloc();
  GetCategoryResponse mGetCategoryResponse;
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
      create: (context) => homeBloc..add(GetCategoryListEvent(token: token)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is GetAllCategoryListResState) {
            mGetCategoryResponse = state.res;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is GetAllCategoryListResState) {
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

  getScreenUI(GetCategoryResponse mGetCategoryResponse) {
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
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  children: [
                    PostAdCategoryGridWidget(mGetCategoryResponse),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
