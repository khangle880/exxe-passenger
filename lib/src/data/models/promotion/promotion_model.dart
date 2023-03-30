import '../../../utils/export/ui_export.dart';
import 'duration_end.dart';
import 'duration_start.dart';
import 'promotion_image_url.dart';
import 'promotion_value.dart';

class PromotionModel {
  PromotionModel({
    this.createdDate,
    this.promotionId,
    this.promotionCode,
    this.promotionName,
    this.promotionBrief,
    this.promotionType,
    this.promotionValue,
    this.dateStart,
    this.dateEnd,
    this.durationStart,
    this.durationEnd,
    this.promotionImageUrl,
    this.savedPromotion,
    this.description,
    this.type,
    this.isPromotionApplied,
    this.read,
  });

  @override
  String toString() {
    return 'PromotionModel{promotionId: $promotionId, promotionCode: $promotionCode, promotionName: $promotionName, promotionBrief: $promotionBrief, promotionType: $promotionType, dateStart: $dateStart, dateEnd: $dateEnd, savedPromotion: $savedPromotion}';
  }

  PromotionModel.fromJson(dynamic json) {
    createdDate = safeParse(json['create_date']);
    promotionId = safeParse(json['promotion_id']);
    promotionCode = safeParse(json['promotion_code']);
    promotionName = safeParse(json['promotion_name']) ?? '';
    promotionBrief = safeParse(json['promotion_brief']);
    promotionType = safeParse(json['promotion_type']);
    promotionValue = json['promotion_value'] != null
        ? PromotionValue.fromJson(json['promotion_value'])
        : null;

    dateStart = safeParse(json['date_start']);
    dateEnd = safeParse(json['date_end']);

    durationStart = json['duration_start'] != null
        ? DurationStart.fromJson(json['duration_start'])
        : null;
    durationEnd = json['duration_end'] != null
        ? DurationEnd.fromJson(json['duration_end'])
        : null;
    promotionImageUrl = json['promotion_image_url'] != null
        ? PromotionImageUrl.fromJson(json['promotion_image_url'])
        : null;
    savedPromotion = safeParse(json['saved_promotion']);
    description = safeParse(json['description']);
    type =
        safeParse(json['notification_type'], payload: NotificationType.values);
    isPromotionApplied = safeParse(json['is_promotion_applied']);
    read = safeParse(json['read']);
  }
 
  DateTime? createdDate;
  num? promotionId;
  String? promotionCode;
  String? promotionName;
  String? promotionBrief;
  String? promotionType;
  PromotionValue? promotionValue;
  DateTime? dateStart;
  DateTime? dateEnd;
  DurationStart? durationStart;
  DurationEnd? durationEnd;
  PromotionImageUrl? promotionImageUrl;
  bool? savedPromotion;
  String? description;
  bool? isPromotionApplied;
  NotificationType? type;
  bool? read;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['promotion_id'] = promotionId;
    map['promotion_code'] = promotionCode;
    map['promotion_name'] = promotionName;
    map['promotion_brief'] = promotionBrief;
    map['promotion_type'] = promotionType;
    if (promotionValue != null) {
      map['promotion_value'] = promotionValue!.toJson();
    }
    map['date_start'] = dateStart;
    map['date_end'] = dateEnd;
    if (durationStart != null) {
      map['duration_start'] = durationStart!.toJson();
    }
    if (durationEnd != null) {
      map['duration_end'] = durationEnd!.toJson();
    }
    if (promotionImageUrl != null) {
      map['promotion_image_url'] = promotionImageUrl!.toJson();
    }
    map['saved_promotion'] = savedPromotion;
    return map;
  }
}
