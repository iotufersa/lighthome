import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:more4iot_dart_api/more4iot_dart_api.dart' as more4iot;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '../.env');
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
  bool _lightState = false;
  Color _color = Colors.grey;

  final actionClient = more4iot.ActionRestClient(Dio(),
      baseUrl:
          'http://${dotenv.env['MORE4IOT_HOST']}:${dotenv.env['MORE4IOT_SERVICE_CATALOGER_PORT']}');

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
                color: _color,
              ),
              onPressed: () async {
                _lightState = !_lightState;
                await actionClient
                    .inscribe(more4iot.Action(
                        creator: 'string',
                        origin: [],
                        scope: <String, dynamic>{
                          'commands': <String, dynamic>{'light': _lightState}
                        },
                        status: true,
                        receiver: more4iot.Receiver(
                            identifiers: ['string'],
                            protocol: 'coap',
                            uri: '192.168.0.187:5683/light'),
                        lifetime: more4iot.Lifetime(validity: true, count: 0)))
                    .then((value) => setState(() =>
                        {_color = _lightState ? Colors.yellow : Colors.grey}));
              },
            ),
          ],
        ),
      ),
    );
  }
}
