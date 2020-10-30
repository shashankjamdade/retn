import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/UserLocationSelected.dart';
import 'package:flutter_rentry_new/screens/postad/SelectLocationPostAdScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class LocationForAdScreen extends StatefulWidget {
  @override
  _LocationForAdScreenState createState() => _LocationForAdScreenState();
}

class _LocationForAdScreenState extends State<LocationForAdScreen> {
  TextEditingController priceController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String mSelectedLocationName = "";
  String mSelectedLocationLat = "";
  String mSelectedLocationLng = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  PostAdsCommonAppbar(title: "Confirm your location"),
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_15, top: space_20, bottom: space_20),
                    child: Text(
                      "LOCATION",
                      style: CommonStyles.getMontserratStyle(
                          space_14, FontWeight.w700, Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: space_20,
                  ),
                  GestureDetector(
                    onTap: (){
                      navigateToLocationSelect(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                                padding: EdgeInsets.only(left: space_5, top: space_15, bottom: space_10),
                                child: Text(mSelectedLocationName.isNotEmpty?mSelectedLocationName:"Select Location", style: CommonStyles.getRalewayStyle(space_12, FontWeight.w500, Colors.black),)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_right, color: CommonStyles.primaryColor,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      child: Divider(height: space_1, thickness: space_1, color: Colors.black,)),
                  Expanded(child: SizedBox()),
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
                        color: CommonStyles.green,
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(space_15),
                            child: Text(
                              "Post",
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

  navigateToLocationSelect(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectLocationPostAdScreen()),
    );
    if(result is UserLocationSelected){
      debugPrint("GOT_LOCATION ----- ${result.city}");
      setState(() {
        mSelectedLocationName = result.city;
        mSelectedLocationLat = result.mlat;
        mSelectedLocationLng = result.mlng;
      });
    }
  }

  void onSubmit() {

  }
}
