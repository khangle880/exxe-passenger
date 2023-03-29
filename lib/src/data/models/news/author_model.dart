import '../../../utils/parser_utils.dart';

class NewsAuthorModel {
  NewsAuthorModel({
    this.authorId,
    this.authorName,
  });

  NewsAuthorModel.fromJson(dynamic json) {
    authorId = safeParse(json['authorId']);
    authorName = safeParse(json['authorName']);
  }

  String? authorId;
  String? authorName;

  NewsAuthorModel copyWith({
    String? authorId,
    String? authorName,
  }) =>
      NewsAuthorModel(
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['authorId'] = authorId;
    map['authorName'] = authorName;
    return map;
  }
}
