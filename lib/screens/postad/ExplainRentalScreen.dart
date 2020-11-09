import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/screens/postad/UploadProductImgScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class ExplainRentalScreen extends StatefulWidget {
  @override
  _ExplainRentalScreenState createState() => _ExplainRentalScreenState();
}

class _ExplainRentalScreenState extends State<ExplainRentalScreen> {

  TextEditingController typeController = new TextEditingController();
  TextEditingController brandController = new TextEditingController();
  TextEditingController lorenController = new TextEditingController();
  TextEditingController ipsumController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  PostAdsCommonAppbar(title: "What are you offering?"),
                  Padding(padding: EdgeInsets.only(left: space_15, top: space_20, bottom: space_20),
                    child: Text("INCLUDE INFORMATION", style: CommonStyles.getMontserratStyle(space_14, FontWeight.w700, Colors.black),),
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
                          NormalTextInputWidget(
                              typeController, "Type*", false,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter type name";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        NormalTextInputWidget(
                              brandController, "Brand*", false,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter brand name";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        NormalTextInputWidget(
                              lorenController, "Loren*", false,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter loren";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        NormalTextInputWidget(
                            ipsumController, "Ipsum*", false,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter ipsum";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        NormalTextInputWidget(
                              titleController, "Title*", false,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter title";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        NormalTextInputWidget(
                              descriptionController, "Description*", false,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter description";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){onSubmit();},
                    child: Container(
                      margin: EdgeInsets.only(left: space_15, right: space_15, bottom: space_35, top: space_15),
                      height: space_50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_5),
                        color: CommonStyles.blue,
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(space_15),
                            child: Text("Next", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, Colors.white),)),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    )
    );
  }

  void onSubmit() {
    if (typeController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_type);
    } else if (brandController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_brand);
    } else if (lorenController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_loren);
    } else if (ipsumController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_ipsum);
    } else if (titleController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_title);
    } else if (descriptionController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_desc);
    }  else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadProductImgScreen()),
      );
      //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
    }
  }
}
