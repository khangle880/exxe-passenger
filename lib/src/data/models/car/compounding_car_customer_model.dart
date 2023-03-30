import '../../../utils/utils.dart';
import '../models.dart';

/// compounding_car_id : 584
/// compounding_car_name : "One-Way: From An Giang to TP Hồ Chí Minh"
/// compounding_car_customer_id : 949
/// partner : {"partner_id":45,"partner_name":"Lê Thành Hoàn","phone":"0987147534","avatar_url":{"image_id":320,"image_url":"/manage_detail_data/static/src/img/stored-attachment-module-x7UxjvqsRiXgxfUoJ1elUbzgY6fhzl2D-1661782296-otyyWBKTWZgJD975ZKx9YvnfVliIzzId-1661782296.png"}}
/// compounding_type : "one_way"
/// expected_going_on_date : "2022-09-13 17:30:00"
/// expected_picking_up_date : false
/// car : {"car_id":2,"name":"XE 5 CHỖ","number_seat":4,"icon":{"icon_id":false,"icon_url":false}}
/// from_province : {"province_id":1044,"province_name":"An Giang","province_short_name":"A.Giang","province_brief_name":"An Giang","province_vietnamese_name":"angiang","image_url":{"id":4,"url":"/management_ghn_integration/static/src/img/odoosmes-com-angiang-1657707544.png"},"latitude":"10.3747638","longitude":"105.4171817"}
/// from_pick_up_station : {"station_name":false,"station_id":false,"station_image":{"id":false,"url":false},"latitude":false,"longitude":false}
/// is_picking_up_from_start : false
/// from_address : "123a"
/// from_longitude : "123a"
/// from_latitude : "123a"
/// to_province : {"province_id":1066,"province_name":"TP Hồ Chí Minh","province_short_name":"TP.HCM","province_brief_name":"TP.HCM","province_vietnamese_name":"hochiminh","image_url":{"id":154,"url":"/management_ghn_integration/static/src/img/odoosmes-com-hochiminh-1657707551.png"},"latitude":"10.7718733","longitude":"106.6952249"}
/// to_pick_up_station : {"station_name":false,"station_id":false,"station_image":{"id":false,"url":false},"latitude":false,"longitude":false}
/// is_taking_to_final_destination : false
/// to_address : "123a"
/// to_longitude : "123a"
/// to_latitude : "123a"
/// is_a_day_tour : false
/// hour_of_wait_time : false
/// distance : 500.0
/// duration : 120.0
/// customer_deposit_percentage : "20.0"
/// number_seat : 4
/// payment_method : false
/// amount_undiscounted : 5000000.0
/// discount_after_tax : 0.0
/// amount_total : 0.0
/// down_payment : {"percent":0.2,"total":1000000.0}
/// amount_due : 0
/// state : "cancel"
/// second_remains : 0
/// second_waiting_remains : 0
/// confirm_date : false
/// paid_date : false
/// cancel_date : "2022-09-12 16:22:01"
/// deposit_date : false
/// amount_return : 0.0
/// cancel_reason : {"cancel_reason_id":47,"reason":"Tôi muốn thay đổi hình thức thanh toán"}
/// number_available_seat : 4
/// car_driver_id : {"partner_id":false,"partner_name":false,"phone":false,"avatar_url":{"image_id":false,"image_url":false},"car_information":[],"rating_number":0.0}
/// price_unit : {"price_distance_unit_id":15,"name":"Price By Distance From 500.0 Kms To 850.0 Kms - XE 5 CHỖ","car_id":{"car_id":2,"name":"XE 5 CHỖ","icon":{"icon_id":false,"icon_url":false}},"price_unit_per_km":10000.0,"price_unit":5000000}
/// fee_final_destination : 0.0
/// promotion : ""
/// sale_order_id : false
/// note : false

