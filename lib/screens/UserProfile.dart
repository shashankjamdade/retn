import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/main.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';
import 'package:flutter_rentry_new/screens/EditProfileScreen.dart';
import 'package:flutter_rentry_new/screens/MyFavScreen.dart';
import 'package:flutter_rentry_new/screens/NotificationListScreen.dart';
import 'package:flutter_rentry_new/screens/PackageScreen.dart';
import 'package:flutter_rentry_new/screens/SplashScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';

import 'MyPackageListScreen.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  HomeBloc homeBloc = new HomeBloc();
  UserProfileResponse mUserprofileRes;
  var loginResponse;
  var token = "";
  var createdDate = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_PROFILE_SCREEN---------");
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
      create: (context) => homeBloc..add(GetUserProfileDataEvent(token: token)),
      child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is GetUserProfileResState) {
              mUserprofileRes = state.res;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is GetUserProfileResState) {
                return getScreenUi(state);
              } else {
                return getProgressUI();
              }
            },
          )),
    );
  }

  Widget getScreenUi(HomeState state) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: space_15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: space_20,
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfileScreen(mUserprofileRes)),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: space_50,
                                width: space_50,
                                margin: EdgeInsets.only(right: space_15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(space_25),
                                  child: Container(
                                    decoration: BoxDecoration(shape: BoxShape.circle),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/images/app_img.png",
                                      image: mUserprofileRes.data.profile_picture != null
                                          ? mUserprofileRes.data.profile_picture
                                          : "http://rentozo.com/assets/img/user.jpg",
                                      fit: BoxFit.fill,
                                      width: space_80,
                                      height: space_60,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(space_10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mUserprofileRes.data.username != null
                                          ? mUserprofileRes.data.username
                                          : "",
                                      style: CommonStyles.getMontserratStyle(
                                          space_18, FontWeight.w600, Colors.black),
                                    ),
                                    SizedBox(
                                      height: space_15,
                                    ),
                                    Text(
                                      "View and edit profile",
                                      style: CommonStyles.getMontserratDecorationStyle(
                                          space_15,
                                          FontWeight.w600,
                                          CommonStyles.primaryColor,
                                          TextDecoration.underline),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: space_15,
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyPackageListScreen()),
                                    );
                                  }, child: ProfileRowWidget("My Package")),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PackageScreen()),
                                    );
                                  },
                                  child: ProfileRowWidget("Upgrade Package")),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyFavScreen()),
                                    );
                                  }, child: ProfileRowWidget("My Favourites")),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NotificationListScreen()),
                                    );
                                  }, child: ProfileRowWidget("Notification")),
                           InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => ScreenOne(true)),
                                        ModalRoute.withName("/Home")
                                    );
                                  }, child: ProfileRowWidget("Logout")),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    );
  }
  Widget getProgressUI() {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                CommonAppbarWidget(app_name, skip_for_now, () {
                  onSearchLocation(context);
                }),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: space_15),
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )),
                ),
              ],
            ),
            CommonBottomNavBarWidget(),
          ],
        ),
      ),
    );
  }

}
