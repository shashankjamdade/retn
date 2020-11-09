import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/user_profile_response.dart';
import 'package:flutter_rentry_new/screens/postad/ChangePasswordScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     usernameController = new TextEditingController(text: widget.mUserprofileRes.data.username);
     aboutController = new TextEditingController(text: widget.mUserprofileRes.data.username);
     mobileController = new TextEditingController(text: widget.mUserprofileRes.data.contact);
     emailController = new TextEditingController(text: widget.mUserprofileRes.data.email);
     locationController = new TextEditingController(text: widget.mUserprofileRes.data.address);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        child: Column(
          children: [
            CommonAppbarWidget(app_name, skip_for_now, () {
              onSearchLocation(context);
            }),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: space_15, vertical: space_15),
                child: ListView(
                  children: [
                    Text(
                      "Owner Info",
                      style: CommonStyles.getRalewayStyle(
                          space_16, FontWeight.w600, Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: space_15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: space_35,
                          width: space_35,
                          margin: EdgeInsets.only(right: space_25),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(space_10),
                            child: Container(
                              color: CommonStyles.blue,
                              child: Center(
                                child: Icon(Icons.edit, color: Colors.white,),
                              ),
                            ),
                          ),
                        ),
                    Container(
                          height: space_80,
                          width: space_80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(space_10),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/app_img.png",
                              image: widget.mUserprofileRes
                                  .data.profile_picture !=
                                  null
                                  ? widget.mUserprofileRes.data.profile_picture
                                  : "http://rentozo.com/assets/img/user.jpg",
                              fit: BoxFit.cover,
                              width: space_80,
                              height: space_80,
                            ),
                          ),
                        ),
                        Container(
                          height: space_35,
                          width: space_35,
                          margin: EdgeInsets.only(left: space_25),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(space_10),
                            child: Container(
                              color: CommonStyles.red,
                              child: Center(
                                child: Icon(Icons.delete, color: Colors.white,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: space_25,),
                    NormalTextInputWidget(
                        usernameController, "Full Name", true,
                            (String value) {
                          if (value.isEmpty) {
                            return "";
                          }
                        }, TextInputType.text),
                    SizedBox(height: space_25,),
                    Text(
                      "About",
                      style: CommonStyles.getRalewayStyle(
                          space_16, FontWeight.w600, Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextFormField(
                      obscureText: false,
                      controller: aboutController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Say something about you...",
                        fillColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: space_15,),
                   Row(
                     children: [
                       Expanded(
                         flex: 3,
                         child: Text("Mobile no.", style: CommonStyles.getMontserratStyle(space_12, FontWeight.w500, CommonStyles.grey),),
                       ),
                       Expanded(
                         flex: 7,
                         child:  TextField(
                           controller: mobileController,
                           keyboardType: TextInputType.number,
                           style: TextStyle(color: Colors.black),
                           decoration: InputDecoration(
                               focusColor: Colors.white,
                               border: InputBorder.none,
                               hintStyle:
                               TextStyle(color: Colors.black),
                               focusedBorder: InputBorder.none,
                               enabledBorder: InputBorder.none,
                               errorBorder: InputBorder.none,
                               disabledBorder: InputBorder.none,
                               hintText: ""),
                         ),
                       )
                     ],
                   ),
                    Divider(height: space_1, thickness: space_1, color: Colors.black,),
                    SizedBox(height: space_15,),
                    Row(
                     children: [
                       Expanded(
                         flex: 3,
                         child: Text("Email", style: CommonStyles.getMontserratStyle(space_12, FontWeight.w500, CommonStyles.grey),),
                       ),
                       Expanded(
                         flex: 7,
                         child:  TextField(
                           controller: emailController,
                           style: TextStyle(color: Colors.black),
                           keyboardType: TextInputType.emailAddress,
                           decoration: InputDecoration(
                               focusColor: Colors.white,
                               border: InputBorder.none,
                               hintStyle:
                               TextStyle(color: Colors.black),
                               focusedBorder: InputBorder.none,
                               enabledBorder: InputBorder.none,
                               errorBorder: InputBorder.none,
                               disabledBorder: InputBorder.none,
                               hintText: ""),
                         ),
                       )
                     ],
                   ),
                    Divider(height: space_1, thickness: space_1, color: Colors.black,),
  SizedBox(height: space_15,),
                    Row(
                     children: [
                       Expanded(
                         flex: 3,
                         child: Text("Location", style: CommonStyles.getMontserratStyle(space_12, FontWeight.w500, CommonStyles.grey),),
                       ),
                       Expanded(
                         flex: 7,
                         child:  TextField(
                           controller: locationController,
                           style: TextStyle(color: Colors.black),
                           keyboardType: TextInputType.emailAddress,
                           decoration: InputDecoration(
                               focusColor: Colors.white,
                               border: InputBorder.none,
                               hintStyle:
                               TextStyle(color: Colors.black),
                               focusedBorder: InputBorder.none,
                               enabledBorder: InputBorder.none,
                               errorBorder: InputBorder.none,
                               disabledBorder: InputBorder.none,
                               hintText: ""),
                         ),
                       )
                     ],
                   ),
                    Divider(height: space_1, thickness: space_1, color: Colors.black,),
                    SizedBox(height: space_50,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: space_15),
                        height: space_50,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                            borderRadius: BorderRadius.circular(space_5)
                        ),
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.all(space_15),
                              child: Text("Change Password", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, Colors.white),)),
                        ),
                      ),
                    ),
                    SizedBox(height: space_20,),
                    GestureDetector(
                      onTap: (){onSubmit();},
                      child: Container(
                        margin: EdgeInsets.only(bottom: space_35),
                        height: space_50,
                        decoration: BoxDecoration(
                          color: CommonStyles.green,
                          borderRadius: BorderRadius.circular(space_5)
                        ),
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.all(space_15),
                              child: Text("Update Profile", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, Colors.white),)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  onSubmit(){

  }
}
