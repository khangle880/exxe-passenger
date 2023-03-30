import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:developer' show log;

import '../../core/chat_base_response.dart';
import '../../core/error/error.dart';
import 'parser_helper.dart';

class ChatParserHelper {
  static Future<Either<Failure, T>> singleParseDefault<T>(
      Future<Response<dynamic>> request, Parser<T> parser,
      {Function(T value)? rightPreCall}) async {
    try {
      final response = await request;
      ChatSingleResponse<T> result =
          ChatSingleResponse<T>(response, (data) => parser(data));
      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      rightPreCall?.call(result.item as T);
      return Right(result.item as T);
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }

  static Future<Either<Failure, List<T>>> listParseDefault<T>(
      Future<Response<dynamic>> request, Parser<T> parser,
      {Function(List<T> value)? rightPreCall}) async {
    try {
      final response = await request;
      ChatListResponse<T> result =
          ChatListResponse<T>(response, (data) => parser(data));
      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      rightPreCall?.call(result.items!);
      return Right(result.items!);
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }

  static Future<Either<Failure, ChatPagingResponse<T>>> pagingParseDefault<T>(
      Future<Response<dynamic>> request, Parser<T> parser,
      {Function(List<T> value)? rightPreCall}) async {
    try {
      final response = await request;
      ChatPagingResponse<T> result =
          ChatPagingResponse<T>(response, (data) => parser(data));
      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      rightPreCall?.call(result.items);
      return Right(result);
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }
}
