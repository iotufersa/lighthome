import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:more4iot_dart_api/more4iot_dart_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LightHome',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Light Bulb'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final actionClient =
      ActionRestClient(Dio(), baseUrl: 'http://192.168.0.5:3666');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Icon(
                Icons.light,
                size: 300,
              ),
              onPressed: () async => {
                actionClient.getActions().then((value) =>
                    value.forEach((element) => print(element.toJson())))
              },
            ),
          ],
        ),
      ),
    );
  }
}
