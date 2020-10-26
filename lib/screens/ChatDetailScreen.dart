import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/ChatMsgModel.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';

class ChatDetailScreen extends StatefulWidget {
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  TextEditingController chatTextController;
  FocusNode _focusNode = new FocusNode();
  List<ChatMsg> msgList = List();
  String myId = "1";

  @override
  void initState() {
    super.initState();
    chatTextController = TextEditingController();
    _focusNode.addListener(_onLoginUserNameFocusChange);
    msgList.add(new ChatMsg("1", "Hello"));
    msgList.add(new ChatMsg("2", "Hello"));
    msgList.add(new ChatMsg("2", "Hello sdfkjshdk j"));
    msgList.add(new ChatMsg(
        "1", "Hellosd sdf sdf sdf hsdkjf skjd nsjkdnf jsdnf ksndkjfn sdjfnk dsfkj dfkjsndkf jnsdkfjnsdk fjnsdf jnsdfjsndf sjdnf"));
    msgList.add(new ChatMsg(
        "2", "Hello sdfj sdkjfsjdf jsdnfjsnd kjsndjkfnskdf nskdnf skdnfs jd"));
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
                      "M",
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
              "Manish Kumar",
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
                        alignment: msgList[pos].id == myId ? Alignment.topRight:Alignment.topLeft,
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
                            child: Text(msgList[pos].msg, style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, CommonStyles.grey),),
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

  void onSubmitMsg(String msg){
    msgList.add(ChatMsg("1", msg));
    setState(() {
      msgList = msgList;
    });
    chatTextController.text = "";
  }

}
