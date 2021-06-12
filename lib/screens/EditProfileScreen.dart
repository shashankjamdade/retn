import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/common_response.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';
import 'package:flutter_rentry_new/screens/postad/ChangePasswordScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  UserProfileResponse mUserprofileRes;

  EditProfileScreen(this.mUserprofileRes);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String userLocation = "";
  File _image;
  final picker = ImagePicker();
  HomeBloc homeBloc = new HomeBloc();
  var loginResponse;
  var token = "";
  var mSelectedProfileSetting = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController =
    new TextEditingController(text: widget.mUserprofileRes.data.username);
    aboutController = new TextEditingController();
    mobileController =
    new TextEditingController(text: widget.mUserprofileRes.data.contact);
    emailController =
    new TextEditingController(text: widget.mUserprofileRes.data.email);
    locationController = new TextEditingController(text: userLocation);
    mSelectedProfileSetting = widget.mUserprofileRes.data.profile_setting;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userSelectedLocation = StateContainer
        .of(context)
        .mUserLocationSelected;
    if (userSelectedLocation != null) {
      if (widget.mUserprofileRes.data.address != null) {
        userLocation = widget.mUserprofileRes.data
            .address; //+", "+widget.mUserprofileRes.data.city+", "+widget.mUserprofileRes.data.state;
      } else {
        userLocation = StateContainer
            .of(context)
            .mUserLocationSelected != null
            ? "${StateContainer
            .of(context)
            .mUserLocationSelected
            .address}, ${StateContainer
            .of(context)
            .mUserLocationSelected
            .city}, ${StateContainer
            .of(context)
            .mUserLocationSelected
            .state}"
            : "";
      }
      debugPrint("ACCESSING_INHERITED ${userLocation}");
      locationController = new TextEditingController(text: userLocation);
    }
    loginResponse = StateContainer
        .of(context)
        .mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, "true");
      },
      child: BlocProvider(
        create: (context) => homeBloc..add(InitialEvent()),
        child: BlocListener(
            cubit: homeBloc,
            listener: (context, state) {
              if ((state is ChangePwdResState || state is UserUpdateResState) &&
                  state.res is CommonResponse) {
                if (state.res.msg != null) {
                  showSnakbar(_scaffoldKey, state.res.msg);
                }
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return getScreenUI(state);
              },
            )),
      ),
    );
  }

  Widget getScreenUI(HomeState state) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Column(
              children: [
              CommonAppbarWidget(app_name, skip_for_now, () {
            onSearchLocation(context);
          }),
          (state is ProgressState)
              ? Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
              : Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: space_15, vertical: space_15),
              child: ListView(
                children: [
                Text(
                "Owner Info",
                style: CommonStyles.getRalewayStyle(
                    space_16, FontWeight.w600, Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: space_15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
//                            GestureDetector(
//                              onTap:(){
//                                getImage();
//                              },
//                              child: Container(
//                                height: space_35,
//                                width: space_35,
//                                margin: EdgeInsets.only(right: space_25),
//                                child: ClipRRect(
//                                  borderRadius: BorderRadius.circular(space_10),
//                                  child: Container(
//                                    color: CommonStyles.blue,
//                                    child: Center(
//                                      child: Icon(
//                                        Icons.edit,
//                                        color: Colors.white,
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      height: space_90,
                      width: space_90,
                      child: Stack(
                        children: [
                          Container(
                            height: space_80,
                            width: space_80,
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(space_10),
                              child: _image != null
                                  ? Image.file(
                                _image,
                                fit: BoxFit.cover,
                                width: space_80,
                                height: space_80,
                              )
                                  : FadeInImage.assetNetwork(
                                placeholder:
                                "assets/images/userlogo.png",
                                image: widget
                                    .mUserprofileRes
                                    .data
                                    .profile_picture !=
                                    null
                                    ? widget.mUserprofileRes
                                    .data.profile_picture
                                    : "http://rentozo.com/assets/img/user.jpg",
                                fit: BoxFit.contain,
                                width: space_80,
                                height: space_80,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: space_30,
                              height: space_30,
                              decoration: BoxDecoration(
                                  color: CommonStyles.primaryColor,
                                  borderRadius:
                                  BorderRadius.circular(
                                      space_15),
                                  border: Border.all(
                                      color: Colors.white)),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: space_15,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
//                            Container(
//                              height: space_35,
//                              width: space_35,
//                              margin: EdgeInsets.only(left: space_25),
//                              child: ClipRRect(
//                                borderRadius: BorderRadius.circular(space_10),
//                                child: Container(
//                                  color: CommonStyles.red,
//                                  child: Center(
//                                    child: Icon(
//                                      Icons.delete,
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ),
                ],
              ),
              SizedBox(
                height: space_25,
              ),
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
//                        NormalTextInputWidget(
//                            usernameController, "Full Name", false, (String value) {
//                          if (value.isEmpty) {
//                            return "";
//                          }
//                        }, TextInputType.text),
              SizedBox(
                height: space_15,
              ),
//                        Text(
//                          "About",
//                          style: CommonStyles.getRalewayStyle(
//                              space_16, FontWeight.w600, Colors.black),
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                        ),
//                        TextFormField(
//                          obscureText: false,
//                          controller: aboutController,
//                          maxLines: 4,
//                          decoration: InputDecoration(
//                            hintText: "Say something about you...",
//                            fillColor: Colors.transparent,
//                          ),
//                        ),
//                        SizedBox(
//                          height: space_15,
//                        ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Mobile no.",
                      style: CommonStyles.getMontserratStyle(
                          space_12,
                          FontWeight.w500,
                          CommonStyles.grey),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: mobileController,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          focusColor: Colors.white,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: ""),
                    ),
                  )
                ],
              ),
              Divider(
                height: space_1,
                thickness: space_1,
                color: Colors.black,
              ),
              SizedBox(
                height: space_15,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Email",
                      style: CommonStyles.getMontserratStyle(
                          space_12,
                          FontWeight.w500,
                          CommonStyles.grey),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      readOnly: true,
                      controller: emailController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusColor: Colors.white,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: ""),
                    ),
                  )
                ],
              ),
              Divider(
                height: space_1,
                thickness: space_1,
                color: Colors.black,
              ),
              SizedBox(
                height: space_15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Contact Number", style: CommonStyles.getMontserratStyle(
                  space_12,
                  FontWeight.w500,
                  CommonStyles.grey),),
                  RadioListTile(
                    contentPadding: EdgeInsets.only( // Add this
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: space_10
                    ),
                    groupValue: mSelectedProfileSetting,
                    title: Text('Show'),
                    value: "public",
                    onChanged: (val) {
                      setState(() {
                        mSelectedProfileSetting = val;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: mSelectedProfileSetting,
                    contentPadding: EdgeInsets.only( // Add this
                        left: 0,
                        right: 0,
                        bottom: space_10,
                        top: 0
                    ),
                    title: Text('Hide'),
                    value: "private",
                    onChanged: (val) {
                      setState(() {
                        mSelectedProfileSetting = val;
                      });
                    },
                  ),
                ],
              ),
              Divider(
              height: space_1,
              thickness: space_1,
              color: Colors.black,
            ),
//                          SizedBox(
//                            height: space_15,
//                          ),
//                          Row(
//                            children: [
//                              Expanded(
//                                flex: 3,
//                                child: Text(
//                                  "Location",
//                                  style: CommonStyles.getMontserratStyle(
//                                      space_12,
//                                      FontWeight.w500,
//                                      CommonStyles.grey),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 7,
//                                child: TextField(
//                                  controller: locationController,
//                                  style: TextStyle(color: Colors.black),
//                                  keyboardType: TextInputType.emailAddress,
//                                  decoration: InputDecoration(
//                                      focusColor: Colors.white,
//                                      border: InputBorder.none,
//                                      hintStyle: TextStyle(color: Colors.black),
//                                      focusedBorder: InputBorder.none,
//                                      enabledBorder: InputBorder.none,
//                                      errorBorder: InputBorder.none,
//                                      disabledBorder: InputBorder.none,
//                                      hintText: ""),
//                                ),
//                              )
//                            ],
//                          ),
//                          Divider(
//                            height: space_1,
//                            thickness: space_1,
//                            color: Colors.black,
//                          ),
            SizedBox(
              height: space_50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChangePasswordScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: space_15),
                height: space_50,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(space_5)),
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(space_15),
                      child: Text(
                        "Change Password",
                        style: CommonStyles.getRalewayStyle(
                            space_14,
                            FontWeight.w500,
                            Colors.white),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: space_20,
            ),
            GestureDetector(
              onTap: () {
                onSubmit();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: space_35),
                height: space_50,
                decoration: BoxDecoration(
                    color: CommonStyles.green,
                    borderRadius: BorderRadius.circular(space_5)),
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(space_15),
                      child: Text(
                        "Update Profile",
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
        ),
      ),
      ],
    ),)
    ,
    )
    );
  }

  onSubmit() {
    if (usernameController.text
        .trim()
        .isEmpty) {
      showSnakbar(_scaffoldKey, empty_username);
    } else if (mobileController.text
        .trim()
        .isEmpty) {
      showSnakbar(_scaffoldKey, empty_mobile);
    } else if (emailController.text
        .trim()
        .isEmpty) {
      showSnakbar(_scaffoldKey, empty_email);
    }
    /*else if (locationController.text.trim().isEmpty) {
      showSnakbar(_scaffoldKey, empty_address);
    }*/
    else {
      if (_image != null) {
        homeBloc
          ..add(UserUpdateEvent(
              token: token,
              username: usernameController.text.trim(),
              aboutus: aboutController.text.trim(),
              contact: mobileController.text.trim(),
              email: emailController.text.trim(),
              address: locationController.text.trim(),
              profile_setting: mSelectedProfileSetting,
              image: _image));
      } else {
        homeBloc
          ..add(UserUpdateEvent(
              token: token,
              username: usernameController.text.trim(),
              aboutus: aboutController.text.trim(),
              contact: mobileController.text.trim(),
              email: emailController.text.trim(),
              profile_setting: mSelectedProfileSetting,
              address: locationController.text.trim()));
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 500,
        maxHeight: 600);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        debugPrint("FILE_SELECTED ${_image.path}");
      } else {
        print('No image selected.');
      }
    });
  }
}
