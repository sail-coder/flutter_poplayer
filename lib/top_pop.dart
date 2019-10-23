import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopPop extends StatelessWidget {
  final double offsetY;
  final double height;
  final double minHeight;
  final double parentHeight;
  final Widget child;
  final Color backgroupColor;
  final bool needDarker;
  final GestureTapCallback onDarkerTap;

  TopPop(
      {Key key,
      this.offsetY = 0.0,
      this.height = 0.0,
      this.minHeight = 0.0,
      this.parentHeight = 0.0,
      this.child,
      this.backgroupColor,
      this.needDarker = false,
      this.onDarkerTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double tempOffsetY = 0.0;
    if (offsetY >= 0.0) {
      tempOffsetY = max(0.0, (parentHeight - minHeight));
    } else {
      tempOffsetY = offsetY + max(0.0, (parentHeight - minHeight));
    }
    double opacity = offsetY.abs() / height;
    debugPrint(
        '++++++++offsetY = ${offsetY.toString()}+++++++++opacity = ${opacity.toString()}+++++parentHeight= ${parentHeight.toString()}++ height=${height.toString()}++++++++++minHeight=${minHeight.toString()}+++++++++++++++++++');
    return Stack(
      children: <Widget>[
        needDarker && opacity > 0
            ? GestureDetector(
                onTap: onDarkerTap,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: parentHeight,
                    color: Color(0x4C000000),
                  ),
                ),
              )
            : Container(),
        Transform.translate(
            offset: Offset(0, tempOffsetY),
            child: Container(
              color: backgroupColor ?? Color(0x00000000),
              width: MediaQuery.of(context).size.width,
              height: height,
              child: child,
            ))
      ],
    );
  }
}

enum Status {
  Top, // 0
  Bottom, // 1
  Right, // 2
  Middle, // 3
}

class TopPopConfig {
  bool needTop;
  Status status;
  final bool needDarker;
  final double topMaxHeight;
  final double topMinHeight;
  final double topAutoAnimDistance;
  final Widget container;
  final Color backgroupColor;
  final VoidCallback toBottomCallback;
  final VoidCallback toTopCallback;
  final GestureTapCallback onDarkerTap;

  TopPopConfig(
      {this.needTop = false,
      this.needDarker = false,
      this.status = Status.Bottom,
      this.backgroupColor,
      this.topMaxHeight = 0.0,
      this.topMinHeight = 0.0,
      this.topAutoAnimDistance = 20.0,
      this.toBottomCallback,
      this.toTopCallback,
      this.onDarkerTap,
      this.container});
}
