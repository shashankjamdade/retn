class GetNotificationResponse {
  bool status;
  String message;
  List<NotificationData> data;

  GetNotificationResponse({
      this.status, 
      this.message, 
      this.data});

  GetNotificationResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class NotificationData {
  String id;
  String user_id;
  String admin_id;
  String content;
  String admin_view;
  String user_view;
  String deleted;
  String createdAt;

  NotificationData({
      this.id, 
      this.user_id, 
      this.admin_id, 
      this.content, 
      this.admin_view, 
      this.user_view, 
      this.deleted, 
      this.createdAt});

  NotificationData.fromJson(dynamic json) {
    id = json["id"];
    user_id = json["user_id"];
    admin_id = json["admin_id"];
    content = json["content"];
    admin_view = json["admin_view"];
    user_view = json["user_view"];
    deleted = json["deleted"];
    createdAt = json["createdAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["user_id"] = user_id;
    map["admin_id"] = admin_id;
    map["content"] = content;
    map["admin_view"] = admin_view;
    map["user_view"] = user_view;
    map["deleted"] = deleted;
    map["createdAt"] = createdAt;
    return map;
  }

}