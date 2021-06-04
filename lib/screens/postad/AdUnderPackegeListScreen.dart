import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  var _razorpay = Razorpay();
  var mShowProgress = false;
  var mCheckedTnC = false;
  var mCheckedCovidGuidelines = false;

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_AdUnderPackageListScreen---------");
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      mShowProgress = false;
    });
    var amt = "";
//    setState(() {
//      mSelectedPackageId = mBuypackageId;
//    });
    mGetNotificationResponse.data.forEach((element) {
      if (element.package_id == mBuypackageId) {
        amt = element.package_price;
      }
    });
    debugPrint("PAYMENT_SUCCESS ------- > ${jsonEncode(response.paymentId)}");
    var mRazorpaySuccessRes = new RazorpaySuccessRes(
        paymentId: response.paymentId,
        orderId: response.orderId,
        signature: response.signature);
    debugPrint("PG_RES ------- > ${jsonEncode(mRazorpaySuccessRes)}");
    homeBloc
      ..add(PackagePaymentEvent(
          token: token,
          packageId: mBuypackageId,
          amt: amt,
          pgRes: jsonEncode(mRazorpaySuccessRes)));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      mShowProgress = false;
    });
    debugPrint("PAYMENT_ERROR ------- > ${response.message}");
    showSnakbar(_scaffoldKey, response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint(
        "PAYMENT_EXT_WALLET ------- > ${jsonEncode(response.walletName)}");
    setState(() {
      mShowProgress = false;
    });
  }

  redirectToWebView(String mWebLink, AdPostReqModel adPostReqModel) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AppPage2("Rentozo", mWebLink, adPostReqModel)),
    );
  }

  void openCheckout(String amt, String packageName, String userPackageId,
      String packageId) async {
    setState(() {
      mShowProgress = true;
    });
    var amtNum = int.parse(amt);
    var finalAmt = amtNum * 100;
    debugPrint("PAYYYY ${finalAmt} for $packageId");
    var options = {
      'key': RAZORPAY_KEY,
      'amount': "${finalAmt}",
      'name': packageName,
      'description': 'Buy new package',
      'prefill': {
        'contact': '${loginResponse?.data?.contact}',
        'email': '${loginResponse?.data?.email}'
      },
      'external': {
        'wallets': ['paytm'],
      }
    };
    try {
      _razorpay.open(options);
//      var mWebLink =
//      "https://rentozo.com/webviewpayment/view/${packageId}/${loginResponse?.data?.id}";
//      redirectToWebView(mWebLink, widget.adPostReqModel);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc..add(AdUnderPackageEvent(token: token)),
      child: BlocListener(
          cubit: homeBloc,
          listener: (context, state) {
            if (state is AdUnderPackageState) {
              mGetNotificationResponse = state.res;
            } else if (state is PackagePaymentState) {
              if (state.res != null) {
                debugPrint("GOTRES_POSTADS ${state.res.status}");
                if (state.res != null && state.res.status == "success") {
                  homeBloc..add(AdUnderPackageEvent(token: token));
                }
                if (state.res != null && state.res.msg != null) {
                  Fluttertoast.showToast(
                      msg: state.res.msg,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: space_14);
                }
              }
            } else if (state is PostAdsState) {
              if (state.res != null && state.res.msg != null) {
//                showSnakbar(_scaffoldKey, state.res.msg);
                Fluttertoast.showToast(
                    msg: state.res.msg,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: space_14);
                if (state.res.status != null &&
                    (state.res.status == "success" ||
                        state.res.status == "true")) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              isRedirectToMyAds: true,
                            )),
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
                      padding: EdgeInsets.only(
                          left: space_15, top: space_20, bottom: space_15),
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
                        child: ListView.builder(
                            itemCount: adUnderPackageRes.data.length,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            itemBuilder: (context, index) {
                              if (adUnderPackageRes
                                      .data[index].purchase_button ==
                                  "show") {
                                return ListTile(
                                  key: Key("${index}"),
//                                  leading: Icon(Icons.notification_important),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: CommonStyles.blue),
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(space_5),
                                                  bottomLeft:
                                                      Radius.circular(space_5),
                                                  topRight:
                                                      Radius.circular(space_0),
                                                  bottomRight:
                                                      Radius.circular(space_0)),
                                              color: CommonStyles.primaryColor,
                                          ),
                                          padding:
                                          const EdgeInsets.all(space_10),
                                          child: Text(
                                            adUnderPackageRes
                                                    .data[index].package_name +
                                                "   No. Post: ${adUnderPackageRes.data[index].no_of_posts}   Days: ${adUnderPackageRes.data[index].no_of_days}    ",
                                            style:
                                                CommonStyles.getMontserratStyle(
                                                    space_15,
                                                    FontWeight.w600,
                                                    Colors.white),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          mBuypackageId = adUnderPackageRes
                                              .data[index].package_id;
                                          openCheckout(
                                              adUnderPackageRes
                                                  .data[index].package_price,
                                              adUnderPackageRes
                                                  .data[index].package_name,
                                              adUnderPackageRes
                                                  .data[index].user_package_id,
                                              adUnderPackageRes
                                                  .data[index].package_id);
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.all(space_10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: CommonStyles.darkAmber),
                                              borderRadius:
                                              BorderRadius.circular(space_5),
                                          color: CommonStyles.blue),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Buy Now",
                                                style: CommonStyles
                                                    .getMontserratStyle(
                                                  space_15,
                                                  FontWeight.w600,
                                                  Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: space_8,),
                                              Text(
                                                "\u20B9 ${adUnderPackageRes
                                                    .data[index].package_price}",
                                                style: CommonStyles
                                                    .getMontserratStyle(
                                                        space_15,
                                                        FontWeight.w600,
                                                        Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          CommonStyles.darkAmber,
                                      selectedRowColor:
                                          CommonStyles.darkAmber,
                                      disabledColor: CommonStyles.darkAmber),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: space_15),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: CommonStyles.blue),
                                        borderRadius:
                                            BorderRadius.circular(space_15)),
                                    child: RadioListTile(
                                      groupValue: mSelectedPackageName,
                                      title: Text(
                                        adUnderPackageRes
                                                .data[index].package_name +
                                            " | ${adUnderPackageRes.data[index].no_of_posts} Post For ${adUnderPackageRes.data[index].no_of_days} Days",
                                        style: CommonStyles.getMontserratStyle(
                                            space_16,
                                            FontWeight.w600,
                                            CommonStyles.primaryColor),
                                      ),
                                      value: adUnderPackageRes
                                          .data[index].user_package_id,
                                      onChanged: (val) {
                                        debugPrint("Selected_Package - ${val}");
                                        setState(() {
                                          mSelectedPackageName = val;
                                          mSelectedPackageId = val;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: privacyPolicyLinkAndTermsOfService(),
                      value: mCheckedTnC,
                      onChanged: (bool value) {
                        setState(() {
                          mCheckedTnC = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        "I Agree to Follow proper covid guidelines before delivering product & services",
                        style: CommonStyles.getRalewayStyle(
                            space_12, FontWeight.w400, Colors.black),
                      ),
                      value: mCheckedCovidGuidelines,
                      onChanged: (bool value) {
                        setState(() {
                          mCheckedCovidGuidelines = value;
                        });
                      },
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
                mShowProgress
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      )
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
    if (mSelectedPackageId.isEmpty) {
      showSnakbar(_scaffoldKey, empty_package);
    } else if (!mCheckedTnC) {
      showSnakbar(_scaffoldKey, accept_tnc);
    } else if (!mCheckedCovidGuidelines) {
      showSnakbar(_scaffoldKey, accept_covid_tnc);
    } else {
      //api call
      widget.adPostReqModel.packageId = mSelectedPackageId;
      homeBloc
        ..add(
            PostAdsEvent(token: token, adPostReqModel: widget.adPostReqModel));
    }
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
          child: Text.rich(TextSpan(
              text: 'By continuing, you agree to our ',
              style: CommonStyles.getRalewayStyle(
                  space_12, FontWeight.w400, Colors.black),
              children: <TextSpan>[
            TextSpan(
                text: 'Terms and Conditions',
                style: CommonStyles.getMontserratDecorationStyle(space_12,
                    FontWeight.w400, Colors.black, TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchURL(
                        "https://rentozo.com/home/page/terms-and-conditions");
                  }),
            TextSpan(
                text: ' and ',
                style: CommonStyles.getRalewayStyle(
                    space_12, FontWeight.w400, Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Privacy Policy',
                      style: CommonStyles.getMontserratDecorationStyle(
                          space_12,
                          FontWeight.w400,
                          Colors.black,
                          TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchURL(
                              "https://rentozo.com/home/page/privacy-policy");
                        })
                ])
          ]))),
    );
  }
}

class AppPage2 extends StatefulWidget {
  final String _appTitle;
  final String _connectionString;
  AdPostReqModel adPostReqModel;

  AppPage2(this._appTitle, this._connectionString, this.adPostReqModel);

  @override
  _AppPage2State createState() =>
      _AppPage2State(this._appTitle, this._connectionString);
}

class _AppPage2State extends State<AppPage2> {
  final String _appTitle;
  String connectionString;
  num _stackToView = 1;
  bool launchFileInProgress = false;
  bool shouldChangeStack = true;
  final _key = GlobalKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _AppPage2State(this._appTitle, this.connectionString);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(_appTitle)),
      child: Container(
        child: SafeArea(
          child: IndexedStack(
            index: _stackToView,
            children: <Widget>[
              WebView(
                key: _key,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: this.connectionString,
                onPageStarted: (value) => setState(() {
                  debugPrint("URL --> ${value}");
                  if (shouldChangeStack) {
                    _stackToView = 1;
                  } else {
                    _stackToView = 0;
                  }
                }),
                onPageFinished: (value) => setState(() {
                  _stackToView = 0;
                }),
                onWebViewCreated: (WebViewController tmp) {
                  _controller.complete(tmp);
                },
                navigationDelegate: (NavigationRequest request) async {
                  print(request.url);
//                  if (request.url.contains("download")) {
                  setState(() {
                    shouldChangeStack = true;
                    connectionString = request.url;
                  });
//                    if (await canLaunch(request.url)) {
//                      await launch(request.url);
//                    }
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: WebView(
                            javascriptMode: JavascriptMode.unrestricted,
                            initialUrl: request.url,
                            onPageStarted: (value) => {
                              if (value?.contains("success"))
                                {
                                  debugPrint("URL2 -->> ${value}"),
                                  Navigator.pop(context),
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              AdUnderPackageListScreen(
                                                  widget.adPostReqModel))),
//                            Navigator.pop(context, "success")
                                }
                              else if (value?.contains("failure"))
                                {
                                  debugPrint("URL2 -->> ${value}"),
                                  Navigator.pop(context),
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              AdUnderPackageListScreen(
                                                  widget.adPostReqModel))),
                                }
                            },
                          ),
                        ));
                      });
                  return NavigationDecision.prevent;
//                  } else {
//                    setState(() {
//                      shouldChangeStack = true;
//                    });
//                    return NavigationDecision.navigate;
//                  }
                },
              ),
              Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
          top: true,
        ),
      ),
    );
  }
}
