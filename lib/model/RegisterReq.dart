class RegisterReq{
  String name;
  String mobile;
  String email;
  String password;
  String login_type;
  String otp;
  String deviceToken;
  String reffCode;

  RegisterReq(this.name, this.mobile, this.email, this.password, this.login_type, this.otp, this.deviceToken, this.reffCode);
}