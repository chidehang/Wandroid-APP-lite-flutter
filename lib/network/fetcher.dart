import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/model/bean/banner_bean.dart';
import 'package:wandroid_app_flutter/network/api_exception.dart';
import 'package:wandroid_app_flutter/network/http_manager.dart';
import 'dart:convert';
import 'dart:async';

class Fetcher<T> {

  /// 获取首页banner数据
  static Future<List<BannerBean>> fetchHomeBanners() async {
    final api = "banner/json";
    Response<String> resp = await HttpManager.getInstance().client.get(api);
    return compute(parseBanners, resp.data);
  }

  static List<BannerBean> parseBanners(String source) {
    final result = json.decode(source);
    checkResult(result);
    final parsed = result["data"].cast<Map<String, dynamic>>();
    return parsed.map<BannerBean>((json) => BannerBean.fromJson(json)).toList();
  }

  static Future<List<ArticleBean>> fetchHomeArticles(int page) async {
    final api = "article/list/$page/json";
    Response<String> resp = await HttpManager.getInstance().client.get(api);
    return compute(parseArticles, resp.data);
  }

  static List<ArticleBean> parseArticles(String source) {
    final result = json.decode(source);
    checkResult(result);
    final parsed = result["data"]["datas"].cast<Map<String, dynamic>>();
    return parsed.map<ArticleBean>((json) => ArticleBean.fromJson(json)).toList();
  }

  /// 检查接口返回数据是否错误
  static void checkResult(Map<String, dynamic> result) {
    if (result["errorCode"] != 0) {
      throw ApiException(code: result["errorCode"], msg: result["errorMsg"]);
    }
  }
}