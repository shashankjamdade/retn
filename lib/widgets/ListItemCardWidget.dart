import 'package:flutter/material.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/Constants.dart';
import 'package:flutter_rentry/utils/size_config.dart';

import 'CommonWidget.dart';

class ListItemCardWidget extends StatefulWidget {
  String type;

  ListItemCardWidget(this.type);

  @override
  _ListItemCardWidgetState createState() => _ListItemCardWidgetState();
}

class _ListItemCardWidgetState extends State<ListItemCardWidget> {
  String text1;
  String text2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_400,
      color: CommonStyles.blue.withOpacity(0.1),
      child: Column(
        children: [
          RichTextTitleBtnWidget("TOP", getRichText2ByType(widget.type), () {
            onViewAllClick(context, widget.type);
          }),
          Container(
            height: space_300,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                      height: space_300, child: ItemCardWidget());
                }),
          ),
        ],
      ),
    );
  }


}
