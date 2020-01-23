import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/model/bean/category_bean.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/page/category_content_page.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/widget/empty_data_tips.dart';

/// 体系tab
class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryPageState();
  }

}

class _CategoryPageState extends State<CategoryPage> with TickerProviderStateMixin {

  /// 一级体系tab控制器
  TabController _oneTabController;
  /// 二级体系tab控制器
  TabController _twoTabController;

  List<CategoryBean> _categoryTree;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllCategoryTree();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCategoryTreeView(_categoryTree);
  }

  /// 一级、二级体系tab
  Widget _buildCategoryTreeView(List<CategoryBean> data) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data == null || data.isEmpty) {
      return Center(
        child: EmptyDataTips(onTap: () {
          _loadAllCategoryTree();
        },),
      );
    }

    return Column(
      children: <Widget>[
        _buildOneLevelTabs(data),
        _buildTwoLevelTabs(data[_oneTabController.index].children),
        SizedBox(height: 5,),
        _buildTabView(data[_oneTabController.index].children)
      ],
    );
  }

  /// 一级体系视图
  Widget _buildOneLevelTabs(List<CategoryBean> data) {
    if (_oneTabController == null) {
      _oneTabController = TabController(length: data.length, vsync: this);
      _oneTabController.addListener(_onOneLevelTabChanged);
    }

    return TabBar(
      isScrollable: true,
      controller: _oneTabController,
      labelColor: AColors.tab_label_selected,
      unselectedLabelColor: AColors.tab_label_normal,
      tabs: <Widget>[
        for (final bean in data) Tab(text: bean.name,),
      ],
    );
  }

  /// 二级体系视图
  Widget _buildTwoLevelTabs(List<CategoryBean> data) {
    _twoTabController = TabController(length: data.length, vsync: this);

    return TabBar(
      isScrollable: true,
      controller: _twoTabController,
      labelColor: AColors.tab_label_selected,
      unselectedLabelColor: AColors.tab_label_normal,
      tabs: <Widget>[
        for (final bean in data) Tab(text: bean.name,),
      ],
    );
  }

  /// 分类下内容
  Widget _buildTabView(List<CategoryBean> data) {
    final view = Expanded(
      child: TabBarView(
        controller: _twoTabController,
        children: data.map(
                (bean) {
              return CategoryContentPage(bean.id);
            }
        ).toList(),
      ),
    );
    return view;
  }

  _onOneLevelTabChanged() {
    if (_oneTabController.indexIsChanging && this.mounted) {
      setState(() {
        // 切换一级tab时，重置二级tab，避免出现索引对应不上
        _twoTabController.index = 0;
      });
    }
  }

  /// 获取全部体系分类
  _loadAllCategoryTree() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      Future<List<CategoryBean>> f = Fetcher.fetchCategoryTree();
      f.then((list) {
        setState(() {
          _categoryTree = list;
        });
      }).catchError((e) {
        Fluttertoast.showToast(msg: "$e");
        debugPrint("$e");
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _oneTabController?.dispose();
    _twoTabController?.dispose();
    super.dispose();
  }
}