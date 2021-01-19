import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/ChatMsgModel.dart';
import 'package:flutter_rentry_new/model/new_inbox_chat_res.dart';
import 'package:flutter_rentry_new/screens/ItemDetailScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:intl/intl.dart';  //for date format
import 'LoginScreen.dart';

class ChatDetailScreen extends StatefulWidget {

  String username;
  String indexId;
  String slug;
  String sellerId;
  String adId;
  ChatDetailScreen({this.username, this.indexId = "", this.slug, this.sellerId, this.adId});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  TextEditingController chatTextController;
  FocusNode _focusNode = new FocusNode();
  List<Messages> msgList = List();
  String myId = "1";
  HomeBloc homeBloc = new HomeBloc();
  NewInboxChatRes mGetAllChatMsgRes;
  var loginResponse;
  var token = "";
  var myUserId = "";
  var _timer;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _timer = new Timer.periodic(Duration(seconds: 10),
            (_) => homeBloc..add(GetAllChatMsgNoProgressEvent(token: token, indexId: widget.indexId, adId: widget.adId)));
    super.initState();
    debugPrint("ENTRY_CHATDETAIL_SCREEN--------- ${widget.sellerId}");
    chatTextController = TextEditingController();
//    getMessage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      myUserId = loginResponse.data.id;
      myId = myUserId;
      debugPrint("ACCESSING_INHERITED ${token}, ${myUserId}");
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    //Dispose Listener to know when is updated focus
    _timer.cancel();
    _focusNode.addListener(_onLoginUserNameFocusChange);
    super.dispose();
  }

  void _onLoginUserNameFocusChange() {
    //Force updated once if focus changed
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (context) => homeBloc..add(GetAllChatMsgEvent(token: token, indexId: widget.indexId, adId: widget.adId)),
        child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is GetAllChatMsgResState) {
              mGetAllChatMsgRes = state.res;
            }else if(state is SendMsgResState){
              if(msgList==null || msgList.length==0){
                homeBloc..add(GetAllChatMsgEvent(token: token, indexId: widget.indexId, adId: widget.adId));
              }
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if(state is GetAllChatMsgResState){
                return getScreenUI(state);
              }if(state is SendMsgResState){
                return getScreenUI(state);
              }else{
                return getProgressScreenUI(-1);
              }
            },
          ),
        ));
  }

  Widget getScreenUI(HomeState state){
    if(state is GetAllChatMsgResState){
      mGetAllChatMsgRes = state.res;
      msgList = mGetAllChatMsgRes.data.messages;
    }else{

    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: CommonStyles.primaryColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: FlatButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemDetailScreen(categoryName: mGetAllChatMsgRes.data.ad_and_user_details?.ad_slug,)),
              );
            },
            icon: Stack(
              children: [
                Container(
                  height: space_30,
                  width: space_30,
                  decoration: BoxDecoration(
                      color: CommonStyles.red, shape: BoxShape.circle),
                  child: Center(
                    child: Container(
                      height: space_30,
                      width: space_30,
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(space_15),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/app_img.png",
                          image: (mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image!=null && mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image?.isNotEmpty)?mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image:"http://rentozo.com/assets/img/user.jpg",
                          fit: BoxFit.fill,
                          width: space_80,
                          height: space_60,
                        ),
                      ),
                    )
                    /* Text(
                      (mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image!=null && mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image?.isNotEmpty)?mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image:"http://rentozo.com/assets/img/user.jpg",
                      style: CommonStyles.getRalewayStyle(
                          space_15, FontWeight.w500, Colors.white),
                    )*/,
                  ),
                ),
                Positioned(
                  right: 0.0,
                  child: Container(
                    height: space_8,
                    width: space_8,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
            label: Text(
              "${(mGetAllChatMsgRes.data.ad_and_user_details?.chat_with?.username!=null && mGetAllChatMsgRes.data.ad_and_user_details?.chat_with?.username.isNotEmpty)?mGetAllChatMsgRes.data.ad_and_user_details?.chat_with?.username:""}",
              style: CommonStyles.getRalewayStyle(
                  space_15, FontWeight.w500, Colors.white),
            )),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: space_15,
                  right: space_15,
                  top: space_15,
                  bottom: space_60),
              child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: msgList!=null?msgList.length:0,
                  itemBuilder: (context, pos) {
                    var createDate = DateTime.parse(
                        "${msgList[pos].created_date}");
                    DateFormat timeFormatter = new DateFormat('HH:mm');
                    String currentTime = timeFormatter.format(createDate);
                    var dateTimeStr = "${currentTime}";
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: space_10),
                      child: Align(
                        alignment: msgList[pos].user_id == myUserId ? Alignment.topRight:Alignment.topLeft,
                        child: Card(
                          elevation: space_5,
                          borderOnForeground: false,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.only(
                                topLeft: msgList[pos].user_id == myId ? Radius
                                    .circular(space_30) : Radius.circular(0),
                                topRight: Radius.circular(space_30),
                                bottomRight: msgList[pos].user_id == myId ? Radius
                                    .circular(0) : Radius.circular(space_30),
                                bottomLeft: Radius.circular(space_30),
                              )),
                          child: Container(
                            width: space_200,
                            padding: EdgeInsets.all(space_15),
                            decoration: BoxDecoration(
                                gradient: chatMsgGradient(),
                                borderRadius: BorderRadius.only(
                                  topLeft: msgList[pos].user_id == myId ? Radius
                                      .circular(space_30) : Radius.circular(0),
                                  topRight: Radius.circular(space_30),
                                  bottomRight: msgList[pos].user_id == myId ? Radius
                                      .circular(0) : Radius.circular(space_30),
                                  bottomLeft: Radius.circular(space_30),
                                )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(msgList[pos].message, style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, CommonStyles.grey),),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(dateTimeStr, style: CommonStyles.getRalewayStyle(space_10, FontWeight.w500, CommonStyles.grey),)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: space_15),
                margin: EdgeInsets.symmetric(
                    horizontal: space_15, vertical: space_10),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: CommonStyles.grey)],
                    color: CommonStyles.lightGrey,
                    borderRadius: BorderRadius.circular(space_35)),
                child: Container(
                    child: TextField(
                      controller: chatTextController,
                      decoration: InputDecoration(
                          focusColor: Colors.black12,
//                          prefixIcon: IconButton(
//                            onPressed: () {},
//                            icon: ImageIcon(
//                              AssetImage(
//                                "assets/images/choose_file_icon.png",
//                              ),
//                              color: CommonStyles.grey,
//                            ),),
                          suffixIcon: IconButton(
                              onPressed: () {
                                onSubmitMsg(chatTextController.text);
                              },
                              icon: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: CommonStyles.secondarygrey,
                                          width: space_1)),
                                  padding: EdgeInsets.all(space_5),
                                  child: Center(
                                      child: Icon(
                                        Icons.send,
                                        size: space_15,
                                        color: CommonStyles.grey,
                                      )))),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
