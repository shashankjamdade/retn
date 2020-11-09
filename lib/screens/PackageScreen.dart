import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/get_all_package_list_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  HomeBloc homeBloc = new HomeBloc();
  GetAllPackageListResponse mGetAllPackageListResponse;
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
      create: (context) => homeBloc..add(GetAllPackageListEvent(token: token)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is HomeResState) {
            mGetAllPackageListResponse = state.res;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is GetAllPackageListResState) {
            return getScreenUI(state.res);
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }),
      ),
    );
  }

  getScreenUI(GetAllPackageListResponse getAllPackageListResponse) {
    var packageList = new List<GetAllPackageData>();
    var currentPackage = new GetAllPackageData();
    getAllPackageListResponse.data.forEach((element) {
      if(element.sort_order == "0"){
        currentPackage = element;
      }else{
        packageList.add(element);
      }
    });
    var currentPackFromDate;
    var currentPackToDate;
    if(currentPackage!=null && currentPackage.updated_date!=null && currentPackage.no_of_days!=null) {
       currentPackFromDate = DateTime.parse(
          "${currentPackage.updated_date}");
       currentPackToDate = currentPackFromDate.add(
          Duration(days: int.parse(currentPackage.no_of_days)));
       currentPackFromDate = currentPackFromDate.toString().split(" ")[0];
       currentPackToDate = currentPackToDate.toString().split(" ")[0];
    }

    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: space_15, vertical: space_25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PACKAGES",
                              style: CommonStyles.getMontserratStyle(
                                  space_14, FontWeight.w600, CommonStyles.blue),
                            ),
                            RichTextTitleWidget("STATER", "${currentPackage.title}"),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: space_15,
                                right: space_15,
                                bottom: space_15),
                            height: space_200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(space_15),
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/current_package_back.png",
                                    ),
                                    fit: BoxFit.fill)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: space_25, vertical: space_15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "STATER",
                                            style: CommonStyles.getRalewayStyle(
                                                space_15,
                                                FontWeight.w600,
                                                Colors.white),
                                          ),
                                          Text(
                                            "${currentPackage.title}",
                                            style:
                                                CommonStyles.getMontserratStyle(
                                                    space_45,
                                                    FontWeight.w900,
                                                    Colors.white),
                                          ),
                                          Text(
                                            "PACK",
                                            style: CommonStyles.getRalewayStyle(
                                                space_15,
                                                FontWeight.w500,
                                                Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Align(
                                              child: Text(
                                            "\u20B9",
                                            style: CommonStyles.getRalewayStyle(
                                                space_30,
                                                FontWeight.w400,
                                                CommonStyles.primaryColor),
                                          )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "",
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_15,
                                                        FontWeight.w600,
                                                        Colors.white),
                                              ),
                                              Text(
                                                "${currentPackage.price}",
                                                style: CommonStyles
                                                    .getMontserratStyle(
                                                        space_45,
                                                        FontWeight.w900,
                                                        CommonStyles
                                                            .primaryColor),
                                              ),
                                              Text(
                                                "month",
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_15,
                                                        FontWeight.w500,
                                                        CommonStyles
                                                            .primaryColor),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: space_10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          text: new TextSpan(
                                            text: "Valid from",
                                            style: CommonStyles.getRalewayStyle(
                                                space_13,
                                                FontWeight.w500,
                                                CommonStyles.primaryColor),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: '\n${currentPackFromDate}',
                                                  style: CommonStyles
                                                      .getMontserratStyle(
                                                          space_13,
                                                          FontWeight.w800,
                                                          CommonStyles
                                                              .primaryColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: new TextSpan(
                                            text: "Valid till",
                                            style: CommonStyles.getRalewayStyle(
                                                space_13,
                                                FontWeight.w500,
                                                CommonStyles.primaryColor),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: '\n${currentPackToDate}',
                                                  style: CommonStyles
                                                      .getMontserratStyle(
                                                          space_13,
                                                          FontWeight.w800,
                                                          CommonStyles
                                                              .primaryColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: getProportionateScreenHeight(
                                context, space_250),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: space_50,
                                width: space_120,
                                child: Card(
                                  elevation: space_3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(space_5)),
                                  child: ClipRRect(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(space_5)),
                                      child: Center(
                                        child: Text(
                                          "Upgrade",
                                          style: CommonStyles.getRalewayStyle(
                                              space_14,
                                              FontWeight.w400,
                                              CommonStyles.blue),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: space_15, vertical: space_15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichTextTitleWidget("UPGRADE", "AND SAVE MORE"),
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: space_5,
                                    bottom: space_5,
                                    left: space_10),
                                child: Text(
                                  "SHOW MORE",
                                  style: CommonStyles.getRalewayStyle(space_13,
                                      FontWeight.w500, CommonStyles.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                          height: space_220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: packageList.length,
                              itemBuilder: (context, index) {
                                return PackageCardWidget(packageList[index]);
                              })),
                      SizedBox(
                        height: space_15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: space_15, vertical: space_15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichTextTitleWidget("HISTORY", ""),
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: space_5,
                                    bottom: space_5,
                                    left: space_10),
                                child: Text(
                                  "SHOW MORE",
                                  style: CommonStyles.getRalewayStyle(space_13,
                                      FontWeight.w500, CommonStyles.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                          height: space_220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: packageList.length,
                              itemBuilder: (context, index) {
                                return PackageCardWidget(packageList[index]);
                              })),
                      SizedBox(
                        height: space_95,
                      ),
                    ],
                  ),
                )
              ],
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    ));
  }
}