class CompoundingCarCustomerModel {
  CompoundingCarModel? compoundingCarData;
  num? compoundingCarId;
  String? compoundingCarName;
  num? compoundingCarCustomerId;
  String? compoundingCarCustomerCode;
  PartnerModel? partner;
  CompoundingType? compoundingType;
  DateTime? expectedGoingOnDate;
  DateTime? expectedPickingUpDate;
  CarModel? car;
  ProvinceModel? fromProvince;
  StationModel? fromPickUpStation;
  bool? isPickingUpFromStart;
  String? fromAddress;
  String? fromLongitude;
  String? fromLatitude;
  ProvinceModel? toProvince;
  StationModel? toPickUpStation;
  bool? isTakingToFinalDestination;
  String? toAddress;
  String? toLongitude;
  String? toLatitude;
  bool? isADayTour;
  num? hourOfWaitTime;
  num? distance;
  num? duration;
  double? customerDepositPercentage;
  num? numberSeat;
  String? paymentMethod;
  num? amountUndiscounted;
  num? discountAfterTax;
  num? amountTotal;
  DownPayment? downPayment;
  OvertimeSurchargeModel? overtimeSurcharge;
  num? tollsSurcharge;
  num? tip;
  num? amountDue;
  CompoundingCarCustomerState? state;
  num? secondRemains;
  num? secondWaitingRemains;
  DateTime? confirmDate;
  DateTime? paidDate;
  String? cancelDate;
  DateTime? depositDate;
  num? amountReturn;
  CancelReasonModel? cancelReason;
  String? qualityCar;
  num? numberAvailableSeat;
  CarDriverModel? carDriverId;
  CarPriceModel? priceUnit;
  num? feeFinalDestination;
  PromotionModel? promotion;
  num? saleOrderId;
  String? note;
  RatingResModel? rating;
  CompoundingCarRatingState? ratingState;
  List<CarPriceModel>? carPriceModels;

  bool get shouldShow => state != null;

  /// address available can show view
  String? get fromAddressShow => ([
        CompoundingType.oneWay,
        CompoundingType.twoWay
      ]).contains(compoundingType)
          ? fromAddress
          : (isPickingUpFromStart ?? false)
              ? fromAddress
              : fromPickUpStation?.stationName;

  /// address available can show view
  String? get toAddressShow =>
      [CompoundingType.oneWay, CompoundingType.twoWay].contains(compoundingType)
          ? toAddress
          : toPickUpStation?.stationName;

  LocationModel get fromLocation => LocationModel(
        coordinate: CoordinateModel(
          longitude: double.tryParse(fromLongitude ?? ''),
          latitude: double.tryParse(fromLatitude ?? ''),
        ),
        station: fromPickUpStation,
        province: fromProvince,
      );

  LocationModel get toLocation => LocationModel(
        coordinate: CoordinateModel(
          longitude: double.tryParse(toLongitude ?? ''),
          latitude: double.tryParse(toLatitude ?? ''),
        ),
        station: toPickUpStation,
        province: toProvince,
      );

  CompoundingCarCustomerModel({
    this.compoundingCarData,
    this.compoundingCarId,
    this.compoundingCarName,
    this.compoundingCarCustomerId,
    this.compoundingCarCustomerCode,
    this.partner,
    this.compoundingType,
    this.expectedGoingOnDate,
    this.expectedPickingUpDate,
    this.car,
    this.fromProvince,
    this.fromPickUpStation,
    this.isPickingUpFromStart,
    this.fromAddress,
    this.fromLongitude,
    this.fromLatitude,
    this.toProvince,
    this.toPickUpStation,
    this.isTakingToFinalDestination,
    this.toAddress,
    this.toLongitude,
    this.toLatitude,
    this.isADayTour,
    this.hourOfWaitTime,
    this.distance,
    this.duration,
    this.customerDepositPercentage,
    this.numberSeat,
    this.paymentMethod,
    this.amountUndiscounted,
    this.discountAfterTax,
    this.amountTotal,
    this.downPayment,
    this.overtimeSurcharge,
    this.tollsSurcharge,
    this.tip,
    this.amountDue,
    this.state,
    this.secondRemains,
    this.secondWaitingRemains,
    this.confirmDate,
    this.paidDate,
    this.cancelDate,
    this.depositDate,
    this.amountReturn,
    this.cancelReason,
    this.qualityCar,
    this.numberAvailableSeat,
    this.carDriverId,
    this.priceUnit,
    this.feeFinalDestination,
    this.promotion,
    this.saleOrderId,
    this.note,
    this.rating,
    this.ratingState,
    this.carPriceModels,
  });

