class GeneralSettingRes {
  String message;
  GeneralData data;
  bool status;

  GeneralSettingRes({
      this.message, 
      this.data, 
      this.status});

  GeneralSettingRes.fromJson(dynamic json) {
    message = json["message"];
    data = json["data"] != null ? GeneralData.fromJson(json["data"]) : null;
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = message;
    if (data != null) {
      map["data"] = data.toJson();
    }
    map["status"] = status;
    return map;
  }

}

class GeneralData {
  String id;
  String application_name;
  String description;
  String favicon;
  String logo;
  String timezone;
  String currency;
  String language;
  String copyright;
  String admin_email;
  String email_from;
  String smtp_host;
  String smtp_port;
  String smtp_user;
  String smtp_pass;
  String facebook_link;
  String twitter_link;
  String google_link;
  String youtube_link;
  String linkedin_link;
  String instagram_link;
  String recaptchaSecretKey;
  String recaptchaSiteKey;
  String map_api_key;
  String razorpay_key_id;
  String razorpayKeySecret;
  String mapAccessToken;
  String defaultMap;
  String terms_and_conditions;
  String recaptchaLang;
  String emailVerification;
  String createdDate;
  String updatedDate;

  GeneralData({
      this.id, 
      this.application_name, 
      this.description, 
      this.favicon, 
      this.logo, 
      this.timezone, 
      this.currency, 
      this.language, 
      this.copyright, 
      this.admin_email, 
      this.email_from, 
      this.smtp_host, 
      this.smtp_port, 
      this.smtp_user, 
      this.smtp_pass, 
      this.facebook_link, 
      this.twitter_link, 
      this.google_link, 
      this.youtube_link, 
      this.linkedin_link, 
      this.instagram_link, 
      this.recaptchaSecretKey, 
      this.recaptchaSiteKey, 
      this.map_api_key, 
      this.razorpay_key_id, 
      this.razorpayKeySecret, 
      this.mapAccessToken, 
      this.defaultMap, 
      this.terms_and_conditions, 
      this.recaptchaLang, 
      this.emailVerification, 
      this.createdDate, 
      this.updatedDate});

  GeneralData.fromJson(dynamic json) {
    id = json["id"];
    application_name = json["application_name"];
    description = json["description"];
    favicon = json["favicon"];
    logo = json["logo"];
    timezone = json["timezone"];
    currency = json["currency"];
    language = json["language"];
    copyright = json["copyright"];
    admin_email = json["admin_email"];
    email_from = json["email_from"];
    smtp_host = json["smtp_host"];
    smtp_port = json["smtp_port"];
    smtp_user = json["smtp_user"];
    smtp_pass = json["smtp_pass"];
    facebook_link = json["facebook_link"];
    twitter_link = json["twitter_link"];
    google_link = json["google_link"];
    youtube_link = json["youtube_link"];
    linkedin_link = json["linkedin_link"];
    instagram_link = json["instagram_link"];
    recaptchaSecretKey = json["recaptchaSecretKey"];
    recaptchaSiteKey = json["recaptchaSiteKey"];
    map_api_key = json["map_api_key"];
    razorpay_key_id = json["razorpay_key_id"];
    razorpayKeySecret = json["razorpayKeySecret"];
    mapAccessToken = json["mapAccessToken"];
    defaultMap = json["defaultMap"];
    terms_and_conditions = json["terms_and_conditions"];
    recaptchaLang = json["recaptchaLang"];
    emailVerification = json["emailVerification"];
    createdDate = json["createdDate"];
    updatedDate = json["updatedDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["application_name"] = application_name;
    map["description"] = description;
    map["favicon"] = favicon;
    map["logo"] = logo;
    map["timezone"] = timezone;
    map["currency"] = currency;
    map["language"] = language;
    map["copyright"] = copyright;
    map["admin_email"] = admin_email;
    map["email_from"] = email_from;
    map["smtp_host"] = smtp_host;
    map["smtp_port"] = smtp_port;
    map["smtp_user"] = smtp_user;
    map["smtp_pass"] = smtp_pass;
    map["facebook_link"] = facebook_link;
    map["twitter_link"] = twitter_link;
    map["google_link"] = google_link;
    map["youtube_link"] = youtube_link;
    map["linkedin_link"] = linkedin_link;
    map["instagram_link"] = instagram_link;
    map["recaptchaSecretKey"] = recaptchaSecretKey;
    map["recaptchaSiteKey"] = recaptchaSiteKey;
    map["map_api_key"] = map_api_key;
    map["razorpay_key_id"] = razorpay_key_id;
    map["razorpayKeySecret"] = razorpayKeySecret;
    map["mapAccessToken"] = mapAccessToken;
    map["defaultMap"] = defaultMap;
    map["terms_and_conditions"] = terms_and_conditions;
    map["recaptchaLang"] = recaptchaLang;
    map["emailVerification"] = emailVerification;
    map["createdDate"] = createdDate;
    map["updatedDate"] = updatedDate;
    return map;
  }

}