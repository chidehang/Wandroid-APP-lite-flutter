import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/model/bean/search_key_bean.dart';
import 'package:wandroid_app_flutter/model/db/search_key_dao.dart';
import 'package:wandroid_app_flutter/network/fetcher.dart';
import 'package:wandroid_app_flutter/page/search_result_page.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';

/// 搜索文章页
class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }

}

class _SearchPageState extends State<SearchPage> {

  final _editController = TextEditingController();

  SearchKeyDao _searchKeyDao;

  List<SearchKeyBean> _hotKeys = List();

  @override
  void initState() {
    super.initState();
    _searchKeyDao = SearchKeyDao();
    _loadHotKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.home_search_hint),
        brightness: Brightness.light,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.margin_common),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 输入框和搜索按钮
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(25),),
                    padding: EdgeInsets.symmetric(horizontal: Dimens.margin_common),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Strings.search_input_hint,
                      ),
                      controller: _editController,
                    ),
                  ),
                ),
                SizedBox(width: Dimens.margin_common,),
                GestureDetector(
                  child: Image.asset("res/images/ic_search_yellow.png", width: 25, height: 25,),
                  onTap: () {
                    if (_editController.text == null || _editController.text.isEmpty) {
                      Fluttertoast.showToast(msg: Strings.search_input_hint);
                      return;
                    }
                    _search(_editController.text);
                    // 保存搜索记录
                    _searchKeyDao.insert(SearchKeyBean(name: _editController.text));
                  },
                ),
              ],
            ),
            SizedBox(height: Dimens.page_vertical_margin,),
            // 热门关键字
            Text(Strings.search_hot_key, style: TextStyle(color: AColors.tab_label_selected, fontSize: Dimens.label_font_size),),
            Wrap(
              spacing: Dimens.spacing_item,
              runSpacing: -10,
              children: <Widget>[
                for (SearchKeyBean bean in _hotKeys)
                  ActionChip(
                    label: Text(bean.name),
                    onPressed: () {
                      _search(bean.name);
                    },
                  )
              ],
            ),
            SizedBox(height: Dimens.page_vertical_margin,),
            // 历史记录
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(Strings.search_history_key, style: TextStyle(color: AColors.tab_label_selected, fontSize: Dimens.label_font_size),),
                Expanded(child: Container(),),
                ActionChip(
                  backgroundColor: Colors.white,
                  avatar: Image.asset("res/images/ic_delete.png", width: 14, height: 14,),
                  label: Text(Strings.search_clear_keys, style: TextStyle(fontSize: 13, color: AColors.secondary_text_dark),),
                  labelPadding: EdgeInsets.symmetric(horizontal: Dimens.spacing_item),
                  onPressed: () {
                    Future future = _searchKeyDao.deleteAll();
                    future.whenComplete(() {
                      setState(() {
                      });
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: Dimens.spacing_item,),
            Flexible(
              child: FutureBuilder<List<SearchKeyBean>>(
                future: _searchKeyDao.queryAll(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildHistoryListView(snapshot.data);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 历史搜索列表view
  Widget _buildHistoryListView(List<SearchKeyBean> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final bean = data[data.length - 1 - index];
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(Dimens.margin_common),
            decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AColors.divider))),
            child: Text(bean.name, style: TextStyle(fontSize: 14, color: AColors.secondary_text_dark),),
          ),
          onTap: () {
            _search(bean.name);
          },
        );
      },
    );
  }

  /// 获取搜索热词
  _loadHotKeys() {
    Future<List<SearchKeyBean>> future = Fetcher.fetchHotKeys();
    future.then((list) {
      setState(() {
        _hotKeys = list;
      });
    });
  }

  /// 进行搜索
  _search(String key) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultPage(key)));
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }
}