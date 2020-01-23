import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';
import 'package:wandroid_app_flutter/util/pair.dart';
import 'package:wandroid_app_flutter/widget/article_list_tile.dart';
import 'package:wandroid_app_flutter/widget/empty_data_tips.dart';
import 'package:wandroid_app_flutter/widget/load_more_tips.dart';

/// 体系下文章列表
class CategoryContentPage extends StatefulWidget {

  /// 体系ID
  int categoryId;

  CategoryContentPage(this.categoryId, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryContentPageState();
  }
}

class CategoryContentPageState extends State<CategoryContentPage> with AutomaticKeepAliveClientMixin{

  int _page = 0;
  List<ArticleBean> _articleList = List();

  ScrollController _scrollController = ScrollController();

  /// 初次加载
  bool _isInitialLoad;
  /// 正在加载更多
  bool _isLoadingMore;
  /// 有更多数据
  bool _hasMore;

  @override
  void initState() {
    super.initState();
    _isInitialLoad = true;
    _isLoadingMore = false;
    _hasMore = true;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    _loadFreshData();
  }

  @override
  void didUpdateWidget(CategoryContentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _retryInitial();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var view;
    if (_isInitialLoad) {
      // 初次加载时显示菊花
      view = Center(
        child: CircularProgressIndicator(),
      );
    } else if (_articleList != null && _articleList.isNotEmpty) {
      // 加载完成后有数据
      view = RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (_hasMore && index == _articleList.length) {
                  return LoadMoreTips();
                }

                return ArticleListTile(_articleList[index]);
              },
              itemCount: _hasMore? _articleList.length + 1 : _articleList.length,
            ),
          );
    } else {
      // 加载完成后无数据
      view = Center(
            child: EmptyDataTips(onTap: _retryInitial,),
          );
    }

    return view;
  }

  /// 下拉刷新回调
  Future _onRefresh() {
    return _loadFreshData();
  }

  /// 刷新数据
  Future _loadFreshData() {
    Future<Pair<List<ArticleBean>, bool>> f = Fetcher.fetchCategoryArticles(0, widget.categoryId);
    f.then((pair) {
      _page = 0;
      safeSetState(() {
        _hasMore = !pair.second;
        _articleList = pair.first;
      });
    }).catchError((e) {
      _hasMore = false;
      Fluttertoast.showToast(msg: "$e");
      debugPrint("$e");
    }).whenComplete(() {
      if (_isInitialLoad) {
        safeSetState(() {
          _isInitialLoad = false;
        });
      }
    });

    return f;
  }

  /// 更多数据
  _loadMoreData() {
    if (!_isLoadingMore) {
      _isLoadingMore = true;

      Future<Pair<List<ArticleBean>, bool>> f = Fetcher.fetchCategoryArticles(_page+1, widget.categoryId);
      f.then((pair) {
        _page++;
        var list = pair.first;
        if (list == null || list.isEmpty) {
          safeSetState(() {
            _hasMore = false;
          });
          Fluttertoast.showToast(msg: Strings.net_request_no_more_data);
        } else {
          safeSetState(() {
            _hasMore = true;
            _articleList.addAll(list);
          });
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: "$e");
        debugPrint("$e");
      }).whenComplete(() {
        _isLoadingMore = false;
      });
    }
  }

  /// 重试加载数据
  _retryInitial() {
    setState(() {
      _isInitialLoad = true;
    });
    _loadFreshData();
  }

  safeSetState(Function action) {
    if (this.mounted) {
      setState(() {
        action();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}