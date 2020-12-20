import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/my_ads_edit_res.dart';
import 'package:flutter_rentry_new/model/sub_category_list_response.dart';
import 'package:flutter_rentry_new/screens/ItemDetailScreen.dart';
import 'package:flutter_rentry_new/screens/NearByChildSubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/editAds/EditCustomFieldsScreen.dart';
import 'package:flutter_rentry_new/screens/postad/CustomFieldsScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class EditAdsSubCategoryScreen extends StatefulWidget {
  AdPostReqModel adPostReqModel;
  MyAdsEditRes mMyAdsEditRes;
  EditAdsSubCategoryScreen({this.adPostReqModel, this.mMyAdsEditRes});

  @override
  _EditAdsSubCategoryScreenState createState() => _EditAdsSubCategoryScreenState();
}

class _EditAdsSubCategoryScreenState extends State<EditAdsSubCategoryScreen> {
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
          homeBloc..add((widget.adPostReqModel.categoryId == widget.mMyAdsEditRes.data.post.category)?InitialEvent():SubCategoryListReqEvent(categoryId: widget.adPostReqModel.categoryId, token: token)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is InitialHomeState) {
            mSubCategoryListResponse = new SubCategoryListResponse(status: true, message: "",data: widget.mMyAdsEditRes.data.subcategory);
          }else if (state is SubCategoryListResState) {
            mSubCategoryListResponse = state.res;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if(state is SubCategoryListResState){
              return setDataToUI(state.res);
            }else if(state is InitialHomeState){
              return setDataToUI(new SubCategoryListResponse(status: true, message: "",data: widget.mMyAdsEditRes.data.subcategory));
            }else if(state is ProgressState){
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else {
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
                PostAdsCommonAppbar(title: "What are you offering?"),
                Container(
                  margin: EdgeInsets.only(
                      left: space_15,
                      bottom: space_15,
                      top: getProportionateScreenHeight(context, space_25)),
                  child: Row(
                    children: [
                      Text(
                        widget.adPostReqModel.categoryName,
                        style: CommonStyles.getRalewayStyle(
                            space_15, FontWeight.w800, CommonStyles.red),
                      ),
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
                                    widget.adPostReqModel.subCategoryId = subCategoryListResponse.data[index].id;
                                    widget.adPostReqModel.subCategoryName = subCategoryListResponse.data[index].name;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditCustomeFieldsScreen(widget.adPostReqModel, widget.mMyAdsEditRes)),
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
          ],
        ),
      ),
    );
  }

  void onSearchClick() {}
}