  CompoundingCarCustomerModel.withLocation({
    this.compoundingCarData,
    this.compoundingCarId,
    this.compoundingCarName,
    this.compoundingCarCustomerId,
    this.compoundingCarCustomerCode,
    this.partner,
    this.compoundingType,
    this.expectedGoingOnDate,
    this.expectedPickingUpDate,
    this.car,
    this.isPickingUpFromStart,
    this.isTakingToFinalDestination,
    this.isADayTour,
    this.hourOfWaitTime,
    this.customerDepositPercentage,
    this.numberSeat,
    this.paymentMethod,
    this.amountUndiscounted,
    this.discountAfterTax,
    this.amountTotal,
    this.downPayment,
    this.amountDue,
    this.state,
    this.secondRemains,
    this.secondWaitingRemains,
    this.confirmDate,
    this.paidDate,
    this.cancelDate,
    this.depositDate,
    this.amountReturn,
    this.cancelReason,
    this.qualityCar,
    this.numberAvailableSeat,
    this.carDriverId,
    this.priceUnit,
    this.feeFinalDestination,
    this.promotion,
    this.saleOrderId,
    this.note,
    this.rating,
    this.ratingState,
    this.carPriceModels,
    LocationModel? from,
    LocationModel? to,
    DirectionsModel? directionsModel,
  }) {
    // from
    fromProvince = from?.province;
    fromPickUpStation = from?.station;
    fromAddress = from?.address;
    fromLongitude = from?.coordinate?.longitude.toString();
    fromLatitude = from?.coordinate?.latitude.toString();

    // to
    toProvince = to?.province;
    toPickUpStation = to?.station;
    toAddress = to?.address;
    toLongitude = to?.coordinate?.longitude.toString();
    toLatitude = to?.coordinate?.latitude.toString();

    // direction
    distance = directionsModel?.getDistanceKm;
    duration = directionsModel?.getDuration;
  }

