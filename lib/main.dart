import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page/Home.dart';
import 'route/Routes.dart';

import 'provider/AppProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        // initialRoute: '/timeline',
        theme: ThemeData(
          primaryColor:Colors.deepOrange,
        ),
        home: HomePage(),
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
