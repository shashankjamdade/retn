import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/main.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';
import 'package:flutter_rentry_new/screens/CouponListScreen.dart';
import 'package:flutter_rentry_new/screens/EditProfileScreen.dart';
import 'package:flutter_rentry_new/screens/MyFavScreen.dart';
import 'package:flutter_rentry_new/screens/NotificationListScreen.dart';
import 'package:flutter_rentry_new/screens/PackageScreen.dart';
import 'package:flutter_rentry_new/screens/SplashScreen.dart';
import 'package:flutter_rentry_new/screens/postad/MyAdsListScreen.dart';
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
          cubit: homeBloc,
          listener: (context, state) {
            if (state is GetUserProfileResState) {
              mUserprofileRes = state.res;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is GetUserProfileResState && state.res is UserProfileResponse) {
                if(state.res.status){
                  return getScreenUi(state);
                }else{
                  return getErrorUI();
                }
              } else {
                return getProgressUI();
              }
            },
          )),
    );
  }

  Widget getScreenUi(HomeState state) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
        },
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
                            onTap: () {
                              redirectToEditScreen();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: space_70,
                                  width: space_70,
                                  margin: EdgeInsets.only(right: space_15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(space_35),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: "assets/images/userlogo.png",
                                        image: mUserprofileRes.data != null &&
                                                mUserprofileRes
                                                        .data.profile_picture !=
                                                    null
                                            ? mUserprofileRes.data.profile_picture
                                            : "http://rentozo.com/assets/img/user.jpg",
                                        fit: BoxFit.contain,
                                        width: space_70,
                                        height: space_70,
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
                                            space_18,
                                            FontWeight.w600,
                                            Colors.black),
                                      ),
                                      SizedBox(
                                        height: space_15,
                                      ),
                                      Text(
                                        "View and edit profile",
                                        style: CommonStyles
                                            .getMontserratDecorationStyle(
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
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CouponListScreen()),
                                      );
                                    },
                                    child: ProfileRowWidget("Offers",
                                        "assets/images/nearbyoffers.png")),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyPackageListScreen()),
                                      );
                                    },
                                    child: ProfileRowWidget("My Package",
                                        "assets/images/mypackage.png")),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PackageScreen()),
                                      );
                                    },
                                    child: ProfileRowWidget("Upgrade Package",
                                        "assets/images/upgradepackage.png")),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyAdsListScreen()),
                                      );
                                    },
                                    child: ProfileRowWidget(
                                        "My Ads", "assets/images/myads.png")),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyFavScreen()),
                                      );
                                    },
                                    child: ProfileRowWidget("My Favourites",
                                        "assets/images/myfavourites.png")),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationListScreen()),
                                      );
                                    },
                                    child: ProfileRowWidget("Notification",
                                        "assets/images/notification.png")),
                                InkWell(
                                    onTap: () {
                                      StateContainer.of(context).mLoginResponse =
                                          null;
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScreenOne(true)),
                                          ModalRoute.withName("/Home"));
                                    },
                                    child: ProfileRowWidget(
                                        "Logout", "assets/images/logout.png")),
                                SizedBox(
                                  height: space_15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        "https://rentozo.com/home/page/about-us");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(space_15),
                                    child: Text(
                                      'About us',
                                      style: TextStyle(
                                        fontSize: space_16,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                        color: CommonStyles.primaryColor,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor:
                                            CommonStyles.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: space_5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        "https://rentozo.com/home/page/tips-of-security");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(space_15),
                                    child: Text(
                                      'Tips Of Security',
                                      style: TextStyle(
                                        fontSize: space_16,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                        color: CommonStyles.primaryColor,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor:
                                            CommonStyles.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: space_5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        "https://rentozo.com/home/page/terms-and-conditions");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(space_15),
                                    child: Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        fontSize: space_16,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                        color: CommonStyles.primaryColor,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor:
                                            CommonStyles.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: space_5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        "https://rentozo.com/home/page/privacy-policy");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(space_15),
                                    child: Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        fontSize: space_16,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                        color: CommonStyles.primaryColor,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor:
                                            CommonStyles.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: space_5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchURL("https://rentozo.com/contact");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(space_15),
                                    child: Text(
                                      'Contact us',
                                      style: TextStyle(
                                        fontSize: space_16,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                        color: CommonStyles.primaryColor,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor:
                                            CommonStyles.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: space_90,
                                )
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

  Widget getErrorUI() {
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
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Something went wrong!!',
                          style: CommonStyles.getRalewayStyle(
                              space_16, FontWeight.w500, Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            homeBloc
                              ..add(GetUserProfileDataEvent(token: token));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(space_15),
                            child: Text(
                              'RETRY',
                              style: TextStyle(
                                fontSize: space_18,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                                color: CommonStyles.primaryColor,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.solid,
                                decorationColor: CommonStyles.primaryColor,
                              ),
                            ),
                          ),
                        ),
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

  redirectToEditScreen() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditProfileScreen(mUserprofileRes)),
    );
    if(res!=null && res == "true"){
      homeBloc..add(GetUserProfileDataEvent(token: token));
    }
  }

}
