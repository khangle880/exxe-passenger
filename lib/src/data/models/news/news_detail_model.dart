import '../../../utils/export/ui_export.dart';
import '../models.dart';
import 'author_model.dart';

class NewsDetailModel {
  NewsDetailModel({
    this.postId,
    this.title,
    this.shortContent,
    this.content,
    this.thumbnail,
    this.slug,
    this.tags,
    this.createdAt,
    this.author,
    this.category,
  });

  NewsDetailModel.fromJson(dynamic json) {
    postId = safeParse(json['postId']);
    title = safeParse(json['title']);
    shortContent = safeParse(json['shortContent']);
    content = safeParse(json['content']);
    thumbnail = safeParse(json['thumbnail']);
    slug = safeParse(json['slug']);
    tags = List.from((json['tags'] ?? []).map((e) => safeParse(e)));
    createdAt = safeParse(json['createdAt']);
    author =
    json['author'] != null ? NewsAuthorModel.fromJson(json['author']) : null;
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  String? postId;
  String? title;
  String? shortContent;
  String? content;
  String? thumbnail;
  String? slug;
  List<String>? tags;
  DateTime? createdAt;
  NewsAuthorModel? author;
  CategoryModel? category;

  NewsDetailModel copyWith({
    String? postId,
    String? title,
    String? shortContent,
    String? content,
    String? thumbnail,
    String? slug,
    List<String>? tags,
    DateTime? createdAt,
    NewsAuthorModel? author,
    CategoryModel? category,
  }) =>
      NewsDetailModel(
        postId: postId ?? this.postId,
        title: title ?? this.title,
        shortContent: shortContent ?? this.shortContent,
        content: content ?? this.content,
        thumbnail: thumbnail ?? this.thumbnail,
        slug: slug ?? this.slug,
        tags: tags ?? this.tags,
        createdAt: createdAt ?? this.createdAt,
        author: author ?? this.author,
        category: category ?? this.category,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    map['title'] = title;
    map['shortContent'] = shortContent;
    map['content'] = content;
    map['thumbnail'] = thumbnail;
    map['slug'] = slug;
    if (tags != null) {
      map['tags'] = tags;
    }
    map['createdAt'] = createdAt;
    if (author != null) {
      map['author'] = author?.toJson();
    }
    if (category != null) {
      map['category'] = category?.toJson();
    }
    return map;
  }
}
