class GetAllChatMsgRes {
  bool status;
  String message;
  ChatMsgData data;

  GetAllChatMsgRes({
      this.status, 
      this.message, 
      this.data});

  GetAllChatMsgRes.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] != null ? ChatMsgData.fromJson(json["data"]) : null;
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

class ChatMsgData {
  Ad ad;
  Inbox inbox;
  List<Messages> messages;

  ChatMsgData({
      this.ad, 
      this.inbox, 
      this.messages});

  ChatMsgData.fromJson(dynamic json) {
    ad = json["ad"] != null ? Ad.fromJson(json["ad"]) : null;
    inbox = json["inbox"] != null ? Inbox.fromJson(json["inbox"]) : null;
    if (json["messages"] != null) {
      messages = [];
      json["messages"].forEach((v) {
        messages.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (ad != null) {
      map["ad"] = ad.toJson();
    }
    if (inbox != null) {
      map["inbox"] = inbox.toJson();
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
  String message;
  String created_date;
  String seller;

  Messages({
      this.id, 
      this.inbox_id, 
      this.user_id, 
      this.message, 
      this.created_date, 
      this.seller});

  Messages.fromJson(dynamic json) {
    id = json["id"];
    inbox_id = json["inbox_id"];
    user_id = json["user_id"];
    message = json["message"];
    created_date = json["created_date"];
    seller = json["seller"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["inbox_id"] = inbox_id;
    map["user_id"] = user_id;
    map["message"] = message;
    map["created_date"] = created_date;
    map["seller"] = seller;
    return map;
  }

}

class Inbox {
  String id;
  String ad;
  String sender_id;
  String receiver_id;
  String created_date;

  Inbox({
      this.id, 
      this.ad, 
      this.sender_id, 
      this.receiver_id, 
      this.created_date});

  Inbox.fromJson(dynamic json) {
    id = json["id"];
    ad = json["ad"];
    sender_id = json["sender_id"];
    receiver_id = json["receiver_id"];
    created_date = json["created_date"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["ad"] = ad;
    map["sender_id"] = sender_id;
    map["receiver_id"] = receiver_id;
    map["created_date"] = created_date;
    return map;
  }

}

class Ad {
  String id;
  String ad;
  String inbox_id;
  String user_id;
  String created_date;
  String pid;
  String title;
  String slug;
  String seller;
  String img_1;
  String category;
  String subcategory;
  String chat_with_id;
  String chat_with;

  Ad({
      this.id, 
      this.ad, 
      this.inbox_id, 
      this.user_id, 
      this.created_date, 
      this.pid, 
      this.title, 
      this.slug, 
      this.seller, 
      this.img_1, 
      this.category, 
      this.subcategory, 
      this.chat_with_id, 
      this.chat_with});

  Ad.fromJson(dynamic json) {
    id = json["id"];
    ad = json["ad"];
    inbox_id = json["inbox_id"];
    user_id = json["user_id"];
    created_date = json["created_date"];
    pid = json["pid"];
    title = json["title"];
    slug = json["slug"];
    seller = json["seller"];
    img_1 = json["img_1"];
    category = json["category"];
    subcategory = json["subcategory"];
    chat_with_id = json["chat_with_id"];
    chat_with = json["chat_with"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["ad"] = ad;
    map["inbox_id"] = inbox_id;
    map["user_id"] = user_id;
    map["created_date"] = created_date;
    map["pid"] = pid;
    map["title"] = title;
    map["slug"] = slug;
    map["seller"] = seller;
    map["img_1"] = img_1;
    map["category"] = category;
    map["subcategory"] = subcategory;
    map["chat_with_id"] = chat_with_id;
    map["chat_with"] = chat_with;
    return map;
  }

}