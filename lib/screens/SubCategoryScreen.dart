import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry/bloc/home/HomeState.dart';
import 'package:flutter_rentry/inherited/StateContainer.dart';
import 'package:flutter_rentry/model/sub_category_list_response.dart';
import 'package:flutter_rentry/screens/ItemDetailScreen.dart';
import 'package:flutter_rentry/screens/NearByChildSubCategoryScreen.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/Constants.dart';
import 'package:flutter_rentry/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';
import 'package:flutter_rentry/widgets/ListItemCardWidget.dart';

class SubCategoryScreen extends StatefulWidget {
  String categoryId;

  SubCategoryScreen({this.categoryId});

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
              return Center(
                child: CircularProgressIndicator(),
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
            CommonAppbarWidget(app_name, skip_for_now, () {
              onSearchLocation(context);
            }),
            Container(
              margin: EdgeInsets.only(
                  left: space_15,
                  top: getProportionateScreenHeight(context, space_120)),
              child: Row(
                children: [
                  Text(
                    "BEDS",
                    style: CommonStyles.getRalewayStyle(
                        space_15, FontWeight.w800, CommonStyles.red),
                  ),
                  SizedBox(
                    height: space_15,
                  ),
                  Container(
                      height: space_15,
                      child: VerticalDivider(
                        thickness: space_2,
                        color: CommonStyles.grey,
                        indent: space_3,
                      )),
                  Text(
                    "FURNITURE",
                    style: CommonStyles.getRalewayStyle(
                        space_15, FontWeight.w800, CommonStyles.blue),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: getProportionateScreenHeight(context, space_160)),
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 3,
                children: List.generate(subCategoryListResponse.data.length, (index) {
                  return Container(
                    height: space_300,
                    width: space_230,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NearByChildSubCategoryScreen()),
                          );
                        },
                        child: SubCategoryItemWidget(subCategoryData: subCategoryListResponse.data[index],)),
                  );
                }),
              ),
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}
}
