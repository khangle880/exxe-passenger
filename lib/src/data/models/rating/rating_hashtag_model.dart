class RatingHashtagModel {
  RatingHashtagModel({
    this.tagId,
    this.tagContent,
  });

  RatingHashtagModel.fromJson(dynamic json) {
    tagId = json['tag_id'];
    tagContent = json['tag_content'];
  }

  int? tagId;
  String? tagContent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tag_id'] = tagId;
    map['tag_content'] = tagContent;
    return map;
  }
}
