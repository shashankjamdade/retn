import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/filter_res.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/CustomWidget.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'dart:ui' as ui;

import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class FilterScreen extends StatefulWidget {
  FilterRes filterRes;

  FilterScreen(this.filterRes);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isFilter = true;
  bool checkedValue = false;
  double _currentSliderValue = 0;
  ui.Image sampleIcon;
  String highestEducation = "Low to High";
  List<String> sortingList = List();
  String mType, mSelectedValue;

  @override
  void initState() {
    super.initState();
    getUiImage("assets/images/slider_thumb.png", 30, 30)
        .then((value) => sampleIcon = value);
    //Edu
    sortingList.add("Low to High");
    sortingList.add("High to Low");
    sortingList.add("Most Relevant");
    setState(() {
      _currentSliderValue = double.parse(widget.filterRes.budget.min);
    });
  }

  @override
  Widget build(BuildContext context) {
    var diff = int.parse(widget.filterRes.budget.max) -
        int.parse(widget.filterRes.budget.min);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // CommonAppbarWidget(app_name, skip_for_now, () {
                //   onSearchLocation(context);
                // }),
                PostAdsCommonAppbar(title: "Filter"),
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
                                    setState(() {
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
                                    style: CommonStyles.getRalewayStyle(
                                        space_14,
                                        FontWeight.w600,
                                        isFilter
                                            ? Colors.white
                                            : CommonStyles.darkAmber),
                                  )),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(right: space_15),
                            decoration: BoxDecoration(
                                gradient: isFilter
                                    ? filterTabUnSelectedGradient()
                                    : filterTabSelectedGradient()),
                            height: space_50,
                            child: Center(
                              child: FlatButton.icon(
                                  onPressed: () {
                                    setState(() {
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
                                    style: CommonStyles.getRalewayStyle(
                                        space_14,
                                        FontWeight.w600,
                                        isFilter
                                            ? CommonStyles.darkAmber
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
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: space_15,
                                                right: space_15),
                                            child: Text(
                                              "SubCategories",
                                              style:
                                                  CommonStyles.getRalewayStyle(
                                                      space_15,
                                                      FontWeight.w800,
                                                      Colors.black),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: space_15,
                                                right: space_15),
                                            child: ListView.builder(
                                                itemCount: widget.filterRes
                                                    .subcategory.length,
                                                shrinkWrap: true,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    height: space_50,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${widget.filterRes.subcategory[index].sub_name}",
                                                          style: CommonStyles
                                                              .getRalewayStyle(
                                                                  space_14,
                                                                  FontWeight
                                                                      .w500,
                                                                  Colors.black),
                                                        ),
                                                        Checkbox(
                                                          value: widget
                                                              .filterRes
                                                              .subcategory[
                                                                  index]
                                                              .isChecked,
                                                          onChanged:
                                                              (bool value) {
                                                            setState(() {
                                                              widget
                                                                  .filterRes
                                                                  .subcategory[
                                                                      index]
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
                                            child: Text(
                                              "Others",
                                              style:
                                                  CommonStyles.getRalewayStyle(
                                                      space_15,
                                                      FontWeight.w800,
                                                      Colors.black),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: space_15,
                                                right: space_15),
                                            child: ListView.builder(
                                                itemCount: widget.filterRes
                                                    .customefield.length,
                                                shrinkWrap: true,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    height: space_50,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${widget.filterRes.customefield[index].name}",
                                                          style: CommonStyles
                                                              .getRalewayStyle(
                                                                  space_14,
                                                                  FontWeight
                                                                      .w500,
                                                                  Colors.black),
                                                        ),
                                                        Checkbox(
                                                          value: widget
                                                              .filterRes
                                                              .customefield[
                                                                  index]
                                                              .isChecked,
                                                          onChanged:
                                                              (bool value) {
                                                            setState(() {
                                                              widget
                                                                  .filterRes
                                                                  .customefield[
                                                                      index]
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
                                            padding: EdgeInsets.only(
                                                left: space_15,
                                                right: space_15,
                                                top: space_25),
                                            child: Text(
                                              "PRICE",
                                              style:
                                                  CommonStyles.getRalewayStyle(
                                                      space_15,
                                                      FontWeight.w800,
                                                      Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: space_15,
                                                right: space_15,
                                                top: space_15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "₹ ${widget.filterRes.budget.min}",
                                                  style: CommonStyles
                                                      .getRalewayStyle(
                                                          space_12,
                                                          FontWeight.w500,
                                                          Colors.black),
                                                ),
                                                Text(
                                                  "₹ ${widget.filterRes.budget.max}",
                                                  style: CommonStyles
                                                      .getRalewayStyle(
                                                          space_12,
                                                          FontWeight.w500,
                                                          Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTrackColor: CommonStyles
                                                    .primaryColor
                                                    .withOpacity(0.8),
                                                inactiveTrackColor:
                                                    CommonStyles.blue,
                                                trackShape:
                                                    RectangularSliderTrackShape(),
                                                showValueIndicator:
                                                    ShowValueIndicator.always,
                                                valueIndicatorColor:
                                                    CommonStyles.blue,
                                                trackHeight: 8.0,
                                                thumbColor:
                                                    CommonStyles.primaryColor,
//          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                                thumbShape: SliderThumbImage(
                                                    sampleIcon),
                                                overlayColor: CommonStyles
                                                    .primaryColor
                                                    .withAlpha(32),
                                                overlayShape:
                                                    RoundSliderOverlayShape(
                                                        overlayRadius: 28.0),
                                              ),
                                              child: Slider(
                                                value: _currentSliderValue,
                                                min: double.parse(widget
                                                    .filterRes.budget.min),
                                                max: double.parse(widget
                                                    .filterRes.budget.max),
                                                divisions: diff,
                                                label: _currentSliderValue
                                                    .round()
                                                    .toString(),
                                                onChanged: (double value) {
                                                  setState(() {
                                                    _currentSliderValue = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: space_15,
                                                right: space_15),
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
                                                        style: CommonStyles
                                                            .getRalewayStyle(
                                                                space_10,
                                                                FontWeight.w600,
                                                                CommonStyles
                                                                    .blue),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: space_5),
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                                BorderRadius
                                                                    .circular(
                                                                        space_3)),
                                                        child: Center(
                                                          child: Text(
                                                            "₹ 200",
                                                            style: CommonStyles
                                                                .getRalewayStyle(
                                                                    space_12,
                                                                    FontWeight
                                                                        .w500,
                                                                    Colors
                                                                        .black),
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
                                                            right: space_5),
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                                BorderRadius
                                                                    .circular(
                                                                        space_3)),
                                                        child: Center(
                                                          child: Text(
                                                            "₹ 200",
                                                            style: CommonStyles
                                                                .getRalewayStyle(
                                                                    space_12,
                                                                    FontWeight
                                                                        .w500,
                                                                    Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Min.",
                                                        style: CommonStyles
                                                            .getRalewayStyle(
                                                                space_10,
                                                                FontWeight.w600,
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
                                      child: ListView.builder(
                                          itemCount: 1,
                                          shrinkWrap: true,
                                          primary: false,
                                          itemBuilder: (context, pos) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  left: space_15,
                                                  right: space_15),
                                              child: FilterSortByWidget(
                                                  "By Price",
                                                  "PRICE",
                                                  sortingList[0],
                                                  this.sortingList,
                                                  (String mType,
                                                      String mSelectedValue) {
                                                onDropDownValueChange(
                                                    mType, mSelectedValue);
                                              }),
                                            );
                                          }),
                                    )),
                          SizedBox(
                            height: space_35,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: space_15, right: space_10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(space_5),
                                        gradient: filterTabSelectedGradient()),
                                    height: space_50,
                                    child: Center(
                                      child: FlatButton(
                                          onPressed: () {
                                            var dummyCustom =
                                                List<Customefield>();
                                            widget.filterRes.customefield
                                                .forEach((element) {
                                              element.isChecked = false;
                                              dummyCustom.add(element);
                                            });
                                            var dummySubCategory =
                                                List<Subcategory>();
                                            widget.filterRes.subcategory
                                                .forEach((element) {
                                              element.isChecked = false;
                                              dummySubCategory.add(element);
                                            });
                                            setState(() {
                                              widget.filterRes.customefield =
                                                  dummyCustom;
                                              widget.filterRes.subcategory =
                                                  dummySubCategory;
                                              _currentSliderValue = double.parse(widget.filterRes.budget.min);
                                            });
                                          },
                                          child: Text(
                                            "Reset",
                                            style: CommonStyles.getRalewayStyle(
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
                                        right: space_15, left: space_10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(space_5),
                                        color: CommonStyles.blue),
                                    height: space_50,
                                    child: Center(
                                      child: FlatButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Apply",
                                            style: CommonStyles.getRalewayStyle(
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
  }

  onDropDownValueChange(String type, String selectedValue) {
    debugPrint("SELECTED ${type} ----- ${selectedValue}");
  }
}
