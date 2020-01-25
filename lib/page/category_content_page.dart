import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';
import 'package:wandroid_app_flutter/util/page_launcher.dart';
import 'package:wandroid_app_flutter/util/pair.dart';
import 'package:wandroid_app_flutter/widget/article_list_tile.dart';
import 'package:wandroid_app_flutter/widget/empty_data_tips.dart';
import 'package:wandroid_app_flutter/widget/load_more_tips.dart';
import 'package:wandroid_app_flutter/widget/refresh_list_view.dart';

/// 体系下文章列表
class CategoryContentPage extends StatefulWidget {

  /// 体系ID
  final int categoryId;

  CategoryContentPage(this.categoryId, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryContentPageState();
  }
}

class CategoryContentPageState extends State<CategoryContentPage> with AutomaticKeepAliveClientMixin{

  GlobalKey<RefreshListViewState> _refreshKey = GlobalKey();

  @override
  void didUpdateWidget(CategoryContentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当widget更新时，刷新列表数据
    _refreshKey.currentState.retryInitial();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var view;
    view = RefreshListView<ArticleBean>(
      key: _refreshKey,
      itemBuilder: _itemViewBuilder,
      onLoadRefresh: _onLoadFreshData,
      onLoadMore: _onLoadMoreData,
      onItemTap: _onItemTapAction,
    );
    return view;
  }

  /// item项view构建
  Widget _itemViewBuilder<T>(BuildContext context, int index, T item) {
    return ArticleListTile(item as ArticleBean);
  }

  /// 刷新数据
  Future<Pair<List<ArticleBean>, bool>> _onLoadFreshData(int page) {
    return Fetcher.fetchCategoryArticles(page, widget.categoryId);
  }

  /// 更多数据
  Future<Pair<List<ArticleBean>, bool>> _onLoadMoreData(int page) {
    return Fetcher.fetchCategoryArticles(page, widget.categoryId);
  }

  /// item点击跳转文章详情
  _onItemTapAction<T>(BuildContext context, int index, T item) {
    final bean = item as ArticleBean;
    PageLauncher.openBrowser(context, bean.link, title: bean.title);
  }

  @override
  bool get wantKeepAlive => true;
}