
import '../../../utils/export/ui_export.dart';

class PromotionImageUrl {
  PromotionImageUrl({
      this.imageId, 
      this.imageUrl,});

  PromotionImageUrl.fromJson(dynamic json) {
    imageId = safeParse(json['image_id']);
    imageUrl = safeParse(json['image_url']);
  }
  int? imageId;
  String? imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_id'] = imageId;
    map['image_url'] = imageUrl;
    return map;
  }

}