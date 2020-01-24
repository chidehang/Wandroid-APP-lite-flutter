import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/model/bean/banner_bean.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/page/article_details_page.dart';
import 'package:wandroid_app_flutter/page/search_page.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/selector.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';
import 'package:wandroid_app_flutter/util/page_launcher.dart';
import 'package:wandroid_app_flutter/widget/article_list_tile.dart';
import 'package:wandroid_app_flutter/widget/dot.dart';
import 'package:wandroid_app_flutter/widget/empty_data_tips.dart';
import 'package:wandroid_app_flutter/widget/load_more_tips.dart';
import 'package:wandroid_app_flutter/widget/loop_banner.dart';

/// 首页tab
class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {

  List<BannerBean> _bannerList = List();

  /// 是否初始加载
  bool _initial;

  /// 分页列表页码
  int _page = 0;
  /// 是否加载中
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  List<ArticleBean> _articleList = List();

  /// 是否显示加载更多菊花（默认有）
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _initial = true;
    _loadFreshBanners();
    _loadFreshArticles();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreArticles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 初始加载时显示菊花
    if (_initial) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 初始加载结束后显示真正布局
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(child: _buildSearchBarView()),
          SliverToBoxAdapter(child: _buildBannerView(_bannerList)),
          _buildArticleListView(_articleList),
        ],
      ),
    );
  }

  /// 顶部搜索栏
  Widget _buildSearchBarView() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Image.asset("res/images/ic_droid_thumb.png", width: 32, height: 32,),
        ),
        Expanded(
          child: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: Dimens.margin_common, right: Dimens.margin_common, bottom: Dimens.margin_common),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Row(
                  children: <Widget>[
                    Image.asset("res/images/ic_search.png", width: 16, height: 16,),
                    Padding(
                      padding: const EdgeInsets.only(left: Dimens.margin_common),
                      child: Text(Strings.home_search_hint, style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ),
      ],
    );
  }

  /// 首页banner视图
  Widget _buildBannerView(List<BannerBean> data) {
    if (data==null || data.isEmpty) {
      return Container(width: 0, height: 0,);
    }

    var images = data.map((bean) => bean.imagePath).toList();

    var selectedDot = Dot(Selector.dotIndicatorImage(state: DrawableState.SELECTED));
    var unselectedDot = Dot(Selector.dotIndicatorImage());
    var bannerSec = Padding(
      padding: EdgeInsets.only(left: Dimens.margin_common, right: Dimens.margin_common, bottom: Dimens.margin_common),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: LoopBanner(
          images,
          aspectRatio: 2,
          selectedIndicator: selectedDot,
          unselectIndicator: unselectedDot,
          onTap: (index) {
            BannerBean bean = _bannerList[index];
            PageLauncher.openArticleDetails(context, bean.title, bean.url);
          },
        ),
      ),
    );
    return bannerSec;
  }

  /// 文章列表视图
  Widget _buildArticleListView(List<ArticleBean> data) {
    if (data == null || data.isEmpty) {
      // 数据为空，返回提示组件
      return SliverToBoxAdapter(child: EmptyDataTips(onTap: () {
        if (!_isLoading) {
          _isLoading = true;
          _loadFreshBanners();
          _loadFreshArticles();
          _isLoading = false;
        }
      },));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (_hasMore && index == data.length) {
                  return LoadMoreTips();
                }

                final ArticleBean bean = data[index];
                return GestureDetector(
                  child: ArticleListTile(bean),
                  onTap: () {
                    PageLauncher.openArticleDetails(context, bean.title, bean.link);
                  },
                );
              },
          // 最后一项item作为loadmore提示组件
          childCount: _hasMore? data.length + 1 : data.length,
      ),
    );
  }

  Future _onRefresh() {
    return Future.wait([_loadFreshBanners(), _loadFreshArticles()]);
  }

  /// 刷新banner列表
  Future _loadFreshBanners() {
    Future<List<BannerBean>> f = Fetcher.fetchHomeBanners();
    f.then((list) {
      setState(() {
        _bannerList = list;
      });
    }).catchError((e) {
      debugPrint("$e");
    });
    return f;
  }

  /// 刷新文章列表
  Future _loadFreshArticles() {
    Future<List<ArticleBean>> f = Fetcher.fetchHomeArticles(0);
    f.then((list) {
      _page = 0;
      setState(() {
        _hasMore = true;
        _articleList = list;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: "$e");
      debugPrint("$e");
    }).whenComplete(() {
      if (_initial) {
        setState(() {
          _initial = false;
        });
      }
    });
    return f;
  }

  /// 上拉加载更多文章
  _loadMoreArticles() {
    if (!_isLoading) {
      _isLoading = true;

      Future<List<ArticleBean>> f = Fetcher.fetchHomeArticles(_page+1);
      f.then((list) {
        _page++;
        if (list==null || list.isEmpty) {
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
      }).whenComplete(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}