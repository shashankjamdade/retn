import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeBloc.dart';
import 'package:flutter_rentry_new/bloc/home/HomeState.dart';
import 'package:flutter_rentry_new/bloc/home/HomeEvent.dart';
import 'package:flutter_rentry_new/inherited/StateContainer.dart';
import 'package:flutter_rentry_new/model/AdPostReqModel.dart';
import 'package:flutter_rentry_new/model/custom_field_model2.dart';
import 'package:flutter_rentry_new/model/get_custom_fields_response.dart';
import 'package:flutter_rentry_new/screens/postad/UploadProductImgScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:gson/gson.dart';

class CustomeFieldsScreen extends StatefulWidget {

  AdPostReqModel adPostReqModel;
  CustomeFieldsScreen(this.adPostReqModel);

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
  var mHashmap = HashMap<String, dynamic>();
  var isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    debugPrint("ENTRY_CustomFields_SCREEN---------");
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
      create: (context) => homeBloc
        ..add(CustomFieldsEvent(
            token: token, subCategoryId: widget.adPostReqModel.subCategoryId)),
      child: BlocListener(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is GetNotificationListResState) {
              mGetCustomFieldsResponse = state.res;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is CustomFieldsState) {
                textEditingControllerList.clear();
                return getScreenUi(state.res);
              } else {
                return getProgressUi();
              }
            },
          )),
    );
  }

  Widget getScreenUi(GetCustomFieldsResponse response) {
    mGetCustomFieldsResponse = response;
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_15, top: space_20, bottom: space_20),
                    child: Text(
                      "INCLUDE INFORMATION",
                      style: CommonStyles.getMontserratStyle(
                          space_14, FontWeight.w700, Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: space_20,
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: space_15),
                        child: ListView.builder(
                            itemCount: mGetCustomFieldsResponse.data.length,
                            itemBuilder: (context, index) {
//                              if (mGetCustomFieldsResponse.data[index].type !=
//                                      CUSTOMFIELD_TEXT &&
//                                  mGetCustomFieldsResponse.data[index].type !=
//                                      CUSTOMFIELD_TEXTAREA) {
//                                if (!isDataLoaded) {
//                                  mHashmap[mGetCustomFieldsResponse.data[index]
//                                      .name] = mHashmap[mGetCustomFieldsResponse
//                                                  .data[index].name] !=
//                                              null &&
//                                          mHashmap[mGetCustomFieldsResponse
//                                                  .data[index].name]
//                                              .isNotEmpty
//                                      ? mHashmap[mGetCustomFieldsResponse
//                                          .data[index].name]
//                                      : "Select ${mGetCustomFieldsResponse.data[index].name}";
//                                }
//                              }
                              return Container(
                                margin: EdgeInsets.only(bottom: space_15),
                                child: ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
//                                leading: Container(
//                                  height: space_0,
//                                  width: space_0,
//                                ),
                                  title: Container(
                                    margin: EdgeInsets.only(bottom: space_8),
                                    child: Text(
                                      mGetCustomFieldsResponse
                                              .data[index].name +
                                          (mGetCustomFieldsResponse.data[index]
                                                          .required !=
                                                      null &&
                                                  mGetCustomFieldsResponse
                                                          .data[index]
                                                          .required ==
                                                      "1"
                                              ? "*"
                                              : ""),
                                      style: CommonStyles.getMontserratStyle(
                                          space_15,
                                          FontWeight.w600,
                                          Colors.black),
                                    ),
                                  ),
                                  subtitle: Container(
                                    child: getCustomWidgetByType(
                                        mGetCustomFieldsResponse.data[index]),
                                  ),
                                ),
                              );
                            })),
                  ),
                  GestureDetector(
                    onTap: () {
                      onSubmit();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: space_15,
                          right: space_15,
                          bottom: space_35,
                          top: space_15),
                      height: space_50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_5),
                        color: CommonStyles.blue,
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(space_15),
                            child: Text(
                              "Next",
                              style: CommonStyles.getRalewayStyle(
                                  space_14, FontWeight.w500, Colors.white),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget getCustomWidgetByType(CustomFieldsData data) {
    switch (data.type) {
      case CUSTOMFIELD_TEXT:
        {
          var textEditingControllerObj;
          if (!mHashmap.containsKey(data.id)) {
            textEditingControllerObj = new TextEditingController();
            textEditingControllerList.add(textEditingControllerObj);
            mHashmap[data.id] = textEditingControllerObj;
          } else {
            textEditingControllerObj = mHashmap[data.id];
          }
          return Container(
            margin: EdgeInsets.only(top: space_10),
            height: getProportionateScreenHeight(context, space_40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "";
                      }
                    },
                    obscureText: false,
                    maxLength: data.length != null && data.length.isNotEmpty
                        ? int.parse(data.length)
                        : 20,
                    controller: textEditingControllerObj,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Enter ${data.name}",
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        break;
      case CUSTOMFIELD_TEXTAREA:
        {
          var textEditingControllerObj;
          if (!mHashmap.containsKey(data.id)) {
            textEditingControllerObj = new TextEditingController();
            textEditingControllerList.add(textEditingControllerObj);
            mHashmap[data.id] = textEditingControllerObj;
          } else {
            textEditingControllerObj = mHashmap[data.id];
          }
          return Container(
            margin: EdgeInsets.only(top: space_10),
            height: getProportionateScreenHeight(context, space_40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "";
                      }
                    },
                    obscureText: false,
                    maxLength: data.length != null && data.length.isNotEmpty && int.parse(data.length)>0
                        ? int.parse(data.length)
                        : 20,
                    controller: textEditingControllerObj,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Enter ${data.name}",
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        break;
      case CUSTOMFIELD_CHECKBOX:
        {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.type_value.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          data.name,
                          style: CommonStyles.getRalewayStyle(
                              space_15, FontWeight.w500, Colors.black),
                        ),
                        value: data.type_value[index].checked,
                        onChanged: (bool value) {
                          setState(() {
                            data.type_value[index].checked = value;
                          });
                        },
                      );
                    }),
              ),
            ],
          ));
        }
        break;
      case CUSTOMFIELD_DROPDOWN:
        {
          var idList = List<String>();
          var nameList = List<String>();
          data.type_value.forEach((element) {
            idList.add(element.dropdown_id);
            nameList.add(element.dropdown_value);
          });
          debugPrint("HASHMAP_VALUE -->> ${data.default_value}");
          return DropdownButton(
            hint: data.default_value == null || data.default_value.isEmpty
                ? Text(
                    'Select ${data.name}',
                    style: CommonStyles.getRalewayStyle(
                        space_15, FontWeight.w500, Colors.black),
                  )
                : Text(
                    data.default_value,
                    style: CommonStyles.getRalewayStyle(
                        space_15, FontWeight.w500, Colors.black),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(color: Colors.blue),
            items: data.type_value.map(
              (val) {
                return DropdownMenuItem<Type_value>(
                  value: val,
                  child: Text(val.dropdown_value),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(
                () {
                  if (value is Type_value) {
                    data.default_value = value.dropdown_value;
                    data.default_id = value.dropdown_id;
                    debugPrint(
                        "SELECTED_VALUE ${value}-->> ${data.default_value}");
                  }
                },
              );
            },
          );
        }
        break;
      case CUSTOMFIELD_RADIO:
        {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: data.type_value.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Container(
                        height: space_60,
                        child: RadioListTile(
                          groupValue: data.default_value,
                          title: Text(data.type_value[index].name),
                          value: data.type_value[index].value,
                          selected: data.type_value[index].checked,
                          onChanged: (val) {
                            setState(() {
                              data.default_value = val;
                            });
                          },
                        ),
                      );
                    }),
              ),
            ],
          ));
        }
        break;
      case CUSTOMFIELD_MULTI_RADIO:
        {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: data.type_value.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Container(
                        height: space_60,
                        child: RadioListTile(
                          groupValue: data.default_value,
                          title: Text(data.type_value[index].name),
                          value: data.type_value[index].value,
                          onChanged: (val) {
                            setState(() {
                              data.default_value = val;
                            });
                          },
                        ),
                      );
                    }),
              ),
            ],
          ));
        }
        break;
      case CUSTOMFIELD_MULTI_CHECKBOX:
        {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: data.type_value.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          data.type_value[index].name,
                          style: CommonStyles.getMontserratStyle(
                              space_15, FontWeight.w500, Colors.black),
                        ),
                        value: data.type_value[index].checked,
                        onChanged: (bool value) {
                          setState(() {
                            data.type_value[index].checked = value;
                          });
                        },
                      );
                    }),
              ),
            ],
          ));
        }
        break;
    }
  }

  Widget getProgressUi() {
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_15, top: space_20, bottom: space_20),
                    child: Text(
                      "INCLUDE INFORMATION",
                      style: CommonStyles.getMontserratStyle(
                          space_14, FontWeight.w700, Colors.black),
                    ),
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
    ));
  }

  void onSubmit() {
    print("SUBMITTED_Value ${jsonEncode(mGetCustomFieldsResponse.data)}");
    var customFieldList = new List<CustomFieldModel>();
    var errormsg = "";
    mGetCustomFieldsResponse.data.forEach((element) {
      var arraylist = new List<String>();
      switch (element.type) {
        case CUSTOMFIELD_TEXT:
          {
            var textController = mHashmap[element.id] as TextEditingController;
            var str = textController.text;
            if (element.required == "1" && str.isEmpty && errormsg.isEmpty) {
              errormsg = "Please enter valid ${element.name}";
            }
            arraylist.add(str);
            customFieldList.add(new CustomFieldModel(element.id, arraylist));
          }
          break;
        case CUSTOMFIELD_TEXTAREA:
          {
            var textController = mHashmap[element.id] as TextEditingController;
            var str = textController.text;
            if (element.required == "1" && str.isEmpty && errormsg.isEmpty) {
              errormsg = "Please enter valid ${element.name}";
            }
            arraylist.add(str);
            customFieldList.add(new CustomFieldModel(element.id, arraylist));
          }
          break;
        case CUSTOMFIELD_CHECKBOX:
          {
            bool flag = false;
            element.type_value.forEach((item) {
              if (item.checked) {
                flag = true;
                arraylist.add(item.value);
              }
            });
            if (element.required == "1" && flag == false && errormsg.isEmpty) {
              errormsg = "Please select ${element.name}";
            } else {
              customFieldList.add(new CustomFieldModel(element.id, arraylist));
            }
          }
          break;
        case CUSTOMFIELD_DROPDOWN:
          {
            arraylist.add(element.default_id);
            if (element.required == "1" &&
                element.default_id.isEmpty &&
                errormsg.isEmpty) {
              errormsg = "Please select ${element.name}";
            }
            customFieldList.add(new CustomFieldModel(element.id, arraylist));
          }
          break;
        case CUSTOMFIELD_RADIO:
          {
            if (element.required == "1" &&
                element.default_value.isEmpty &&
                errormsg.isEmpty) {
              errormsg = "Please select ${element.name}";
            } else {
              arraylist.add(element.default_value);
              customFieldList.add(new CustomFieldModel(element.id, arraylist));
            }
          }
          break;
        case CUSTOMFIELD_MULTI_CHECKBOX:
          {
            bool flag = false;
            element.type_value.forEach((item) {
              if (item.checked) {
                flag = true;
                arraylist.add(item.value);
              }
            });
            if (element.required == "1" && flag == false && errormsg.isEmpty) {
              errormsg = "Please select ${element.name}";
            } else {
              customFieldList.add(new CustomFieldModel(element.id, arraylist));
            }
          }
          break;
        case CUSTOMFIELD_MULTI_RADIO:
          {
            if (element.required == "1" &&
                element.default_value.isEmpty &&
                errormsg.isEmpty) {
              errormsg = "Please select ${element.name}";
            } else {
              arraylist.add(element.default_value);
              customFieldList.add(new CustomFieldModel(element.id, arraylist));
            }
          }
          break;
      }
    });

    var customFieldStr = "";
    customFieldList.forEach((element) {
      customFieldStr = customFieldStr +"${customFieldStr.isNotEmpty?",":""}"+ jsonEncode(element);
      print("SUBMITTED_Value_FINAL ${jsonEncode(element)}");
    });
    customFieldStr  = "["+customFieldStr+"]";
    print("SUBMITTED_Value_FINALL ${customFieldStr}");

    if (errormsg.isNotEmpty) {
      showSnakbar(_scaffoldKey, errormsg);
    } else {
      widget.adPostReqModel.customFields = customFieldStr;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadProductImgScreen(widget.adPostReqModel)),
      );
    }
  }
}
