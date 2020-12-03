import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
import 'package:flutter_rentry_new/screens/ItemDetailScreen.dart';
import 'package:flutter_rentry_new/screens/NearByChildSubCategoryScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';

class SubCategoryScreen extends StatefulWidget {
  String categoryId;
  String categoryName;

  SubCategoryScreen({this.categoryId, this.categoryName});

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  SubCategoryListResponse mSubCategoryListResponse;
  var loginResponse;
  var token = "";


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if(loginResponse!=null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          homeBloc..add(SubCategoryListReqEvent(categoryId: widget.categoryId, token: token)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is SubCategoryListResState) {
            mSubCategoryListResponse = state.res;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if(state is SubCategoryListResState){
              return setDataToUI(state.res);
            }else if(state is ProgressState){
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

  Widget setDataToUI(SubCategoryListResponse subCategoryListResponse){
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Container(
                  margin: EdgeInsets.only(
                      left: space_15,
                      bottom: space_15,
                      top: getProportionateScreenHeight(context, space_25)),
                  child: Row(
                    children: [
                      Text(
                        widget.categoryName,
                        style: CommonStyles.getRalewayStyle(
                            space_15, FontWeight.w800, CommonStyles.red),
                      ),
                      SizedBox(
                        height: space_15,
                      ),
//                      Container(
//                          height: space_15,
//                          child: VerticalDivider(
//                            thickness: space_2,
//                            color: CommonStyles.grey,
//                            indent: space_3,
//                          )),
//                      Text(
//                        "FURNITURE",
//                        style: CommonStyles.getRalewayStyle(
//                            space_15, FontWeight.w800, CommonStyles.blue),
//                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeight(context, space_25)),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          children: List.generate(subCategoryListResponse.data.length, (index) {
                            return Container(
                              height: space_300,
                              width: space_230,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NearByChildSubCategoryScreen(categoryId: widget.categoryId, categoryName: widget.categoryName, subCategoryName: subCategoryListResponse.data[index].name, subCategoryId: subCategoryListResponse.data[index].id, radius: LOCATION_RADIUS, isFromNearBy: false,)),
                                    );
                                  },
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: SubCategoryItemWidget(subCategoryData: subCategoryListResponse.data[index],))),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: space_80,)
                    ],
                  ),
                ),
              ],
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}
}
