import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/RazorpaySuccessRes.dart';
import 'package:flutter_rentry_new/model/ad_under_package_res.dart';
import 'package:flutter_rentry_new/model/get_notification_response.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/screens/HomeScreen.dart';
import 'package:flutter_rentry_new/screens/MyPackageListScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/my_flutter_app_icons.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CarousalCommonWidgets.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/ListItemCardWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'MyAdsListScreen.dart';

class AdUnderPackageListScreen extends StatefulWidget {

  AdPostReqModel adPostReqModel;
  AdUnderPackageListScreen(this.adPostReqModel);
  @override
  _AdUnderPackageListScreenState createState() =>
      _AdUnderPackageListScreenState();
}

class _AdUnderPackageListScreenState extends State<AdUnderPackageListScreen> {
  TrackingScrollController controller = TrackingScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc = new HomeBloc();
  AdUnderPackageRes mGetNotificationResponse;
  var loginResponse;
  var token = "";
  var email = "";
  var mobile = "";
  var mSelectedPackageName = "";
  var mSelectedPackageId = "";
  var mBuypackageId = "";
  var mSelectedPackageAmt = "";
//  var _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_AdUnderPackageListScreen---------");
//    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
//      email = loginResponse.email;
//      mobile = loginResponse.data.contact;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
  }

  @override
  void dispose() {
    super.dispose();
//    _razorpay.clear();
  }

//  void _handlePaymentSuccess(PaymentSuccessResponse response) {
//    var amt = "";
////    setState(() {
////      mSelectedPackageId = mBuypackageId;
////    });
//    mGetNotificationResponse.data.forEach((element){
//      if(element.package_id == mBuypackageId){
//        amt = element.package_price;
//      }
//    });
//    debugPrint("PAYMENT_SUCCESS ------- > ${jsonEncode(response.paymentId)}");
//    var mRazorpaySuccessRes = new RazorpaySuccessRes(paymentId: response.paymentId, orderId: response.orderId, signature: response.signature);
//    debugPrint("PG_RES ------- > ${jsonEncode(mRazorpaySuccessRes)}");
//    homeBloc..add(PackagePaymentEvent(token: token, packageId: mBuypackageId, amt: amt, pgRes: jsonEncode(mRazorpaySuccessRes)));
//  }

//  void _handlePaymentError(PaymentFailureResponse response) {
//    debugPrint("PAYMENT_ERROR ------- > ${response.message}");
//    showSnakbar(_scaffoldKey, response.message);
//  }

//  void _handleExternalWallet(ExternalWalletResponse response) {
//    debugPrint("PAYMENT_EXT_WALLET ------- > ${jsonEncode(response.walletName)}");
//  }

  void openCheckout(String amt, String packageName, String packageId) async {
    debugPrint("PAYYYY ${amt} for $packageId");
//    var options = {
//      'key': 'rzp_test_5JE0nfz3a956ce',
//      'amount': amt,
//      'name': packageName,
//      'description': 'Buy new package',
//      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
//      'external': {
//        'wallets' : ['paytm'],
//      }
//    };
//    try{
//      _razorpay.open(options);
//    }
//    catch(e) {
//      debugPrint(e);
//    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc..add(AdUnderPackageEvent(token: token)),
      child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is AdUnderPackageState) {
              mGetNotificationResponse = state.res;
            }else if (state is PackagePaymentState) {
              if(state.res!=null){
                debugPrint("GOTRES_POSTADS ${state.res.status}");
                if(state.res!=null && state.res.status == "success") {
                  homeBloc..add(AdUnderPackageEvent(token: token));
                }
                if(state.res!=null && state.res.msg!=null) {
                  Fluttertoast.showToast(
                      msg: state.res.msg,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: space_14
                  );
                }
              }
            }else if(state is PostAdsState){
              if(state.res!=null && state.res.msg!=null){
//                showSnakbar(_scaffoldKey, state.res.msg);
                Fluttertoast.showToast(
                    msg: state.res.msg,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: space_14
                );
                if(state.res.status!=null && (state.res.status == "success" || state.res.status == "true")){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(isRedirectToMyAds: true,)),
                  );
                }
              }
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is AdUnderPackageState) {
                return getScreenUI(state.res);
              } else {
                return ProgressNormalAppBarWidget("");
              }
            },
          )),
    );
  }

  Widget getScreenUI(AdUnderPackageRes adUnderPackageRes) {
    if (adUnderPackageRes.status) {
      if (adUnderPackageRes.data.length > 0) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            body: Stack(
              children: [
                Container(
                    child: Column(
                  children: [
                    PostAdsCommonAppbar(title: "Select Package"),
                    Padding(
                      padding: EdgeInsets.only(left: space_15, top: space_20, bottom: space_15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Packages",
                          style: CommonStyles.getMontserratStyle(
                              space_14, FontWeight.w700, Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: space_60),
                        child: ListView.builder(
                            itemCount: adUnderPackageRes.data.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              if(adUnderPackageRes.data[index].purchase_button == "show"){
                                return ListTile(
                                  key: Key("${index}"),
//                                  leading: Icon(Icons.notification_important),
                                  title: Row(
                                    children: [
                                      Text(
                                        adUnderPackageRes.data[index].package_name + " (${adUnderPackageRes.data[index].package_price} for ${adUnderPackageRes.data[index].no_of_days} days)",
                                        style: CommonStyles.getMontserratStyle(
                                            space_15, FontWeight.w500, Colors.black),
                                      ),
                                      SizedBox(width: space_15,),
                                      GestureDetector(
                                        onTap: (){
                                          mBuypackageId = adUnderPackageRes.data[index].package_id;
                                          openCheckout(adUnderPackageRes.data[index].package_price, adUnderPackageRes.data[index].package_name, adUnderPackageRes.data[index].package_id);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(space_8),
                                          child: Text(
                                            "Buy Now",
                                            style: CommonStyles.getMontserratDecorationStyle(
                                                space_15, FontWeight.w600, Colors.redAccent, TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                                return RadioListTile(
                                  groupValue: mSelectedPackageName,
                                  title: Text(
                                    adUnderPackageRes.data[index].package_name + " (${adUnderPackageRes.data[index].package_price} for ${adUnderPackageRes.data[index].no_of_days} days)",
                                  ),
                                  value: adUnderPackageRes.data[index].package_id,
                                  onChanged: (val) {
                                    debugPrint("Selected_Package - ${val}");
                                    setState(() {
                                      mSelectedPackageName = val;
                                      mSelectedPackageId = val;
                                    });
                                  },
                                );
                              }
                            }),
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
                )),
              ],
            ),
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: space_15),
          child: Center(
            child: Text(
              "No Notificaitons Found",
              style: CommonStyles.getMontserratStyle(
                  space_15, FontWeight.w600, Colors.black),
            ),
          ),
        );
      }
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: space_15),
        child: Center(
          child: Text(
            adUnderPackageRes.message,
            style: CommonStyles.getMontserratStyle(
                space_15, FontWeight.w600, Colors.black),
          ),
        ),
      );
    }
  }

  void onSubmit() {
    if(mSelectedPackageId.isEmpty){
      showSnakbar(_scaffoldKey, empty_package);
    }else{
      //api call
      widget.adPostReqModel.packageId = mSelectedPackageId;
      homeBloc..add(PostAdsEvent(token: token, adPostReqModel: widget.adPostReqModel));
    }
  }
}
