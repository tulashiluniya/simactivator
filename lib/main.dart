import 'package:flutter/material.dart';
import 'package:simactivator/LandingPage.dart';

//Start Point of App
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //returns Material Design for app
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0XFF6a1b9a),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("NTC, Ncell & Other Services"),
          actions: <Widget>[],
        ),
        //body of app
        body: LandingPage());
  }
}
