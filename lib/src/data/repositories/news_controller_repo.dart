import 'package:dartz/dartz.dart';

import '../../core/core.dart';
import '../../core/new_base_response.dart';
import '../../utils/export/main_app.dart';
import '../data.dart';

class NewsControllerRepo extends INewsControllerRepo {
  late final INetworkUtility _networkUtility;

  NewsControllerRepo()
      : _networkUtility = GetIt.I.get<INetworkUtility>(
          instanceName: NetworkConstant.newsDomain,
        );

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final response = await _networkUtility.request(
        Apis.getNewsCategories,
        Method.GET,
      );

      NewsListResponse<CategoryModel> result = NewsListResponse<CategoryModel>(
          response, (data) => CategoryModel.fromJson(data));

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      return Right(result.items!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NewsDetailModel>> getNewsDetail(String postId) async {
    try {
      final response = await _networkUtility.request(
        "${Apis.getPostDetail}/$postId",
        Method.GET,
      );

      NewsSingleResponse<NewsDetailModel> result =
          NewsSingleResponse<NewsDetailModel>(
              response, (data) => NewsDetailModel.fromJson(data));

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      return Right(result.item!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NewsModel>>> getNewsPost({
    int? limit,
    int? offset,
    String? categoryId,
  }) async {
    try {
      final query = {
        "limit": limit ?? 20,
        "offset": offset ?? 0,
        "categoryId": categoryId,
      }.getCleanNull;
      final response = await _networkUtility.request(
        Apis.getPosts,
        Method.GET,
        queryParameters: query,
      );

      NewsListResponse<NewsModel> methods = NewsListResponse<NewsModel>(
          response, (data) => NewsModel.fromJson(data));

      if (methods.error != null) {
        return Left(ServerFailure(methods.error!));
      }
      return Right(methods.items!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
