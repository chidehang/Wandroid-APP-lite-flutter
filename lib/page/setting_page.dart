import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';
import 'package:wandroid_app_flutter/util/page_launcher.dart';

/// 设置页面
class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }

}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.mine_setting_label),
        brightness: Brightness.light,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Image.asset("res/images/app_logo.png", width: 80, height: 80,),
            SizedBox(height: 15,),
            // 显示版本号信息
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.version, style: TextStyle(color: AColors.secondary_text_dark),);
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 50,),
            _buildDivider(),
            _buildModuleEntry("res/images/ic_about_me.png", Strings.setting_about_me, () {
              PageLauncher.openBrowser(context, "https://me.csdn.net/dehang0");
            }),
            _buildDivider(),
            _buildModuleEntry("res/images/ic_git_link.png", Strings.setting_git_link, () {
              PageLauncher.openBrowser(context, "https://github.com/chidehang/Wandroid-APP-lite-flutter");
            }),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AColors.divider))),
    );
  }

  Widget _buildModuleEntry(String img, String text, Function onTap) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Image.asset(img, width: 28, height: 28,),
              SizedBox(width: Dimens.margin_common,),
              Text(text, style: TextStyle(fontSize: 16, color: AColors.secondary_text_dark),),
              Expanded(child: Container(),),
              Image.asset("res/images/arrow_right.png", width: 15, height: 15,)
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}