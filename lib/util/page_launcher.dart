import 'package:flutter/material.dart';
import 'package:wandroid_app_flutter/page/article_details_page.dart';

class PageLauncher {
  /// 打开文章详情
  static Future<T> openArticleDetails<T>(BuildContext context, String title, String url) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          var args = ArticleArguments(title, url);
          return ArticleDetailsPage(args);
        })
    );
    return result;
  }
}