class RazorpaySuccessRes {
  String paymentId;
  String orderId;
  String signature;

  RazorpaySuccessRes({this.paymentId, this.orderId, this.signature});

//  static RazorpaySuccessRes fromMap(Map<dynamic, dynamic> map) {
//    String paymentId = map["razorpay_payment_id"];
//    String signature = map["razorpay_signature"];
//    String orderId = map["razorpay_order_id"];
//
//    return new RazorpaySuccessRes(paymentId, orderId, signature);
//  }

  Map toJson() => {
    'paymentId': paymentId,
    'orderId': orderId,
    'signature': signature,
  };
}


class RazorpayWalletSuccessRes {
  String walletName;

  RazorpayWalletSuccessRes(this.walletName);

  static RazorpayWalletSuccessRes fromMap(Map<dynamic, dynamic> map) {
    var walletName = map["external_wallet"] as String;
    return new RazorpayWalletSuccessRes(walletName);
  }

  Map toJson() => {
    'walletName': walletName
  };
}