  CompoundingCarCustomerModel copyWithModel(
      CompoundingCarCustomerModel customerData) {
    return CompoundingCarCustomerModel(
      compoundingCarData: customerData.compoundingCarData ?? compoundingCarData,
      compoundingCarId: customerData.compoundingCarId ?? compoundingCarId,
      compoundingCarName: customerData.compoundingCarName ?? compoundingCarName,
      compoundingCarCustomerId:
          customerData.compoundingCarCustomerId ?? compoundingCarCustomerId,
      compoundingCarCustomerCode:
          customerData.compoundingCarCustomerCode ?? compoundingCarCustomerCode,
      partner: customerData.partner ?? partner,
      compoundingType: customerData.compoundingType ?? compoundingType,
      expectedGoingOnDate:
          customerData.expectedGoingOnDate ?? expectedGoingOnDate,
      expectedPickingUpDate:
          customerData.expectedPickingUpDate ?? expectedPickingUpDate,
      car: customerData.car ?? car,
      fromProvince: customerData.fromProvince ?? fromProvince,
      fromPickUpStation: customerData.fromPickUpStation ?? fromPickUpStation,
      isPickingUpFromStart:
          customerData.isPickingUpFromStart ?? isPickingUpFromStart,
      fromAddress: customerData.fromAddress ?? fromAddress,
      fromLongitude: customerData.fromLongitude ?? fromLongitude,
      fromLatitude: customerData.fromLatitude ?? fromLatitude,
      toProvince: customerData.toProvince ?? toProvince,
      toPickUpStation: customerData.toPickUpStation ?? toPickUpStation,
      isTakingToFinalDestination:
          customerData.isTakingToFinalDestination ?? isTakingToFinalDestination,
      toAddress: customerData.toAddress ?? toAddress,
      toLongitude: customerData.toLongitude ?? toLongitude,
      toLatitude: customerData.toLatitude ?? toLatitude,
      isADayTour: customerData.isADayTour ?? isADayTour,
      hourOfWaitTime: customerData.hourOfWaitTime ?? hourOfWaitTime,
      distance: customerData.distance ?? distance,
      duration: customerData.duration ?? duration,
      customerDepositPercentage:
          customerData.customerDepositPercentage ?? customerDepositPercentage,
      numberSeat: customerData.numberSeat ?? numberSeat,
      paymentMethod: customerData.paymentMethod ?? paymentMethod,
      amountUndiscounted: customerData.amountUndiscounted ?? amountUndiscounted,
      discountAfterTax: customerData.discountAfterTax ?? discountAfterTax,
      amountTotal: customerData.amountTotal ?? amountTotal,
      downPayment: customerData.downPayment ?? downPayment,
      amountDue: customerData.amountDue ?? amountDue,
      state: customerData.state ?? state,
      secondRemains: customerData.secondRemains ?? secondRemains,
      secondWaitingRemains:
          customerData.secondWaitingRemains ?? secondWaitingRemains,
      confirmDate: customerData.confirmDate ?? confirmDate,
      paidDate: customerData.paidDate ?? paidDate,
      cancelDate: customerData.cancelDate ?? cancelDate,
      depositDate: customerData.depositDate ?? depositDate,
      amountReturn: customerData.amountReturn ?? amountReturn,
      cancelReason: customerData.cancelReason ?? cancelReason,
      qualityCar: customerData.qualityCar ?? qualityCar,
      numberAvailableSeat:
          customerData.numberAvailableSeat ?? numberAvailableSeat,
      carDriverId: customerData.carDriverId ?? carDriverId,
      priceUnit: customerData.priceUnit ?? priceUnit,
      feeFinalDestination:
          customerData.feeFinalDestination ?? feeFinalDestination,
      promotion: customerData.promotion ?? promotion,
      saleOrderId: customerData.saleOrderId ?? saleOrderId,
      note: customerData.note ?? note,
      rating: customerData.rating ?? rating,
      ratingState: customerData.ratingState ?? ratingState,
    );
  }

