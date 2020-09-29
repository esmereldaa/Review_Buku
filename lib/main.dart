import 'package:flutter/material.dart';
import 'home.dart';
import 'loginpage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home : new MyHomePage(),
      routes: <String, WidgetBuilder> {
        '/homepage' : (BuildContext context) => Home() 
      });
      }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: new Center(
        child: LoginPage(),
      ),
    );
  }
}

