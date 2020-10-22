import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rentry/utils/CommonStyles.dart';
import 'package:flutter_rentry/utils/size_config.dart';
import 'package:flutter_rentry/widgets/CommonWidget.dart';

class BottomBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black54,
          ),
          CommonBottomNavBarWidget()
        ],
      ),
    );
  }

}
