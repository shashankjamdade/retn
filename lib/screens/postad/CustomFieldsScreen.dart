import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/get_custom_fields_response.dart';
import 'package:flutter_rentry_new/screens/postad/UploadProductImgScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';

class CustomeFieldsScreen extends StatefulWidget {
  var subCategoryId = "";
  CustomeFieldsScreen(this.subCategoryId);

  @override
  _CustomeFieldsScreenState createState() => _CustomeFieldsScreenState();
}

class _CustomeFieldsScreenState extends State<CustomeFieldsScreen> {

  var textEditingControllerList = new List<TextEditingController>();

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc = new HomeBloc();
  GetCustomFieldsResponse mGetCustomFieldsResponse;
  var loginResponse;
  var token = "";

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_CustomFields_SCREEN---------");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginResponse = StateContainer.of(context).mLoginResponse;
    if(loginResponse!=null) {
      token = loginResponse.data.token;
      debugPrint("ACCESSING_INHERITED ${token}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc..add(CustomFieldsEvent(token: token, subCategoryId: widget.subCategoryId)),
      child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if(state is GetNotificationListResState){
              mGetCustomFieldsResponse = state.res;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state){
              if(state is CustomFieldsState){
                return getScreenUi(state.res);
              }else {
                return getProgressUi();
              }
            },
          )),
    );
  }

  Widget getScreenUi(GetCustomFieldsResponse response){
    textEditingControllerList.clear();

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
                      PostAdsCommonAppbar(title: "What are you offering?"),
                      Padding(padding: EdgeInsets.only(left: space_15, top: space_20, bottom: space_20),
                        child: Text("INCLUDE INFORMATION", style: CommonStyles.getMontserratStyle(space_14, FontWeight.w700, Colors.black),),
                      ),
                      SizedBox(
                        height: space_20,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: space_15),
                          child: ListView.builder(
                            itemCount: mGetCustomFieldsResponse.data.length,
                              itemBuilder: (context, index){
                              return getCustomWidgetByType(mGetCustomFieldsResponse.data[index]);
                          })
                        ),
                      ),
                      GestureDetector(
                        onTap: (){onSubmit();},
                        child: Container(
                          margin: EdgeInsets.only(left: space_15, right: space_15, bottom: space_35, top: space_15),
                          height: space_50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(space_5),
                            color: CommonStyles.blue,
                          ),
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(space_15),
                                child: Text("Next", style: CommonStyles.getRalewayStyle(space_14, FontWeight.w500, Colors.white),)),
                          ),
                        ),
                      )
                    ],
                  ), 
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget getCustomWidgetByType(CustomFieldsData data){
    switch(CUSTOMFIELD_TEXT){
      case CUSTOMFIELD_TEXT :{
        var textEditingControllerObj = new TextEditingController();
        textEditingControllerList.add(textEditingControllerObj);
        return  Container(
          margin: EdgeInsets.only(top: space_15),
          child: NormalTextInputWidget(textEditingControllerObj, "Enter ${data.name}", false,
                  (String value) {
                if (value.isEmpty) {
                  return "";
                }
              }, TextInputType.text),
        );
      }
        break;
    case CUSTOMFIELD_TEXTAREA :{
      var textEditingControllerObj = new TextEditingController();
      textEditingControllerList.add(textEditingControllerObj);
          return  Container(
            margin: EdgeInsets.only(top: space_15),
            child: NormalTextInputWidget(textEditingControllerObj, "Enter ${data.name}", false,
                    (String value) {
                  if (value.isEmpty) {
                    return "";
                  }
                }, TextInputType.text),
          );
      }
        break;
    case CUSTOMFIELD_CHECKBOX :{
//        return Container(
//          margin: EdgeInsets.only(top: space_15),
//          child: CheckboxListTile(
//            title: Text("title text"),
//            value: checkedValue,
//            onChanged: (newValue) {
//              setState(() {
//                checkedValue = newValue;
//              });
//            },
//            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//          ),
//        );
      }
        break;
    case CUSTOMFIELD_DROPDOWN :{

      }
        break;
    case CUSTOMFIELD_RADIO :{

      }
        break;
    case CUSTOMFIELD_MULTI_CHECKBOX :{

      }
        break;
    case CUSTOMFIELD_MULTI_RADIO :{

      }
        break;
    }
  }

  Widget getProgressUi(){
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
                      PostAdsCommonAppbar(title: "What are you offering?"),
                      Padding(padding: EdgeInsets.only(left: space_15, top: space_20, bottom: space_20),
                        child: Text("INCLUDE INFORMATION", style: CommonStyles.getMontserratStyle(space_14, FontWeight.w700, Colors.black),),
                      ),
                      SizedBox(
                        height: space_20,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: space_15),
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void onSubmit() {
//    if (typeController.text.trim().isEmpty) {
//      showSnakbar(_scaffoldKey, empty_type);
//    } else if (brandController.text.trim().isEmpty) {
//      showSnakbar(_scaffoldKey, empty_brand);
//    } else if (lorenController.text.trim().isEmpty) {
//      showSnakbar(_scaffoldKey, empty_loren);
//    } else if (ipsumController.text.trim().isEmpty) {
//      showSnakbar(_scaffoldKey, empty_ipsum);
//    } else if (titleController.text.trim().isEmpty) {
//      showSnakbar(_scaffoldKey, empty_title);
//    } else if (descriptionController.text.trim().isEmpty) {
//      showSnakbar(_scaffoldKey, empty_desc);
//    }  else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadProductImgScreen()),
      );
      //API hit
//      authenticationBloc.dispatch(LoginEvent(loginInfoModel: testLogin));
//      BlocProvider.of<AuthenticationBloc>(_context)
//    }
  }
}
