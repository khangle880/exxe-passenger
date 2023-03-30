import '../../../utils/export/ui_export.dart';

/// vnpay_payment_url : "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=400000000&vnp_BankCode=VNBANK&vnp_Command=pay&vnp_CreateDate=20221001113359&vnp_CurrCode=VND&vnp_IpAddr=127.0.0.1&vnp_Locale=vn&vnp_OrderInfo=EXXE_APPUSER-0987147539+makes+wallet+recharge+request.+Amount%3A+4000000.0&vnp_OrderType=other&vnp_ReturnUrl=321a&vnp_TmnCode=EXXEVN03&vnp_TxnRef=PYM-20221001113359-eeYvPj693MWEc7&vnp_Version=2.1.0&vnp_SecureHash=f24b01d53d389e148d97ef34b7fc8541b02861ada6aa130da26f4f0559bda439b6c4316c1578c2e75da9b9a2d82c1bc1b7f25a45d1d54684ab27961c7805145a"
/// vnpay_code : "PYM-20221001113359-eeYvPj693MWEc7"
/// payment_id : 1515

class PaymentRequestModel {
  PaymentRequestModel({
    String? vnpayPaymentUrl,
    String? vnpayCode,
    num? paymentId,
  }) {
    _vnpayPaymentUrl = vnpayPaymentUrl;
    _vnpayCode = vnpayCode;
    _paymentId = paymentId;
  }

  PaymentRequestModel.fromJson(dynamic json) {
    _vnpayPaymentUrl = safeParse(json['vnpay_payment_url']);
    _vnpayCode = safeParse(json['vnpay_code']);
    _paymentId = safeParse(json['payment_id']);
  }

  String? _vnpayPaymentUrl;
  String? _vnpayCode;
  num? _paymentId;

  PaymentRequestModel copyWith({
    String? vnpayPaymentUrl,
    String? vnpayCode,
    num? paymentId,
  }) =>
      PaymentRequestModel(
        vnpayPaymentUrl: vnpayPaymentUrl ?? _vnpayPaymentUrl,
        vnpayCode: vnpayCode ?? _vnpayCode,
        paymentId: paymentId ?? _paymentId,
      );

  String? get vnpayPaymentUrl => _vnpayPaymentUrl;

  String? get vnpayCode => _vnpayCode;

  num? get paymentId => _paymentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vnpay_payment_url'] = _vnpayPaymentUrl;
    map['vnpay_code'] = _vnpayCode;
    map['payment_id'] = _paymentId;
    return map;
  }
}
