import 'dart:developer';

import 'package:dio/dio.dart';

abstract class INetworkUtility {
  Future<Response> request(String url,
      Method method, {
        dynamic data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      });
}

class NetworkUtility implements INetworkUtility {
  late Dio _dio;

  final String baseUrl;
  final List<Interceptor>? interceptors;
  final ResponseType responseType;

  NetworkUtility(this.baseUrl, {
    this.interceptors,
    this.responseType = ResponseType.plain,
    int connectTimeout = 30000,
    int receiveTimeout = 30000,
    int sendTimeout = 30000,
  }) {
    BaseOptions options = BaseOptions(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      responseType: responseType,
      headers: {},
      validateStatus: (_) {
        return true;
      },
      baseUrl: baseUrl,
    );
    _dio = Dio(options);

    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors ?? []);
    }
  }

  @override
  Future<Response> request(String url,
      Method method, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        Options? options,
      }) async {
    options ??= Options(headers: {});
    options.method = method.value;

    log(url);
    // ignore: prefer_typing_uninitialized_variables
    var response;
    try {
      response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      // ignore: avoid_print
      print("$url: ${e.toString()}");
    }
    return response;
  }
}

enum ErrorCode {
  // ignore: constant_identifier_names
  TIME_OUT,
  // ignore: constant_identifier_names
  UNKNOWN,
}

enum Method {
  // ignore: constant_identifier_names
  POST,
  // ignore: constant_identifier_names
  PUT,
  // ignore: constant_identifier_names
  PATCH,
  // ignore: constant_identifier_names
  DELETE,
  // ignore: constant_identifier_names
  GET,
}

extension MethodExtensions on Method {
  String get value => ['POST', 'PUT', 'PATCH', 'DELETE', 'GET'][index];
}

extension ErrorCodeExtensions on ErrorCode {
  String get value => ['time_out', 'unknown'][index];
}
