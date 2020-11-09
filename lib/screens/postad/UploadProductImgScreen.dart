import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/screens/postad/RentalPriceScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class UploadProductImgScreen extends StatefulWidget {
  @override
  _UploadProductImgScreenState createState() => _UploadProductImgScreenState();
}

class _UploadProductImgScreenState extends State<UploadProductImgScreen> {
  String img1 = "";
  String img2 = "";
  String img3 = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostAdsCommonAppbar(title: "What are you offering?"),
              Padding(
                padding: EdgeInsets.only(
                    left: space_15, top: space_20, bottom: space_20),
                child: Text(
                  "INCLUDE GALLERY",
                  style: CommonStyles.getMontserratStyle(
                      space_14, FontWeight.w700, Colors.black),
                ),
              ),
              Expanded(
                child: Container(
                  height: space_180,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: space_150,
                            width: space_200,
                            margin: EdgeInsets.only(
                                left: space_15, right: space_5, top: space_5),
                            decoration: BoxDecoration(
                                color: CommonStyles.lightGrey,
                                borderRadius: BorderRadius.circular(space_10)),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: Container(
                                height: space_30,
                                width: space_30,
                                decoration: BoxDecoration(
                                    color: CommonStyles.red,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ))),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: space_150,
                            width: space_200,
                            margin: EdgeInsets.only(
                                left: space_15, right: space_5, top: space_5),
                            decoration: BoxDecoration(
                                color: CommonStyles.lightGrey,
                                borderRadius: BorderRadius.circular(space_10)),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: Container(
                                height: space_30,
                                width: space_30,
                                decoration: BoxDecoration(
                                    color: CommonStyles.red,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ))),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: space_150,
                            width: space_200,
                            margin: EdgeInsets.only(
                                left: space_15, right: space_5, top: space_5),
                            decoration: BoxDecoration(
                                color: CommonStyles.lightGrey,
                                borderRadius: BorderRadius.circular(space_10)),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: Container(
                                height: space_30,
                                width: space_30,
                                decoration: BoxDecoration(
                                    color: CommonStyles.red,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ))),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: space_15, right: space_15),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                          onTap: (){},
                          child: Container(
                      height: space_70,
                      margin: EdgeInsets.only(right: space_5),
                      decoration: BoxDecoration(
                            color: CommonStyles.lightGrey,
                            borderRadius: BorderRadius.circular(space_10)),
                            child: Center(
                              child: Icon(Icons.camera_alt, color: CommonStyles.primaryColor,),
                            ),
                    ),
                        )),
                    Expanded(
                        child: GestureDetector(
                          onTap: (){},
                          child: Container(
                      margin: EdgeInsets.only(left: space_5),
                      height: space_70,
                      decoration: BoxDecoration(
                            color: CommonStyles.lightGrey,
                            borderRadius: BorderRadius.circular(space_10)),
                            child: Center(
                              child: Icon(Icons.photo, color: CommonStyles.primaryColor,),
                            ),
                    ),
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RentalPriceScreen()),
                  );
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
        ),
      ),
    );
  }
}
