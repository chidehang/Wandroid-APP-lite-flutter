import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wandroid_app_flutter/page/category_page.dart';
import 'package:wandroid_app_flutter/page/home_page.dart';
import 'package:wandroid_app_flutter/page/mine_page.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';


/// 主界面
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }

}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  int _selectedIndex = 0;
  List<_Tab> _tabs;
  var pages;

  static double top = 0;

  @override
  void initState() {
    super.initState();

    final double iconSize = 25;
    if (_tabs == null) {
      _tabs = <_Tab>[
        _Tab(
          title: Strings.main_tab_home,
          icon: Image.asset("res/images/tab_home_normal.png", width: iconSize, height: iconSize,),
          activeIcon: Image.asset("res/images/tab_home_selected.png", width: iconSize, height: iconSize),
          vsync: this
        ),
        _Tab(
          title: Strings.main_tab_category,
          icon: Image.asset("res/images/tab_category_normal.png", width: iconSize, height: iconSize),
          activeIcon: Image.asset("res/images/tab_category_selected.png", width: iconSize, height: iconSize),
          vsync: this
        ),
        _Tab(
          title: Strings.main_tab_mine,
          icon: Image.asset("res/images/tab_mine_normal.png", width: iconSize, height: iconSize),
          activeIcon: Image.asset("res/images/tab_mine_selected.png", width: iconSize, height: iconSize),
          vsync: this
        )
      ];

      pages = <Widget>[
        HomePage(),
        CategoryPage(),
        MinePage(),
      ];
    }
    _tabs[_selectedIndex].animationController.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    var bottomItems = _tabs.map((tab) => tab.item).toList();

    top = MediaQueryData.fromWindow(window).padding.top;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQueryData.fromWindow(window).padding.top),
        child: SafeArea(top: true, child: Offstage()),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: bottomItems,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: textTheme.caption.fontSize,
        unselectedFontSize: textTheme.caption.fontSize - 2,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    for (_Tab tab in _tabs) {
      tab.animationController.dispose();
    }
    super.dispose();
  }
}

class _Tab {

  final BottomNavigationBarItem item;
  final Widget child;
  final AnimationController animationController;
  Animation _animation;

  _Tab({String title, Widget icon, Widget activeIcon, this.child, TickerProvider vsync})
      : item = BottomNavigationBarItem(icon: icon, title: Text(title), activeIcon: activeIcon),
        animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: vsync) {
    _animation = animationController.drive(CurveTween(
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)
    ));
  }

  FadeTransition buildTransition(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: child,
    );
  }
}