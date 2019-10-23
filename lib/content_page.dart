import 'dart:math';

import 'package:flutter/widgets.dart';

class ContentPage extends StatelessWidget {
  final Widget content;
  final bool absorbing;
  final double offsetX;
  final double rightPageWidth;

  ContentPage(
      {Key key,
      this.content,
      this.absorbing,
      this.offsetX,
      this.rightPageWidth = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double color = 0.0;
    if (rightPageWidth > 0 && offsetX < 0) {
      color = (255 * 0.2 / rightPageWidth) * offsetX.abs();
    }
    return AbsorbPointer(
      child: Transform.translate(
        offset: Offset(min(0, offsetX), 0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            content,
            IgnorePointer(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color.fromARGB(color.toInt(), 0, 0, 0),
            ))
          ],
        ),
      ),
      absorbing: absorbing ?? false,
    );
  }
}
