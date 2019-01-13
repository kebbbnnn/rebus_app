import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flip_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = new PageController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _toggle;
  TextEditingController _answerController = new TextEditingController();
  var _listAnswer = [
    "one thing after another",
    "broken heart",
    "but on second thought",
    "last but not least",
    "one in a million",
    "fooling around",
    "history repeats itself",
    "musically inclined",
    "the beginning of the end",
    "scatter brain",
    "line up in single file",
    "pacing back and forth",
    "a backwards glance",
    "a thin line between love and hate",
    "all things great and small"
  ];

  double _screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double _screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  Future<Null> _toggleOrientation() async {
    final SharedPreferences prefs = await _prefs;
    _toggle = prefs.getBool('orientation_toggle');
    _toggle = !_toggle;

    if (_toggle) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    setState(() {
      prefs.setBool("orientation_toggle", _toggle);
    });
  }

  void _showCardNumber(int cardNum) {
    Fluttertoast.showToast(
        msg: "$cardNum",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black.withOpacity(0.85),
        textColor: Colors.white);
  }

  // Creates flip card page
  Widget _createPage(int counter) {
    return new FlipCard(
      direction: FlipDirection.HORIZONTAL, // default
      front: Container(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('graphics/puzzle_$counter.jpg'),
            ],
          ),
        ),
      ),
      back: Center(
        child: Container(
          color: Colors.black87,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: _screenWidth(context),
              maxWidth: _screenWidth(context),
              minHeight: 300.0,
              maxHeight: 300.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AutoSizeText(
                  _listAnswer[counter],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
      body: new PageView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          return _createPage(index % _listAnswer.length);
        },
        onPageChanged: (page) {
          _showCardNumber(page + 1);
        },
      ),
      floatingActionButton: new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
          ),
          new FloatingActionButton(
            onPressed: () {
              _toggleOrientation();
            },
            child: new Icon(_toggleIcon()),
          ),
        ],
      ),
    );
  }

  IconData _toggleIcon() {
    debugPrint('_toggle: $_toggle');
    return _toggle != null && _toggle
        ? Icons.stay_current_portrait
        : Icons.stay_current_landscape;
  }
}
