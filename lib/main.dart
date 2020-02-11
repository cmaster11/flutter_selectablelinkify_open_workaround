import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:selectabletext_fix/fixed_selectable_linkify.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Broken selectable linkify Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

//
//
// This is all about https://github.com/flutter/flutter/issues/43494
//
//

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FixedSelectableLinkify(
                text: 'Hello!\n'
                    'We have a link here: https://google.com ! :D',
                onOpen: (link) => print('tapped $link'),
              ),
              SelectableLinkify(
                text: 'Hello!\n'
                    'We have a link here: https://google.com ! :D but you cannot open me!',
                onOpen: (link) => print('tapped $link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
