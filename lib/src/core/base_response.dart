// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import '../utils/json_utils.dart';

abstract class BaseResponse {
  late int statusCode;
  late Map map;
  String? error;

  bool get success => statusCode == 200 || statusCode == 201;

  BaseResponse(Response response) {
    final serverError = JsonUtils.getMap(response.data)['error'];
    map = JsonUtils.getMap(response.data)['result'] ?? {};
    if (serverError != null) {
      error = serverError["data"]["message"] ?? serverError["message"];
    } else if (map['success'] == false) {
      error = map['message'];
    }

    statusCode = error != null ? 500 : map['code'] ?? response.statusCode ?? 0;
  }
}

typedef ResponseParser<T> = T Function(dynamic data);

class StatusResponse<T> extends BaseResponse {
  StatusResponse(Response response) : super(response) {
    if (success) {
    } else {
      error = map['message'] ?? "Đã xảy ra lỗi hệ thống";
    }
  }
}

class SingleResponse<T> extends BaseResponse {
  T? item;

  SingleResponse(Response response, ResponseParser parse) : super(response) {
    if (success && error == null) {
      item = parse(map['data']);
    } else {
      error = error ?? "Đã xảy ra lỗi hệ thống";
    }
  }
}

class ListResponse<T> extends BaseResponse {
  List<T>? items;

  ListResponse(Response response, ResponseParser parser) : super(response) {
    if (success && error == null) {
      final list = JsonUtils.getMapList(map['data']);
      if (list.isEmpty) {
        items = [];
      } else {
        items = List<T>.from(list.map((x) => parser(x)));
      }
    } else {
      error = error ?? "Đã xảy ra lỗi hệ thống";
      items = [];
    }
  }
}

class PagingListResponse<T> extends BaseResponse {
  late List<T> items;
  late Pagination pagination;

  PagingListResponse(Response response, ResponseParser parser)
      : super(response) {
    if (success) {
      final data = JsonUtils.getMap(map['data']);
      final list = JsonUtils.getMapList(data['result']);

      if (data['paginate'] != null) {
        pagination = Pagination.fromJson(data['paginate']);
      }

      items = List<T>.from(list.map((x) => parser(x)));
    } else {
      error = error ?? "Đã xảy ra lỗi hệ thống";
      items = [];
    }
  }
}

class Pagination {
  final int offset;
  final int limit;
  final int total;

  Pagination({
    required this.offset,
    required this.limit,
    required this.total,
  });

  bool get canLoadMore => offset + limit < total;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        offset: int.tryParse(json['offset'].toString()) ?? 0,
        limit: int.tryParse(json['limit'].toString()) ?? 0,
        total: int.tryParse(json['total'].toString()) ?? 0,
      );
}