//                          contentPadding:
//                          EdgeInsets.only(left: space_15, bottom: space_15, top: space_15, right: space_15),
                          hintText: "Say something..."),
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getProgressScreenUI(int length){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: CommonStyles.primaryColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: FlatButton.icon(
            onPressed: () {},
            icon: Stack(
              children: [
                Container(
                  height: space_30,
                  width: space_30,
                  decoration: BoxDecoration(
                      color: CommonStyles.red, shape: BoxShape.circle),
                  child: Center(
                    child: Container(
                      height: space_30,
                      width: space_30,
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(space_15),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/app_img.png",
                          image: (mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image!=null && mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image?.isNotEmpty)?mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image:"http://rentozo.com/assets/img/user.jpg",
                          fit: BoxFit.fill,
                          width: space_80,
                          height: space_60,
                        ),
                      ),
                    )
                    /* Text(
                      (mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image!=null && mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image?.isNotEmpty)?mGetAllChatMsgRes?.data?.ad_and_user_details?.ad_image:"http://rentozo.com/assets/img/user.jpg",
                      style: CommonStyles.getRalewayStyle(
                          space_15, FontWeight.w500, Colors.white),
                    )*/,
                  ),
                ),
                Positioned(
                  right: 0.0,
                  child: Container(
                    height: space_8,
                    width: space_8,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
            label: Text(
              "",
              style: CommonStyles.getRalewayStyle(
                  space_15, FontWeight.w500, Colors.white),
            )),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: space_15,
                  right: space_15,
                  top: space_15,
                  bottom: space_60),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  void onSubmitMsg(String msg){
    if(msg!=null && msg.isNotEmpty){
      if(msgList==null){
        msgList = List();
      }
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      msgList.insert(0, Messages(message: msg, user_id: myUserId, created_date: formattedDate));
      setState(() {
        msgList = msgList;
      });
//    debugPrint("MSG_ADDED ${mGetAllChatMsgRes.data.inbox.receiver_id}");
      homeBloc..add(SendMsgReqEvent(token: token, adId: mGetAllChatMsgRes.data.ad_and_user_details?.ad_id, msg: msg, recieverId: mGetAllChatMsgRes.data.ad_and_user_details?.chat_with?.receiver_id, inboxId: mGetAllChatMsgRes.data.ad_and_user_details?.inbox_id!=null?mGetAllChatMsgRes.data.ad_and_user_details?.inbox_id:""));
      chatTextController.text = "";
    }
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          homeBloc..add(GetAllChatMsgNoProgressEvent(token: token, indexId: widget.indexId, adId: widget.adId));
        }, onResume: (Map<String, dynamic> message) async {

    }, onLaunch: (Map<String, dynamic> message) async {

    });
  }

}
