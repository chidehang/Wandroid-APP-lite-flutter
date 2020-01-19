import 'package:wandroid_app_flutter/resource/strings.dart';

class ApiException implements Exception {

  final int code;
  final String msg;

  ApiException({this.code, this.msg});

  @override
  String toString() {
    return msg ?? Strings.net_request_error;
  }
}