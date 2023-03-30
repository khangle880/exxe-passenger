import 'package:dartz/dartz.dart';
import 'package:exxe/src/core/core.dart';

import '../../../utils/export/logic_export.dart';

abstract class INewsControllerRepo {
  Future<Either<Failure, List<NewsModel>>> getNewsPost({
    int? limit,
    int? offset,
    String? categoryId,
  });

  Future<Either<Failure, NewsDetailModel>> getNewsDetail(String postId);

  Future<Either<Failure, List<CategoryModel>>> getCategories();
}
