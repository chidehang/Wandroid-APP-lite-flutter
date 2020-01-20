import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';

/// 传递参数
class ArticleArguments {
  final String title;
  final String url;

  ArticleArguments(this.title, this.url);
}

/// 文章详情
class ArticleDetailsPage extends StatefulWidget {

  final ArticleArguments arguments;

  ArticleDetailsPage(this.arguments);

  @override
  State<StatefulWidget> createState() {
    return _ArticleDetailsPageState();
  }
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments.title, maxLines: 1,)
      ),
      body: Container(),
    );
  }

}