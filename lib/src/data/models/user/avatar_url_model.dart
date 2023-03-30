import '../../../utils/utils.dart';

/// image_id : 231
/// image_url : "/manage_detail_data/static/src/img/stored-attachment-module-ceSiVSqnc1AnW1eqvzsSKtwoMK8gttH9-1660278564-ouFKmADFWhLUpS7z7QSWdRPXWRRClYIn-1660278564.png"

class AvatarUrlModel {
  AvatarUrlModel({
    num? imageId,
    String? imageUrl,
  }) {
    _imageId = imageId;
    _imageUrl = imageUrl;
  }

  AvatarUrlModel.fromJson(dynamic json) {
    _imageId = safeParse(json['image_id']);
    _imageUrl = safeParse(json['image_url']);
  }

  num? _imageId;
  String? _imageUrl;

  AvatarUrlModel copyWith({
    num? imageId,
    String? imageUrl,
  }) =>
      AvatarUrlModel(
        imageId: imageId ?? _imageId,
        imageUrl: imageUrl ?? _imageUrl,
      );

  num? get imageId => _imageId;

  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_id'] = _imageId;
    map['image_url'] = _imageUrl;
    return map;
  }
}
