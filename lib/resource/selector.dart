import 'package:flutter/material.dart';

enum DrawableState {
  NORMAL, ENABLE, PRESSED, SELECTED, CHECKED,
}

/// 获取不同状态下的图片
class Selector {
  static Image dotIndicatorImage({DrawableState state = DrawableState.NORMAL}) {
    switch(state) {
      case DrawableState.CHECKED:
      case DrawableState.SELECTED:
        return Image.asset("res/images/indicator_dot_checked.png",);
        break;

      default:
        return Image.asset("res/images/indicator_dot_normal.png",);
    }
  }
}