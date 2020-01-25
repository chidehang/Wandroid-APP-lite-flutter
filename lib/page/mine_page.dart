import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wandroid_app_flutter/page/setting_page.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';

/// 我的tab
class MinePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }

}

class _MinePageState extends State<MinePage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 200,
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(
              image: AssetImage("res/images/header_mine_background.jpg"),
              fit: BoxFit.cover
            ),),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset("res/images/avatar_user.png", width: 65, height: 65,),
                ),
                Text(Strings.mine_user_name, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 30, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildItemView(
                Image.asset("res/images/ic_favorite.png", width: 40, height: 40,),
                Strings.mine_favorite_label,
                () {
                  Fluttertoast.showToast(msg: Strings.coming_soon);
                },
              ),
              _buildItemView(
                Image.asset("res/images/ic_setting.png", width: 40, height: 40, scale: 1.8,),
                Strings.mine_setting_label,
                    () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingPage()));
                },
              ),
              Container(),
              Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemView(Widget image, String label, Function onTap) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          image,
          SizedBox(height: 6,),
          Text(label, style: TextStyle(fontSize: 14, color: AColors.primary_text_dark),)
        ],
      ),
      onTap: onTap,
    );
  }
}