import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/custom_field_model2.dart';
import 'package:flutter_rentry_new/model/get_rent_type_response.dart';
import 'package:flutter_rentry_new/model/my_ads_edit_res.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/MyPackageListScreen.dart';
import 'package:flutter_rentry_new/screens/postad/AdUnderPackegeListScreen.dart';
import 'package:flutter_rentry_new/screens/postad/LocationForAdScreen.dart';
import 'package:flutter_rentry_new/screens/postad/MyAdsListScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:place_picker/place_picker.dart';

class EditRentalPriceScreen extends StatefulWidget {
  AdPostReqModel adPostReqModel;
  MyAdsEditRes mMyAdsEditRes;

  EditRentalPriceScreen(this.adPostReqModel, this.mMyAdsEditRes);

  @override
  _EditRentalPriceScreenState createState() => _EditRentalPriceScreenState();
}

class _EditRentalPriceScreenState extends State<EditRentalPriceScreen> {
  TextEditingController priceController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController tagController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc = new HomeBloc();
  GetRentTypeResponse mGetRentTypeResponse;
  var loginResponse;
  var token = "";
  var mSelectedDurationType = "";
  var mSelectedDurationTypeId = "";
  var rentDurationTypeStrList;
  var mSelctedLocation = "";
  var priceText = "";
  var titleText = "";
  var descText = "";
  var tagText = "";

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
  void initState() {
    super.initState();
    priceText = widget.mMyAdsEditRes.data.post.price;
    titleText = widget.mMyAdsEditRes.data.post.title;
    descText = widget.mMyAdsEditRes.data.post.description;
    tagText = widget.mMyAdsEditRes.data.post.tags;
    mSelectedDurationTypeId = widget.mMyAdsEditRes.data.post.rent_type_id;
    mSelctedLocation = widget.mMyAdsEditRes.data.post.location;
    widget.adPostReqModel.address = widget.mMyAdsEditRes.data.post.location;
    widget.adPostReqModel.addresslat = widget.mMyAdsEditRes.data.post.lat;
    widget.adPostReqModel.addresslng = widget.mMyAdsEditRes.data.post.lang;
    priceController = new TextEditingController(text: priceText);
    titleController = new TextEditingController(text: titleText);
    descController = new TextEditingController(text: descText);
    tagController = new TextEditingController(text: tagText);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => homeBloc..add(GetRentTypeEvent(token: token)),
        child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is GetRentTypeResState) {
              mGetRentTypeResponse = state.res;
              rentDurationTypeStrList = List<String>();
              mGetRentTypeResponse.data.forEach((element) {
                rentDurationTypeStrList.add(element.rent_type);
              });
            } else if (state is PostEditAdsState) {
              if (state.res != null && state.res.msg != null) {
//                showSnakbar(_scaffoldKey, state.res.msg);
                Fluttertoast.showToast(
                    msg: state.res.msg,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: space_14);
                if (state.res.status != null &&
                    (state.res.status == "success" ||
                        state.res.status == "true")) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyAdsListScreen()),
                  );
                }
              }
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is GetRentTypeResState) {
              return getScreenUI(state);
            } else if (state is PostEditAdsState) {
              return getScreenUI(state);
            } else {
              return ProgressNormalAppBarWidget("Rental");
            }
          }),
        ));
  }

  Widget getScreenUI(HomeState state) {
    if (state is GetRentTypeResState) {
      mGetRentTypeResponse = state.res;
    }
    if (widget.mMyAdsEditRes != null) {
      mGetRentTypeResponse.data.forEach((element) {
        if (mSelectedDurationTypeId == element.ads_rent_type_id) {
          mSelectedDurationType = element.rent_type;
        }
        print("RENTTYPE_VAL ${mSelectedDurationType}");
      });
    }
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
                  PostAdsCommonAppbar(title: "Rental"),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: space_20),
                            child: Text(
                              "PRODUCT INFO",
                              style: CommonStyles.getMontserratStyle(
                                  space_14, FontWeight.w700, Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: space_10,
                          ),
                          TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "";
                              }
                            },
                            obscureText: false,
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Enter title",
                              labelText: "Enter title",
                              fillColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            height: space_15,
                          ),
                          TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "";
                              }
                            },
                            minLines: 3,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            obscureText: false,
                            controller: descController,
                            decoration: InputDecoration(
                              hintText: "Enter description",
                              labelText: "Enter description",
                              fillColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            height: space_15,
                          ),
                          TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "";
                              }
                            },
                            obscureText: false,
                            controller: tagController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "eg. best car, grocery item in LA",
                              labelText: "Enter tags (optional)",
                              fillColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            height: space_15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: space_20),
                            child: Text(
                              "PRICE",
                              style: CommonStyles.getMontserratStyle(
                                  space_14, FontWeight.w700, Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: space_10,
                          ),
                          Container(
                            height:
                                getProportionateScreenHeight(context, space_40),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "";
                                      }
                                    },
                                    obscureText: false,
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "₹ Enter price",
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: space_20,
                          ),
                          Container(
                            height: space_100,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Rental Duration",
                                        style: CommonStyles.getRalewayStyle(
                                            space_14,
                                            FontWeight.w500,
                                            CommonStyles.grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                          child: DropdownButton(
                                        hint: mSelectedDurationType == null ||
                                                mSelectedDurationType.isEmpty
                                            ? Text(
                                                'Select type',
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_12,
                                                        FontWeight.w500,
                                                        Colors.black),
                                              )
                                            : Text(
                                                mSelectedDurationType,
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_12,
                                                        FontWeight.w500,
                                                        Colors.black),
                                              ),
                                        isExpanded: true,
                                        iconSize: 30.0,
                                        style: TextStyle(color: Colors.blue),
                                        items: mGetRentTypeResponse.data.map(
                                          (val) {
                                            return DropdownMenuItem<
                                                RentTypeData>(
                                              value: val,
                                              child: Text(val.rent_type),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              if (value is RentTypeData) {
                                                mSelectedDurationType =
                                                    value.rent_type;
                                                mSelectedDurationTypeId =
                                                    value.ads_rent_type_id;
                                                debugPrint(
                                                    "SELECTED_VALUE ${value}-->> ${mSelectedDurationType}");
                                              }
                                            },
                                          );
                                        },
                                      )),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: space_1,
                                  thickness: space_1,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: space_0),
                            child: Text(
                              "SELECT LOCATION",
                              style: CommonStyles.getMontserratStyle(
                                  space_14, FontWeight.w700, Colors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showPlacePicker();
                            },
                            child: Container(
                              height: space_50,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: space_15),
                              padding:
                                  EdgeInsets.symmetric(horizontal: space_15),
                              decoration: BoxDecoration(
                                  color: CommonStyles.primaryColor
                                      .withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.circular(space_15)),
                              child: Center(
                                child: Text(
                                  mSelctedLocation.isNotEmpty
                                      ? mSelctedLocation
                                      : "Select Location",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: CommonStyles.getRalewayStyle(
                                      space_15, FontWeight.w500, Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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

  void onSubmit() {
    if (titleController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_title);
    } else if (descController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_desc);
    } else if (descController.text.trim().length < 20) {
      showSnakbar(_scaffoldKey, short_desc);
    } else if (priceController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_price);
    } else if (mSelectedDurationTypeId.isEmpty) {
      showSnakbar(_scaffoldKey, empty_rental_type);
    } else if (mSelctedLocation.isEmpty) {
      showSnakbar(_scaffoldKey, empty_location);
    } else {
      widget.adPostReqModel.title = titleController.text.trim();
      widget.adPostReqModel.desc = descController.text.trim();
      widget.adPostReqModel.tags = tagController.text.trim();
      widget.adPostReqModel.rentTypeId = mSelectedDurationTypeId;
      widget.adPostReqModel.price = priceController.text.trim();
      //API hit
      homeBloc
        ..add(PostEditAdsEvent(
            token: token, adPostReqModel: widget.adPostReqModel));
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
    }
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker(GOOGLE_API_KEY)));
    // Handle the result in your way
    print("LOCATION_SEELCTED ${result.latLng.latitude}");
    widget.adPostReqModel.address =
        "${result.name}, ${result.locality}, ${result.city}, ${result.postalCode}";
    final coordinates =
        new Coordinates(result.latLng.latitude, result.latLng.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    widget.adPostReqModel.address =
        "${first.addressLine}, ${first.locality}, ${first.adminArea}, ${first.countryName}";
    widget.adPostReqModel.addresslat = result.latLng.latitude.toString();
    widget.adPostReqModel.addresslng = result.latLng.longitude.toString();
    setState(() {
      mSelctedLocation = result.name;
    });
  }
}
