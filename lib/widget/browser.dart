import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 浏览器组件
class Browser extends StatefulWidget {

  final String initialUrl;

  WebViewController _webViewController;

  Function(String) onReceiveTitle;

  Browser(this.initialUrl, {this.onReceiveTitle});

  @override
  State<StatefulWidget> createState() {
    return _BrowserState();
  }

  /// 处理后退事件
  handleGoBack(BuildContext context) {
    if (_webViewController == null) {
      Navigator.of(context).pop();
      return;
    }

    Future<bool> canGoBack = _webViewController.canGoBack();
    canGoBack.then((can) {
      if (can) {
        _webViewController.goBack();
      } else {
        Navigator.of(context).pop();
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: "$e");
      Navigator.of(context).pop();
    }).catchError((e) {
      Fluttertoast.showToast(msg: "$e");
    });
  }
}


class _BrowserState extends State<Browser> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: widget.initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            widget._webViewController = controller;
          },
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
            _receiveTitle();
          },
        ),
        _buildProgressView(),
      ],
    );
  }

  Widget _buildProgressView() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(strokeWidth: 2,),
      );
    } else {
      return Container();
    }
  }

  /// 获取H5标题
  _receiveTitle() async {
    String title = await widget._webViewController.getTitle();
    debugPrint("_receiveTitle: title=$title");
    if (title.isNotEmpty) {
      widget?.onReceiveTitle(title);
    }
  }
}