import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 浏览器组件
class Browser extends StatefulWidget {

  final String initialUrl;
  WebViewController _webViewController;

  Browser(this.initialUrl);

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
}