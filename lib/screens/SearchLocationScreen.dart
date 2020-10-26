import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry/bloc/home/HomeState.dart';
import 'package:flutter_rentry/model/location_search_response.dart';
import 'package:flutter_rentry/model/search_sub_category_response.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/NearbyCommonWidget.dart';

class SearchLocationScreen extends StatefulWidget {
  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  HomeBloc homeBloc = new HomeBloc();
  TextEditingController locationController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var token = "";
  var mCategorySelected = "";
  var mCategorySelectedId = "";
  var mCategorySelectedSubCategoryId = "";
  var mLocationSelected = "";
  var mSelectedLattitude = "0.0";
  var mSelectedLongitude = "0.0";
  var mCurrentSearching = "category";

  @override
  void initState() {
    super.initState();
    locationController.addListener(() {
      debugPrint("Location searicng");
      if (mCurrentSearching == "category") {
        setState(() {
          mCurrentSearching = "location";
        });
      }
      if (mCurrentSearching == "location") {
        homeBloc
          ..add(LocationSeachReqEvent(
              token: token, seachKey: locationController.text));
      }
    });
    categoryController.addListener(() {
      debugPrint("Category searicng");
      if (mCurrentSearching == "location") {
        setState(() {
          mCurrentSearching = "category";
        });
      }
      if (mCurrentSearching == "category") {
        homeBloc
          ..add(SubCategorySearchReqEvent(
              token: token, seachKey: categoryController.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          homeBloc..add(SubCategorySearchReqEvent(token: token, seachKey: "")),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is LocationSearchResState) {
              return setUI(state, state.res);
            } else if (state is SubCategorySearchResState) {
              return setUI(state, state.res);
            } else if (state is ProgressState) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return setProgressUI();
            }
          },
        ),
      ),
    );
  }

  setProgressUI() {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: CommonStyles.primaryColor,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: space_15, vertical: space_10),
                    child: Container(
                      height: space_50,
                      width: getProportionateScreenWidth(context, space_220),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_15),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: space_5),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Center(
                              child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: space_5),
                                  child: TextField(
                                    controller: categoryController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: "Search By Category..."),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: CommonStyles.primaryColor,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: space_15, vertical: space_10),
                    child: Container(
                      height: space_50,
                      width: getProportionateScreenWidth(context, space_220),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_15),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Container(
                                margin:
                                    EdgeInsets.symmetric(horizontal: space_5),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Center(
                              child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: space_5),
                                  child: TextField(
                                    controller: locationController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
//                          contentPadding:
//                          EdgeInsets.only(left: space_15, bottom: space_15, top: space_15, right: space_15),
                                        hintText: "Search By Location..."),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(space_15),
                                      bottomRight: Radius.circular(space_15))),
                              child: Center(
                                  child: Icon(
                                Icons.search,
                                color: CommonStyles.primaryColor,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: space_25, horizontal: space_15),
                      child: FlatButton.icon(
                          onPressed: () {},
                          icon: ImageIcon(
                            AssetImage("assets/images/bottom_nav_nearby.png"),
                            color: CommonStyles.blue,
                          ),
                          label: Text(
                            "Use your current location",
                            style: CommonStyles.getRalewayStyle(
                                space_15, FontWeight.w600, Colors.black),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: space_35),
                      child: Text(
                        mCurrentSearching == "location"
                            ? "LOCATION"
                            : "TOP CATEGORIES",
                        style: CommonStyles.getRalewayStyle(
                            space_14, FontWeight.w500, CommonStyles.blue),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: space_25),
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setUI(HomeState state, dynamic obj, {bool isProgress = false}) {
    if (obj != null) {
      if (obj is SearchLocationResponse || obj is SearchCategoryResponse) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            body: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        color: CommonStyles.primaryColor,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: space_15, vertical: space_10),
                        child: Container(
                          height: space_50,
                          width:
                              getProportionateScreenWidth(context, space_220),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(space_15),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: space_5),
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: space_5),
                                      child: TextField(
                                        controller: categoryController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            focusColor: Colors.white,
                                            border: InputBorder.none,
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: "Search By Category..."),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: CommonStyles.primaryColor,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: space_15, vertical: space_10),
                        child: Container(
                          height: space_50,
                          width:
                              getProportionateScreenWidth(context, space_220),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(space_15),
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: space_5),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: space_5),
                                      child: TextField(
                                        controller: locationController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            focusColor: Colors.white,
                                            border: InputBorder.none,
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
//                          contentPadding:
//                          EdgeInsets.only(left: space_15, bottom: space_15, top: space_15, right: space_15),
                                            hintText: "Search By Location..."),
                                      )),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(space_15),
                                          bottomRight:
                                              Radius.circular(space_15))),
                                  child: Center(
                                      child: Icon(
                                    Icons.search,
                                    color: CommonStyles.primaryColor,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: space_25, horizontal: space_15),
                          child: FlatButton.icon(
                              onPressed: () {},
                              icon: ImageIcon(
                                AssetImage(
                                    "assets/images/bottom_nav_nearby.png"),
                                color: CommonStyles.blue,
                              ),
                              label: Text(
                                "Use your current location",
                                style: CommonStyles.getRalewayStyle(
                                    space_15, FontWeight.w600, Colors.black),
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: space_35),
                          child: Text(
                            mCurrentSearching == "location"
                                ? "LOCATION"
                                : "TOP CATEGORIES",
                            style: CommonStyles.getRalewayStyle(
                                space_14, FontWeight.w500, CommonStyles.blue),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: space_25),
                          child: ListView.builder(
                              itemCount: state is LocationSearchResState
                                  ? state.res.data.length
                                  : (state is SubCategorySearchResState)
                                      ? state.res.data.length
                                      : 0,
                              itemBuilder: (context, pos) {
                                if (state is LocationSearchResState) {
                                  return LocationCityListWidget(
                                      state.res.data[pos],
                                      (String lat, String lng, String name) {
                                    onLocationSelected(lat, lng, name);
                                  });
                                } else if (state is SubCategorySearchResState) {
                                  debugPrint("CATEGDSGDFD ${state.res.data}");
                                  return CategoryListWidget(
                                      state.res.data[pos],
                                      (String categoryId,String subCategoroyId, String name) {
                                    onCategorySelected(categoryId, subCategoroyId, name);
                                  });
                                }
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                isProgress
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        height: space_0,
                        width: space_0,
                      )
              ],
            ),
          ),
        );
      } else {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  onLocationSelected(String lat, String lng, String name) {
    debugPrint("SELECTED_________ ${lat}, ${lng}, ${name}");
    mSelectedLattitude = lat;
    mSelectedLongitude = lng;
  }

  onCategorySelected(String categoryId ,String subCategoryId, String name) {
    debugPrint("SELECTED_________ ${categoryId}, ${subCategoryId}, ${name}");
    mCategorySelected = name;
    mCategorySelectedId = categoryId;
    mCategorySelectedSubCategoryId = subCategoryId;
  }

}
