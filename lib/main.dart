import 'package:flutter/material.dart';
import 'package:gmap/screens/first_page.dart';
import 'package:gmap/screens/register_page.dart';
import './screens/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}
