import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/widget/browser.dart';

/// 传递参数
class WebArguments {
  final String title;
  final String url;

  WebArguments(this.url, {this.title = "..."});
}

/// 文章详情
class BrowserPage extends StatefulWidget {

  final WebArguments arguments;

  BrowserPage(this.arguments);

  @override
  State<StatefulWidget> createState() {
    return _BrowserPageState();
  }
}

class _BrowserPageState extends State<BrowserPage> {

  String _title = "";

  @override
  void initState() {
    super.initState();
    _title = widget.arguments.title;
  }

  @override
  Widget build(BuildContext context) {
    Browser browser = Browser(widget.arguments.url, onReceiveTitle: (title) {
      setState(() {
        _title = title;
      });
    },);
    return WillPopScope(
      onWillPop: () {
        return browser.handleGoBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title, maxLines: 1,),
          brightness: Brightness.light,
        ),
        body: browser,
      ),
    );
  }
}