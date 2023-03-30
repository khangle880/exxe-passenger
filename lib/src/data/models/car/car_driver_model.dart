import '../../../utils/export/ui_export.dart';
import '../models.dart';

class CarInformation {
  num? carInformationId;
  CarBrandModel? carBrand;
  String? carName;
  StandardModel? standardId;
  List? extraUtility;
  ImageModel? carFrontImage;
  ImageModel? carBackImage;
  List? carImage;
  String? state;

  Map<String, dynamic> toJson() {
    return {
      'carInformationId': carInformationId,
      'carBrand': carBrand,
      'carName': carName,
      'standardId': standardId,
      'extraUtility': extraUtility,
      'carFrontImage': carFrontImage,
      'carBackImage': carBackImage,
      'carImage': carImage,
      'state': state,
    };
  }

  factory CarInformation.fromJson(Map<String, dynamic> json) {
    return CarInformation(
      carInformationId: json['car_information_id'] as num?,
      carBrand: json['car_brand'] != null
          ? CarBrandModel.fromJson(json['car_brand'])
          : null,
      carName: json['car_name'] as String?,
      standardId: json['standard_id'] != null
          ? StandardModel.fromJson(json['standard_id'])
          : null,
      extraUtility: json['extra_utility'] as List?,
      carFrontImage: json['car_front_image'] != null
          ? ImageModel.fromJson(json['car_front_image'])
          : null,
      carBackImage: json['car_back_image'] != null
          ? ImageModel.fromJson(json['car_front_image'])
          : null,
      carImage: json['car_image'] as List?,
      state: json['state'] as String?,
    );
  }

  CarInformation({
    this.carInformationId,
    this.carBrand,
    this.carName,
    this.standardId,
    this.extraUtility,
    this.carFrontImage,
    this.carBackImage,
    this.carImage,
    this.state,
  });
}

class StandardModel {
  StandardModel({
    num? standardId,
    String? standardName,
    List? requiredExtraUtility,
  }) {
    _standardId = standardId;
    _standardName = standardName;
    _requiredExtraUtility = requiredExtraUtility;
  }

  num? _standardId;
  String? _standardName;
  List? _requiredExtraUtility;

  StandardModel.fromJson(dynamic json) {
    _standardId = safeParse(json['standard_id']);
    _standardName = safeParse(json['standard_name']);
    _requiredExtraUtility = safeParse(json['required_extra_utility']);
  }

  num? get standardId => _standardId;

  String? get standardName => _standardName;

  List? get requiredExtraUtility => _requiredExtraUtility;
}

/// partner_id : false
/// partner_name : false
/// phone : false
/// avatar_url : {"image_id":false,"image_url":false}
/// car_information : []
/// rating_number : 0.0

class CarDriverModel {
  CarDriverModel({
    this.partnerId,
    this.partnerName,
    this.phone,
    this.avatarUrl,
    this.carType,
    this.carInformation,
    this.ratingNumber,
    this.ratingCount,
    this.rating1StarCount,
    this.rating2StarCount,
    this.rating3StarCount,
    this.rating4StarCount,
    this.rating5StarCount,
    this.traccarDeviceId,
  });

  CarDriverModel.fromJson(dynamic json) {
    partnerId = safeParse(json['partner_id']);
    partnerName = safeParse(json['partner_name']);
    phone = safeParse(json['phone']);
    avatarUrl = json['avatar_url'] != null
        ? AvatarUrlModel.fromJson(json['avatar_url'])
        : null;
    carType = json['car_type'] != null ? json['car_type'].cast<String>() : [];
    if (json['car_information'] != null) {
      carInformation = [];
      json['car_information'].forEach((v) {
        carInformation?.add(CarInformation.fromJson(v));
      });
    }
    ratingNumber = safeParse(json['rating_number']);
    ratingCount = safeParse(json['rating_count']);
    rating1StarCount = safeParse(json['rating_1_star_count']);
    rating2StarCount = safeParse(json['rating_2_star_count']);
    rating3StarCount = safeParse(json['rating_3_star_count']);
    rating4StarCount = safeParse(json['rating_4_star_count']);
    rating5StarCount = safeParse(json['rating_5_star_count']);
    traccarDeviceId = safeParse(json['traccar_device_id']);
  }

  num? partnerId;
  String? partnerName;
  String? phone;
  AvatarUrlModel? avatarUrl;
  List<String>? carType;
  List<CarInformation>? carInformation;
  num? ratingNumber;
  num? ratingCount;
  num? rating1StarCount;
  num? rating2StarCount;
  num? rating3StarCount;
  num? rating4StarCount;
  num? rating5StarCount;
  String? traccarDeviceId;

