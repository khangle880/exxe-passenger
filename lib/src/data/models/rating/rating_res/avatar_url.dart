class AvatarUrl {
  AvatarUrl({
      this.imageId, 
      this.imageUrl,});

  AvatarUrl.fromJson(dynamic json) {
    imageId = json['image_id'];
    imageUrl = json['image_url'];
  }
  num? imageId;
  String? imageUrl;
AvatarUrl copyWith({  num? imageId,
  String? imageUrl,
}) => AvatarUrl(  imageId: imageId ?? this.imageId,
  imageUrl: imageUrl ?? this.imageUrl,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_id'] = imageId;
    map['image_url'] = imageUrl;
    return map;
  }

}