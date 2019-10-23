import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_poplayer/content_page.dart';
import 'package:flutter_poplayer/pop_layer_controller.dart';
import 'package:flutter_poplayer/right_pop.dart';
import 'dart:core';

import 'package:flutter_poplayer/top_pop.dart';

class Poplayer extends StatefulWidget {
  final TopPopConfig topPopConfig;
  final RightPopConfig rightPopConfig;

  final Widget content;
  final Color backgroundColor;
  final double height;
  final PoplayerController controller;

  Poplayer(
      {Key key,
      this.content,
      this.height,
      this.topPopConfig,
      this.rightPopConfig,
      this.controller,
      this.backgroundColor = const Color(0xFFFFFFFF)})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PoplayerState();
  }
}

class _PoplayerState extends State<Poplayer> with TickerProviderStateMixin {
  AnimationController _animationControllerX;
  AnimationController _animationControllerY;
  Animation<double> _animationX;
  Animation<double> _animationY;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  bool _inContent = true;
  bool _absorbing = false;
  AxisDirection topDirection = AxisDirection.up;
  AxisDirection horizontalDirection = AxisDirection.right;
  PoplayerController _controller;
  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller?.addListener(_handEvent);
  }

  @override
  void dispose() {
    _controller.removeListener(_handEvent);
    _controller.dispose();
    super.dispose();
  }

  void _handEvent() {
    switch (_controller.event) {
      case PoplayerController.AUTO_TO_TOP:
        {
          if (widget?.topPopConfig?.needTop == true) {
            animateToTop();
          }
          break;
        }
      case PoplayerController.AUTO_TO_BOTTOM:
        {
          if (widget?.topPopConfig?.needTop == true) {
            animateToBottom();
          }
          break;
        }
      case PoplayerController.AUTO_TO_LEFT:
        {
          if (widget?.rightPopConfig?.needRight == true) {
            animateToRight(widget?.rightPopConfig?.maxWidth ??
                MediaQuery.of(context).size.width);
          }
          break;
        }
      case PoplayerController.AUTO_TO_RIGHT:
        {
          if (widget?.rightPopConfig?.needRight == true) {
            animateToMiddle();
          }
          break;
        }
        break;
      case PoplayerController.TO_Y:
        {
          if (widget?.topPopConfig?.needTop == true) {
            animateToY(_controller.scrollDelta);
          }
          break;
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    _height = widget?.height ?? MediaQuery.of(context).size.height;
    return SizedBox.fromSize(
      size: Size.fromHeight(_height),
      child: GestureDetector(
        onVerticalDragUpdate: _inContent
            ? (details) {
                calculateOffsetY(
                    details,
                    ((widget?.topPopConfig?.topMaxHeight ?? 0) <= 0
                            ? _height
                            : (widget?.topPopConfig?.topMaxHeight ?? 0)) -
                        (widget?.topPopConfig?.topMinHeight ?? 0));
              }
            : null,
        onVerticalDragEnd: (_) {
          if (_offsetY.abs() >
                  (widget?.topPopConfig?.topAutoAnimDistance ?? 20) &&
              topDirection == AxisDirection.up) {
            animateToTop();
          } else {
            animateToBottom();
          }
        },
        onVerticalDragCancel: () {
          debugPrint("onVerticalDragCancel");
        },
        onVerticalDragStart: (_) {
          _animationControllerX?.stop();
          _animationControllerY?.stop();
        },
        onVerticalDragDown: (_) {
          debugPrint("onVerticalDragDown");
        },
        onHorizontalDragStart: (_) {
          _animationControllerX?.stop();
          _animationControllerY?.stop();
        },
        onHorizontalDragUpdate: (details) {
          if (widget?.rightPopConfig?.needRight != true) {
            return;
          }
          if (_offsetX + details.delta.dx >= screenWidth) {
            setState(() {
              _offsetX = screenWidth;
              horizontalDirection = details.delta.dx > 0
                  ? AxisDirection.right
                  : AxisDirection.left;
            });
          } else if (_offsetX + details.delta.dx <=
              -(widget?.rightPopConfig?.maxWidth ?? screenWidth)) {
            setState(() {
              _offsetX = -(widget?.rightPopConfig?.maxWidth ?? screenWidth);
              horizontalDirection = details.delta.dx > 0
                  ? AxisDirection.right
                  : AxisDirection.left;
            });
          } else {
            setState(() {
              _offsetX += details.delta.dx;
              horizontalDirection = details.delta.dx > 0
                  ? AxisDirection.right
                  : AxisDirection.left;
            });
          }
          debugPrint('onHorizontalDragUpdate _offsetX = $_offsetX');
        },
        onHorizontalDragEnd: (details) {
          debugPrint(
              'onHorizontalDragEnd horizontalDirection = $horizontalDirection');

          if (horizontalDirection == AxisDirection.left) {
            if ((_offsetX?.abs() ?? 0.0) <
                widget?.rightPopConfig?.autoAnimDistance) {
              animateToMiddle();
            } else {
              animateToRight(widget?.rightPopConfig?.maxWidth ?? screenWidth);
            }
          } else {
            if ((_offsetX?.abs() ?? 0.0) >
                widget?.rightPopConfig?.autoAnimDistance) {
              animateToMiddle();
            } else {
              animateToRight(widget?.rightPopConfig?.maxWidth ?? screenWidth);
            }
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: widget?.backgroundColor,
              child: buildContent(),
            ),
            buildTop(),
            buildRight(),
          ],
        ),
      ),
    );
  }

  void calculateOffsetY(DragUpdateDetails details, double height) {
    if (widget?.topPopConfig?.needTop != true ||
        widget?.topPopConfig?.needDarker == true) {
      return;
    }
    if (_offsetY + details.delta.dy >= height) {
      setState(() {
        _offsetY = height;
      });
    } else if (_offsetY + details.delta.dy <= -height) {
      setState(() {
        _offsetY = -height;
      });
    } else {
      setState(() {
        _offsetY += details.delta.dy;
        topDirection =
            details.delta.dy < 0 ? AxisDirection.up : AxisDirection.down;
      });
    }
  }

  void animateToMiddle() {
    _animationControllerX =
        AnimationController(duration: Duration(milliseconds: 50), vsync: this);
    final curve = CurvedAnimation(
        parent: _animationControllerX, curve: Curves.easeOutCubic);
    _animationX = Tween(begin: _offsetX, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          _offsetX = _animationX.value;
        });
      });
    _inContent = true;
    _animationControllerX.forward();
  }

  void animateToLeft(double screenWidth) {
    _animationControllerX =
        AnimationController(duration: Duration(milliseconds: 50), vsync: this);
    final curve = CurvedAnimation(
        parent: _animationControllerX, curve: Curves.easeOutCubic);
    _animationX = Tween(begin: _offsetX, end: screenWidth).animate(curve)
      ..addListener(() {
        setState(() {
          _offsetX = _animationX.value;
          debugPrint('animateToLeft _offsetX = $_offsetX');
        });
      });
    _inContent = false;
    _animationControllerX.forward();
  }

  void animateToRight(double screenWidth) {
    _animationControllerX =
        AnimationController(duration: Duration(milliseconds: 50), vsync: this);
    final curve = CurvedAnimation(
        parent: _animationControllerX, curve: Curves.easeOutCubic);
    _animationX = Tween(begin: _offsetX, end: -screenWidth).animate(curve)
      ..addListener(() {
        setState(() {
          _offsetX = _animationX.value;
          debugPrint('animateToRight _offsetX = $_offsetX');
        });
      });
    _inContent = false;
    _animationControllerX.forward();
  }

  void animateToTop() {
    final screenHeight = MediaQuery.of(context).size.height;
    final double maxHeight = (widget.topPopConfig.topMaxHeight <= 0
            ? screenHeight
            : widget.topPopConfig.topMaxHeight) -
        widget.topPopConfig.topMinHeight;
    _animationControllerY =
        AnimationController(duration: Duration(milliseconds: 50), vsync: this);
    final curve = CurvedAnimation(
        parent: _animationControllerY, curve: Curves.easeOutCubic);
    _animationY = Tween(begin: _offsetY, end: -maxHeight).animate(curve)
      ..addListener(() {
        setState(() {
          _offsetY = _animationY.value;
        });
      });
    _animationControllerY.forward();
    _animationControllerY.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if ((widget?.topPopConfig?.needTop == true) &&
            widget?.topPopConfig?.toTopCallback != null) {
          widget?.topPopConfig?.toTopCallback();
        }
        setState(() {
          widget?.topPopConfig?.status = Status.Top;
        });
      }
    });
  }

  void animateToBottom() {
    final double minHeight = 0;
    _animationControllerY =
        AnimationController(duration: Duration(milliseconds: 50), vsync: this);
    final curve = CurvedAnimation(
        parent: _animationControllerY, curve: Curves.easeInCirc);
    _animationY = Tween(begin: _offsetY, end: -minHeight).animate(curve)
      ..addListener(() {
        setState(() {
          _offsetY = _animationY.value;
        });
      });
    _animationControllerY.forward();
    _animationControllerY.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if ((widget?.topPopConfig?.needTop == true) &&
            widget?.topPopConfig?.toBottomCallback != null) {
          widget?.topPopConfig?.toBottomCallback();
        }
        setState(() {
          widget?.topPopConfig?.status = Status.Bottom;
        });
      }
    });
  }

  void animateToY(double scrollDelta) {
    setState(() {
      _offsetY -= scrollDelta * 1.5;
    });
  }

  Widget buildTop() {
    return (widget?.topPopConfig?.needTop == true)
        ? TopPop(
            offsetY: _offsetY,
            height: widget?.topPopConfig?.topMaxHeight,
            minHeight: widget?.topPopConfig?.topMinHeight,
            parentHeight: _height,
            child: widget?.topPopConfig?.container,
            backgroupColor: widget?.topPopConfig?.backgroupColor,
            onDarkerTap: widget?.topPopConfig?.onDarkerTap,
            needDarker: (widget?.topPopConfig?.needDarker == true),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }

  Widget buildRight() {
    return (widget?.rightPopConfig?.needRight == true)
        ? RightPop(
            offsetX: _offsetX,
            width: widget?.rightPopConfig?.maxWidth ?? 0,
            child: widget?.rightPopConfig?.container,
            backgroupColor: widget.rightPopConfig.backgroupColor,
          )
        : Container(
            width: 0,
            height: 0,
          );
  }

  Widget buildContent() {
    return widget.content != null
        ? ContentPage(
            content: widget.content,
            offsetX: (widget?.rightPopConfig?.needRight == true) ? _offsetX : 0,
            absorbing: _absorbing,
            rightPageWidth: widget?.rightPopConfig?.maxWidth ?? 0,
          )
        : Container(
            width: 0,
            height: 0,
          );
  }
}
