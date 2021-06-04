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

class AllCategoryScreen extends StatefulWidget {
  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
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
        cubit: homeBloc,
        listener: (context, state) {
          if (state is GetAllCategoryListResState) {
            if (state.res != null && state.res is GetCategoryResponse) {
              if (state.res.status) {
                mGetCategoryResponse = state.res;
              }
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is GetAllCategoryListResState &&
                state.res != null &&
                state.res is GetCategoryResponse) {
              if (state.res.status) {
                return getScreenUI(state.res);
              } else {
                return getErrorScreenUI();
              }
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
              PostAdsCommonAppbar(title: "Categories"),
              Padding(
                padding: EdgeInsets.only(
                    left: space_15, top: space_20, bottom: space_20),
                child: Text(
                  "CHOOSE CATEGORY",
                  style: CommonStyles.getMontserratStyle(
                      space_14, FontWeight.w800, CommonStyles.blue),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  children: [
                    AllCategoryGridWidget(mGetCategoryResponse),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getErrorScreenUI() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostAdsCommonAppbar(title: "Categories"),
              Padding(
                padding: EdgeInsets.only(
                    left: space_15, top: space_20, bottom: space_20),
                child: Text(
                  "CHOOSE CATEGORY",
                  style: CommonStyles.getMontserratStyle(
                      space_14, FontWeight.w800, CommonStyles.blue),
                ),
              ),
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
                        onTap: () {
                          homeBloc..add(GetCategoryListEvent(token: token));
                        },
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
      ),
    );
  }
}
