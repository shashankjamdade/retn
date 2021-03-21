class NewInboxChatRes {
  String status;
  String msg;
  Data data;

  NewInboxChatRes({
      this.status, 
      this.msg, 
      this.data});

  NewInboxChatRes.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}

class Data {
  Ad_and_user_details ad_and_user_details;
  List<Messages> messages;

  Data({
      this.ad_and_user_details, 
      this.messages});

  Data.fromJson(dynamic json) {
    ad_and_user_details = json["ad_and_user_details"] != null ? Ad_and_user_details.fromJson(json["ad_and_user_details"]) : null;
    if (json["messages"] != null) {
      messages = [];
      json["messages"].forEach((v) {
        messages.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (ad_and_user_details != null) {
      map["ad_and_user_details"] = ad_and_user_details.toJson();
    }
    if (messages != null) {
      map["messages"] = messages.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Messages {
  String id;
  String inbox_id;
  String user_id;
  String ad_id;
  String sender_id;
  String receiver_id;
  String message;
  String notVisibleTo;
  String created_date;

  Messages({
      this.id, 
      this.inbox_id, 
      this.user_id, 
      this.ad_id, 
      this.sender_id, 
      this.receiver_id, 
      this.message, 
      this.notVisibleTo, 
      this.created_date});

  Messages.fromJson(dynamic json) {
    id = json["id"];
    inbox_id = json["inbox_id"];
    user_id = json["user_id"];
    ad_id = json["ad_id"];
    sender_id = json["sender_id"];
    receiver_id = json["receiver_id"];
    message = json["message"];
    notVisibleTo = json["notVisibleTo"];
    created_date = json["created_date"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["inbox_id"] = inbox_id;
    map["user_id"] = user_id;
    map["ad_id"] = ad_id;
    map["sender_id"] = sender_id;
    map["receiver_id"] = receiver_id;
    map["message"] = message;
    map["notVisibleTo"] = notVisibleTo;
    map["created_date"] = created_date;
    return map;
  }

}

class Ad_and_user_details {
  String profile_setting;
  String inbox_id;
  String ad_id;
  String ad_image;
  String ad_title;
  String ad_slug;
  String ad_seller;
  String created_date;
  Chat_with chat_with;

  Ad_and_user_details({
      this.profile_setting,
      this.inbox_id,
      this.ad_id,
      this.ad_image, 
      this.ad_title, 
      this.ad_slug, 
      this.ad_seller, 
      this.created_date, 
      this.chat_with});

  Ad_and_user_details.fromJson(dynamic json) {
    profile_setting = json["profile_setting"];
    inbox_id = json["inbox_id"];
    ad_id = json["ad_id"];
    ad_image = json["ad_image"];
    ad_title = json["ad_title"];
    ad_slug = json["ad_slug"];
    ad_seller = json["ad_seller"];
    created_date = json["created_date"];
    chat_with = json["chat_with"] != null ? Chat_with.fromJson(json["chat_with"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["profile_setting"] = profile_setting;
    map["inbox_id"] = inbox_id;
    map["ad_id"] = ad_id;
    map["ad_image"] = ad_image;
    map["ad_title"] = ad_title;
    map["ad_slug"] = ad_slug;
    map["ad_seller"] = ad_seller;
    map["created_date"] = created_date;
    if (chat_with != null) {
      map["chat_with"] = chat_with.toJson();
    }
    return map;
  }

}

class Chat_with {
  String receiver_id;
  String username;
  String contact;
  String email;

  Chat_with({
      this.receiver_id, 
      this.username, 
      this.contact, 
      this.email});

  Chat_with.fromJson(dynamic json) {
    receiver_id = json["receiver_id"];
    username = json["username"];
    contact = json["contact"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["receiver_id"] = receiver_id;
    map["username"] = username;
    map["contact"] = contact;
    map["email"] = email;
    return map;
  }

}