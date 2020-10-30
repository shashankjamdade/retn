import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController currentPwdController = new TextEditingController();
  TextEditingController newPwdController = new TextEditingController();
  TextEditingController confirmPwdController = new TextEditingController();
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
                  PostAdsCommonAppbar(title: "Change Password"),
                  Padding(padding: EdgeInsets.only(left: space_15, top: space_20, bottom: space_20),
                    child: Text("Manage Password", style: CommonStyles.getMontserratStyle(space_14, FontWeight.w700, Colors.black),),
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
                              currentPwdController, "Current Password", true,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter type name";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        NormalTextInputWidget(
                              newPwdController, "New Password", true,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter brand name";
                                }
                              }, TextInputType.text),
                          SizedBox(
                            height: space_15,
                          ),
                        NormalTextInputWidget(
                              confirmPwdController, "Confirm Password", true,
                                  (String value) {
                                if (value.isEmpty) {
                                  return "Please enter loren";
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
                        color: CommonStyles.green,
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(space_15),
                            child: Text("Update Password", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, Colors.white),)),
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
    if (currentPwdController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_password);
    } else if (newPwdController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_new_password);
    } else if (confirmPwdController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_conf_password);
    }  else if (confirmPwdController.text.trim() != newPwdController.text.trim()) {
      showSnakbar(_scaffoldKey, pwd_no_match);
    }  else {
      //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
    }
  }
}
