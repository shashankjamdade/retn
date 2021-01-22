import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/common_response.dart';
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
  HomeBloc homeBloc = new HomeBloc();
  CommonResponse commonResponse;
  var loginResponse;
  var token = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_HOME_SCREEN---------");
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
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => homeBloc..add(InitialEvent()),
        child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is ChangePwdResState) {
              commonResponse = state.res;
              showSnakbar(_scaffoldKey, commonResponse.msg);
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            return getScreenUI(state);
          }),
        ));
  }

  Widget getScreenUI(HomeState state) {
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_15, top: space_20, bottom: space_20),
                    child: Text(
                      "Manage Password",
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
                  (state is ProgressState)
                      ? Container(
                          margin: EdgeInsets.only(
                              left: space_15,
                              right: space_15,
                              bottom: space_35,
                              top: space_15),
                          height: space_50,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : GestureDetector(
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
                              borderRadius: BorderRadius.circular(space_5),
                              color: CommonStyles.green,
                            ),
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(space_15),
                                  child: Text(
                                    "Update Password",
                                    style: CommonStyles.getRalewayStyle(
                                        space_14,
                                        FontWeight.w500,
                                        Colors.white),
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
    if (currentPwdController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_password);
    } else if (newPwdController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_new_password);
    } else if (confirmPwdController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_conf_password);
    } else if (confirmPwdController.text.trim() !=
        newPwdController.text.trim()) {
      showSnakbar(_scaffoldKey, pwd_no_match);
    } else {
      //API hit
      homeBloc
        ..add(ChangePwdEvent(
            token: token,
            pwd: currentPwdController.text.trim(),
            newpwd: confirmPwdController.text.trim()));
//      BlocProvider.of<AuthenticationBloc>(_context)
    }
  }
}
