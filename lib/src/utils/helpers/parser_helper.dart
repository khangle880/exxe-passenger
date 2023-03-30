import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:exxe/src/utils/export/logic_export.dart';

import '../../core/base_response.dart';
import '../../core/error/error.dart';

typedef Parser<T> = T Function(dynamic json);

class ParserHelper {
  static Future<Either<Failure, T>> singleParseDefault<T>(
      Future<Response<dynamic>> request, Parser<T> parser,
      {Function(T value)? rightPreCall}) async {
    try {
      final response = await request;
      SingleResponse<T> result =
          SingleResponse<T>(response, (data) => parser(data));
      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      rightPreCall?.call(result.item as T);
      return Right(result.item as T);
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }

  static Future<Either<Failure, List<T>>> listParseDefault<T>(
      Future<Response<dynamic>> request, Parser<T> parser,
      {Function(List<T> value)? rightPreCall}) async {
    try {
      final response = await request;
      ListResponse<T> result =
          ListResponse<T>(response, (data) => parser(data));
      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      rightPreCall?.call(result.items!);
      return Right(result.items!);
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }

  static Future<Either<Failure, List<T>>> paginateParseDefault<T>(
      Future<Response<dynamic>> request, Parser<T> parser,
      {Function(List<T> value)? rightPreCall}) async {
    try {
      final response = await request;
      PagingListResponse<T> result =
          PagingListResponse<T>(response, (data) => parser(data));
      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      rightPreCall?.call(result.items);
      return Right(result.items);
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }
}
