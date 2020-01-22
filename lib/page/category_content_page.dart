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
  final int categoryId;

  CategoryContentPage(this.categoryId);

  @override
  State<StatefulWidget> createState() {
    return _CategoryContentPageState();
  }
}

class _CategoryContentPageState extends State<CategoryContentPage> {

  int _page = 0;
  List<ArticleBean> _articleList = List();

  ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    _loadFreshData();
  }

  @override
  Widget build(BuildContext context) {
    var view = _articleList != null && _articleList.isNotEmpty
        ? RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (_hasMore && index == _articleList.length) {
                  return LoadMoreTips();
                }

                return ArticleListTile(_articleList[index]);
              },
              itemCount: _hasMore? _articleList.length + 1 : _articleList.length,
            ),
          )
        : Center(
            child: EmptyDataTips(),
          );

    return view;
  }

  Future _onRefresh() {
    return _loadFreshData();
  }

  /// 刷新数据
  Future _loadFreshData() {
    Future<Pair<List<ArticleBean>, bool>> f = Fetcher.fetchCategoryArticles(0, widget.categoryId);
    f.then((pair) {
      _page = 0;
      _hasMore = pair.second;
      setState(() {
        _articleList = pair.first;
      });
    }).catchError((e) {
      _hasMore = false;
      Fluttertoast.showToast(msg: "$e");
      debugPrint("$e");
    });

    return f;
  }

  /// 更多数据
  _loadMoreData() {
    if (!_isLoading) {
      _isLoading = true;

      Future<Pair<List<ArticleBean>, bool>> f = Fetcher.fetchCategoryArticles(_page+1, widget.categoryId);
      f.then((pair) {
        _page++;
        var list = pair.first;
        if (list == null || list.isEmpty) {
          setState(() {
            _hasMore = false;
          });
          Fluttertoast.showToast(msg: Strings.net_request_no_more_data);
        } else {
          setState(() {
            _hasMore = true;
            _articleList.addAll(list);
          });
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: "$e");
        debugPrint("$e");
      }).whenComplete(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}