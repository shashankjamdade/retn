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
import 'package:flutter_rentry_new/model/my_ads_edit_res.dart';
import 'package:flutter_rentry_new/screens/postad/UploadProductImgScreen.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/Constants.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:flutter_rentry_new/widgets/CommonWidget.dart';
import 'package:flutter_rentry_new/widgets/PostAdsCommonWidget.dart';
import 'package:gson/gson.dart';

import 'EditUploadProductImgScreen.dart';

class EditCustomeFieldsScreen extends StatefulWidget {
  AdPostReqModel adPostReqModel;
  MyAdsEditRes mMyAdsEditRes;

  EditCustomeFieldsScreen(this.adPostReqModel, this.mMyAdsEditRes);

  @override
  _EditCustomeFieldsScreenState createState() =>
      _EditCustomeFieldsScreenState();
}

class _EditCustomeFieldsScreenState extends State<EditCustomeFieldsScreen> {
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
        ..add((widget.adPostReqModel.subCategoryId ==
                widget.mMyAdsEditRes.data.post.subcategory)
            ? InitialEvent()
            : CustomFieldsEvent(
                token: token,
                subCategoryId: widget.adPostReqModel.subCategoryId)),
      child: BlocListener(
          cubit: homeBloc,
          listener: (context, state) {
            if (state is InitialHomeState) {
              mGetCustomFieldsResponse = new GetCustomFieldsResponse(status: true, message: "",data: widget.mMyAdsEditRes.data.customefield);
            }else if (state is GetNotificationListResState) {
              mGetCustomFieldsResponse = state.res;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if(state is InitialHomeState){
                return getScreenUi(new GetCustomFieldsResponse(status: true, message: "",data: widget.mMyAdsEditRes.data.customefield));
              }else if (state is CustomFieldsState) {
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
                              return Container(
                                margin: EdgeInsets.only(bottom: space_15),
                                child: ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
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
                                        mGetCustomFieldsResponse.data[index], index),
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

  Widget getCustomWidgetByType(CustomFieldsData data, int poss) {
    switch (data.type) {
      case CUSTOMFIELD_TEXT:
        {
          var textEditingControllerObj;
          if (!mHashmap.containsKey(data.id)) {
            textEditingControllerObj = new TextEditingController(text: (data.type_value[0].value!=null && data.type_value[0].value.isNotEmpty)?  data.type_value[0].value : "");
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
            debugPrint("TEXTAREA ${(data.type_value[0].value!=null && data.type_value[0].value.isNotEmpty)?  data.type_value[0].value.trim() : ""}");
            textEditingControllerObj = new TextEditingController(text: (data.type_value[0].value!=null && data.type_value[0].value.isNotEmpty)?  data.type_value[0].value.trim() : "");
            textEditingControllerList.add(textEditingControllerObj);
            mHashmap[data.id] = textEditingControllerObj;
          } else {
            textEditingControllerObj = mHashmap[data.id];
          }
          debugPrint("CONTRILLER-- ${textEditingControllerObj.text}");
          return Container(
            margin: EdgeInsets.only(top: space_10),
            child: TextField(
              obscureText: false,
              maxLines: 3,
              minLines: 2,
              maxLength: data.length != null && data.length.isNotEmpty
                  ? int.parse(data.length)
                  : 20,
              controller: textEditingControllerObj,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Enter ${data.name}",
                filled: true,
                fillColor: Colors.transparent,
              ),
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
          var isNeedToSetDefaultDrop = true;
          debugPrint("DROPDOWN_DEFAULT --> ${data.default_value}");

          data.type_value.forEach((element) {
            if(data.default_value!=null && data.default_value?.isNotEmpty && data?.default_value == element?.dropdown_value){
              isNeedToSetDefaultDrop = false;
            }
            idList.add(element.dropdown_id);
            nameList.add(element.dropdown_value);
          });

          debugPrint("ISSSS_DROPDOWN ${isNeedToSetDefaultDrop}");
          if(isNeedToSetDefaultDrop){
            data.type_value.forEach((element) {
              if(element.is_selected!=null && element.is_selected == 1){
                data.default_value = element.dropdown_value;
                data.default_id = element.dropdown_id;
              }
            });
          }

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
                  var i = data?.type_value?.indexOf(value);
                  debugPrint("DROPDOWN_SELECTED_INDEX ${i}");
                  mGetCustomFieldsResponse.data[poss].type_value[i].is_selected = 1;
                  data.type_value[i].is_selected = 1;
                  if (value is Type_value) {
                    mGetCustomFieldsResponse.data[poss].default_value = value.dropdown_value;
                    mGetCustomFieldsResponse.data[poss].default_id = value.dropdown_id;
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
          data.type_value.forEach((element) {
            if(element.checked!=null && element.checked){
              data.default_value = element.value;
            }
          });
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
                                  data.type_value[index].checked = true;
                                  mGetCustomFieldsResponse.data[poss].type_value[index].checked = true;
                                  mGetCustomFieldsResponse.data[poss].default_value = val;
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
          var isNeedToSetDefault = true;
          data.type_value.forEach((element) {
            if(data.default_value!=null && data.default_value?.isNotEmpty && data?.default_value == element?.value){
              isNeedToSetDefault = false;
            }
          });
          debugPrint("ISSSS ${isNeedToSetDefault}");
          if(isNeedToSetDefault){
            data.type_value.forEach((element) {
              if(element.checked!=null && element.checked){
                data.default_value = element.value;
              }
            });
          }
          debugPrint("MULT_RADIO --> ${data.default_value}");
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
                            debugPrint("SELECTED--> ${val}");
                            setState(() {
                              data.default_value = val;
                              data.type_value[index].checked = true;
                              mGetCustomFieldsResponse.data[poss].type_value[index].checked = true;
                              mGetCustomFieldsResponse.data[poss].default_value = val;
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
                element.default_id!=null && element.default_id.isEmpty &&
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
    customFieldStr = "[" + customFieldStr + "]";
    print("SUBMITTED_Value_FINALL ${customFieldStr}");

    if (errormsg.isNotEmpty) {
      showSnakbar(_scaffoldKey, errormsg);
    } else {
      widget.adPostReqModel.customFields = customFieldStr;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditUploadProductImgScreen(widget.adPostReqModel, widget.mMyAdsEditRes)),
      );
    }
  }
}
