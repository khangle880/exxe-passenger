// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import '../utils/json_utils.dart';

abstract class NewsBaseResponse {
  late int statusCode;
  late Map data;
  String? error;

  bool get success => statusCode == 200 || statusCode == 201;

  NewsBaseResponse(Response response) {
    data = JsonUtils.getMap(response.data);
    statusCode = data['success'] != null
        ? data['success']
            ? 200
            : 400
        : response.statusCode ?? 0;
  }
}

typedef ResponseParser<T> = T Function(dynamic data);

class NewsSingleResponse<T> extends NewsBaseResponse {
  T? item;

  NewsSingleResponse(Response response, ResponseParser parse)
      : super(response) {
    if (success) {
      item = parse(data['data']);
    } else {
      error = response.data["message"] ?? response.data;
    }
  }
}

class NewsListResponse<T> extends NewsBaseResponse {
  List<T>? items;

  NewsListResponse(Response response, ResponseParser parser) : super(response) {
    if (success) {
      final list = JsonUtils.getMapList(data['data']);
      if (list.isEmpty) {
        items = [];
      } else {
        items = List<T>.from(list.map((x) => parser(x)));
      }
    } else {
      error = response.data["message"] ?? response.data;
      items = [];
    }
  }
}
