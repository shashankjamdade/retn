import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class RentalPriceScreen extends StatefulWidget {
  @override
  _RentalPriceScreenState createState() => _RentalPriceScreenState();
}

class _RentalPriceScreenState extends State<RentalPriceScreen> {
  TextEditingController priceController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> daysList = List();
  String days = "10";
  String month = "";
  String year = "";

  @override
  void initState() {
    super.initState();
    daysList.add("10");
    daysList.add("20");
    daysList.add("30");
    daysList.add("40");
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostAdsCommonAppbar(title: "Rental"),
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_15, top: space_20, bottom: space_20),
                    child: Text(
                      "PRICE",
                      style: CommonStyles.getMontserratStyle(
                          space_14, FontWeight.w700, Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: space_20,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          NormalTextInputWidget(priceController, "₹", false,
                              (String value) {
                            if (value.isEmpty) {
                              return "";
                            }
                          }, TextInputType.text),
                          SizedBox(
                            height: space_20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text("Rental Duration", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, CommonStyles.grey),),
                              ),
                           Expanded(
                                flex: 2,
                                child: Text("Day", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w600, CommonStyles.blue),),
                              ),
                           Expanded(
                                flex: 3,
                                child: Container(
                                  child: DropdownButtonFormField(
                                    key: Key("value"),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white))),
                                    value: days,
                                    iconSize: 20.0,
                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.black,),
                                    items: (daysList != null && daysList.length > 0)
                                        ? daysList.map(
                                          (val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                                padding: EdgeInsets.only(left: space_10),
                                                child: Text(val, style: CommonStyles.getMontserratStyle(space_12, FontWeight.w600, Colors.black), textAlign: TextAlign.right,)),
                                          ),
                                        );
                                      },
                                    ).toList()
                                        : ['No List'].map(
                                          (val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      //Method
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(height: space_1, thickness: space_1, color: Colors.black,),
                          SizedBox(
                            height: space_15,
                          ),
                        ],
                      ),
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
                        color: CommonStyles.blue,
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(space_15),
                            child: Text(
                              "Next",
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500, Colors.white),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void onSubmit() {
    if (priceController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_type);
    }  else {
      //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
    }
  }
}
