# flutter_poplayer

Left slide and slide up drawer effect. Compatible with Android & iOS.

### Installation

Add 

```bash

flutter_swiper : ^lastest_version

```
to your pubspec.yaml ,and run 

```bash
flutter packages get 
```
in your project's root directory.

### Basic Usage

Create a new project with command

```
flutter create myapp
```

Edit lib/main.dart like this:

```

import 'package:flutter/material.dart';

import 'package:flutter_poplayer/flutter_poplayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_poplayer demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RightPopConfig _rightPopConfig;
  TopPopConfig _topPopConfig;
  final PoplayerController _controller = PoplayerController();
  @override
  void initState() {
    super.initState();
    _rightPopConfig = RightPopConfig(
        needRight: true,
        maxWidth: 240,
        backgroupColor: Colors.yellow,
        autoAnimDistance: 20,
        container: GestureDetector(
          child: Center(child: Text('点我收起')),
          onTap: () {
            _controller.autoToRight();
          },
        ));

    _topPopConfig = TopPopConfig(
        backgroupColor: Colors.red,
        needTop: true,
        topMaxHeight: 740,
        topAutoAnimDistance: 20,
        topMinHeight: 150,
        container: GestureDetector(
          child: Center(child: Text('点我收起')),
          onTap: () {
            _controller.autoToBottom();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Poplayer(
        rightPopConfig: _rightPopConfig,
        topPopConfig: _topPopConfig,
        controller: _controller,
        content: Container(
          child: Center(
            child: Text('content'),
          ),
        ),
      ),
    );
  }
}

```

