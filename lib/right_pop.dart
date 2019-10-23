import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RightPop extends StatelessWidget {
  final double offsetX;
  final double width;
  final Widget child;
  final Color backgroupColor;

  RightPop({Key key, this.offsetX, this.width, this.child, this.backgroupColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Transform.translate(
      offset: Offset(max(0, offsetX + screenWidth), 0),
      child: SizedBox.fromSize(
        size: Size.fromWidth(width),
        child:
            Container(color: backgroupColor ?? Color(0x00000000), child: child),
      ),
    );
  }
}

class RightPopConfig {
  final bool needRight;
  final double maxWidth;
  final double autoAnimDistance;
  final Widget container;
  final Color backgroupColor;

  RightPopConfig(
      {this.needRight = false,
      this.backgroupColor,
      this.maxWidth = 0.0,
      this.autoAnimDistance = 20.0,
      this.container});
}
