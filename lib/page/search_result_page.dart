import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/util/page_launcher.dart';
import 'package:wandroid_app_flutter/util/pair.dart';
import 'package:wandroid_app_flutter/widget/article_list_tile.dart';
import 'package:wandroid_app_flutter/widget/refresh_list_view.dart';

class SearchResultPage extends StatefulWidget {

  final String searchKey;

  SearchResultPage(this.searchKey);

  @override
  State<StatefulWidget> createState() {
    return _SearchResultPageState();
  }

}

class _SearchResultPageState extends State<SearchResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchKey),
      ),
      body: RefreshListView<ArticleBean>(
        itemBuilder: _itemViewBuilder,
        onLoadRefresh: _onLoadFreshData,
        onLoadMore: _onLoadMoreData,
        onItemTap: _onItemTapAction,
      ),
    );
  }

  /// item项view构建
  Widget _itemViewBuilder<T>(BuildContext context, int index, T item) {
    return ArticleListTile(item as ArticleBean);
  }

  /// 刷新数据
  Future<Pair<List<ArticleBean>, bool>> _onLoadFreshData(int page) {
    return Fetcher.fetchSearchArticles(page, widget.searchKey);
  }

  /// 更多数据
  Future<Pair<List<ArticleBean>, bool>> _onLoadMoreData(int page) {
    return Fetcher.fetchSearchArticles(page, widget.searchKey);
  }

  /// item点击跳转文章详情
  _onItemTapAction<T>(BuildContext context, int index, T item) {
    final bean = item as ArticleBean;
    PageLauncher.openArticleDetails(context, bean.title, bean.link);
  }
}