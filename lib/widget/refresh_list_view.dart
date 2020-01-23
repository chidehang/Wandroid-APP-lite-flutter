import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';
import 'package:wandroid_app_flutter/util/pair.dart';
import 'package:wandroid_app_flutter/widget/empty_data_tips.dart';
import 'package:wandroid_app_flutter/widget/load_more_tips.dart';

/// 下拉刷新+上拉加载列表
class RefreshListView<T> extends StatefulWidget {

  /// 构建index对应项的view
  final Widget Function<T>(BuildContext context, int index, T item) itemBuilder;
  /// index对应项的点击回调
  final Function<T>(BuildContext context, int index, T item) onItemTap;
  /// 刷新加载回调（bool表示是否还有更多数据）
  final Future<Pair<List<T>, bool>> Function(int page) onLoadRefresh;
  /// 更多加载回调（bool表示是否还有更多数据）
  final Future<Pair<List<T>, bool>> Function(int page) onLoadMore;

  RefreshListView({
    @required this.itemBuilder,
    @required this.onLoadRefresh,
    @required this.onLoadMore,
    this.onItemTap,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RefreshListViewState<T>();
  }

}

class RefreshListViewState<T> extends State<RefreshListView> {

  /// 当前分页页码
  int _page = 0;

  List<T> _data = List();

  ScrollController _scrollController = ScrollController();

  /// 初次加载
  bool _isInitialLoad = true;
  /// 正在加载更多
  bool _isLoadingMore = false;
  /// 有更多数据
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // 滑动到底部时触发加载更多
        _loadMoreData();
      }
    });
    _loadFreshData();
  }

  @override
  Widget build(BuildContext context) {
    var view;
    if (_isInitialLoad) {
      // 初次加载时显示菊花
      view = Center(
        child: CircularProgressIndicator(),
      );
    } else if (_data != null && _data.isNotEmpty) {
      // 加载完成后有数据
      view = RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (_hasMore && index == _data.length) {
              // 最后一项view为加载更多菊花
              return LoadMoreTips();
            }

            final T item = _data[index];
            return GestureDetector(
              child: widget.itemBuilder(context, index, item),
              onTap: () {
                widget.onItemTap(context, index, item);
              },
            );
          },
          itemCount: _hasMore? _data.length + 1 : _data.length,
        ),
      );
    } else {
      // 加载完成后无数据
      view = Center(
        child: EmptyDataTips(onTap: retryInitial,),
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
    Future<Pair<List<T>, bool>> future = widget.onLoadRefresh(0);
    future.then((pair) {
      _page = 0;
      safeSetState(() {
        _hasMore = !pair.second;
        _data = pair.first;
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

    return future;
  }

  /// 更多数据
  _loadMoreData() {
    if (!_isLoadingMore) {
      _isLoadingMore = true;

      Future<Pair<List<T>, bool>> future = widget.onLoadMore(_page+1);
      future.then((pair) {
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
            _data.addAll(list);
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
  retryInitial() {
    safeSetState(() {
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

  List<T> getData() {
    return _data;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}