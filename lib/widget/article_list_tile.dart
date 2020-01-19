import 'package:flutter/material.dart';
import 'package:wandroid_app_flutter/model/bean/article_bean.dart';
import 'package:wandroid_app_flutter/resource/a_colors.dart';
import 'package:wandroid_app_flutter/resource/dimens.dart';
import 'package:wandroid_app_flutter/resource/strings.dart';

class ArticleListTile extends StatelessWidget {

  final ArticleBean bean;

  ArticleListTile(this.bean);

  @override
  Widget build(BuildContext context) {
    final primaryTextStyle = TextStyle(color: AColors.primary_text_dark, fontSize: 14, fontWeight: FontWeight.bold);
    final secondaryTextStyle = TextStyle(color: AColors.secondary_text_dark, fontSize: 11);

    var author = "";
    if (bean.author==null || bean.author.isEmpty) {
      author = Strings.article_share_label + "${bean.shareUser}  ";
    } else {
      author = Strings.article_author_label + "${bean.author}  ";
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(Dimens.margin_common),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(bean.title, style: primaryTextStyle, maxLines: 2,),
              Row(
                children: <Widget>[
                  Text(author, style: secondaryTextStyle,),
                  _buildSecondaryText(Strings.article_classify_label + "${bean.superChapterName}/${bean.chapterName}  "),
                  _buildSecondaryText(Strings.article_date_label + "${bean.niceShareDate}")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryText(String text) {
    final secondaryTextStyle = TextStyle(color: AColors.secondary_text_dark, fontSize: 11);
    return Flexible(
      child: Text(text, style: secondaryTextStyle, maxLines: 1,),
    );
  }
}