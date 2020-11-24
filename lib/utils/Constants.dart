import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/screens/ChildSubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/NearByChildSubCategoryScreen.dart';
import 'package:url_launcher/url_launcher.dart';
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


void onViewAllClick(BuildContext context, String type, String categoryId, String categoryName) {
//  switch (type) {
//    case TYPE_FURNITURE:
//      break;
//  }
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) =>
            NearByChildSubCategoryScreen(isFromNearBy: false, lat: "",
              lng: "", categoryId: categoryId, categoryName: categoryName,)),
  );
//  Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => ChildSubCategoryScreen()),
//  );
}


Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
  final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
  image.Image baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
  image.Image resizeImage = image.copyResize(baseSizeImage, height: height, width: width);
  ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

lauchDialer(String mobile) async {
  if(mobile.isNotEmpty) {
    var url = "tel:" + mobile;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
//Future<bool> isInternet() async {
//  var connectivityResult = await (Connectivity().checkConnectivity());
//  if (connectivityResult == ConnectivityResult.mobile) {
//    // I am connected to a mobile network, make sure there is actually a net connection.
//    if (await DataConnectionChecker().hasConnection) {
//      // Mobile data detected & internet connection confirmed.
//      return true;
//    } else {
//      // Mobile data detected but no internet connection found.
//      return false;
//    }
//  } else if (connectivityResult == ConnectivityResult.wifi) {
//    // I am connected to a WIFI network, make sure there is actually a net connection.
//    if (await DataConnectionChecker().hasConnection) {
//      // Wifi detected & internet connection confirmed.
//      return true;
//    } else {
//      // Wifi detected but no internet connection found.
//      return false;
//    }
//  } else {
//    // Neither mobile data or WIFI detected, not internet connection found.
//    return false;
//  }
//}


