import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/RazorpaySuccessRes.dart';

//import 'package:flutter_rentry_new/model/RazorpaySuccessRes.dart';
import 'package:flutter_rentry_new/model/get_all_package_list_response.dart';
import 'package:flutter_rentry_new/model/login_response.dart';
import 'package:flutter_rentry_new/screens/MyPackageListScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart'; //for date format

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  HomeBloc homeBloc = new HomeBloc();
  GetAllPackageListResponse mGetAllPackageListResponse;
  LoginResponse loginResponse;
  var token = "";
  // var _razorpay = Razorpay();

 var _razorpay = Razorpay();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var mSelectedPackageName = "";
  var mSelectedPackageId = "";
  var mBuypackageId = "";
  var mSelectedPackageAmt = "";
  WebViewController webViewController;
  String htmlFilePath = 'assets/razorpay.html';
  var isWebviewLaunch = false;
  String mWebLink = "";
  double progress = 0;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  num _stackToView = 1;

  loadLocalHTML() async {
    String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
    webViewController.loadUrl(mWebLink);
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
    showSnakbar(_scaffoldKey, "Something went wrong, Please try again");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint(
        "PAYMENT_EXT_WALLET ------- > ${jsonEncode(response.walletName)}");
  }

  void openCheckout(String amt, String id, String title) async {
    var amtNum = int.parse(amt);
    debugPrint("PAYMENT_CHECKOUT");
    mSelectedPackageId = id;
    mSelectedPackageName = title;
    mSelectedPackageAmt = amt;
    var options = {
      'key': RAZORPAY_KEY,
      'amount': "${amtNum*100}",
      'name': 'Rentozo',
      'description': 'Buy new package',
      'prefill': {'contact': '${loginResponse?.data?.contact}', 'email': '${loginResponse?.data?.email}'},
      'external': {
        'wallets': ['paytm'],
      }
    };
    try {
      mSelectedPackageId = id;
      mSelectedPackageName = title;
      mSelectedPackageAmt = amt;
      _razorpay.open(options);
     // setState(() {
     //   isWebviewLaunch = true;
     //   mWebLink =
     //       "https://rentozo.com/webviewpayment/view/${mSelectedPackageId}/${loginResponse?.data?.id}";
     // });
     // redirectToWebView(mWebLink);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc..add(GetAllPackageListEvent(token: token)),
      child: BlocListener(
        cubit: homeBloc,
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
    var isCurrPackageAdded = false;
    getAllPackageListResponse.data.forEach((element) {
      if (!isCurrPackageAdded/*element.sort_order == "0"*/) {
        currentPackage = element;
        isCurrPackageAdded = true;
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
                                                    space_20,
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
                                            style: CommonStyles.getMontserratStyle(
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
                                  Text(
                                    "${currentPackage?.no_of_posts} ${currentPackage?.no_of_posts.length==1?"Post":"Posts"} for ${currentPackage?.no_of_days} ${currentPackage?.no_of_days.length==1?"Day":"Days"}",
                                    style: CommonStyles
                                        .getMontserratStyle(
                                        space_15,
                                        FontWeight.w600,
                                        Colors.white),
                                  ),
                                 /* Row(
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
                                  )*/
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
                            /*GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: space_5,
                                    bottom: space_5,
                                    left: space_10),
                                child: Text(
                                  "",
                                  style: CommonStyles.getRalewayStyle(space_13,
                                      FontWeight.w500, CommonStyles.blue),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Container(
                          height: space_250,
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
                                        PackageCardWidget(packageList[index], (){
                                          openCheckout(
                                              packageList[index].price,
                                              packageList[index].id,
                                              packageList[index].title);
                                        }));
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
            /* isWebviewLaunch
                ?Column(
                    children: [
                      Expanded(
                        child: WebView(
                          initialUrl: mWebLink,
                          javascriptMode: JavascriptMode.unrestricted,
                         onPageStarted: (String url) {
                            print('Page started loading: $url');
                          },
                          onPageFinished: (String url) {
                            print('Page finished loading: $url');
                          },
                          gestureNavigationEnabled: true,
                          navigationDelegate: (NavigationRequest request) {
                            print('allowing navigation to $request');
                            webViewController.loadUrl(request.url);
                            return NavigationDecision.navigate;
                          },
                          onWebViewCreated: (WebViewController tmp) {
                            webViewController = tmp;
                            _controller.complete(webViewController);
                          },
                        ),
                      ),
                    ],
                  )
//            Container(
//              width: space_0,
//              height: space_0,
//            )
                : Container(
                    width: space_0,
                    height: space_0,
                  ),*/
          ],
        ),
      ),
    ));
  }

  redirectToWebView(String mWebLink)async{
    var res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppPage("Rentozo", mWebLink)),
    );
  }
}

class AppPage extends StatefulWidget {
  final String _appTitle;
  final String _connectionString;

  AppPage(this._appTitle, this._connectionString);

  @override
  _AppPageState createState() =>
      _AppPageState(this._appTitle, this._connectionString);
}

class _AppPageState extends State<AppPage> {
  final String _appTitle;
  String connectionString;
  num _stackToView = 1;
  bool launchFileInProgress = false;
  bool shouldChangeStack = true;
  final _key = GlobalKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _AppPageState(this._appTitle, this.connectionString);

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
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (builder) {
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: space_40),
                          child: Center(
                            child: WebView(
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: request.url,
                              onPageStarted: (value) => {
                                if (value?.contains("success"))
                                  {
                                    debugPrint("URL2 -->> ${value}"),
                                    Navigator.pop(context),
                                    Navigator.of(context)
                                        .pushReplacement(new MaterialPageRoute(builder: (context) => PackageScreen())),
//                            Navigator.pop(context, "success")
                                  }
                                else if (value?.contains("failure"))
                                  {
                                    debugPrint("URL2 -->> ${value}"),
                                    Navigator.pop(context),
                                    Navigator.of(context)
                                        .pushReplacement(new MaterialPageRoute(builder: (context) => PackageScreen())),
                                  }
                              },
                            ),
                          ),
                        );
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
