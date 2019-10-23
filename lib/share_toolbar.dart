import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShareToolbar extends StatelessWidget {
  final String aid;
  final ShareItemTapCallback callback;
  ShareToolbar({this.aid, this.callback, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 58, right: 58),
      color: Color(0xffffffff),
      alignment: Alignment.center,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ShareItem(
                iconPath: 'images/wachat.png',
                aid: aid,
                name: ShareItem.WECHAT_TIME,
                callback: callback),
            ShareItem(
                aid: aid,
                iconPath: 'images/wechat_f.png',
                name: ShareItem.WECHAT_FRIENDS,
                callback: callback),
            ShareItem(
                aid: aid,
                iconPath: 'images/qq.png',
                name: ShareItem.QQ_FRIENDS,
                callback: callback)
          ],
        ),
      ),
    );
  }
}

typedef ShareItemTapCallback = void Function(String aid, String target);

class ShareItem extends StatelessWidget {
  static const String WECHAT_FRIENDS = '微信好友';
  static const String QQ_FRIENDS = 'QQ好友';
  static const String WECHAT_TIME = '朋友圈';
  final String iconPath;
  final String name;
  final String aid;
  final ShareItemTapCallback callback;
  ShareItem({this.iconPath, this.name, this.aid, this.callback});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback(aid, getTarget(name));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            iconPath,
            package: 'window',
            width: 24,
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
          )
        ],
      ),
    );
  }

  String getTarget(String name) {
    if (name == WECHAT_FRIENDS) {
      return 'ShareWechatFriendsReceiver';
    } else if (name == WECHAT_TIME) {
      return 'ShareWechatTimelineReceiver';
    } else if (name == QQ_FRIENDS) {
      return 'ShareQQReceiver';
    }
    return name;
  }
}
