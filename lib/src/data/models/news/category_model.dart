import '../../../utils/parser_utils.dart';

class CategoryModel {
  CategoryModel({
    this.categoryId,
    this.categoryName,
  });

  CategoryModel.fromJson(dynamic json) {
    categoryId = safeParse(json['categoryId']);
    categoryName = safeParse(json['categoryName']);
  }

  String? categoryId;
  String? categoryName;

  CategoryModel copyWith({
    String? categoryId,
    String? categoryName,
  }) =>
      CategoryModel(
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['categoryId'] = categoryId;
    map['categoryName'] = categoryName;
    return map;
  }
}
