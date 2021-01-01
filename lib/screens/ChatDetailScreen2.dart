import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/ChatMsgModel.dart';
import 'package:flutter_rentry_new/model/get_all_chat_msg_res.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';

import 'LoginScreen.dart';

class ChatDetailScreen2 extends StatefulWidget {

  String username;
  String indexId;
  String slug;
  ChatDetailScreen2(this.username, this.indexId, this.slug);

  @override
  _ChatDetailScreen2State createState() => _ChatDetailScreen2State();
}

class _ChatDetailScreen2State extends State<ChatDetailScreen2> {
  TextEditingController chatTextController;
  FocusNode _focusNode = new FocusNode();
  List<Messages> msgList = List();
  String myId = "1";
  HomeBloc homeBloc = new HomeBloc();
  GetAllChatMsgRes mGetAllChatMsgRes;
  var loginResponse;
  var token = "";
  var myUserId = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_CHATHOME_SCREEN2222---------");
    chatTextController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if (loginResponse != null) {
      token = loginResponse.data.token;
      myUserId = loginResponse.data.id;
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
        create: (context) => homeBloc..add(GetAllChatMsgEvent(token: token, indexId: widget.indexId, slug: widget.slug)),
        child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is GetAllChatMsgResState) {
              mGetAllChatMsgRes = state.res;
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
            onPressed: () {},
            icon: Stack(
              children: [
                Container(
                  height: space_30,
                  width: space_30,
                  decoration: BoxDecoration(
                      color: CommonStyles.red, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      widget.username[0].toUpperCase(),
                      style: CommonStyles.getRalewayStyle(
                          space_15, FontWeight.w500, Colors.white),
                    ),
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
              "${widget.username}",
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
                  itemCount: msgList.length,
                  itemBuilder: (context, pos) {
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
                                topLeft: msgList[pos].id == myId ? Radius
                                    .circular(space_30) : Radius.circular(0),
                                topRight: Radius.circular(space_30),
                                bottomRight: msgList[pos].id == myId ? Radius
                                    .circular(0) : Radius.circular(space_30),
                                bottomLeft: Radius.circular(space_30),
                              )),
                          child: Container(
                            width: space_200,
                            padding: EdgeInsets.all(space_15),
                            decoration: BoxDecoration(
                                gradient: chatMsgGradient(),
                                borderRadius: BorderRadius.only(
                                  topLeft: msgList[pos].id == myId ? Radius
                                      .circular(space_30) : Radius.circular(0),
                                  topRight: Radius.circular(space_30),
                                  bottomRight: msgList[pos].id == myId ? Radius
                                      .circular(0) : Radius.circular(space_30),
                                  bottomLeft: Radius.circular(space_30),
                                )
                            ),
                            child: Text(msgList[pos].message, style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, CommonStyles.grey),),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: ImageIcon(
                              AssetImage(
                                "assets/images/choose_file_icon.png",
                              ),
                              color: CommonStyles.grey,
                            ),),
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

//                    Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Center(child: IconButton(icon: Icon(Icons.multiline_chart), onPressed: (){})),
//                       ),
//                       Expanded(
//                         flex: 8,
//                         child: Container(
//                           child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: space_15),
//                             child: TextField(
//                               controller: chatTextController,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Center(child: Container(
//                           height: space_40,
//                           width: space_40,
//                           padding: EdgeInsets.all(space_5),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                               border: Border.all(color: Colors.grey)
//                           ),
//                           child: Center(
//                             child: Icon(Icons.send,),
//                           ),
//                         )),
//                       ),
//
//                     ],
//                    ),
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
                    child: Text(
                      widget.username[0].toUpperCase(),
                      style: CommonStyles.getRalewayStyle(
                          space_15, FontWeight.w500, Colors.white),
                    ),
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
              "${widget.username}",
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
    msgList.add(Messages(message: msg, user_id: myUserId));
    setState(() {
      msgList = msgList;
    });
    homeBloc..add(SendMsgReqEvent(token: token, adId: mGetAllChatMsgRes.data.inbox.ad, msg: msg, recieverId: mGetAllChatMsgRes.data.inbox.receiver_id, inboxId: mGetAllChatMsgRes.data.inbox.id));
    chatTextController.text = "";
  }

}
