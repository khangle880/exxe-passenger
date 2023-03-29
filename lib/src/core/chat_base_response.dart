// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import '../utils/json_utils.dart';

abstract class ChatBaseResponse {
  late int statusCode;
  late Map data;
  late dynamic map;
  String? error;

  bool get success => statusCode == 200 || statusCode == 201;

  ChatBaseResponse(Response response) {
    data = JsonUtils.getMap(response.data);
    statusCode = data['success'] != null
        ? data['success']
            ? 200
            : data['status_code'] ?? 400
        : response.statusCode ?? 0;
    if (success) {
      map = data['data'];
    }
  }
}

typedef ResponseParser<T> = T Function(dynamic data);

class ChatSingleResponse<T> extends ChatBaseResponse {
  T? item;

  ChatSingleResponse(Response response, ResponseParser parse)
      : super(response) {
    if (success) {
      item = parse(map);
    } else {
      error = data['message'] ?? "Đã xảy ra lỗi hệ thống";
    }
  }
}

class ChatListResponse<T> extends ChatBaseResponse {
  List<T>? items;

  ChatListResponse(Response response, ResponseParser parser) : super(response) {
    if (success) {
      final list = JsonUtils.getMapList(map);
      if (list.isEmpty) {
        items = [];
      } else {
        items = List<T>.from(list.map((x) => parser(x)));
      }
    } else {
      error = data['message'] ?? "Đã xảy ra lỗi hệ thống";
      items = [];
    }
  }
}

class ChatPagingResponse<T> extends ChatBaseResponse {
  late List<T> items;
  late ChatPagination pagination;

  ChatPagingResponse(Response response, ResponseParser parser)
      : super(response) {
    if (success) {
      final list = JsonUtils.getMapList(map['data']);

      pagination = ChatPagination.fromJson(map);

      items = List<T>.from(list.map((x) => parser(x)));
    } else {
      error = data['message'] ?? "Đã xảy ra lỗi hệ thống";
      items = [];
    }
  }
}

class ChatPagination {
  final bool hasMore;
  final int limit;
  final int total;
  final int offset;

  ChatPagination({
    required this.hasMore,
    required this.limit,
    required this.total,
    required this.offset,
  });

  bool get canLoadMore => hasMore;

  factory ChatPagination.fromJson(Map<dynamic, dynamic> json) => ChatPagination(
        hasMore: json['has_more'] ?? false,
        limit: int.tryParse(json['limit'].toString()) ?? 0,
        offset: int.tryParse(json['offset'].toString()) ?? 0,
        total: int.tryParse(json['total'].toString()) ?? 0,
      );
}
