import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/screens/ChildSubCategoryScreen.dart';
import 'CommonStyles.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;


void showSnakbar(GlobalKey<ScaffoldState> _scaffoldKey, String msg){
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(msg),
  ));
}

void onClickViewAll(BuildContext context, String type){

}

void onSearchLocation(BuildContext context){

}

String getMapUrl(double lat, double longi, int w, int h){
  var mapUrl =
      "https://maps.googleapis.com/maps/api/staticmap?center=${lat},${longi}&zoom=10&size=${w}x${h}&markers=color:red%7Clabel:%7C${lat},${longi}&maptype=roadmap&key=AIzaSyA-7MnlahCeTpKE5mOD5XQf-8ixgbdtDSs";
  return mapUrl;
}

String getRichText2ByType(String type) {
  String text2;
  switch (type) {
    case TYPE_VEHICLE:
      text2 = "VEHICLES";
      break;
    case TYPE_FURNITURE:
      text2 = "FURNITURE";
      break;
    case TYPE_ELECTRONICS:
      text2 = "ELECTRONICS";
      break;
    case TYPE_CLOTHS:
      text2 = "CLOTHS";
      break;
    case TYPE_PROPERTIES:
      text2 = "PROPERTIES";
      break;
    case TYPE_SERVICE:
      text2 = "SERVICE";
      break;
    case TYPE_FREELANCING:
      text2 = "FREELANCING";
      break;
   case SIMILAR_PRODUCT:
      text2 = "PRODUCTS";
      break;
  case MORE_PRODUCTS:
      text2 = "PRODUCTS";
      break;
  }
  return text2;
}


void onViewAllClick(BuildContext context, String type) {
//  switch (type) {
//    case TYPE_FURNITURE:
//      break;
//  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChildSubCategoryScreen()),
  );
}


Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
  final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
  image.Image baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
  image.Image resizeImage = image.copyResize(baseSizeImage, height: height, width: width);
  ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}



