import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/filter_res.dart';
import 'package:flutter_rentry_new/model/nearby_item_list_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/CustomWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
import 'dart:ui' as ui;

class NearByChildSubCategoryScreen extends StatefulWidget {
  String categoryId,
      subCategoryId,
      radius,
      lat,
      lng,
      categoryName,
      subCategoryName;

  bool isFromNearBy;

  NearByChildSubCategoryScreen(
      {this.categoryId = "",
      this.subCategoryId = "",
      this.radius = LOCATION_RADIUS,
      this.lat = "",
      this.lng = "",
      this.isFromNearBy = true,
      this.categoryName = "",
      this.subCategoryName = ""});

  @override
  _NearByChildSubCategoryScreenState createState() =>
      _NearByChildSubCategoryScreenState();
}

class _NearByChildSubCategoryScreenState
    extends State<NearByChildSubCategoryScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  var loginResponse;
  var token = "";
  var mLat = "";
  var mLng = "";
  bool isFilter = true;
  bool checkedValue = false;
  double _currentSliderValue = 0;
  ui.Image sampleIcon;
  String highestEducation = "Low to High";
  List<String> sortingList = List();
  List<String> ratingList = List();
  String mType, mSelectedValue;
  NearbySubChildCategoryListResponse mNearbySubChildCategoryListResponse;
  FilterRes mFilterRes;
  String filter_subcategory_id = "";
  String filter_custome_filed_id = "";
  String filter_min = "";
  String filter_max = "";
  String priceSort = "";
  String ratingSort = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_ITEM_LIST_SCREEN_MAIN-----${widget.categoryName}---");
    getUiImage("assets/images/slider_thumb.png", 30, 30)
        .then((value) => sampleIcon = value);
    //Edu
    sortingList.add("Low to High");
    sortingList.add("High to Low");
    //Edu
    ratingList.add("Low to High");
    ratingList.add("High to Low");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
    var selectedCurrentLoc = StateContainer.of(context).mUserLocationSelected;
    var selectedLoc = StateContainer.of(context).mUserLocNameSelected;
    if (widget.lat != null &&
        widget.lng != null &&
        widget.lat.isNotEmpty &&
        widget.lng.isNotEmpty) {
      mLat = widget.lat;
      mLng = widget.lng;
      debugPrint("ACCESSING_SELECTED_LOCATION ${mLat}, ${mLng} ------");
    } else if (selectedLoc != null) {
      mLat = selectedLoc.mlat;
      mLng = selectedLoc.mlng;
      debugPrint("ACCESSING_INHERITED_LOCATION ${mLat}, ${mLng} ------");
    } else if (selectedCurrentLoc != null ||
        widget.isFromNearBy ||
        (widget.lat.isEmpty && widget.lng.isEmpty)) {
      mLat = selectedCurrentLoc.mlat;
      mLng = selectedCurrentLoc.mlng;
      debugPrint("ACCESSING_INHERITED_LOCATION ${mLat}, ${mLng} ------");
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD_METHOD_CALLED ${filter_subcategory_id}");
    return BlocProvider(
      create: (context) => homeBloc
        ..add(NearbySubChildCategoryListReqEvent(
            token: token,
            categoryId: widget.categoryId,
            subcategory_id: widget.subCategoryId,
            radius: widget.radius,
            lat: mLat,
            lng: mLng,
            filter_subcategory_id: filter_subcategory_id,
            filter_custome_filed_id: filter_custome_filed_id,
            filter_min: filter_min,
            filter_max: filter_max,
            sort_by_price: priceSort!=null && priceSort.isNotEmpty? priceSort:"")),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is NearbySubChildCategoryListResState) {
              return setDataToUI(state.res);
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

  Widget setDataToUI(NearbySubChildCategoryListResponse res) {
    mNearbySubChildCategoryListResponse = res;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                child: Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Container(
                  margin: EdgeInsets.only(
                      left: space_15,
                      top: getProportionateScreenHeight(context, space_15)),
                  child: Row(
                    children: [
                      widget.isFromNearBy
                          ? Text(
                              "BROWSE BY NEARME",
                              style: CommonStyles.getRalewayStyle(
                                  space_15, FontWeight.w800, Colors.black),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  left: space_15,
                                  top: getProportionateScreenHeight(
                                      context, space_15)),
                              child: widget.subCategoryName != null &&
                                      widget.subCategoryName.isNotEmpty
                                  ? Row(
                                      children: [
                                        Text(
                                          widget.categoryName,
                                          style: CommonStyles.getRalewayStyle(
                                              space_15,
                                              FontWeight.w800,
                                              CommonStyles.red),
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
                                          widget.subCategoryName,
                                          style: CommonStyles.getRalewayStyle(
                                              space_15,
                                              FontWeight.w800,
                                              CommonStyles.blue),
                                        ),
//                                        Container(
//                                            height: space_15,
//                                            child: VerticalDivider(
//                                              thickness: space_2,
//                                              color: CommonStyles.grey,
//                                              indent: space_3,
//                                            )),
//                                        RichTextTitleWidget(
//                                            "SUB", "CATEGORIES"),
                                      ],
                                    )
                                  : Text(
                                      widget.categoryName,
                                      style: CommonStyles.getRalewayStyle(
                                          space_15,
                                          FontWeight.w800,
                                          CommonStyles.red),
                                    ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: space_15,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: getWidthToHeightRatio(context),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          itemCount: res.data.ad_list.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: space_280,
                              width: space_230,
                              child: ItemCardNoMarginWidget(
                                  category_adslist: res.data.ad_list[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: space_110,
                      )
                    ],
                  ),
                ),
              ],
            )),
            CommonBottomNavBarWidget(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  child: BottomFloatingFilterBtnsWidget(
                      res.data.filter, openFilterSheet)),
            )
          ],
        ),
      ),
    );
  }

  void openFilterSheet() {
    if (mFilterRes != null) {
      List<Subcategory> subcategory = List();
      List<Customefield> customefield = List();
      mNearbySubChildCategoryListResponse.data.filter?.subcategory
          ?.forEach((element) {
        if (filter_subcategory_id?.contains(element?.sub_id)) {
          element?.isChecked = true;
        }
        subcategory?.add(element);
      });
      mNearbySubChildCategoryListResponse.data.filter?.customefield
          ?.forEach((parentelement) {
        List<FieldOptions> field_options = List();
        parentelement?.field_options?.forEach((element) {
          if (filter_custome_filed_id?.contains(element?.id)) {
            element?.isChecked = true;
          }
          field_options?.add(element);
        });
        parentelement.field_options = field_options;
        customefield?.add(parentelement);
      });
      mNearbySubChildCategoryListResponse.data.filter?.subcategory =
          subcategory;
      mNearbySubChildCategoryListResponse.data.filter?.customefield =
          customefield;
      mNearbySubChildCategoryListResponse.data.filter?.budget?.min =
          mFilterRes?.budget?.min;
      mNearbySubChildCategoryListResponse.data.filter?.budget?.max =
          mFilterRes?.budget?.max;
      mFilterRes = mNearbySubChildCategoryListResponse.data.filter;
      showModalBottomsheet(mFilterRes);
    } else {
      mFilterRes = mNearbySubChildCategoryListResponse.data.filter;
      showModalBottomsheet(mFilterRes);
    }
  }

  void recallApiWithFilter(FilterRes filterRes) {
//    setState(() {
//      mFilterRes = filterRes;
//    });
    homeBloc
      ..add(NearbySubChildCategoryListReqEvent(
          token: token,
          categoryId: widget.categoryId,
          subcategory_id: widget.subCategoryId,
          radius: widget.radius,
          lat: mLat,
          lng: mLng,
          filter_subcategory_id: filter_subcategory_id,
          filter_custome_filed_id: filter_custome_filed_id,
          filter_min: filter_min,
          filter_max: filter_max,
          sort_by_price: priceSort!=null && priceSort.isNotEmpty? priceSort:""));
  }

  void showModalBottomsheet(FilterRes filterRes) {
    StateSetter dialogSetState;
    if(_currentSliderValue == 0){
      _currentSliderValue = filterRes.budget != null &&
          filterRes.budget.min != null &&
          filterRes.budget.min?.isNotEmpty
          ? double.parse(filterRes.budget.min)
          : 0;
    }
    var diff = filterRes.budget != null &&
            filterRes.budget.max != null &&
            filterRes.budget.max?.isNotEmpty
        ? (int.parse(filterRes.budget.max) - int.parse(filterRes.budget.min))
        : 1;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                dialogSetState = setState;
                return SafeArea(
                  child: Scaffold(
                    body: Stack(
                      children: [
                        Column(
                          children: [
                            CommonAppbarWidget(app_name, skip_for_now, () {
                              onSearchLocation(context);
                            }),
                            Container(
                              margin: EdgeInsets.only(top: space_15),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        margin: EdgeInsets.only(left: space_15),
                                        decoration: BoxDecoration(
                                            gradient: isFilter
                                                ? filterTabSelectedGradient()
                                                : filterTabUnSelectedGradient()),
                                        height: space_50,
                                        child: Center(
                                          child: FlatButton.icon(
                                              onPressed: () {
                                                dialogSetState(() {
                                                  isFilter = !isFilter;
                                                });
                                              },
                                              icon: ImageIcon(
                                                AssetImage(
                                                  "assets/images/filter_icon_amber.png",
                                                ),
                                                color: isFilter
                                                    ? Colors.white
                                                    : CommonStyles.darkAmber,
                                              ),
                                              label: Text(
                                                "Filter",
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_14,
                                                        FontWeight.w600,
                                                        isFilter
                                                            ? Colors.white
                                                            : CommonStyles
                                                                .darkAmber),
                                              )),
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        margin:
                                            EdgeInsets.only(right: space_15),
                                        decoration: BoxDecoration(
                                            gradient: isFilter
                                                ? filterTabUnSelectedGradient()
                                                : filterTabSelectedGradient()),
                                        height: space_50,
                                        child: Center(
                                          child: FlatButton.icon(
                                              onPressed: () {
                                                dialogSetState(() {
                                                  isFilter = !isFilter;
                                                });
                                              },
                                              icon: ImageIcon(
                                                AssetImage(
                                                  "assets/images/sortby_icon_amber.png",
                                                ),
                                                color: isFilter
                                                    ? CommonStyles.darkAmber
                                                    : Colors.white,
                                              ),
                                              label: Text(
                                                "Sort By",
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_14,
                                                        FontWeight.w600,
                                                        isFilter
                                                            ? CommonStyles
                                                                .darkAmber
                                                            : Colors.white),
                                              )),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(top: space_30),
                                child: Container(
                                  color: Colors.white,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Container(
                                          child: isFilter
                                              ? Container(
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    children: [
                                                      filterRes
                                                          .subcategory!=null && filterRes
                                                          .subcategory.length>0?Container(
                                                        margin: EdgeInsets.only(
                                                            left: space_15,
                                                            right: space_15),
                                                        child: Text(
                                                          "SubCategories",
                                                          style: CommonStyles
                                                              .getRalewayStyle(
                                                                  space_15,
                                                                  FontWeight
                                                                      .w800,
                                                                  Colors.black),
                                                        ),
                                                      ):Container(width: 0, height: 0,),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: space_15,
                                                            right: space_15),
                                                        child: ListView.builder(
                                                            itemCount: filterRes
                                                                .subcategory
                                                                .length,
                                                            shrinkWrap: true,
                                                            primary: false,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Container(
                                                                height:
                                                                    space_50,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "${filterRes.subcategory[index].sub_name}",
                                                                      style: CommonStyles.getRalewayStyle(
                                                                          space_14,
                                                                          FontWeight
                                                                              .w500,
                                                                          Colors
                                                                              .black),
                                                                    ),
                                                                    Checkbox(
                                                                      value: filterRes
                                                                          .subcategory[
                                                                              index]
                                                                          .isChecked,
                                                                      onChanged:
                                                                          (bool
                                                                              value) {
                                                                        dialogSetState(
                                                                            () {
                                                                          filterRes
                                                                              .subcategory[index]
                                                                              .isChecked = value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: space_15,
                                                            right: space_15),
                                                        child: ListView.builder(
                                                            itemCount: filterRes
                                                                            .customefield !=
                                                                        null &&
                                                                    filterRes
                                                                            .customefield
                                                                            ?.length >
                                                                        0
                                                                ? filterRes
                                                                    .customefield
                                                                    .length
                                                                : 0,
                                                            shrinkWrap: true,
                                                            primary: false,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemBuilder: (context,
                                                                parentIndex) {
                                                              return Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      "${filterRes.customefield != null && filterRes.customefield.length > 0 && filterRes.customefield[parentIndex].field_options != null && filterRes.customefield[parentIndex].field_options.length > 0 ? filterRes.customefield[parentIndex].name : ""}",
                                                                      style: CommonStyles.getRalewayStyle(
                                                                          space_15,
                                                                          FontWeight
                                                                              .w800,
                                                                          Colors
                                                                              .black),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            space_15,
                                                                        right:
                                                                            space_15),
                                                                    child: ListView.builder(
                                                                        itemCount: filterRes.customefield != null && filterRes.customefield?.length > 0 ? filterRes.customefield[parentIndex].field_options.length : 0,
                                                                        shrinkWrap: true,
                                                                        primary: false,
                                                                        scrollDirection: Axis.vertical,
                                                                        itemBuilder: (context, index) {
                                                                          return Container(
                                                                            height:
                                                                                space_50,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "${filterRes.customefield != null && filterRes.customefield.length > 0 && filterRes.customefield[parentIndex].field_options != null && filterRes.customefield[parentIndex].field_options.length > 0 ? filterRes.customefield[parentIndex].field_options[index].name : ""}",
                                                                                  style: CommonStyles.getMontserratStyle(space_14, FontWeight.w500, Colors.black),
                                                                                ),
                                                                                Checkbox(
                                                                                  value: filterRes.customefield[parentIndex].field_options[index].isChecked,
                                                                                  onChanged: (bool value) {
                                                                                    dialogSetState(() {
                                                                                      filterRes.customefield[parentIndex].field_options[index].isChecked = value;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: space_15,
                                                                right: space_15,
                                                                top: space_25),
                                                        child: Text(
                                                          "PRICE",
                                                          style: CommonStyles
                                                              .getRalewayStyle(
                                                                  space_15,
                                                                  FontWeight
                                                                      .w800,
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: space_15,
                                                                right: space_15,
                                                                top: space_15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "₹ ${filterRes.budget != null ? "${_currentSliderValue.toStringAsFixed(1)}" : "-"}",
                                                              style: CommonStyles
                                                                  .getMontserratStyle(
                                                                      space_12,
                                                                      FontWeight
                                                                          .w500,
                                                                      Colors
                                                                          .black),
                                                            ),
                                                            Text(
                                                              "₹ ${filterRes.budget != null ? filterRes.budget.max : "-"}",
                                                              style: CommonStyles
                                                                  .getMontserratStyle(
                                                                      space_12,
                                                                      FontWeight
                                                                          .w500,
                                                                      Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: SliderTheme(
                                                          data: SliderTheme.of(
                                                                  context)
                                                              .copyWith(
                                                            activeTrackColor:
                                                                CommonStyles
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.8),
                                                            inactiveTrackColor:
                                                                CommonStyles
                                                                    .blue,
                                                            trackShape:
                                                                RectangularSliderTrackShape(),
                                                            showValueIndicator:
                                                                ShowValueIndicator
                                                                    .always,
                                                            valueIndicatorColor:
                                                                CommonStyles
                                                                    .blue,
                                                            trackHeight: 8.0,
                                                            thumbColor:
                                                                CommonStyles
                                                                    .primaryColor,
//          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                                            thumbShape:
                                                                SliderThumbImage(
                                                                    sampleIcon),
                                                            overlayColor:
                                                                CommonStyles
                                                                    .primaryColor
                                                                    .withAlpha(
                                                                        32),
                                                            overlayShape:
                                                                RoundSliderOverlayShape(
                                                                    overlayRadius:
                                                                        28.0),
                                                          ),
                                                          child: Slider(
                                                            value:
                                                                _currentSliderValue,
                                                            min: double.parse(filterRes.budget != null &&
                                                                    filterRes
                                                                            .budget
                                                                            .min !=
                                                                        null &&
                                                                    filterRes
                                                                        .budget
                                                                        .min
                                                                        ?.isNotEmpty
                                                                ? filterRes
                                                                    .budget.min
                                                                : "0"),
                                                            max: double.parse(filterRes.budget != null &&
                                                                    filterRes
                                                                            .budget
                                                                            .max !=
                                                                        null &&
                                                                    filterRes
                                                                        .budget
                                                                        .max
                                                                        ?.isNotEmpty
                                                                ? filterRes
                                                                    .budget.max
                                                                : "2"),
                                                            divisions: diff,
                                                            label:
                                                                _currentSliderValue
                                                                    .round()
                                                                    .toString(),
                                                            onChanged:
                                                                (double value) {
                                                              dialogSetState(
                                                                  () {
                                                                _currentSliderValue =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: space_15,
                                                                right:
                                                                    space_15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Min.",
                                                                    style: CommonStyles.getRalewayStyle(
                                                                        space_10,
                                                                        FontWeight
                                                                            .w600,
                                                                        CommonStyles
                                                                            .blue),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                space_5),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            space_10,
                                                                        vertical:
                                                                            space_5),
                                                                    decoration: BoxDecoration(
                                                                        color: CommonStyles
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.3),
                                                                        borderRadius:
                                                                            BorderRadius.circular(space_3)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "₹ ${filterRes.budget != null ? filterRes.budget.min : "-"}",
                                                                        style: CommonStyles.getRalewayStyle(
                                                                            space_12,
                                                                            FontWeight.w500,
                                                                            Colors.black),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            space_5),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            space_10,
                                                                        vertical:
                                                                            space_5),
                                                                    decoration: BoxDecoration(
                                                                        color: CommonStyles
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.3),
                                                                        borderRadius:
                                                                            BorderRadius.circular(space_3)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "₹ ${filterRes.budget != null ? filterRes.budget.max : "-"}",
                                                                        style: CommonStyles.getRalewayStyle(
                                                                            space_12,
                                                                            FontWeight.w500,
                                                                            Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Max.",
                                                                    style: CommonStyles.getRalewayStyle(
                                                                        space_10,
                                                                        FontWeight
                                                                            .w600,
                                                                        CommonStyles
                                                                            .red),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  child: ListView(
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: space_15,
                                                          right: space_15),
                                                      child: FilterSortByWidget(
                                                          "By Price",
                                                          "PRICE",
                                                          priceSort!=null && priceSort.isNotEmpty? (priceSort=="high"? sortingList[1] : sortingList[0]):sortingList[0],
                                                          this.sortingList,
                                                          (String mType,
                                                              String
                                                                  mSelectedValue) {
                                                        onDropDownValueChange(
                                                            mType,
                                                            mSelectedValue);
                                                      }),
                                                    )
                                                  ],
                                                ))),
                                      SizedBox(
                                        height: space_35,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: space_15,
                                                    right: space_10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            space_5),
                                                    gradient:
                                                        filterTabSelectedGradient()),
                                                height: space_50,
                                                child: Center(
                                                  child: FlatButton(
                                                      onPressed: () {
                                                        var dummyCustom = List<
                                                            Customefield>();
                                                        filterRes.customefield
                                                            .forEach((element) {
                                                          element.isChecked =
                                                              false;
                                                          dummyCustom
                                                              .add(element);
                                                        });
                                                        var dummySubCategory =
                                                            List<Subcategory>();
                                                        filterRes.subcategory
                                                            .forEach((element) {
                                                          element.isChecked =
                                                              false;
                                                          dummySubCategory
                                                              .add(element);
                                                        });
                                                        dialogSetState(() {
                                                          filterRes
                                                                  .customefield =
                                                              dummyCustom;
                                                          filterRes
                                                                  .subcategory =
                                                              dummySubCategory;
                                                          _currentSliderValue =
                                                              double.parse(
                                                                  filterRes.budget !=
                                                                          null
                                                                      ? filterRes
                                                                          .budget
                                                                          .min
                                                                      : "-");
                                                        });
                                                        _currentSliderValue = filterRes.budget != null &&
                                                            filterRes.budget.min != null &&
                                                            filterRes.budget.min?.isNotEmpty
                                                            ? double.parse(filterRes.budget.min)
                                                            : 0;
                                                        priceSort = "";
                                                        filter_subcategory_id = "";
                                                        filter_custome_filed_id = "";
                                                      },
                                                      child: Text(
                                                        "Reset",
                                                        style: CommonStyles
                                                            .getRalewayStyle(
                                                                space_15,
                                                                FontWeight.w600,
                                                                Colors.white),
                                                      )),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    right: space_15,
                                                    left: space_10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            space_5),
                                                    color: CommonStyles.blue),
                                                height: space_50,
                                                child: Center(
                                                  child: FlatButton(
                                                      onPressed: () {
                                                        var selectedSubCategory =
                                                            "";
                                                        var selectedCustomFilds =
                                                            "";
                                                        if (filterRes != null &&
                                                            filterRes
                                                                    .subcategory !=
                                                                null &&
                                                            filterRes
                                                                    .subcategory
                                                                    ?.length >
                                                                0) {
                                                          filterRes.subcategory
                                                              ?.forEach(
                                                                  (element) {
                                                            if (element
                                                                .isChecked) {
                                                              selectedSubCategory =
                                                                  selectedSubCategory +
                                                                      "${selectedSubCategory.isNotEmpty ? "," : ""}" +
                                                                      element
                                                                          .sub_id;
                                                            }
                                                          });
                                                        }
                                                        if (filterRes != null &&
                                                            filterRes
                                                                    .customefield !=
                                                                null &&
                                                            filterRes
                                                                    .customefield
                                                                    ?.length >
                                                                0 &&
                                                            filterRes
                                                                    .customefield[
                                                                        0]
                                                                    .field_options !=
                                                                null &&
                                                            filterRes
                                                                    .customefield[
                                                                        0]
                                                                    .field_options
                                                                    .length >
                                                                0) {
                                                          filterRes.customefield
                                                              ?.forEach(
                                                                  (parentElement) {
                                                            parentElement
                                                                .field_options
                                                                ?.forEach(
                                                                    (element) {
                                                              if (element
                                                                  .isChecked) {
                                                                selectedCustomFilds =
                                                                    selectedCustomFilds +
                                                                        "${selectedCustomFilds.isNotEmpty ? "," : ""}" +
                                                                        element
                                                                            .id;
                                                              }
                                                            });
                                                          });
                                                        }
                                                        dialogSetState(() {
                                                          mFilterRes =
                                                              filterRes;
                                                          filter_subcategory_id =
                                                              selectedSubCategory;
                                                          filter_custome_filed_id =
                                                              selectedCustomFilds;
                                                          filter_min = _currentSliderValue %
                                                                      1 ==
                                                                  0
                                                              ? _currentSliderValue
                                                                  .toInt()
                                                                  .toString()
                                                              : _currentSliderValue.toString();
                                                          filter_max = filterRes
                                                              ?.budget?.max;
                                                        });
                                                        recallApiWithFilter(
                                                            filterRes);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Apply",
                                                        style: CommonStyles
                                                            .getRalewayStyle(
                                                                space_15,
                                                                FontWeight.w600,
                                                                Colors.white),
                                                      )),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
//            CommonBottomNavBarWidget(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  onDropDownValueChange(String type, String selectedValue) {
    debugPrint("SELECTED ${type} ----- ${selectedValue}");
    setState(() {
      switch(type){
        case "PRICE":{
          priceSort = selectedValue == "Low to High"? "low":"high";
        }
      }
    });
  }

  void onSearchClick() {}
}
