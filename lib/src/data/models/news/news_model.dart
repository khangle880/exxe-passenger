import '../../../utils/parser_utils.dart';
import 'author_model.dart';
import 'category_model.dart';

class NewsModel {
  NewsModel({
    this.postId,
    this.category,
    this.shortContent,
    this.slug,
    this.tags,
    this.thumbnail,
    this.title,
    this.author,
    this.createdAt,
  });

  NewsModel.fromJson(dynamic json) {
    postId = safeParse(json['postId']);
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
    shortContent = safeParse(json['shortContent']);
    slug = safeParse(json['slug']);
    tags = List.from((json['tags'] ?? []).map((e) => safeParse(e)));
    thumbnail = safeParse(json['thumbnail']);
    title = safeParse(json['title']);
    author =
        json['author'] != null ? NewsAuthorModel.fromJson(json['author']) : null;
    createdAt = safeParse(json['createdAt']);
  }

  String? postId;
  CategoryModel? category;
  String? shortContent;
  String? slug;
  List<String>? tags;
  String? thumbnail;
  String? title;
  NewsAuthorModel? author;
  DateTime? createdAt;

  NewsModel copyWith({
    String? postId,
    CategoryModel? category,
    String? shortContent,
    String? slug,
    List<String>? tags,
    String? thumbnail,
    String? title,
    NewsAuthorModel? author,
    DateTime? createdAt,
  }) =>
      NewsModel(
        postId: postId ?? this.postId,
        category: category ?? this.category,
        shortContent: shortContent ?? this.shortContent,
        slug: slug ?? this.slug,
        tags: tags ?? this.tags,
        thumbnail: thumbnail ?? this.thumbnail,
        title: title ?? this.title,
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    map['shortContent'] = shortContent;
    map['slug'] = slug;
    if (tags != null) {
      map['tags'] = tags;
    }
    map['thumbnail'] = thumbnail;
    map['title'] = title;
    if (author != null) {
      map['author'] = author?.toJson();
    }
    map['createdAt'] = createdAt;
    return map;
  }
}
