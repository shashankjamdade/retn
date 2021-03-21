class NewChatlistRes {
  String status;
  String msg;
  List<Data> data;

  NewChatlistRes({
      this.status, 
      this.msg, 
      this.data});

  NewChatlistRes.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  dynamic new_message;
  String inbox_id;
  String ad_id;
  String ad_image;
  String ad_title;
  String ad_slug;
  String ad_seller;
  String created_date;
  Chat_with chat_with;

  Data({
      this.new_message,
      this.inbox_id,
      this.ad_id,
      this.ad_image, 
      this.ad_title, 
      this.ad_slug, 
      this.ad_seller, 
      this.created_date, 
      this.chat_with});

  Data.fromJson(dynamic json) {
    new_message = json["new_message"];
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
    map["new_message"] = new_message;
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