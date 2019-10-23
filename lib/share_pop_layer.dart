import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_poplayer/pop_layer.dart';
import 'package:flutter_poplayer/pop_layer_controller.dart';
import 'package:flutter_poplayer/share_toolbar.dart';
import 'package:flutter_poplayer/top_pop.dart';

class SharePoplayer extends StatelessWidget {
  final String id;
  final VoidCallback toBottomCallback;
  final VoidCallback toTopCallback;
  final GestureTapCallback onDarkerTap;
  final PoplayerController controller;
  final Widget content;
  final ShareItemTapCallback shareItemTapCallback;
  final double height;
  const SharePoplayer(
      {Key key,
      this.id,
      this.toBottomCallback,
      this.toTopCallback,
      this.onDarkerTap,
      this.controller,
      this.content,
      this.shareItemTapCallback,
      this.height = 0.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TopPopConfig topPopConfig = createPopConfig();
    return Poplayer(
      topPopConfig: topPopConfig,
      controller: controller,
      height: height,
      content: content,
    );
  }

  createPopConfig() {
    return TopPopConfig(
        needTop: true,
        needDarker: true,
        topMaxHeight: 120,
        topAutoAnimDistance: 1,
        toTopCallback: toTopCallback,
        toBottomCallback: toBottomCallback,
        onDarkerTap: onDarkerTap,
        topMinHeight: 0,
        container: ShareToolbar(
          callback: shareItemTapCallback,
          aid: id,
        ));
  }
}