  CompoundingCarCustomerModel copyWith({
    CompoundingCarModel? compoundingCarData,
    num? compoundingCarId,
    String? compoundingCarName,
    num? compoundingCarCustomerId,
    String? compoundingCarCustomerCode,
    PartnerModel? partner,
    CompoundingType? compoundingType,
    DateTime? expectedGoingOnDate,
    DateTime? expectedPickingUpDate,
    CarModel? car,
    ProvinceModel? fromProvince,
    StationModel? fromPickUpStation,
    bool? isPickingUpFromStart,
    String? fromAddress,
    String? fromLongitude,
    String? fromLatitude,
    ProvinceModel? toProvince,
    StationModel? toPickUpStation,
    bool? isTakingToFinalDestination,
    String? toAddress,
    String? toLongitude,
    String? toLatitude,
    bool? isADayTour,
    num? hourOfWaitTime,
    num? distance,
    num? duration,
    double? customerDepositPercentage,
    num? numberSeat,
    String? paymentMethod,
    num? amountUndiscounted,
    num? discountAfterTax,
    num? amountTotal,
    DownPayment? downPayment,
    num? amountDue,
    CompoundingCarCustomerState? state,
    num? secondRemains,
    num? secondWaitingRemains,
    DateTime? confirmDate,
    DateTime? paidDate,
    String? cancelDate,
    DateTime? depositDate,
    num? amountReturn,
    CancelReasonModel? cancelReason,
    String? qualityCar,
    num? numberAvailableSeat,
    CarDriverModel? carDriverId,
    CarPriceModel? priceUnit,
    num? feeFinalDestination,
    PromotionModel? promotion,
    num? saleOrderId,
    String? note,
    RatingResModel? rating,
    CompoundingCarRatingState? ratingState,
  }) {
    return CompoundingCarCustomerModel(
      compoundingCarData: compoundingCarData ?? this.compoundingCarData,
      compoundingCarId: compoundingCarId ?? this.compoundingCarId,
      compoundingCarName: compoundingCarName ?? this.compoundingCarName,
      compoundingCarCustomerId:
          compoundingCarCustomerId ?? this.compoundingCarCustomerId,
      compoundingCarCustomerCode:
          compoundingCarCustomerCode ?? this.compoundingCarCustomerCode,
      partner: partner ?? this.partner,
      compoundingType: compoundingType ?? this.compoundingType,
      expectedGoingOnDate: expectedGoingOnDate ?? this.expectedGoingOnDate,
      expectedPickingUpDate:
          expectedPickingUpDate ?? this.expectedPickingUpDate,
      car: car ?? this.car,
      fromProvince: fromProvince ?? this.fromProvince,
      fromPickUpStation: fromPickUpStation ?? this.fromPickUpStation,
      isPickingUpFromStart: isPickingUpFromStart ?? this.isPickingUpFromStart,
      fromAddress: fromAddress ?? this.fromAddress,
      fromLongitude: fromLongitude ?? this.fromLongitude,
      fromLatitude: fromLatitude ?? this.fromLatitude,
      toProvince: toProvince ?? this.toProvince,
      toPickUpStation: toPickUpStation ?? this.toPickUpStation,
      isTakingToFinalDestination:
          isTakingToFinalDestination ?? this.isTakingToFinalDestination,
      toAddress: toAddress ?? this.toAddress,
      toLongitude: toLongitude ?? this.toLongitude,
      toLatitude: toLatitude ?? this.toLatitude,
      isADayTour: isADayTour ?? this.isADayTour,
      hourOfWaitTime: hourOfWaitTime ?? this.hourOfWaitTime,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      customerDepositPercentage:
          customerDepositPercentage ?? this.customerDepositPercentage,
      numberSeat: numberSeat ?? this.numberSeat,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountUndiscounted: amountUndiscounted ?? this.amountUndiscounted,
      discountAfterTax: discountAfterTax ?? this.discountAfterTax,
      amountTotal: amountTotal ?? this.amountTotal,
      downPayment: downPayment ?? this.downPayment,
      amountDue: amountDue ?? this.amountDue,
      state: state ?? this.state,
      secondRemains: secondRemains ?? this.secondRemains,
      secondWaitingRemains: secondWaitingRemains ?? this.secondWaitingRemains,
      confirmDate: confirmDate ?? this.confirmDate,
      paidDate: paidDate ?? this.paidDate,
      cancelDate: cancelDate ?? this.cancelDate,
      depositDate: depositDate ?? this.depositDate,
      amountReturn: amountReturn ?? this.amountReturn,
      cancelReason: cancelReason ?? this.cancelReason,
      qualityCar: qualityCar ?? this.qualityCar,
      numberAvailableSeat: numberAvailableSeat ?? this.numberAvailableSeat,
      carDriverId: carDriverId ?? this.carDriverId,
      priceUnit: priceUnit ?? this.priceUnit,
      feeFinalDestination: feeFinalDestination ?? this.feeFinalDestination,
      promotion: promotion ?? this.promotion,
      saleOrderId: saleOrderId ?? this.saleOrderId,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      ratingState: ratingState ?? this.ratingState,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['compounding_car_data'] = compoundingCarData;
    map['compounding_car_id'] = compoundingCarId;
    map['compounding_car_name'] = compoundingCarName;
    map['compounding_car_customer_id'] = compoundingCarCustomerId;
    if (partner != null) {
      map['partner'] = partner?.toJson();
    }
    map['compounding_type'] = compoundingType;
    map['expected_going_on_date'] = expectedGoingOnDate;
    map['expected_picking_up_date'] = expectedPickingUpDate;
    if (car != null) {
      map['car'] = car?.toJson();
    }
    if (fromProvince != null) {
      map['from_province'] = fromProvince?.toJson();
    }
    if (fromPickUpStation != null) {
      map['from_pick_up_station'] = fromPickUpStation?.toJson();
    }
    map['is_picking_up_from_start'] = isPickingUpFromStart;
    map['from_address'] = fromAddress;
    map['from_longitude'] = fromLongitude;
    map['from_latitude'] = fromLatitude;
    if (toProvince != null) {
      map['to_province'] = toProvince?.toJson();
    }
    if (toPickUpStation != null) {
      map['to_pick_up_station'] = toPickUpStation?.toJson();
    }
    map['is_taking_to_final_destination'] = isTakingToFinalDestination;
    map['to_address'] = toAddress;
    map['to_longitude'] = toLongitude;
    map['to_latitude'] = toLatitude;
    map['is_a_day_tour'] = isADayTour;
    map['hour_of_wait_time'] = hourOfWaitTime;
    map['distance'] = distance;
    map['duration'] = duration;
    map['customer_deposit_percentage'] = customerDepositPercentage;
    map['number_seat'] = numberSeat;
    map['payment_method'] = paymentMethod;
    map['amount_undiscounted'] = amountUndiscounted;
    map['discount_after_tax'] = discountAfterTax;
    map['amount_total'] = amountTotal;
    if (downPayment != null) {
      map['down_payment'] = downPayment?.toJson();
    }
    if (overtimeSurcharge != null) {
      map['overtime_surcharge'] = overtimeSurcharge?.toJson();
    }
    map['tolls_surcharge'] = tollsSurcharge;
    map['tip'] = tip;
    map['amount_due'] = amountDue;
    map['state'] = state;
    map['second_remains'] = secondRemains;
    map['second_waiting_remains'] = secondWaitingRemains;
    map['confirm_date'] = confirmDate;
    map['paid_date'] = paidDate;
    map['cancel_date'] = cancelDate;
    map['deposit_date'] = depositDate;
    map['amount_return'] = amountReturn;
    if (cancelReason != null) {
      map['cancel_reason'] = cancelReason?.toJson();
    }
    map['number_available_seat'] = numberAvailableSeat;
    if (carDriverId != null) {
      map['car_driver_id'] = carDriverId?.toJson();
    }
    if (priceUnit != null) {
      map['price_unit'] = priceUnit?.toJson();
    }
    map['fee_final_destination'] = feeFinalDestination;
    map['promotion'] = promotion;
    map['sale_order_id'] = saleOrderId;
    map['note'] = note;
    map['rating'] = rating;
    map['rating_state'] = ratingState;
    return map;
  }

  factory CompoundingCarCustomerModel.fromJson(dynamic json) {
    return CompoundingCarCustomerModel(
      compoundingCarData: json['compounding_car_data'] != null
          ? CompoundingCarModel.fromJson(json['compounding_car_data'])
          : null,
      compoundingCarId: safeParse(json['compounding_car_id']),
      compoundingCarName: safeParse(json['compounding_car_name']),
      compoundingCarCustomerId: safeParse(json['compounding_car_customer_id']),
      compoundingCarCustomerCode:
          safeParse(json['compounding_car_customer_code']),
      partner: json['partner'] != null
          ? PartnerModel.fromJson(json['partner'])
          : null,
      compoundingType:
          safeParse(json['compounding_type'], payload: CompoundingType.values),
      expectedGoingOnDate: safeParse(json['expected_going_on_date']),
      expectedPickingUpDate: safeParse(json['expected_picking_up_date']),
      car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
      fromProvince: json['from_province'] != null
          ? ProvinceModel.fromJson(json['from_province'])
          : null,
      fromPickUpStation: json['from_pick_up_station'] != null
          ? StationModel.fromJson(json['from_pick_up_station'])
          : null,
      isPickingUpFromStart: safeParse(json['is_picking_up_from_start']),
      fromAddress: safeParse(json['from_address']),
      fromLongitude: safeParse(json['from_longitude']),
      fromLatitude: safeParse(json['from_latitude']),
      toProvince: json['to_province'] != null
          ? ProvinceModel.fromJson(json['to_province'])
          : null,
      toPickUpStation: json['to_pick_up_station'] != null
          ? StationModel.fromJson(json['to_pick_up_station'])
          : null,
      isTakingToFinalDestination:
          safeParse(json['is_taking_to_final_destination']),
      toAddress: safeParse(json['to_address']),
      toLongitude: safeParse(json['to_longitude']),
      toLatitude: safeParse(json['to_latitude']),
      isADayTour: safeParse(json['is_a_day_tour']),
      hourOfWaitTime: safeParse(json['hour_of_wait_time']),
      distance: safeParse(json['distance']),
      duration: safeParse<num?>(json['duration']),
      customerDepositPercentage: safeParse(json['customer_deposit_percentage']),
      numberSeat: safeParse(json['number_seat']),
      paymentMethod: safeParse(json['payment_method']),
      amountUndiscounted: safeParse(json['amount_undiscounted']),
      discountAfterTax: safeParse(json['discount_after_tax']),
      amountTotal: safeParse(json['amount_total']),
      downPayment: json['down_payment'] != null
          ? DownPayment.fromJson(json['down_payment'])
          : null,
      overtimeSurcharge: json['overtime_surcharge'] != null
          ? OvertimeSurchargeModel.fromJson(json['overtime_surcharge'])
          : null,
      tollsSurcharge: safeParse(json['tolls_surcharge']),
      tip: safeParse(json['tip']),
      amountDue: safeParse(json['amount_due']),
      state:
          safeParse(json['state'], payload: CompoundingCarCustomerState.values),
      secondRemains: safeParse(json['second_remains']),
      secondWaitingRemains: safeParse(json['second_waiting_remains']),
      confirmDate: safeParse(json['confirm_date']),
      paidDate: safeParse(json['paid_date']),
      cancelDate: safeParse(json['cancel_date']),
      depositDate: safeParse(json['deposit_date']),
      amountReturn: safeParse(json['amount_return']),
      cancelReason: json['cancel_reason'] != null
          ? CancelReasonModel.fromJson(json['cancel_reason'])
          : null,
      qualityCar: safeParse(json['quality_car']),
      numberAvailableSeat: safeParse(json['number_available_seat']),
      carDriverId: json['car_driver_id'] != null
          ? CarDriverModel.fromJson(json['car_driver_id'])
          : null,
      priceUnit: json['price_unit'] != null
          ? CarPriceModel.fromJson(json['price_unit'])
          : null,
      feeFinalDestination: (json['fee_final_destination']),
      promotion: (json['promotion'] ?? "") is String
          ? null
          : PromotionModel.fromJson(json['promotion']),
      saleOrderId: safeParse(json['sale_order_id']),
      note: safeParse(json['note']),
      rating: json['rating'] != null
          ? RatingResModel.fromJson(json['rating'])
          : null,
      ratingState: safeParse(json['rating_state'],
          payload: CompoundingCarRatingState.values),
    );
  }
}

/// percent : 0.2
/// total : 1000000.0

class DownPayment {
  DownPayment({
    num? percent,
    num? total,
    num? basis,
  }) {
    _percent = percent;
    _total = total;
    _basis = basis;
  }

  DownPayment.fromJson(dynamic json) {
    _percent = safeParse(json['percent']);
    _total = safeParse(json['total']);
    _basis = safeParse(json['basis']);
  }

  num? _percent;
  num? _total;
  num? _basis;

  DownPayment copyWith({
    num? percent,
    num? total,
    num? basis,
  }) =>
      DownPayment(
        percent: percent ?? _percent,
        total: total ?? _total,
        basis: basis ?? _basis,
      );

  num? get percent => _percent;

  num? get total => _total;

  num? get basis => _basis;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percent'] = _percent;
    map['total'] = _total;
    map['basis'] = _basis;
    return map;
  }
}
