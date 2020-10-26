import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/screens/ChatDetailScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List colors = [Colors.red, Colors.lightBlueAccent, Colors.amber];
  String selectedSection = "ALL";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Chat", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w800, Colors.black),),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black87,), onPressed: (){ Navigator.pop(context);}),
      ),
      body: Container(
        margin:
        EdgeInsets.only(left: space_15, right: space_15, top: space_15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: selectedSection == "ALL"
                              ? chatHeaderSelectedGradient()
                              : chatHeaderUnSelectedGradient()),
                      height: space_40,
                      child: Center(
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                selectedSection = "ALL";
                              });
                            },
                            child: Text(
                              "ALL",
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500, selectedSection == "ALL"?Colors.white:CommonStyles.primaryColor),
                            )),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: selectedSection == "RECENT"
                              ? chatHeaderSelectedGradient()
                              : chatHeaderUnSelectedGradient()),
                      height: space_40,
                      child: Center(
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                selectedSection = "RECENT";
                              });
                            },
                            child: Text(
                              "RECENT",
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500,selectedSection == "RECENT"? Colors.white: CommonStyles.primaryColor),
                            )),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: selectedSection == "SPAM"
                              ? chatHeaderSelectedGradient()
                              : chatHeaderUnSelectedGradient()
                      ),
                      height: space_40,
                      child: Center(
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                selectedSection = "SPAM";
                              });
                            },
                            child: Text(
                              "SPAM",
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500, selectedSection == "SPAM"? Colors.white: CommonStyles.primaryColor),
                            )),
                      )),
                ),
              ],
            ),
            SizedBox(height: space_25,),
            Expanded(
              child: Container(
                  child: getChatList()),
            )
          ],
        ),
      ),
    );
  }

  Widget getChatList(){
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 10,
          itemBuilder: (context, pos){
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatDetailScreen()),
                );
              },
              child: Container(
                child: ListTile(
                  key: Key("${pos}"),
                  leading: Container(
                    height: space_50,
                    width: space_50,
                    decoration: BoxDecoration(
                        color: pos%3 == 0? colors[0]: pos%3==1?colors[1]: colors[2],
                        shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Text("M", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w600, Colors.white),),
                    ),
                  ),
                  title: Text("Manish Kumar", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w600, Colors.black.withOpacity(0.8)),),
                  subtitle: Text("sdfj hdskjfhskjd fjd fsjdfk sjdhf kjsdfks", style: CommonStyles.getRalewayStyle(space_15, FontWeight.w500, Colors.black.withOpacity(0.5)),maxLines: 1, overflow: TextOverflow.ellipsis,),
                  trailing: Text("09:32", style: CommonStyles.getRalewayStyle(space_12, FontWeight.w500, Colors.black.withOpacity(0.8)),),
                ),
              ),
            );
          }
      ),
    );
  }
}
