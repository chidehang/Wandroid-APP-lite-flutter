import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/model/bean/banner_bean.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/selector.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';
import 'package:wandroid_app_flutter/widget/article_list_tile.dart';
import 'package:wandroid_app_flutter/widget/dot.dart';
import 'package:wandroid_app_flutter/widget/loop_banner.dart';

/// 首页tab
class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {

  int _page = 0;

  @override
  void initState() {
    super.initState();
    Fetcher.fetchHomeArticles(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _buildSearchBarView()),
          SliverToBoxAdapter(child: _buildBannerFuture()),
          _buildArticlesFuture(),
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
        ),
      ],
    );
  }

  /// 首页banner视图
  FutureBuilder _buildBannerFuture() {
    return FutureBuilder<List<BannerBean>>(
      future: Fetcher.fetchHomeBanners(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Fluttertoast.showToast(msg: snapshot.error.toString());
          return Container(width: 0, height: 0,);
        } else if (snapshot.hasData) {
          return _buildBannerView(snapshot.data);
        } else {
          return Container(width: 0, height: 0,);
        }
      },
    );
  }

  Widget _buildBannerView(List<BannerBean> data) {
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
        ),
      ),
    );
    return bannerSec;
  }

  /// 文章列表视图
  FutureBuilder _buildArticlesFuture() {
    return FutureBuilder<List<ArticleBean>>(
      future: Fetcher.fetchHomeArticles(_page),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Fluttertoast.showToast(msg: snapshot.error.toString());
          return SliverToBoxAdapter(child: Container(width: 0, height: 0,));
        } else if (snapshot.hasData) {
          return _buildArticleListView(snapshot.data);
        } else {
          return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(),));
        }
      },
    );
  }

  Widget _buildArticleListView(List<ArticleBean> data) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
              (context, index) {
            return ArticleListTile(data[index]);
          },
          childCount: data.length
      ),
    );
  }
}