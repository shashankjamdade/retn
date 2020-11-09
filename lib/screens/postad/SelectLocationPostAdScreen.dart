import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/NearbyCommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLocationPostAdScreen extends StatefulWidget {
  @override
  _SelectLocationPostAdScreenState createState() =>
      _SelectLocationPostAdScreenState();
}

class _SelectLocationPostAdScreenState
    extends State<SelectLocationPostAdScreen> {
  TextEditingController locationController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc = new HomeBloc();
  String mSelectedLocationName = "";
  String mSelectedLocationLat = "";
  String mSelectedLocationLng = "";
  var mLocationSelected = "";
  var mSelectedLattitude = "0.0";
  var mSelectedLongitude = "0.0";
  var mCurrentSearching = "category";
  var token = "";
  UserLocationSelected userLocationSelected;
  SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    initializePrefs();
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          homeBloc..add(LocationSeachReqEvent(token: token, seachKey: "")),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is LocationSearchResState) {
            return setToUI(state, state.res);
          }  else if (state is ProgressState) {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return setToProgressUI();
          }
        }),
      ),
    );
  }

  setToUI(HomeState state, dynamic obj, {bool isProgress = false}) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostAdsCommonAppbar(title: "Location"),
                  SizedBox(
                    height: space_25,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: space_15, vertical: space_10),
                    child: Container(
                      height: space_50,
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      width: getProportionateScreenWidth(context, space_220),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(space_15),
                          color: CommonStyles.primaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
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
                          ),
                          Expanded(
                            flex: 6,
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
                              child: (locationController.text != null &&
                                      locationController.text.isNotEmpty)
                                  ? InkWell(
                                      onTap: () {
                                        locationController.text = "";
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight:
                                                    Radius.circular(space_15),
                                                bottomRight:
                                                    Radius.circular(space_15))),
                                        child: Center(
                                            child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        )),
                                      ),
                                    )
                                  : Container(
                                      width: space_0,
                                      height: space_0,
                                    )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: space_15, horizontal: space_15),
                    child: FlatButton.icon(
                        onPressed: () {
                          onCurrentLocationSelect(context);
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/bottom_nav_nearby.png"),
                          color: CommonStyles.blue,
                        ),
                        label: Text(
                          "Use your current location",
                          style: CommonStyles.getRalewayStyle(
                              space_14, FontWeight.w800, Colors.black),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_35, right: space_35, bottom: space_15),
                    child: Text(
                      "TOP LOCATIONS",
                      style: CommonStyles.getRalewayStyle(
                          space_14, FontWeight.w500, CommonStyles.blue),
                    ),
                  ),
                  Expanded(
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
                            }
                          }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onSubmit();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: space_15,
                          right: space_15,
                          bottom: space_35,
                          top: space_15),
                      height: space_50,
                      decoration: BoxDecoration(
                        color: CommonStyles.blue,
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(space_15),
                            child: Text(
                              "Next",
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500, Colors.white),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  setToProgressUI() {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostAdsCommonAppbar(title: "Location"),
                  SizedBox(
                    height: space_25,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: space_15, vertical: space_10),
                    child: Container(
                      height: space_50,
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      width: getProportionateScreenWidth(context, space_220),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(space_15),
                          color: CommonStyles.primaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
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
                          ),
                          Expanded(
                            flex: 6,
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
                              child: (locationController.text != null &&
                                      locationController.text.isNotEmpty)
                                  ? InkWell(
                                      onTap: () {
                                        locationController.text = "";
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight:
                                                    Radius.circular(space_15),
                                                bottomRight:
                                                    Radius.circular(space_15))),
                                        child: Center(
                                            child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        )),
                                      ),
                                    )
                                  : Container(
                                      width: space_0,
                                      height: space_0,
                                    )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: space_15, horizontal: space_15),
                    child: FlatButton.icon(
                        onPressed: () {},
                        icon: ImageIcon(
                          AssetImage("assets/images/bottom_nav_nearby.png"),
                          color: CommonStyles.blue,
                        ),
                        label: Text(
                          "Use your current location",
                          style: CommonStyles.getRalewayStyle(
                              space_14, FontWeight.w800, Colors.black),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_35, right: space_35, bottom: space_15),
                    child: Text(
                      "TOP LOCATIONS",
                      style: CommonStyles.getRalewayStyle(
                          space_14, FontWeight.w500, CommonStyles.blue),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onSubmit();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: space_15,
                          right: space_15,
                          bottom: space_35,
                          top: space_15),
                      height: space_50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_5),
                        color: CommonStyles.green,
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(space_15),
                            child: Text(
                              "Update Password",
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500, Colors.white),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void onSubmit() {
    if (locationController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_password);
    } else {
      //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
    }
  }

  onCurrentLocationSelect(BuildContext context) {
    debugPrint("@@@@@@@@@@@@##");
    var city = prefs.getString(USER_LOCATION_CITY);
    var state = prefs.getString(USER_LOCATION_STATE);
    var lat = prefs.getString(USER_LOCATION_LAT);
    var lng = prefs.getString(USER_LOCATION_LONG);
    debugPrint("CURRENT_CITY ----  ${city}, ${state}");
    UserLocationSelected userLocationSelected = new UserLocationSelected(city: "${city}, ${state}", mlat: lat, mlng: lng);
    Navigator.pop(context, userLocationSelected);
  }

  initializePrefs() async{
     prefs = await SharedPreferences.getInstance();
  }


  onLocationSelected(String lat, String lng, String name) {
    debugPrint("SELECTED_________ ${lat}, ${lng}, ${name}");
    mSelectedLattitude = lat;
    mSelectedLongitude = lng;
    locationController.text = name;
    setState(() {
      mSelectedLattitude = lat;
      mSelectedLongitude = lng;
      mLocationSelected = name;
    });
    UserLocationSelected userLocationSelected = new UserLocationSelected(city: name, mlat: lat, mlng: lng);
    Navigator.pop(context, userLocationSelected);
  }
}
