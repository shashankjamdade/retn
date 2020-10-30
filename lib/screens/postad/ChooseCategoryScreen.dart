import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class ChooseCategoryScreen extends StatefulWidget {
  @override
  _ChooseCategoryScreenState createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostAdsCommonAppbar(title: "What are you offering?"),
                Padding(padding: EdgeInsets.only(left: space_15, top: space_20, bottom: space_20),
                child: Text("CHOOSE YOUR CATEGORY", style: CommonStyles.getMontserratStyle(space_14, FontWeight.w800, CommonStyles.blue),),
                ),
                PostAdCategoryGridWidget(),
              ],
            ),
        ),
      ),
    );
  }
}
