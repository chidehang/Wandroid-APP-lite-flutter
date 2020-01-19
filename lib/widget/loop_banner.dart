import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

/// 轮播banner
class LoopBanner extends StatefulWidget {

  final List<String> _images;
  final double aspectRatio;
  final GestureTapCallback onTap;
  final Curve curve;
  final Widget selectedIndicator;
  final Widget unselectIndicator;

  LoopBanner(
      this._images, {
        this.aspectRatio = 2,
        this.onTap,
        this.curve = Curves.linear,
        this.selectedIndicator,
        this.unselectIndicator,
      }
  );

  @override
  State<StatefulWidget> createState() {
    return _LoopBannerState();
  }
}

class _LoopBannerState extends State<LoopBanner> {

  PageController _pageController;
  int _curIndex;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _curIndex = widget._images.length;
    _pageController = PageController(initialPage: _curIndex);
    _initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildPageView(),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildPageView() {
    var length = widget._images.length;
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: PageView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(widget._images[index % length], fit: BoxFit.cover,),
            onPanDown: (details) {
              _cancelTimer(true);
            },
            onTap: widget.onTap,
          );
        },
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _curIndex = index;
            if (index == 0) {
              _curIndex = length;
              _changePage();
            }
          });
        },
      ),
    );
  }

  Widget _buildIndicator() {
    var length = widget._images.length;
    return Positioned(
      bottom: 10,
      child: Row(
        children: widget._images.asMap().keys.map((i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: i==_curIndex%length? widget.selectedIndicator : widget.unselectIndicator
          );
        }).toList()
      ),
    );
  }

  _changePage() {
    Timer(Duration(milliseconds: 300), () {
      _pageController.jumpToPage(_curIndex);
    });
  }

  _initTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 3), (timer) {
        _curIndex++;
        _pageController.animateToPage(_curIndex, duration: Duration(milliseconds: 300), curve: widget.curve);
      });
    }
  }

  _cancelTimer(bool needRestart) {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      if (needRestart) {
        _initTimer();
      }
    }
  }

  @override
  void dispose() {
    _cancelTimer(false);
    super.dispose();
  }
}