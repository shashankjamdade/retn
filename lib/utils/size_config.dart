
import 'package:flutter/material.dart';

const double space_0 = 0.0;
const double space_1 = 1.0;
const double space_2 = 2.0;
const double space_3 = 3.0;
const double space_5 = 5.0;
const double space_8 = 8.0;
const double space_10 = 10.0;
const double space_12 = 12.0;
const double space_13 = 13.0;
const double space_14 = 14.0;
const double space_15 = 15.0;
const double space_16 = 16.0;
const double space_18 = 18.0;
const double space_20 = 20.0;
const double space_22 = 22.0;
const double space_25 = 25.0;
const double space_30 = 30.0;
const double space_35 = 35.0;
const double space_40 = 40.0;
const double space_45 = 45.0;
const double space_50 = 50.0;
const double space_60 = 60.0;
const double space_70 = 70.0;
const double space_80 = 80.0;
const double space_90 = 90.0;
const double space_95 = 95.0;
const double space_100 = 100.0;
const double space_110 = 110.0;
const double space_115 = 115.0;
const double space_120 = 120.0;
const double space_140 = 140.0;
const double space_150 = 150.0;
const double space_160 = 160.0;
const double space_178 = 178.0;
const double space_180 = 180.0;
const double space_190 = 190.0;
const double space_200 = 200.0;
const double space_220 = 220.0;
const double space_230 = 230.0;
const double space_240 = 240.0;
const double space_250 = 250.0;
const double space_270 = 270.0;
const double space_280 = 280.0;
const double space_300 = 300.0;
const double space_340 = 340.0;
const double space_320 = 320.0;
const double space_350 = 350.0;
const double space_360 = 360.0;
const double space_370 = 370.0;
const double space_380 = 380.0;
const double space_400 = 400.0;
const double space_450 = 450.0;
const double space_500 = 500.0;

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(BuildContext context, double inputHeight) {
  double screenHeight = MediaQuery.of(context).size.height;
  // 812 is the layout height that designer use
  debugPrint("---->${screenHeight}");
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getFullScreenHeight(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  // 812 is the layout height that designer use
  debugPrint("---->${screenHeight}");
  return screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(BuildContext context, double inputWidth) {
  double screenWidth = MediaQuery.of(context).size.width;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
