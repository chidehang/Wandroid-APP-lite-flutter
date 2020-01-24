import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/model/bean/banner_bean.dart';
import 'package:wandroid_app_flutter/model/bean/category_bean.dart';
import 'package:wandroid_app_flutter/model/bean/search_key_bean.dart';
import 'package:wandroid_app_flutter/network/api_exception.dart';
import 'package:wandroid_app_flutter/network/http_manager.dart';
import 'dart:convert';
import 'dart:async';

import 'package:wandroid_app_flutter/util/pair.dart';


class Fetcher<T> {

  /// 首页banner数据
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

  /// 首页文章列表
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

  /// 全部体系分类
  static Future<List<CategoryBean>> fetchCategoryTree() async {
    final api = "tree/json";
    Response<String> resp = await HttpManager.getInstance().client.get(api);
    return compute(parseCategoryTree, resp.data);
  }

  static List<CategoryBean> parseCategoryTree(String source) {
    final result = json.decode(source);
    checkResult(result);
    final parsed = result["data"].cast<Map<String, dynamic>>();
    return parsed.map<CategoryBean>((json) => CategoryBean.fromJson(json)).toList();
  }

  /// 体系下文章列表
  static Future<Pair<List<ArticleBean>, bool>> fetchCategoryArticles(int page, int cid) async {
    final api = "article/list/$page/json";
    Response<String> resp = await HttpManager.getInstance().client.get(api, queryParameters: {"cid": cid});
    return compute(parseCategoryArticles, resp.data);
  }

  static Pair<List<ArticleBean>, bool> parseCategoryArticles(String source) {
    final result = json.decode(source);
    checkResult(result);
    final parsed = result["data"]["datas"].cast<Map<String, dynamic>>();
    Pair<List<ArticleBean>, bool> pair = Pair(parsed.map<ArticleBean>((json) => ArticleBean.fromJson(json)).toList(), result["data"]["over"]);
    return pair;
  }

  /// 搜索热词
  static Future<List<SearchKeyBean>> fetchHotKeys() async {
    final api = "hotkey/json";
    Response<String> resp = await HttpManager.getInstance().client.get(api);
    return compute(parseHotKeys, resp.data);
  }

  static List<SearchKeyBean> parseHotKeys(String source) {
    final result = json.decode(source);
    checkResult(result);
    final parsed = result["data"].cast<Map<String, dynamic>>();
    return parsed.map<SearchKeyBean>((json) => SearchKeyBean.fromJson(json)).toList();
  }

  /// 搜索文章列表
  static Future<Pair<List<ArticleBean>, bool>> fetchSearchArticles(int page, String key) async {
    final api = "article/query/$page/json";
    Response<String> resp = await HttpManager.getInstance().client.post(api, queryParameters: {"k": key});
    return compute(parseSearchArticles, resp.data);
  }

  static Pair<List<ArticleBean>, bool> parseSearchArticles(String source) {
    final result = json.decode(source);
    checkResult(result);
    final parsed = result["data"]["datas"].cast<Map<String, dynamic>>();
    Pair<List<ArticleBean>, bool> pair = Pair(parsed.map<ArticleBean>((json) => ArticleBean.fromJson(json)).toList(), result["data"]["over"]);
    return pair;
  }

  /// 检查接口返回数据是否错误
  static void checkResult(Map<String, dynamic> result) {
    if (result["errorCode"] != 0) {
      throw ApiException(code: result["errorCode"], msg: result["errorMsg"]);
    }
  }
}