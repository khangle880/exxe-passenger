// COMPOUNDING_CAR_CUSTOMER_STATE = [
// ('draft', 'New'),                                    ### Nháp
//
// ('confirm', 'Customer Confirmed'),   ### Đã Xác nhận
// ('deposit', 'Deposited'),                      ### Đã Xác nhận
// ('waiting', 'Connecting Car Driver'), ### Đã xác nhận
// ('assign', 'Assigned Car Driver'),       ### Đã xác nhận
// ('in_process', 'Processing'),               ### Đã Xác nhận
//
// ('done', 'Done'),                                  ### Hoàn Thành
// ('customer_pay', 'Customer Paid'),   ### Hoàn Thành
// ('confirm_pay', 'Confirm Paid'),        ### Hoàn Thành
//
// ('cancel', 'Cancel')                               ### Hủy
// ]

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/config.dart';

enum RatingStateEnum { noRating, rated, unRating }

enum CompoundingCarState {
  draft,
  waiting,
  waitingDeposit,
  confirmDeposit,

  /// for convenient type
  confirm,
  startRunning,
  stopPicking,
  done,
  cancel,
}

enum CompoundingCarCustomerState {
  draft,
  confirm,
  deposit,
  waiting,
  assign,
  startRunning,
  waitingCustomer,
  inProcess,
  stopProcess,
  startReturn,
  inReturnProcess,
  done,
  customerPay,
  confirmPay,
  confirmPaid,
  cancel,
}

enum CompoundingCarRatingState {
  unRating,
  noRating,
  rated,
}

enum CompoundingCarStateGroup {
  all,
  draft,
  processing,
  inProcess,
  confirmPaid,
  cancel,
}

extension CompoundingCarStateGroupExt on CompoundingCarStateGroup {
  String get name {
    switch (this) {
      case CompoundingCarStateGroup.all:
        return "Tất cả";
      case CompoundingCarStateGroup.draft:
        return "Đơn nháp";
      case CompoundingCarStateGroup.processing:
        return "Đang chờ";
      case CompoundingCarStateGroup.inProcess:
        return "Đang di chuyển";
      case CompoundingCarStateGroup.confirmPaid:
        return "Đã hoàn thành";
      case CompoundingCarStateGroup.cancel:
        return "Đã hủy";
    }
  }

  List<CompoundingCarCustomerState> get states {
    switch (this) {
      case CompoundingCarStateGroup.all:
        return [];
      case CompoundingCarStateGroup.draft:
        return [
          CompoundingCarCustomerState.draft,
          CompoundingCarCustomerState.confirm,
        ];
      case CompoundingCarStateGroup.processing:
        return [
          CompoundingCarCustomerState.waiting,
          CompoundingCarCustomerState.assign,
          CompoundingCarCustomerState.startRunning,
          CompoundingCarCustomerState.waitingCustomer,
          CompoundingCarCustomerState.deposit,
        ];
      case CompoundingCarStateGroup.inProcess:
        return [
          CompoundingCarCustomerState.inProcess,
          CompoundingCarCustomerState.done,
          CompoundingCarCustomerState.stopProcess,
          CompoundingCarCustomerState.startReturn,
          CompoundingCarCustomerState.inReturnProcess,
          CompoundingCarCustomerState.customerPay,
        ];
      case CompoundingCarStateGroup.confirmPaid:
        return [
          CompoundingCarCustomerState.confirmPay,
          CompoundingCarCustomerState.confirmPaid
        ];
      case CompoundingCarStateGroup.cancel:
        return [CompoundingCarCustomerState.cancel];
    }
  }
}

extension CompoundingCarCustomerStateExt on CompoundingCarCustomerState {
  String get name {
    switch (this) {
      case CompoundingCarCustomerState.draft:
        return 'Đơn nháp';
      case CompoundingCarCustomerState.confirm:
        return 'Đã xác nhận';
      case CompoundingCarCustomerState.deposit:
        return 'Đã đặt cọc';
      case CompoundingCarCustomerState.waiting:
        return 'Đang chờ';
      case CompoundingCarCustomerState.assign:
        return 'Đã có tài xế';
      case CompoundingCarCustomerState.startRunning:
        return 'Tài xế đang đến đón bạn';
      case CompoundingCarCustomerState.waitingCustomer:
        return 'Tài xế đang đợi';
      case CompoundingCarCustomerState.inProcess:
        return 'Đang di chuyển';
      case CompoundingCarCustomerState.stopProcess:
        return 'Đã kết thúc chiều đi';
      case CompoundingCarCustomerState.startReturn:
        return 'Bắt đầu trở về';
      case CompoundingCarCustomerState.inReturnProcess:
        return 'Đang di chuyển về';
      case CompoundingCarCustomerState.done:
        return 'Đã trả khách';
      case CompoundingCarCustomerState.customerPay:
        return 'Đã thanh toán';
      case CompoundingCarCustomerState.confirmPay:
      case CompoundingCarCustomerState.confirmPaid:
        return 'Đã hoàn thành';
      case CompoundingCarCustomerState.cancel:
        return 'Đã hủy';
    }
  }

  Color get colorByState {
    switch (this) {
      case CompoundingCarCustomerState.draft:
        return AppColors.gray50;

      case CompoundingCarCustomerState.confirm:
      case CompoundingCarCustomerState.deposit:
      case CompoundingCarCustomerState.waiting:
      case CompoundingCarCustomerState.assign:
      case CompoundingCarCustomerState.startRunning:
      case CompoundingCarCustomerState.waitingCustomer:
      case CompoundingCarCustomerState.inProcess:
      case CompoundingCarCustomerState.stopProcess:
      case CompoundingCarCustomerState.startReturn:
      case CompoundingCarCustomerState.inReturnProcess:
        return AppColors.orangeMain;

      case CompoundingCarCustomerState.done:
      case CompoundingCarCustomerState.customerPay:
      case CompoundingCarCustomerState.confirmPay:
      case CompoundingCarCustomerState.confirmPaid:
        return AppColors.green60;

      case CompoundingCarCustomerState.cancel:
        return AppColors.utilRed;
    }
  }
}

enum CompoundingType { oneWay, twoWay, compounding, convenient }

extension CompoundingTypeExt on CompoundingType {
  String get name {
    if (this == CompoundingType.oneWay) {
      return 'Một chiều';
    }
    if (this == CompoundingType.twoWay) {
      return 'Hai chiều';
    }
    if (this == CompoundingType.compounding) {
      return 'Ghép chuyến';
    }
    return 'Tiện chuyến';
  }

  Color get colorByTrip {
    if (this == CompoundingType.oneWay) {
      return AppColors.primaryMain;
    } else if (this == CompoundingType.twoWay) {
      return AppColors.accGreenMain;
    } else if (this == CompoundingType.compounding) {
      return AppColors.secondaryMain;
    }
    return AppColors.accOrgangeMain;
  }

  Widget getSvg({double width = 20, Color? color}) {
    switch (this) {
      case CompoundingType.oneWay:
        return SvgPicture.asset(
          AppIcons.oneWay,
          width: width,
          color: color,
        );
      case CompoundingType.twoWay:
        return SvgPicture.asset(
          AppIcons.twoWay,
          width: width,
          color: color,
        );
      case CompoundingType.compounding:
        return SvgPicture.asset(
          AppIcons.joinWay,
          width: width,
          color: color,
        );
      case CompoundingType.convenient:
        return SvgPicture.asset(
          AppIcons.oneWay,
          width: width,
          color: color ?? const Color(0xFFFBB500),
        );
    }
  }
}
