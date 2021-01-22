import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/get_all_chat_user_list_response.dart';
import 'package:flutter_rentry_new/model/new_chatlist_res.dart';
import 'package:flutter_rentry_new/screens/ChatDetailScreen.dart';
import 'package:flutter_rentry_new/screens/LoginScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:intl/intl.dart';  //for date format

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List colors = [Colors.red, Colors.lightBlueAccent, Colors.amber];
  String selectedSection = "ALL";
  HomeBloc homeBloc = new HomeBloc();
  NewChatlistRes mGetAllChatUserListResponse;
  var loginResponse;
  var token = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_CHATHOME_SCREEN---------");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => homeBloc..add(GetAllChatUserEvent(token: token)),
        child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is GetAllChatUserListResState) {
              mGetAllChatUserListResponse = state.res;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if(state is GetAllChatUserListResState){
                return getScreenUI(state);
              }else{
                return getScreenProgressUI();
              }
            },
          ),
        ));
  }

  Widget getScreenUI(HomeState state) {
    if (state is GetAllChatUserListResState) {
      mGetAllChatUserListResponse = state.res;
    }
    if(mGetAllChatUserListResponse.data.length == 0){
      return getScreenProgressUI(length: 0);
    }else{
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Chat",
            style: CommonStyles.getRalewayStyle(
                space_15, FontWeight.w800, Colors.black),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          margin: EdgeInsets.only(left: space_15, right: space_15, top: space_15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(child: getChatList()),
              )
            ],
          ),
        ),
      );
    }
  }
  Widget getScreenProgressUI({int length = -1}) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Chat",
          style: CommonStyles.getRalewayStyle(
              space_15, FontWeight.w800, Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: length != 0?CircularProgressIndicator():Text("No chat found",style: CommonStyles.getRalewayStyle(space_14, FontWeight.w600, Colors.black),),
        ),
      )
    );
  }

  Widget getChatList() {
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: mGetAllChatUserListResponse.data.length,
          itemBuilder: (context, pos) {
            var createDate = DateTime.parse(
                "${mGetAllChatUserListResponse.data[pos].created_date}");
            DateFormat dateFormatter = new DateFormat('dd MMM');
            DateFormat timeFormatter = new DateFormat('HH:mm');
            String currentTime = timeFormatter.format(createDate);
            String currentDate = dateFormatter.format(createDate);
            var dateTimeStr = "${currentDate}\n${currentTime}";
//            var currentDaterentTime = createDate.toString().split(" ")[1];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatDetailScreen(username:mGetAllChatUserListResponse.data[pos].chat_with.receiver_id, indexId:mGetAllChatUserListResponse.data[pos].inbox_id,
                      slug: mGetAllChatUserListResponse.data[pos].ad_slug, adId:  mGetAllChatUserListResponse.data[pos].ad_id,
                  )),
                );
              },
              child: Container(
                child: ListTile(
                  key: Key("${pos}"),
                  leading: Container(
                    height: space_50,
                    width: space_50,
                    decoration: BoxDecoration(
                        color: pos % 3 == 0
                            ? colors[0]
                            : pos % 3 == 1 ? colors[1] : colors[2],
                        shape: BoxShape.circle),
                    child: Center(
                      child:  Container(
                        height: space_50,
                        width: space_50,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(space_25),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/app_img.png",
                            image: (mGetAllChatUserListResponse.data[pos].ad_image!=null && mGetAllChatUserListResponse.data[pos].ad_image?.isNotEmpty)? mGetAllChatUserListResponse.data[pos].ad_image:"http://rentozo.com/assets/img/user.jpg",
                            fit: BoxFit.fill,
                            width: space_80,
                            height: space_60,
                          ),
                        ),
                      ),/*Text(
                        mGetAllChatUserListResponse.data[pos].chat_with!=null && mGetAllChatUserListResponse.data[pos].chat_with?.username.isNotEmpty?mGetAllChatUserListResponse.data[pos].chat_with?.username[0].toUpperCase():"-",
                        style: CommonStyles.getRalewayStyle(
                            space_15, FontWeight.w600, Colors.white),
                      ),*/
                    ),
                  ),
                  title: Text(
                    mGetAllChatUserListResponse.data[pos].chat_with?.username,
                    style: CommonStyles.getRalewayStyle(space_15,
                        FontWeight.w600, Colors.black.withOpacity(0.8)),
                  ),
                  subtitle: Text(
                    "${mGetAllChatUserListResponse.data[pos].ad_slug}",
                    style: CommonStyles.getRalewayStyle(space_15,
                        FontWeight.w500, Colors.black.withOpacity(0.5)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    dateTimeStr,
                    textAlign: TextAlign.center,
                    style: CommonStyles.getMontserratStyle(space_12,
                        FontWeight.w500, Colors.black.withOpacity(0.8)),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