  CarDriverModel copyWith({
    num? partnerId,
    String? partnerName,
    String? phone,
    AvatarUrlModel? avatarUrl,
    List<String>? carType,
    List<CarInformation>? carInformation,
    num? ratingNumber,
    num? ratingCount,
    num? rating1StarCount,
    num? rating2StarCount,
    num? rating3StarCount,
    num? rating4StarCount,
    num? rating5StarCount,
    String? traccarDeviceId,
  }) =>
      CarDriverModel(
        partnerId: partnerId ?? this.partnerId,
        partnerName: partnerName ?? this.partnerName,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        carType: carType ?? this.carType,
        carInformation: carInformation ?? this.carInformation,
        ratingNumber: ratingNumber ?? this.ratingNumber,
        ratingCount: ratingCount ?? this.ratingCount,
        rating1StarCount: rating1StarCount ?? this.rating1StarCount,
        rating2StarCount: rating2StarCount ?? this.rating2StarCount,
        rating3StarCount: rating3StarCount ?? this.rating3StarCount,
        rating4StarCount: rating4StarCount ?? this.rating4StarCount,
        rating5StarCount: rating5StarCount ?? this.rating5StarCount,
        traccarDeviceId: traccarDeviceId ?? this.traccarDeviceId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['partner_id'] = partnerId;
    map['partner_name'] = partnerName;
    map['phone'] = phone;
    if (avatarUrl != null) {
      map['avatar_url'] = avatarUrl?.toJson();
    }
    map['car_type'] = carType;
    if (carInformation != null) {
      map['car_information'] = carInformation?.map((v) => v.toJson()).toList();
    }
    map['rating_number'] = ratingNumber;
    map['rating_count'] = ratingCount;
    map['rating_1_star_count'] = rating1StarCount;
    map['rating_2_star_count'] = rating2StarCount;
    map['rating_3_star_count'] = rating3StarCount;
    map['rating_4_star_count'] = rating4StarCount;
    map['rating_5_star_count'] = rating5StarCount;
    map['traccar_device_id'] = traccarDeviceId;
    return map;
  }
}

class RatingModel {
  RatingModel({
    num? compoundingCarId,
    String? compoundingCarCustomerName,
    num? compoundingCarCustomerId,
    PartnerModel? partner,
    DurationRating? duration,
    num? ratingId,
    List<RatingHashtagModel>? ratingHashtagModel,
    num? ratingNumber,
    String? ratingContent,
    String? ratingReported,
    bool? ratingEditable,
    String? editableReport,
  }) {
    _compoundingCarId = compoundingCarId;
    _compoundingCarCustomerName = compoundingCarCustomerName;
    _compoundingCarCustomerId = compoundingCarCustomerId;
    _partner = partner;
    _duration = duration;
    _ratingId = ratingId;
    _ratingHashtagModel = ratingHashtagModel;
    _ratingNumber = ratingNumber;
    _ratingContent = ratingContent;
    _ratingReported = ratingReported;
    _ratingEditable = ratingEditable;
    _editableReport = editableReport;
  }

  num? _compoundingCarId;
  String? _compoundingCarCustomerName;
  num? _compoundingCarCustomerId;
  PartnerModel? _partner;
  DurationRating? _duration;
  num? _ratingId;
  List<RatingHashtagModel>? _ratingHashtagModel;
  num? _ratingNumber;
  String? _ratingContent;
  String? _ratingReported;
  bool? _ratingEditable;
  String? _editableReport;

  RatingModel.fromJson(dynamic json) {
    _compoundingCarCustomerId = safeParse(json['compounding_car_customer_id']);
    _compoundingCarId = safeParse(json['compounding_car_id']);
    _compoundingCarCustomerName =
        safeParse(json['compounding_car_customer_name']);
    _partner = json['partner_id'] != null
        ? PartnerModel.fromJson(json['partner_id'])
        : null;
    _duration = json['duration'] != null
        ? DurationRating.fromJson(json['duration'])
        : null;
    _ratingId = safeParse(json['rating_id']);
    if (json['rating_tag_ids'] != null) {
      _ratingHashtagModel = [];
      json['rating_tag_ids'].forEach((v) {
        _ratingHashtagModel?.add(RatingHashtagModel.fromJson(v));
      });
    } else {
      _ratingHashtagModel = null;
    }
    _ratingNumber = safeParse(json['rating_number']);
    _ratingContent = safeParse(json['rating_content']);
    _ratingReported = safeParse(json['rating_reported']);
    _ratingEditable = safeParse(json['rating_editable']);
    _editableReport = safeParse(json['editable_report']);
  }

  num? get compoundingCarId => _compoundingCarId;

  String? get compoundingCarCustomerName => _compoundingCarCustomerName;

  num? get compoundingCarCustomerId => _compoundingCarCustomerId;

  PartnerModel? get partner => _partner;

  DurationRating? get duration => _duration;

  num? get ratingId => _ratingId;

  List<RatingHashtagModel>? get ratingHashtagModel => _ratingHashtagModel;

  num? get ratingNumber => _ratingNumber;

  String? get ratingContent => _ratingContent;

  String? get ratingReported => _ratingReported;

  bool? get ratingEditable => _ratingEditable;

  String? get editableReport => _editableReport;
}

class DurationRating {
  DurationRating({
    num? timeValue,
    String? timeType,
  }) {
    _timeValue = timeValue;
    _timeType = timeType;
  }

  num? _timeValue;
  String? _timeType;

  DurationRating.fromJson(dynamic json) {
    _timeValue = safeParse(json['time_value']);
    _timeType = safeParse(json['time_type']);
  }

  num? get timeValue => _timeValue;

  String? get timeType => _timeType;
}
