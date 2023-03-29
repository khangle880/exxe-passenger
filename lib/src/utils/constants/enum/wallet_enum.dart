import 'package:flutter/material.dart';

import '../../../config/config.dart';

enum TransactionState { draft, done }

enum JournalType {
  cash,
  bank,
}

extension JournalTypeExt on JournalType {
  String get getName {
    switch (this) {
      case JournalType.cash:
        return 'cash';
      case JournalType.bank:
        return 'bank';
    }
  }
}

enum RemainingPaymentMethod {
  cash,
  exxeWallet,
}

extension RemainPaymentMethodExt on RemainingPaymentMethod {
  String get getName {
    switch (this) {
      case RemainingPaymentMethod.cash:
        return 'Tiền mặt';
      case RemainingPaymentMethod.exxeWallet:
        return 'Tài khoản Exxe';
    }
  }

  String get subTitle {
    switch (this) {
      case RemainingPaymentMethod.cash:
        return 'Thanh toán với tài xế';
      case RemainingPaymentMethod.exxeWallet:
        return 'Chọn tài khoản exxe';
    }
  }

  String get iconPath {
    switch (this) {
      case RemainingPaymentMethod.cash:
        return AppIcons.moneyDollar;
      case RemainingPaymentMethod.exxeWallet:
        return AppIcons.wallet;
    }
  }
}

enum PaymentType { inbound, outbound }

enum PartnerType { customer }

enum WalletType { sample }

enum PaymentPurpose {
  passengerWalletRecharge,
  passengerWithdrawing,
  passengerDeposit,
  customerInvoice,
  cancelPassengerDeposit,
  returnPassengerDeposit,
  returnCarDriverDeposit,
  exxeReward,
}

// payment_purpose = fields.Selection([
// ('passenger_wallet_recharge',   'Passenger Wallet Recharge Request'),
// ('passenger_deposit',           'Passenger Deposit'),
// ('cancel_passenger_deposit',    'Cancel Passenger Deposit'),
// ('return_passenger_deposit',    'Return Passenger Deposit'),
// ('customer_invoice',            'Compounding Car Customer Invoice'),
// ('passenger_withdrawing',       'Passenger Withdrawing Request'),
// ('exxe_reward',                 'ExxE Reward'),
// ])

enum PaymentPurposeGroup {
  withdrawing,
  recharge,
  deposit,
  returnDeposit,
  invoice,
  reward,
  cancel,
}

class PaymentLimit {
  static const max = 5000000;
  static const min = 50000;
}

extension PaymentPurposeGroupExt on PaymentPurposeGroup {
  String get name {
    switch (this) {
      case PaymentPurposeGroup.reward:
        return "Quà tặng";
      case PaymentPurposeGroup.deposit:
        return "Đặt cọc";
      case PaymentPurposeGroup.returnDeposit:
        return "Hoàn cọc";
      case PaymentPurposeGroup.invoice:
        return "Hoá đơn";
      case PaymentPurposeGroup.withdrawing:
        return "Rút tiền";
      case PaymentPurposeGroup.recharge:
        return "Nạp tiền";
      case PaymentPurposeGroup.cancel:
        return "Hủy cọc";
    }
  }

  List<PaymentPurpose> get states {
    switch (this) {
      case PaymentPurposeGroup.reward:
        return [PaymentPurpose.exxeReward];
      case PaymentPurposeGroup.deposit:
        return [PaymentPurpose.passengerDeposit];
      case PaymentPurposeGroup.returnDeposit:
        return [
          PaymentPurpose.returnCarDriverDeposit,
          PaymentPurpose.returnPassengerDeposit
        ];
      case PaymentPurposeGroup.invoice:
        return [PaymentPurpose.customerInvoice];
      case PaymentPurposeGroup.withdrawing:
        return [PaymentPurpose.passengerWithdrawing];
      case PaymentPurposeGroup.recharge:
        return [PaymentPurpose.passengerWalletRecharge];
      case PaymentPurposeGroup.cancel:
        return [PaymentPurpose.cancelPassengerDeposit];
    }
  }
}

extension PaymentPurposeEnumExt on PaymentPurpose {
  Color get getStatusColor {
    switch (this) {
      case PaymentPurpose.exxeReward:
        return AppColors.green60;
      case PaymentPurpose.passengerDeposit:
        return AppColors.accOrange;
      case PaymentPurpose.returnPassengerDeposit:
      case PaymentPurpose.returnCarDriverDeposit:
        return AppColors.accOrange;
      case PaymentPurpose.customerInvoice:
        return AppColors.utilRed;
      case PaymentPurpose.passengerWithdrawing:
        return AppColors.utilRed;
      case PaymentPurpose.passengerWalletRecharge:
        return AppColors.green60;
      case PaymentPurpose.cancelPassengerDeposit:
        return AppColors.utilRed;
    }
  }

  String get getTitle {
    switch (this) {
      case PaymentPurpose.exxeReward:
        return "QUÀ TẶNG";
      case PaymentPurpose.passengerDeposit:
        return "ĐẶT CỌC CHUYẾN ĐI";
      case PaymentPurpose.returnPassengerDeposit:
      case PaymentPurpose.returnCarDriverDeposit:
        return "HOÀN CỌC CHUYẾN ĐI";
      case PaymentPurpose.customerInvoice:
        return "HÓA ĐƠN CHUYẾN ĐI";
      case PaymentPurpose.passengerWithdrawing:
        return "RÚT TIỀN";
      case PaymentPurpose.passengerWalletRecharge:
        return "NẠP TIỀN VÀO VÍ";
      case PaymentPurpose.cancelPassengerDeposit:
        return "HỦY CỌC";
    }
  }

  String get getStatusTitle {
    switch (this) {
      case PaymentPurpose.exxeReward:
        return "Quà tặng";
      case PaymentPurpose.passengerDeposit:
        return "Đã đặt cọc";
      case PaymentPurpose.returnPassengerDeposit:
      case PaymentPurpose.returnCarDriverDeposit:
        return "Đã hoàn cọc";
      case PaymentPurpose.customerInvoice:
        return "Hoá đơn";
      case PaymentPurpose.passengerWithdrawing:
        return "Đã rút tiền";
      case PaymentPurpose.passengerWalletRecharge:
        return "Đã nạp tiền";
      case PaymentPurpose.cancelPassengerDeposit:
        return "Đã hủy cọc";
    }
  }

  String get getSign {
    switch (this) {
      case PaymentPurpose.exxeReward:
        return "+";
      case PaymentPurpose.passengerDeposit:
        return "";
      case PaymentPurpose.returnPassengerDeposit:
      case PaymentPurpose.returnCarDriverDeposit:
        return "";
      case PaymentPurpose.customerInvoice:
        return "-";
      case PaymentPurpose.passengerWithdrawing:
        return "-";
      case PaymentPurpose.passengerWalletRecharge:
        return "+";
      case PaymentPurpose.cancelPassengerDeposit:
        return "-";
    }
  }
}
