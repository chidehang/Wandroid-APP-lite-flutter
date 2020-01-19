import 'package:dio/dio.dart';

class HttpManager {

  static const BASE_URL = "https://www.wanandroid.com/";

  static HttpManager _instance;

  factory HttpManager.getInstance() => _getInstance();

  Dio _client;

  HttpManager._internal() {
    _client = Dio();
    _client.options.baseUrl = BASE_URL;
    _client.options.connectTimeout = 5000;
    _client.options.receiveTimeout = 3000;
    (_client.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    _client.interceptors.add(LogInterceptor(responseBody: true));
  }

  static HttpManager _getInstance() {
    if (_instance == null) {
      _instance = HttpManager._internal();
    }
    return _instance;
  }

  Dio get client => _client;

  String parseJson(String origin) {
    return origin;
  }
}