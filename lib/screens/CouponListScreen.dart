import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/coupon_res.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ReadMoreText.dart';

class CouponListScreen extends StatefulWidget {
  @override
  _CouponListScreenState createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  TrackingScrollController controller = TrackingScrollController();
  HomeBloc homeBloc = new HomeBloc();
  CouponRes mCouponRes;
  var loginResponse;
  var token = "";
  var mLat = "";
  var mLng = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_NOTIFICATION_SCREEN---------");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    loginResponse = StateContainer.of(context).mLoginResponse;
//    if (loginResponse != null) {
//      token = loginResponse.data.token;
//      debugPrint("ACCESSING_INHERITED ${token}");
//    }
    var selectedCurrentLoc = StateContainer.of(context).mUserLocationSelected;
    var selectedLoc = StateContainer.of(context).mUserLocNameSelected;
    if (selectedCurrentLoc != null) {
      mLat = selectedCurrentLoc.mlat;
      mLng = selectedCurrentLoc.mlng;
      debugPrint("ACCESSING_INHERITED_LOCATION ${mLat}, ${mLng} ------");
    } else if (selectedLoc != null) {
      mLat = selectedLoc.mlat;
      mLng = selectedLoc.mlng;
      debugPrint("ACCESSING_INHERITED_LOCATION ${mLat}, ${mLng} ------");
    }
//    mLat = "23.2599";
//    mLng = "77.4126";
  }

  @override
  Widget build(BuildContext context) {
    return mLat != null && mLat.isNotEmpty
        ? BlocProvider(
            create: (context) =>
                homeBloc..add(CouponEvent(lat: mLat, lng: mLng)),
            child: BlocListener(
                cubit: homeBloc,
                listener: (context, state) {
                  if (state is CouponState) {
                    mCouponRes = state.res;
                  }
                },
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is CouponState) {
                      return getScreenUI(state.res);
                    } else {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                )),
          )
        : ProgressWidget();
  }

  Widget getScreenUI(CouponRes couponRes) {
    if (!couponRes.status) {
      if (couponRes.data.length > 0) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                    child: Column(
                  children: [
                    CommonAppbarWidget(app_name, skip_for_now, () {
                      onSearchLocation(context);
                    }),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(space_15),
                        child: ListView.builder(
                            itemCount: couponRes.data.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return CouponWidget(mCouponRes?.data[index]);
                            }),
                      ),
                    ),
                    SizedBox(height: space_60,)
                  ],
                )),
                CommonBottomNavBarWidget(),
              ],
            ),
          ),
        );
      } else {
        return EmptyWidget("No offers found");
      }
    }
    /*else {
      return Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: space_15),
        child: Center(
          child: Text(
            getNotificationResponse.message,
            style: CommonStyles.getRalewayStyle(
                space_15, FontWeight.w600, Colors.black),
          ),
        ),
      );
    }*/
  }

  void onSearchClick() {}
}

class CouponWidget extends StatefulWidget {
  CouponData mCouponRes;

  CouponWidget(this.mCouponRes);

  @override
  _CouponWidgetState createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _launchURL(widget.mCouponRes?.slug);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        child: Card(
          elevation: space_3,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(space_10)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(space_10),
                      topRight: Radius.circular(space_10)),
                  child: Container(
                    width: double.infinity,
                    height: space_150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(space_10),
                            topRight: Radius.circular(space_10))),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/app_img_white.png",
                      image: widget.mCouponRes?.image != null &&
                              widget.mCouponRes?.image?.isNotEmpty
                          ? widget.mCouponRes?.image
                          : "",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: space_8, vertical: space_15),
                  child: Text(
                    widget.mCouponRes?.title != null &&
                            widget.mCouponRes?.title?.isNotEmpty
                        ? widget.mCouponRes?.title
                        : "",
                    style: CommonStyles.getMontserratStyle(
                        space_18, FontWeight.w600, Colors.black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: space_8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: space_8),
                          child: ReadMoreText(
                            widget.mCouponRes?.description != null &&
                                    widget.mCouponRes?.description?.isNotEmpty
                                ? widget.mCouponRes?.description
                                : "",
                            colorClickableText: CommonStyles.blue,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...read more ',
                            trimExpandedText: '...read less',
//                          expandText: 'show more',
//                          collapseText: 'show less',
                            trimLines: 2,
//                          linkColor: Colors.blue,
//                            style: CommonStyles.getMontserratStyle(
//                                space_14, FontWeight.w500, Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: space_15,
                      right: space_15,
                      top: space_8,
                      bottom: space_8),
                  height: space_3,
                  width: double.infinity,
                  color: CommonStyles.blue,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: space_8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(space_8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "COUPON",
                              style: CommonStyles.getMontserratStyle(
                                  space_14, FontWeight.w600, Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: DottedBorder(
                          color: CommonStyles.primaryColor,
                          strokeWidth: 1,
                          child: Container(
                            padding: EdgeInsets.all(space_8),
                            child: Center(
                              child: Text(
                                widget.mCouponRes?.coupon_code,
                                style: CommonStyles.getMontserratStyle(
                                    space_13, FontWeight.w600, Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(space_15),
                              color: CommonStyles.blue),
                          padding: EdgeInsets.all(space_8),
                          margin: EdgeInsets.symmetric(horizontal: space_8),
                          child: Center(
                            child: Text(
                              "COPY",
                              style: CommonStyles.getMontserratStyle(
                                  space_14, FontWeight.w600, Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
//    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ExpandableText extends StatefulWidget {
   ExpandableText(
      this.text, {
        Key key,
        this.trimLines = 2,
      })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... read more" : " read less",
        style: TextStyle(
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink
    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex)
                : widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}
