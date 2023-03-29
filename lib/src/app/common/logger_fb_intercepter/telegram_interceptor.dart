import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

String prettyJsonStr(Map<dynamic, dynamic> json) {
  final encoder = JsonEncoder.withIndent('  ', (data) => data.toString());
  return encoder.convert(json);
}

class LoggerFbInterceptor extends Interceptor {
  final String token;
  final int chatId;
  final String? projectId;
  final bool willSendSuccess;

  LoggerFbInterceptor({
    required this.token,
    required this.chatId,
    this.projectId,
    this.willSendSuccess = false,
  }) {
    _projectName = projectId != null ? projectId! : '';
    _projectName = '${_projectName!} ${const Uuid().v4()}';
  }

  String? _projectName;

  void sendPhotoByText(String text, bool success) {
    final now = DateTime.now();
    final key = "${now.hour} ${now.day} ${now.month}";

    final url =
        'https://exxe-47e9d-default-rtdb.asia-southeast1.firebasedatabase.app/logger_passenger $key.json';
    http.post(Uri.parse(url), body: text);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (willSendSuccess) {
      dynamic responseData;
      try {
        responseData = jsonDecode(response.data);
      } catch (e) {
        responseData = response.data;
      }
      final json = prettyJsonStr({
        'projectName': _projectName,
        'from': 'onResponse',
        'Time': DateTime.now().toString(),
        'baseUrl': response.requestOptions.baseUrl,
        'path': response.requestOptions.path,
        'method': response.requestOptions.method,
        'header': response.requestOptions.headers,
        'extra': response.extra,
        'queryParameters': response.requestOptions.queryParameters,
        'requestData': response.requestOptions.data,
        'responseData': responseData,
      });

      sendPhotoByText(json, responseData?['result']?['success'] == true);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final json = prettyJsonStr({
      'projectName': _projectName,
      'from': 'onError',
      'Time': DateTime.now().toString(),
      'baseUrl': err.requestOptions.baseUrl,
      'header': err.requestOptions.headers,
      'path': err.requestOptions.path,
      'type': err.type,
      'message': err.message,
      'statusCode': err.response?.statusCode,
      'error': err.error,
      'requestOptionsData': err.requestOptions.data,
      'responseData': err.response?.data,
      'raw': err.toString()
    });

    sendPhotoByText(json, err.response?.data?['result']?['success'] == true);

    super.onError(err, handler);
  }
}
