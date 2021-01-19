import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/custom_field_model2.dart';
import 'package:flutter_rentry_new/screens/postad/RentalPriceScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductImgScreen extends StatefulWidget {
  AdPostReqModel adPostReqModel;

  UploadProductImgScreen(this.adPostReqModel);

  @override
  _UploadProductImgScreenState createState() => _UploadProductImgScreenState();
}

class _UploadProductImgScreenState extends State<UploadProductImgScreen> {
  String img1 = "";
  String img2 = "";
  String img3 = "";
  String mSelectedImg = "";
  File _image1;
  File _image2;
  File _image3;
  final picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Stack(
            children: [
              Column(
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
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mSelectedImg = "img1";
                                    });
                                  },
                                  child: Container(
                                    height: space_150,
                                    width: space_200,
                                    margin: EdgeInsets.only(
                                        left: space_15,
                                        right: space_5,
                                        top: space_15),
                                    decoration: BoxDecoration(
                                        color: CommonStyles.lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(space_10)),
                                    child: _image1 != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(space_10),
                                            child: Image.file(
                                              _image1,
                                              fit: BoxFit.fill,
                                              width: space_200,
                                              height: space_150,
                                            ),
                                          )
                                        : Container(
                                            height: space_150,
                                            width: space_200,
                                            margin: EdgeInsets.only(
                                                left: space_15,
                                                right: space_5,
                                                top: space_5),
                                            decoration: BoxDecoration(
                                                color: CommonStyles.lightGrey,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        space_10)),
                                            child: Center(
                                              child: Text(
                                                "Upload image",
                                                style: CommonStyles
                                                    .getMontserratStyle(
                                                        space_14,
                                                        FontWeight.w500,
                                                        Colors.black),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                _image1 != null
                                    ? Positioned(
                                        left: 190.0,
                                        top: 5.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _image1 = null;
                                            });
                                          },
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
                                        ),
                                      )
                                    : Container(
                                        height: space_0,
                                        width: space_0,
                                      )
                              ],
                            ),
                          ),
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mSelectedImg = "img2";
                                    });
                                  },
                                  child: Container(
                                    height: space_150,
                                    width: space_200,
                                    margin: EdgeInsets.only(
                                        left: space_15,
                                        right: space_5,
                                        top: space_15),
                                    decoration: BoxDecoration(
                                        color: CommonStyles.lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(space_10)),
                                    child: _image2 != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(space_10),
                                            child: Image.file(
                                              _image2,
                                              fit: BoxFit.fill,
                                              width: space_200,
                                              height: space_150,
                                            ),
                                          )
                                        : Container(
                                            height: space_150,
                                            width: space_200,
                                            margin: EdgeInsets.only(
                                                left: space_15,
                                                right: space_5,
                                                top: space_5),
                                            decoration: BoxDecoration(
                                                color: CommonStyles.lightGrey,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        space_10)),
                                            child: Center(
                                              child: Text(
                                                "Upload image",
                                                style: CommonStyles
                                                    .getMontserratStyle(
                                                        space_14,
                                                        FontWeight.w500,
                                                        Colors.black),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                _image2 != null
                                    ? Positioned(
                                        left: 190.0,
                                        top: 5.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _image2 = null;
                                            });
                                          },
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
                                        ),
                                      )
                                    : Container(
                                        width: space_0,
                                        height: space_0,
                                      )
                              ],
                            ),
                          ),
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mSelectedImg = "img3";
                                    });
                                  },
                                  child: Container(
                                    height: space_150,
                                    width: space_200,
                                    margin: EdgeInsets.only(
                                        left: space_15,
                                        right: space_5,
                                        top: space_15),
                                    decoration: BoxDecoration(
                                        color: CommonStyles.lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(space_10)),
                                    child: _image3 != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(space_10),
                                            child: Image.file(
                                              _image3,
                                              fit: BoxFit.fill,
                                              width: space_200,
                                              height: space_150,
                                            ),
                                          )
                                        : Container(
                                            height: space_150,
                                            width: space_200,
                                            margin: EdgeInsets.only(
                                                left: space_15,
                                                right: space_5,
                                                top: space_5),
                                            decoration: BoxDecoration(
                                                color: CommonStyles.lightGrey,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        space_10)),
                                            child: Center(
                                              child: Text(
                                                "Upload image",
                                                style: CommonStyles
                                                    .getMontserratStyle(
                                                        space_14,
                                                        FontWeight.w500,
                                                        Colors.black),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                _image3 != null
                                    ? Positioned(
                                        left: 190.0,
                                        top: 5.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _image3 = null;
                                            });
                                          },
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
                                        ),
                                      )
                                    : Container(
                                        height: space_0,
                                        width: space_0,
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
//                 dsfsdsdf
                  GestureDetector(
                    onTap: () {
                      if (_image1 != null) {
                        widget.adPostReqModel.imgPath1 =
                            _image1 != null ? _image1.path : "";
                        widget.adPostReqModel.imgPath2 =
                            _image2 != null ? _image2.path : "";
                        widget.adPostReqModel.imgPath3 =
                            _image3 != null ? _image3.path : "";
                        widget.adPostReqModel.img1 =
                            _image1 != null ? _image1 : "";
                        widget.adPostReqModel.img2 =
                            _image2 != null ? _image2 : null;
                        widget.adPostReqModel.img3 =
                            _image3 != null ? _image3 : null;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RentalPriceScreen(widget.adPostReqModel)),
                        );
                      } else {
                        showSnakbar(_scaffoldKey, empty_img);
                      }
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
              mSelectedImg != null && mSelectedImg.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          mSelectedImg = null;
                        });
                      },
                      child: Container(
                        color: Colors.grey.withOpacity(0.6),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(space_15),
                            padding: EdgeInsets.only(
                                top: space_15,
                                left: space_15,
                                right: space_15,
                                bottom: space_15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black, blurRadius: space_5)
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(space_15),
                                  topRight: Radius.circular(space_15),
                                  bottomRight: Radius.circular(space_15),
                                  bottomLeft: Radius.circular(space_15),
                                )),
                            child: Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    getImageCamera(mSelectedImg);
                                  },
                                  child: Container(
                                    height: space_80,
                                    margin: EdgeInsets.only(right: space_5),
                                    decoration: BoxDecoration(
                                        color: CommonStyles.lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(space_10)),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            color: CommonStyles.primaryColor,
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(space_5),
                                            child: Text(
                                              "Camera",
                                              style: CommonStyles
                                                  .getMontserratStyle(
                                                      space_15,
                                                      FontWeight.w500,
                                                      Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    getImage(mSelectedImg);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: space_5),
                                    height: space_80,
                                    decoration: BoxDecoration(
                                        color: CommonStyles.lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(space_10)),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.photo,
                                            color: CommonStyles.primaryColor,
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(space_5),
                                            child: Text(
                                              "Gallery",
                                              style: CommonStyles
                                                  .getMontserratStyle(
                                                      space_15,
                                                      FontWeight.w500,
                                                      Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: space_0,
                      width: space_0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage(String imgType) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        if (imgType == "img1") {
          _image1 = File(pickedFile.path);
          debugPrint("FILE_SELECTED ${_image1.path}");
        } else if (imgType == "img2") {
          _image2 = File(pickedFile.path);
          debugPrint("FILE_SELECTED ${_image2.path}");
        } else if (imgType == "img3") {
          _image3 = File(pickedFile.path);
          debugPrint("FILE_SELECTED ${_image3.path}");
        }
        mSelectedImg = "";
      } else {
        mSelectedImg = "";
        print('No image selected.');
      }
    });
  }

  Future getImageCamera(String imgType) async {
    try{
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          if (imgType == "img1") {
            _image1 = File(pickedFile.path);
            debugPrint("FILE_SELECTED ${_image1.path}");
            Fluttertoast.showToast(
                msg: "Success ${_image1.path}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: space_14);
          } else if (imgType == "img2") {
            _image2 = File(pickedFile.path);
            debugPrint("FILE_SELECTED ${_image2.path}");
            Fluttertoast.showToast(
                msg: "Success ${_image2.path}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: space_14);
          } else if (imgType == "img3") {
            _image3 = File(pickedFile.path);
            debugPrint("FILE_SELECTED ${_image3.path}");
            Fluttertoast.showToast(
                msg: "Success ${_image3.path}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: space_14);
          }
          mSelectedImg = "";
        } else {
          mSelectedImg = "";
          print('No image selected.');
          Fluttertoast.showToast(
              msg: "Cancelled",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: space_14);
        }
      });
    }catch(e, stacktrace){
      Fluttertoast.showToast(
          msg: "EXception ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: space_14);
    }
  }
}
