import 'package:flutter/material.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';

class EmptyDataTips extends StatelessWidget {

  Function onTap;

  EmptyDataTips({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("res/images/ic_empty_data.png", width: 45, height: 45,),
            Padding(
              padding: EdgeInsets.only(top: Dimens.margin_common),
              child: Text(Strings.net_request_no_more_data, style: TextStyle(fontSize: 14, color: AColors.secondary_text_dark),),
            )
          ],
        ),
      ),
    );
  }
}