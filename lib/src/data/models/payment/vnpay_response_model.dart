import '../../../utils/constants/enum/enum.dart';
import '../../../utils/parser_utils.dart';
import '../models.dart';

class VnpayResponseModel {
  VnpayResponseModel({
    this.name,
    this.paymentId,
    this.compoundingCarId,
    this.compoundingCarCustomerId,
    this.vnpayCode,
    this.amount,
    this.description,
    this.bankCode,
    this.transactionNo,
    this.bankTransactionCode,
    this.cardType,
    this.payDate,
    this.responseCode,
    this.state,
  });

  VnpayResponseModel.fromJson(dynamic json) {
    name = safeParse(json['name']);
    paymentId = json['payment_id'] != null
        ? PaymentModel.fromJson(json['payment_id'])
        : null;
    compoundingCarId = safeParse(json['compounding_car_id']);
    compoundingCarCustomerId = safeParse(json['compounding_car_customer_id']);
    vnpayCode = safeParse(json['vnpay_code']);
    amount = safeParse(json['amount']);
    description = safeParse(json['description']);
    bankCode = safeParse(json['bank_code']);
    transactionNo = safeParse(json['transaction_no']);
    bankTransactionCode = safeParse(json['bank_transaction_code']);
    cardType = safeParse(json['card_type']);
    payDate = safeParse(json['pay_date']);
    responseCode = safeParse(json['response_code']);
    state = safeParse(json['state'],payload: TransactionState.values);
  }

  String? name;
  PaymentModel? paymentId;
  num? compoundingCarId;
  num? compoundingCarCustomerId;
  String? vnpayCode;
  num? amount;
  String? description;
  String? bankCode;
  String? transactionNo;
  String? bankTransactionCode;
  String? cardType;
  String? payDate;
  String? responseCode;
  TransactionState? state;

  VnpayResponseModel copyWith({
    String? name,
    PaymentModel? paymentId,
    num? compoundingCarId,
    num? compoundingCarCustomerId,
    String? vnpayCode,
    num? amount,
    String? description,
    String? bankCode,
    String? transactionNo,
    String? bankTransactionCode,
    String? cardType,
    String? payDate,
    String? responseCode,
    TransactionState? state,
  }) =>
      VnpayResponseModel(
        name: name ?? this.name,
        paymentId: paymentId ?? this.paymentId,
        compoundingCarId: compoundingCarId ?? this.compoundingCarId,
        compoundingCarCustomerId:
            compoundingCarCustomerId ?? this.compoundingCarCustomerId,
        vnpayCode: vnpayCode ?? this.vnpayCode,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        bankCode: bankCode ?? this.bankCode,
        transactionNo: transactionNo ?? this.transactionNo,
        bankTransactionCode: bankTransactionCode ?? this.bankTransactionCode,
        cardType: cardType ?? this.cardType,
        payDate: payDate ?? this.payDate,
        responseCode: responseCode ?? this.responseCode,
        state: state ?? this.state,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    if (paymentId != null) {
      map['payment_id'] = paymentId?.toJson();
    }
    map['compounding_car_id'] = compoundingCarId;
    map['compounding_car_customer_id'] = compoundingCarCustomerId;
    map['vnpay_code'] = vnpayCode;
    map['amount'] = amount;
    map['description'] = description;
    map['bank_code'] = bankCode;
    map['transaction_no'] = transactionNo;
    map['bank_transaction_code'] = bankTransactionCode;
    map['card_type'] = cardType;
    map['pay_date'] = payDate;
    map['response_code'] = responseCode;
    map['state'] = state;
    return map;
  }

  static Map<String, String> get vnpayResponseMessage => {
        "00": "Giao dịch thành công.",
        "07":
            "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).",
        "09":
            "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.",
        "10":
            "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần",
        "11":
            "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.",
        "12":
            "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.",
        "13":
            "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch.",
        "24": "Giao dịch không thành công do: Khách hàng hủy giao dịch",
        "51":
            "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.",
        "65":
            "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.",
        "75": "Ngân hàng thanh toán đang bảo trì.",
        "79":
            "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch",
        "99": "Đã có lỗi",
      };
}
