import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/UserLocNameSelected.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/model/google_places_res.dart';
import 'package:flutter_rentry_new/model/location_search_response.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/screens/NearByChildSubCategoryScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/NearbyCommonWidget.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/src/places.dart';

class SearchLocationScreen extends StatefulWidget {
  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  HomeBloc homeBloc = new HomeBloc();
  TextEditingController locationController;
  TextEditingController categoryController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var token = "";
  var mCategorySelected = "";
  var mCategorySelectedId = "";
  var mCategorySelectedSubCategoryId = "";
  var mLocationSelected = "";
  var mSelectedLattitude = "0.0";
  var mSelectedLongitude = "0.0";
  var mCurrentSearching = "category";
  UserLocationSelected userLocationSelected;

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController(text: mLocationSelected);
    categoryController = TextEditingController(text: mCategorySelected);
    locationController.addListener(() {
      debugPrint("Location searicng");
      if (mCurrentSearching == "category") {
        setState(() {
          mCurrentSearching = "location";
        });
      }
      if (mCurrentSearching == "location") {
        homeBloc
          ..add(GooglePlaceEvent(token: token, query: locationController.text));
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userLocationSelected = StateContainer.of(context).mUserLocationSelected;
    var loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
    if (userLocationSelected != null) {
      mLocationSelected = userLocationSelected.city;
      mSelectedLattitude = userLocationSelected.mlat;
      mSelectedLongitude = userLocationSelected.mlng;
      locationController.text = mLocationSelected;
      debugPrint("ACCESSING_INHERITED ${mLocationSelected}");
    }
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
            } else if (state is GooglePlaceState) {
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
                          onPressed: () {
                          },
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
                      padding: EdgeInsets.only(
                          left: space_35, right: space_35, bottom: space_15),
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
    if (state is GooglePlaceState) {
      debugPrint("PLACES--> ${state.res.predictions.length}");
    }
    if (obj != null) {
      if (obj is SearchLocationResponse ||
          obj is SearchCategoryResponse ||
          obj is GooglePlacesRes) {
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
                              Expanded(
                                flex: 2,
                                child: (categoryController.text != null &&
                                        categoryController.text.isNotEmpty)
                                    ? InkWell(
                                        onTap: () {
                                          categoryController.text = "";
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(space_15),
                                                  bottomRight: Radius.circular(
                                                      space_15))),
                                          child: Center(
                                              child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                        ),
                                      )
                                    : Container(
                                        height: space_0,
                                        width: space_0,
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
                                                  bottomRight: Radius.circular(
                                                      space_15))),
                                          child: Center(
                                              child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                        ),
                                      )
                                    : Container(
                                        height: space_0,
                                        width: space_0,
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
                              onPressed: () {
                                debugPrint("Locl --> ${StateContainer.of(context).mUserLocationSelected?.city}");
                                setState(() {
                                  mSelectedLattitude = StateContainer.of(context).mUserLocationSelected?.mlat;
                                  mSelectedLongitude = StateContainer.of(context).mUserLocationSelected?.mlng;
                                  mLocationSelected = StateContainer.of(context).mUserLocationSelected?.city;
                                });
                              },
                              icon: ImageIcon(
                                AssetImage(
                                    "assets/images/bottom_nav_nearby.png"),
                                color: CommonStyles.blue,
                              ),
                              label: Text(
                                "Use your current locationss",
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
                                      : (state is GooglePlaceState)
                                          ? state.res.predictions.length
                                          : 0,
                              itemBuilder: (context, pos) {
                                if (state is LocationSearchResState) {
                                  return LocationCityListWidget(
                                      state.res.data[pos],
                                      (String lat, String lng, String name) {
                                    onLocationSelected(lat, lng, name);
                                  });
                                } else if (state is GooglePlaceState &&
                                    state.res is GooglePlacesRes) {
                                  if (state.res.predictions.length > 0)
                                   /* return InkWell(
                                      onTap: () {
                                        if (state.res.predictions[pos] !=
                                            null) {
                                          debugPrint(
                                              "MY_PLACE_SELECT-->> ${state.res.predictions[pos]?.place_id}");
                                          onLocationSelectedFromGoogle(
                                              state.res.predictions[pos]);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: space_10,
                                            horizontal: space_15),
                                        child: Text(
                                          "${state.res.predictions[pos]?.description}",
//          locationData!=null && locationData.structured_formatting!=null && locationData.structured_formatting.mainText!=null ?locationData.structured_formatting.mainText:"1",
                                          style: CommonStyles.getRalewayStyle(
                                              space_14,
                                              FontWeight.w500,
                                              Colors.black87),
                                        ),
                                      ),
                                    );*/
                                  return GooglePlaceListWidget(
                                      state.res.predictions[pos],
                                      (Predictions prediction) {
                                        onLocationSelectedFromGoogle(prediction);
                                  });
                                } else if (state is SubCategorySearchResState) {
                                  debugPrint("CATEGDSGDFD ${state.res.data}");
                                  return CategoryListWidget(state.res.data[pos],
                                      (String categoryId,
                                          String subCategoroyId,
                                          String categoryName,
                                          String subCategoryName) {
                                    onCategorySelected(
                                        categoryId,
                                        subCategoroyId,
                                        categoryName,
                                        subCategoryName);
                                  });
                                } else {
                                  return Container(
                                    height: 0,
                                    width: 0,
                                  );
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
    locationController.text = name;
    setState(() {
      mSelectedLattitude = lat;
      mSelectedLongitude = lng;
      mLocationSelected = name;
    });
  }

  onLocationSelectedFromGoogle(Predictions prediction) {
    debugPrint("PLACE_ID--> ${prediction.place_id}");
    displayPrediction(prediction);
  }

  onCategorySelected(String categoryId, String subCategoryId,
      String categoryName, String subCategoryName) {
    debugPrint(
        "SELECTED_________ ${categoryId}, ${subCategoryId}, ${categoryName}");
    mCategorySelected = categoryName;
    mCategorySelectedId = categoryId;
    mCategorySelectedSubCategoryId = subCategoryId;
    categoryController.text = categoryName;
    setState(() {
      mCategorySelected =
          subCategoryName != null ? subCategoryName : categoryName;
    });
    if (mSelectedLattitude.isNotEmpty &&
        mSelectedLongitude.isNotEmpty &&
        (categoryId != null || subCategoryId != null)) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NearByChildSubCategoryScreen(
                  categoryId: categoryId,
                  subCategoryId: subCategoryId != null ? subCategoryId : "",
                  radius: LOCATION_RADIUS,
                  lat: mSelectedLattitude != null ? mSelectedLattitude : "",
                  lng: mSelectedLongitude != null ? mSelectedLongitude : "",
                  categoryName: categoryName != null ? categoryName : "",
                  subCategoryName:
                      subCategoryName != null ? subCategoryName : "",
                  isFromNearBy: false,
                )),
      );
    }
  }

//  Future<void> _handlePressButton() async {
//    Prediction p = await PlacesAutocomplete.show(
//        context: context,
//        apiKey: GOOGLE_API_KEY,
//        mode: Mode.overlay, // Mode.fullscreen
//        language: "en");
//
//    debugPrint("LOCATION_SELECT ${p?.structuredFormatting.mainText}");
//    displayPrediction(p);
//  }

  Future<Null> displayPrediction(Predictions p) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);

      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.place_id);

      var placeId = p.place_id;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      mSelectedLattitude = lat.toString();
      mSelectedLongitude = lng.toString();
      locationController.text = p?.structured_formatting?.main_text;
      setState(() {
        mSelectedLattitude = lat.toString();
        mSelectedLongitude = lng.toString();
        mLocationSelected = p?.structured_formatting?.main_text;
      });
      var mUserLocNameSelected = new UserLocNameSelected(address: p?.structured_formatting?.main_text, mlat: lat.toString(), mlng: lng.toString());
      StateContainer.of(context).updateUserSelectedLocation(mUserLocNameSelected);
      print("SELECTED--> ${lat}, ${lng}");
    }
  }
}
