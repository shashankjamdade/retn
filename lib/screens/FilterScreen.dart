import 'package:flutter/material.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/Constants.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';
import 'package:flutter_rentry/widgets/CustomWidget.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'dart:ui' as ui;

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isFilter = true;
  bool checkedValue = false;
  double _currentSliderValue = 20;
  ui.Image sampleIcon;
  String highestEducation = "Low to High";
  List<String> sortingList = List();
  String mType, mSelectedValue;

  @override
  void initState() {
    super.initState();
    getUiImage("assets/images/slider_thumb.png", 30, 30).then((value) =>
    sampleIcon = value);
    //Edu
    sortingList.add("Low to High");
    sortingList.add("High to Low");
    sortingList.add("Most Relevant");
    setState(() {
      _currentSliderValue = 40;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding:
                    EdgeInsets.only(top: space_30),
                    child: Container(
                      color: Colors.white,
                      margin:
                      EdgeInsets.only(bottom: space_50),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    margin:
                                    EdgeInsets.only(left: space_15),
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
                                            color: isFilter?Colors.white: CommonStyles.darkAmber,
                                          ),
                                          label: Text(
                                            "Filter",
                                            style: CommonStyles.getRalewayStyle(
                                                space_14, FontWeight.w600, isFilter?Colors.white: CommonStyles.darkAmber),
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
                                            setState(() {
                                              isFilter = !isFilter;
                                            });
                                          },
                                          icon: ImageIcon(
                                            AssetImage(
                                              "assets/images/sortby_icon_amber.png",
                                            ),
                                            color: isFilter?CommonStyles.darkAmber: Colors.white,
                                          ),
                                          label: Text(
                                            "Sort By",
                                            style: CommonStyles.getRalewayStyle(
                                                space_14, FontWeight.w600, isFilter?CommonStyles.darkAmber: Colors.white),
                                          )),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: space_25,
                          ),
                          Container(
                              child:
                              isFilter
                                  ? Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  primary: false,
                                  children: [
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: space_15, right: space_15),
                                      child: Text(
                                        "LOREM",
                                        style: CommonStyles.getRalewayStyle(
                                            space_15, FontWeight.w800, Colors.black),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: space_15, right: space_15),
                                      height: getProportionateScreenHeight(
                                          context, space_250),
                                      padding: EdgeInsets.only(top: space_15),
                                      child: ListView.builder(
                                          itemCount: 15,
                                          shrinkWrap: true,
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: space_50,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text("Lorem",
                                                    style: CommonStyles.getRalewayStyle(
                                                        space_14, FontWeight.w500,
                                                        Colors.black),),
                                                  Checkbox(
                                                    value: checkedValue,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        checkedValue = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: space_15, right: space_15, top: space_25),
                                      child: Text(
                                        "PRICE",
                                        style: CommonStyles.getRalewayStyle(
                                            space_15, FontWeight.w800, Colors.black),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: space_15, right: space_15, top: space_15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "₹ 999",
                                            style: CommonStyles.getRalewayStyle(space_12,
                                                FontWeight.w500, Colors.black),
                                          ),
                                          Text(
                                            "₹ 9999",
                                            style: CommonStyles.getRalewayStyle(space_12,
                                                FontWeight.w500, Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: CommonStyles.primaryColor.withOpacity(0.8),
                                          inactiveTrackColor: CommonStyles.blue,
                                          trackShape: RectangularSliderTrackShape(),
                                          showValueIndicator: ShowValueIndicator.always,
                                          valueIndicatorColor: CommonStyles.blue,
                                          trackHeight: 8.0,
                                          thumbColor: CommonStyles.primaryColor,
//          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                          thumbShape: SliderThumbImage(sampleIcon),
                                          overlayColor: CommonStyles.primaryColor.withAlpha(
                                              32),
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 28.0),
                                        ),
                                        child: Slider(
                                          value: _currentSliderValue,
                                          min: 0,
                                          max: 100,
                                          divisions: 100,
                                          label: _currentSliderValue.round().toString(),
                                          onChanged: (double value) {
                                            setState(() {
                                              _currentSliderValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(left: space_15, right: space_15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Min.",
                                                  style: CommonStyles.getRalewayStyle(
                                                      space_10,
                                                      FontWeight.w600, CommonStyles.blue),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(left: space_5),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: space_10,
                                                      vertical: space_5),
                                                  decoration: BoxDecoration(
                                                      color: CommonStyles.grey.withOpacity(
                                                          0.3),
                                                      borderRadius: BorderRadius.circular(
                                                          space_3)
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "₹ 200",
                                                      style: CommonStyles.getRalewayStyle(
                                                          space_12,
                                                          FontWeight.w500, Colors.black),
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
                                                  margin: EdgeInsets.only(right: space_5),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: space_10,
                                                      vertical: space_5),
                                                  decoration: BoxDecoration(
                                                      color: CommonStyles.grey.withOpacity(
                                                          0.3),
                                                      borderRadius: BorderRadius.circular(
                                                          space_3)
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "₹ 200",
                                                      style: CommonStyles.getRalewayStyle(
                                                          space_12,
                                                          FontWeight.w500, Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Min.",
                                                  style: CommonStyles.getRalewayStyle(
                                                      space_10,
                                                      FontWeight.w600, CommonStyles.red),
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
                                height: getProportionateScreenHeight(
                                    context, space_250),
                                child: ListView.builder(
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder: (context, pos){
                                  return Container(
                                    margin:
                                    EdgeInsets.only(left: space_15, right: space_15),
                                    child: FilterSortByWidget(
                                        "By Price",
                                        "PRICE",
                                        sortingList[0],
                                        this.sortingList,
                                            ( String mType, String mSelectedValue){
                                          onDropDownValueChange(mType, mSelectedValue);
                                        }),
                                  );
                                }),
                              )
                          ),
                          SizedBox(
                            height: space_35,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    margin:
                                    EdgeInsets.only(left: space_15, right: space_10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(space_5),
                                        gradient: filterTabSelectedGradient()),
                                    height: space_50,
                                    child: Center(
                                      child: FlatButton(
                                          onPressed: () {

                                          },
                                          child: Text(
                                            "Reset",
                                            style: CommonStyles.getRalewayStyle(
                                                space_15, FontWeight.w600, Colors.white),
                                          )),
                                    )),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                    margin:
                                    EdgeInsets.only(right: space_15, left: space_10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(space_5),
                                        color: CommonStyles.blue),
                                    height: space_50,
                                    child: Center(
                                      child: FlatButton(
                                          onPressed: () {

                                          },
                                          child: Text(
                                            "Apply",
                                            style: CommonStyles.getRalewayStyle(
                                                space_15, FontWeight.w600, Colors.white),
                                          )),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: space_80,
                          ),
                        ],
                      ),
                    ),
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

  onDropDownValueChange(String type, String selectedValue) {
    debugPrint("SELECTED ${type} ----- ${selectedValue}");
  }

}
