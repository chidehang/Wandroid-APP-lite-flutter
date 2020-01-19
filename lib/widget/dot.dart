import 'package:flutter/material.dart';

/// 小圆点
class Dot extends StatelessWidget {

  final Widget child;

  Dot(this.child);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 10,
        height: 10,
        child: child,
      ),
    );
  }

}