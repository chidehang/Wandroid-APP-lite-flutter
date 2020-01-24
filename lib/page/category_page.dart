import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/model/bean/category_bean.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/page/category_content_page.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';
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

  int _curTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAllCategoryTree();
  }

  @override
  void didUpdateWidget(CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("_CategoryPageState didUpdateWidget");
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: TabBar(
            isScrollable: true,
            controller: _oneTabController,
            labelColor: AColors.tab_label_selected,
            unselectedLabelColor: AColors.tab_label_normal,
            tabs: <Widget>[
              for (final bean in data) Tab(text: bean.name,),
            ],
          ),
        ),
        // 更多分类按钮
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.margin_common),
            child: Image.asset("res/images/ic_more.png", width: 25, height: 25,),
          ),
          onTap: () {
            _showAllCategoryDialog();
          },
        ),
      ],
    );
  }

  /// 二级体系视图
  Widget _buildTwoLevelTabs(List<CategoryBean> data) {
    _twoTabController = TabController(length: data.length, vsync: this, initialIndex: _curTabIndex);
    _twoTabController.addListener(_onTwoLevelTabChanged);

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
      _updateTwoLevelTabIndex();
    }
  }

  _onTwoLevelTabChanged() {
    _curTabIndex = _twoTabController.index;
  }

  _updateTwoLevelTabIndex() {
    setState(() {
      // 切换一级tab时，重置二级tab，避免出现索引对应不上
      _curTabIndex = 0;
      _twoTabController.index = 0;
    });
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

  /// 显示所有分类的对话框
  _showAllCategoryDialog() async {
    // 自定义对话框内容view
    final content = SingleChildScrollView(
      child: Wrap(
        spacing: Dimens.spacing_item,
        children: <Widget>[
          for (int i=0; i<_categoryTree.length; i++)
            ChoiceChip(
              label: Text(_categoryTree[i].name),
              selected: _oneTabController.index == i,
              onSelected: (selected) {
                if (selected) {
                  Navigator.of(context, rootNavigator: true).pop(i);
                }
              },
            )
        ],
      ),
    );

    // 对话框组件
    final dialog = AlertDialog(
      title: Text(Strings.category_picker),
      content: content,
    );

    // 显示对话框，并等待关闭对话框时回传的结果
    int result = await showDialog(context: context, builder: (context) => dialog);

    if (result != null && result is int) {
      // 返回的结果为指定的索引
      _oneTabController.index = result;
      _updateTwoLevelTabIndex();
    }
  }

  @override
  void dispose() {
    _oneTabController?.dispose();
    _twoTabController?.dispose();
    super.dispose();
  }
}