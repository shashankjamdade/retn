import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/get_category_response.dart';
import 'package:flutter_rentry_new/model/home_response.dart';
import 'package:flutter_rentry_new/model/my_ads_edit_res.dart';
import 'package:flutter_rentry_new/screens/SubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/editAds/EditAdsSubCategoryScreen.dart';
import 'package:flutter_rentry_new/screens/postad/PostAdsSubCategoryScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';

class PostAdsCommonAppbar extends StatelessWidget {
  String title;

  PostAdsCommonAppbar({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_60,
      color: CommonStyles.primaryColor,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white.withOpacity(0.2),
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
                padding: EdgeInsets.only(left: space_25),
                child: Text(
                  title,
                  style: CommonStyles.getMontserratStyle(
                      space_15, FontWeight.w500, Colors.white),
                )),
          )
        ],
      ),
    );
  }
}

class PostAdCategoryGridWidget extends StatelessWidget {
  GetCategoryResponse mGetCategoryResponse;

  PostAdCategoryGridWidget(this.mGetCategoryResponse);

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: space_15, vertical: space_15),
      elevation: space_3,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(space_15)),
      child: Container(
        padding:
            EdgeInsets.only(bottom: space_15, left: space_15, right: space_15),
        decoration: BoxDecoration(
            gradient: cardGradient(),
            borderRadius: BorderRadius.circular(space_15)),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          primary: false,
          children: List.generate(mGetCategoryResponse?.data?.length, (index) {
            return Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostAdsSubCategoryScreen(
                                adPostReqModel: new AdPostReqModel(
                              categoryId: mGetCategoryResponse.data[index].id,
                              categoryName: mGetCategoryResponse.data[index].name,
                            ))),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border(
                        top: BorderSide(
                            width: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? space_1
                                : space_0,
                            color: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        bottom: BorderSide(
                            width: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? space_1
                                : space_0,
                            color: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        right: BorderSide(
                            width: (index + 1) % 3 == 0 ? space_0 : space_1,
                            color: (index + 1) % 3 == 0
                                ? Colors.transparent
                                : CommonStyles.grey.withOpacity(0.5)),
                      )),
                  child: Container(
                    padding: EdgeInsets.all(space_5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: "assets/images/app_img_white.png",
                          image: mGetCategoryResponse.data[index].picture,
                          fit: BoxFit.fill,
                          height: iconSize,
                          width: iconSize,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: space_5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: space_10),
                                      child: Text(
                                        "${mGetCategoryResponse.data[index].name}",
                                        textAlign: TextAlign.center,
                                        style: CommonStyles.getRalewayStyle(
                                            space_12,
                                            FontWeight.w500,
                                            CommonStyles.primaryColor),
                                      ))),
                              Container(
                                  height: space_15,
                                  width: space_15,
                                  margin: EdgeInsets.only(left: space_3),
                                  decoration: BoxDecoration(
                                      color: CommonStyles.primaryColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_right,
                                      color: Colors.white,
                                      size: space_12,
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AllCategoryGridWidget extends StatelessWidget {
  GetCategoryResponse mGetCategoryResponse;

  AllCategoryGridWidget(this.mGetCategoryResponse);

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: space_15, vertical: space_15),
      elevation: space_3,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(space_15)),
      child: Container(
        padding:
            EdgeInsets.only(bottom: space_15, left: space_15, right: space_15),
        decoration: BoxDecoration(
            gradient: cardGradient(),
            borderRadius: BorderRadius.circular(space_15)),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          primary: false,
          children: List.generate(mGetCategoryResponse?.data?.length, (index) {
            return Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubCategoryScreen(
                          categoryId: mGetCategoryResponse.data[index].id,
                          categoryName: mGetCategoryResponse.data[index].name,
                        )),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border(
                        top: BorderSide(
                            width: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? space_1
                                : space_0,
                            color: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        bottom: BorderSide(
                            width: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? space_1
                                : space_0,
                            color: index >= 3 &&
                                    index < mGetCategoryResponse.data.length - 3
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        right: BorderSide(
                            width: (index + 1) % 3 == 0 ? space_0 : space_1,
                            color: (index + 1) % 3 == 0
                                ? Colors.transparent
                                : CommonStyles.grey.withOpacity(0.5)),
                      )),
                  child: Container(
                    padding: EdgeInsets.all(space_5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: "assets/images/app_img_white.png",
                          image: mGetCategoryResponse.data[index].picture,
                          fit: BoxFit.fill,
                          height: iconSize,
                          width: iconSize,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: space_5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: space_10),
                                      child: Text(
                                        "${mGetCategoryResponse.data[index].name}",
                                        textAlign: TextAlign.center,
                                        style: CommonStyles.getRalewayStyle(
                                            space_12,
                                            FontWeight.w500,
                                            CommonStyles.primaryColor),
                                      ))),
                              Container(
                                  height: space_15,
                                  width: space_15,
                                  margin: EdgeInsets.only(left: space_3),
                                  decoration: BoxDecoration(
                                      color: CommonStyles.primaryColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_right,
                                      color: Colors.white,
                                      size: space_12,
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class EditAdCategoryGridWidget extends StatelessWidget {
  MyAdsEditRes mMyAdsEditRes;

  EditAdCategoryGridWidget(this.mMyAdsEditRes);

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: space_15),
      elevation: space_3,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(space_15)),
      child: Container(
        padding:
            EdgeInsets.only(bottom: space_15, left: space_15, right: space_15),
        decoration: BoxDecoration(
            gradient: cardGradient(),
            borderRadius: BorderRadius.circular(space_15)),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          primary: false,
          children:
              List.generate(mMyAdsEditRes?.data?.category?.length, (index) {
            return Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAdsSubCategoryScreen(
                            adPostReqModel: new AdPostReqModel(
                              adId: mMyAdsEditRes?.data?.post?.id,
                              categoryId:
                                  mMyAdsEditRes?.data?.category[index].id,
                              categoryName: mMyAdsEditRes?.data?.category[index].name
                            ),
                            mMyAdsEditRes: mMyAdsEditRes)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color:
                          (mMyAdsEditRes?.data?.category[index].is_selected !=
                                      null &&
                                  (mMyAdsEditRes?.data?.category[index]
                                              .is_selected ==
                                          1 ||
                                      mMyAdsEditRes?.data?.category[index]
                                              .is_selected ==
                                          "1"))
                              ? CommonStyles.grey
                              : Colors.transparent,
                      border: Border(
                        top: BorderSide(
                            width: index >= 3 &&
                                    index <
                                        mMyAdsEditRes?.data?.category.length - 3
                                ? space_1
                                : space_0,
                            color: index >= 3 &&
                                    index <
                                        mMyAdsEditRes?.data?.category.length - 3
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        bottom: BorderSide(
                            width: index >= 3 &&
                                    index <
                                        mMyAdsEditRes?.data?.category.length - 3
                                ? space_1
                                : space_0,
                            color: index >= 3 &&
                                    index <
                                        mMyAdsEditRes?.data?.category.length - 3
                                ? CommonStyles.grey.withOpacity(0.5)
                                : Colors.transparent),
                        right: BorderSide(
                            width: (index + 1) % 3 == 0 ? space_0 : space_1,
                            color: (index + 1) % 3 == 0
                                ? Colors.transparent
                                : CommonStyles.grey.withOpacity(0.5)),
                      )),
                  child: Container(
                    padding: EdgeInsets.all(space_5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: "assets/images/app_img_white.png",
                          image: mMyAdsEditRes?.data?.category[index].picture,
                          fit: BoxFit.fill,
                          height: iconSize,
                          width: iconSize,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: space_5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: space_10),
                                      child: Text(
                                        "${mMyAdsEditRes?.data?.category[index].name}",
                                        textAlign: TextAlign.center,
                                        style: CommonStyles.getRalewayStyle(
                                            space_12,
                                            FontWeight.w500,
                                            CommonStyles.primaryColor),
                                      ))),
                              Container(
                                  height: space_15,
                                  width: space_15,
                                  margin: EdgeInsets.only(left: space_3),
                                  decoration: BoxDecoration(
                                      color: CommonStyles.primaryColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_right,
                                      color: Colors.white,
                                      size: space_12,
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
