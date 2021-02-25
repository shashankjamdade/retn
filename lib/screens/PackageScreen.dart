import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/RazorpaySuccessRes.dart';
import 'package:flutter_rentry_new/model/get_all_package_list_response.dart';
import 'package:flutter_rentry_new/screens/MyPackageListScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart'; //for date format

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  HomeBloc homeBloc = new HomeBloc();
  GetAllPackageListResponse mGetAllPackageListResponse;
  var loginResponse;
  var token = "";
  var _razorpay = Razorpay();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var mSelectedPackageName = "";
  var mSelectedPackageId = "";
  var mBuypackageId = "";
  var mSelectedPackageAmt = "";
  WebViewController webViewController;
  String htmlFilePath = 'assets/razorpay.html';
  var isWebviewLaunch = false;

  loadLocalHTML() async {
    String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
    webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      debugPrint("ACCESSING_INHERITED ${token}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("PAYMENT_SUCCESS ------- > ${jsonEncode(response.paymentId)}");
    var amt = "";
//    setState(() {
//      mSelectedPackageId = mBuypackageId;
//    });
    mGetAllPackageListResponse.data.forEach((element) {
      if (element.id == mSelectedPackageId) {
        amt = element.price;
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
          packageId: mSelectedPackageId,
          amt: amt,
          pgRes: jsonEncode(mRazorpaySuccessRes)));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("PAYMENT_ERROR ------- > ${response.message}");
    showSnakbar(_scaffoldKey, response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint(
        "PAYMENT_EXT_WALLET ------- > ${jsonEncode(response.walletName)}");
  }

  void openCheckout(String amt, String id, String title) async {
    var amtNum = int.parse(amt);
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': "${amtNum*100}",
      'name': 'Rentozo',
      'description': 'Buy new package',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm'],
      }
    };
    try {
      mSelectedPackageId = id;
      mSelectedPackageName = title;
      mSelectedPackageAmt = amt;
      _razorpay.open(options);
//      setState(() {
//        isWebviewLaunch = true;
//      });
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc..add(GetAllPackageListEvent(token: token)),
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is GetAllPackageListResState) {
            mGetAllPackageListResponse = state.res;
          } else if (state is PackagePaymentState) {
            if (state.res != null && state.res.status == "success") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPackageListScreen()),
              );
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is GetAllPackageListResState) {
            return getScreenUI(state.res);
          } else if (state is PackagePaymentState) {
            if (state.res != null) {
              debugPrint("GOTRES_POSTADS ${state.res.status}");
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
            return getScreenUI(mGetAllPackageListResponse);
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }),
      ),
    );
  }

  getScreenUI(GetAllPackageListResponse getAllPackageListResponse) {
    var packageList = new List<GetAllPackageData>();
    var currentPackage = new GetAllPackageData();
    getAllPackageListResponse.data.forEach((element) {
      if (element.sort_order == "0") {
        currentPackage = element;
      } else {
        packageList.add(element);
      }
    });
    var currentPackFromDate;
    var currentPackToDate;
    var currentPackFromDateStr;
    var currentPackToDateStr;
    if (currentPackage != null &&
        currentPackage.updated_date != null &&
        currentPackage.no_of_days != null) {
      currentPackFromDate = DateTime.parse("${currentPackage.updated_date}");
      currentPackToDate = currentPackFromDate
          .add(Duration(days: int.parse(currentPackage.no_of_days)));
      DateFormat dateFormatter = new DateFormat('dd MMM yyyy');
      currentPackFromDateStr = dateFormatter.format(currentPackFromDate);
      currentPackToDateStr = dateFormatter.format(currentPackToDate);

//       currentPackFromDate = currentPackFromDate.toString().split(" ")[0];
//       currentPackToDate = currentPackToDate.toString().split(" ")[0];
    }

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: space_15, vertical: space_25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PACKAGES",
                              style: CommonStyles.getMontserratStyle(
                                  space_14, FontWeight.w600, CommonStyles.blue),
                            ),
                            RichTextTitleWidget(
                                "STATER", "${currentPackage.title}"),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: space_15,
                                right: space_15,
                                bottom: space_15),
                            height: space_200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(space_15),
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/current_package_back.png",
                                    ),
                                    fit: BoxFit.fill)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: space_25, vertical: space_15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "STATER",
                                            style: CommonStyles.getRalewayStyle(
                                                space_15,
                                                FontWeight.w600,
                                                Colors.white),
                                          ),
                                          Text(
                                            "${currentPackage.title}",
                                            style:
                                                CommonStyles.getMontserratStyle(
                                                    space_25,
                                                    FontWeight.w900,
                                                    Colors.white),
                                          ),
                                          Text(
                                            "PACK",
                                            style: CommonStyles.getRalewayStyle(
                                                space_15,
                                                FontWeight.w500,
                                                Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Align(
                                              child: Text(
                                            "\u20B9",
                                            style: CommonStyles.getRalewayStyle(
                                                space_30,
                                                FontWeight.w400,
                                                CommonStyles.primaryColor),
                                          )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "",
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_15,
                                                        FontWeight.w600,
                                                        Colors.white),
                                              ),
                                              Text(
                                                "${currentPackage.price}",
                                                style: CommonStyles
                                                    .getMontserratStyle(
                                                        space_25,
                                                        FontWeight.w900,
                                                        CommonStyles
                                                            .primaryColor),
                                              ),
                                              Text(
                                                "month",
                                                style: CommonStyles
                                                    .getRalewayStyle(
                                                        space_15,
                                                        FontWeight.w500,
                                                        CommonStyles
                                                            .primaryColor),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: space_10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          text: new TextSpan(
                                            text: "Valid from",
                                            style: CommonStyles.getRalewayStyle(
                                                space_13,
                                                FontWeight.w500,
                                                CommonStyles.primaryColor),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text:
                                                      '\n${currentPackFromDateStr}',
                                                  style: CommonStyles
                                                      .getMontserratStyle(
                                                          space_13,
                                                          FontWeight.w800,
                                                          CommonStyles
                                                              .primaryColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: new TextSpan(
                                            text: "Valid till",
                                            style: CommonStyles.getRalewayStyle(
                                                space_13,
                                                FontWeight.w500,
                                                CommonStyles.primaryColor),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text:
                                                      '\n${currentPackToDateStr}',
                                                  style: CommonStyles
                                                      .getMontserratStyle(
                                                          space_13,
                                                          FontWeight.w800,
                                                          CommonStyles
                                                              .primaryColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: getProportionateScreenHeight(
                                context, space_250),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  openCheckout(currentPackage.price,
                                      currentPackage.id, currentPackage.title);
                                },
                                child: Container(
                                  height: space_50,
                                  width: space_120,
                                  child: Card(
                                    elevation: space_3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(space_5)),
                                    child: ClipRRect(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(space_5)),
                                        child: Center(
                                          child: Text(
                                            "Upgrade",
                                            style: CommonStyles.getRalewayStyle(
                                                space_14,
                                                FontWeight.w400,
                                                CommonStyles.blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: space_15, vertical: space_15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichTextTitleWidget("UPGRADE", "AND SAVE MORE"),
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: space_5,
                                    bottom: space_5,
                                    left: space_10),
                                child: Text(
                                  "SHOW MORE",
                                  style: CommonStyles.getRalewayStyle(space_13,
                                      FontWeight.w500, CommonStyles.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                          height: space_220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: packageList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      openCheckout(
                                          packageList[index].price,
                                          packageList[index].id,
                                          packageList[index].title);
                                    },
                                    child:
                                        PackageCardWidget(packageList[index]));
                              })),
                      SizedBox(
                        height: space_15,
                      ),
//                      Container(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: space_15, vertical: space_15),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            RichTextTitleWidget("HISTORY", ""),
//                            GestureDetector(
//                              onTap: () {},
//                              child: Padding(
//                                padding: const EdgeInsets.only(
//                                    top: space_5,
//                                    bottom: space_5,
//                                    left: space_10),
//                                child: Text(
//                                  "SHOW MORE",
//                                  style: CommonStyles.getRalewayStyle(space_13,
//                                      FontWeight.w500, CommonStyles.blue),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      SizedBox(
//                        height: space_5,
//                      ),
//                      Container(
//                          height: space_220,
//                          child: ListView.builder(
//                              scrollDirection: Axis.horizontal,
//                              itemCount: packageList.length,
//                              itemBuilder: (context, index) {
//                                return InkWell(
//                                    onTap: (){
//                                      openCheckout(packageList[index].price);
//                                    },
//                                    child: PackageCardWidget(packageList[index]));
//                              })),
                      SizedBox(
                        height: space_95,
                      ),
                    ],
                  ),
                )
              ],
            ),
            CommonBottomNavBarWidget(),
            isWebviewLaunch
                ? Column(
                    children: [
                      Expanded(
                        child: WebView(
                          initialUrl: '',
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController tmp) {
                            webViewController = tmp;
                            loadLocalHTML();
                          },
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: space_0,
                    height: space_0,
                  ),
          ],
        ),
      ),
    ));
  }
}
