import 'package:flutter/material.dart';

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
    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: Text("mine"),
      ),
    );
  }

}