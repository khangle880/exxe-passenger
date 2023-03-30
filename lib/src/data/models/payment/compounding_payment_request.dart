import '../../../utils/utils.dart';
import '../models.dart';

/// provider : "vnpay"
/// vnpay_payment_url : "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=26000000&vnp_BankCode=VNBANK&vnp_Command=pay&vnp_CreateDate=20221005105916&vnp_CurrCode=VND&vnp_IpAddr=127.0.0.1&vnp_Locale=vn&vnp_OrderInfo=EXXE_APP+Compounding+Car+Customer+From+binh+duong+to+binh+dinh&vnp_OrderType=other&vnp_ReturnUrl=313131sd31&vnp_TmnCode=EXXEVN03&vnp_TxnRef=CUS-20221005105916-FaXGTrcrjicGyu&vnp_Version=2.1.0&vnp_SecureHash=c82e703247eaa60e98a6757eed91d64c4baad739d6ae6b10e3804411f7635b2da84f8e338f2c18e60fb4373bdd19b2f003c0623dc95033ca0161e933dbb572bc"
/// vnpay_code : "CUS-20221005105916-FaXGTrcrjicGyu"

class CompoundingPaymentRequest {
  CompoundingPaymentRequest(
      {String? provider,
      String? vnpayPaymentUrl,
      String? vnpayCode,
      CompoundingCarCustomerModel? customer}) {
    provider = provider;
    vnpayPaymentUrl = vnpayPaymentUrl;
    vnpayCode = vnpayCode;
    customer = customer;
  }

  CompoundingPaymentRequest.fromJson(dynamic json) {
    provider = safeParse(json['provider']);
    vnpayPaymentUrl = safeParse(json['vnpay_payment_url']);
    vnpayCode = safeParse(json['vnpay_code']);
    customer = json['compounding_car_customer_id'] != null
        ? CompoundingCarCustomerModel.fromJson(
            json['compounding_car_customer_id'])
        : null;
  }

  String? provider;
  String? vnpayPaymentUrl;
  String? vnpayCode;
  CompoundingCarCustomerModel? customer;
}
