import 'package:flutter/material.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';

class LoadMoreTips extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2,),
            width: 16,
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimens.margin_common),
            child: Text(Strings.loading, style: TextStyle(fontSize: 11, color: AColors.secondary_text_dark),),
          ),
        ],
      ),
    );
  }

}