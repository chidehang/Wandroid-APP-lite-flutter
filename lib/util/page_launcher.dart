import 'package:flutter/material.dart';
import 'package:wandroid_app_flutter/page/browser_page.dart';

class PageLauncher {
  /// 打开内部浏览器
  static Future<T> openBrowser<T>(BuildContext context, String url, {String title = "..."}) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          var args = WebArguments(url, title: title);
          return BrowserPage(args);
        })
    );
    return result;
  }
}