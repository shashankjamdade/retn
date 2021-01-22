class GetAllChatUserListResponse {
  bool status;
  String message;
  AllChatUserDataList data;

  GetAllChatUserListResponse({
      this.status, 
      this.message, 
      this.data});

  GetAllChatUserListResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] != null ? AllChatUserDataList.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}

class AllChatUserDataList {
  List<AllChatUserData> chat_list;

  AllChatUserDataList({
      this.chat_list});

  AllChatUserDataList.fromJson(dynamic json) {
    if (json["chat_list"] != null) {
      chat_list = [];
      json["chat_list"].forEach((v) {
        chat_list.add(AllChatUserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (chat_list != null) {
      map["chat_list"] = chat_list.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class AllChatUserData {
  String inbox_id;
  String user_id;
  String chat_created_date;
  String ads_id;
  String ad_title;
  String ad_image;
  String ad_slug;
  String seller_id;
  String ad_category_id;
  String not_visible_to;
  String chat_with_id;
  String chat_with;
  int new_message;

  AllChatUserData({
      this.inbox_id, 
      this.user_id, 
      this.chat_created_date, 
      this.ads_id, 
      this.ad_title, 
      this.ad_image, 
      this.ad_slug, 
      this.seller_id, 
      this.ad_category_id, 
      this.not_visible_to, 
      this.chat_with_id, 
      this.chat_with, 
      this.new_message});

  AllChatUserData.fromJson(dynamic json) {
    inbox_id = json["inbox_id"];
    user_id = json["user_id"];
    chat_created_date = json["chat_created_date"];
    ads_id = json["ads_id"];
    ad_title = json["ad_title"];
    ad_image = json["ad_image"];
    ad_slug = json["ad_slug"];
    seller_id = json["seller_id"];
    ad_category_id = json["ad_category_id"];
    not_visible_to = json["not_visible_to"];
    chat_with_id = json["chat_with_id"];
    chat_with = json["chat_with"];
    new_message = json["new_message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["inbox_id"] = inbox_id;
    map["user_id"] = user_id;
    map["chat_created_date"] = chat_created_date;
    map["ads_id"] = ads_id;
    map["ad_title"] = ad_title;
    map["ad_image"] = ad_image;
    map["ad_slug"] = ad_slug;
    map["seller_id"] = seller_id;
    map["ad_category_id"] = ad_category_id;
    map["not_visible_to"] = not_visible_to;
    map["chat_with_id"] = chat_with_id;
    map["chat_with"] = chat_with;
    map["new_message"] = new_message;
    return map;
  }

}