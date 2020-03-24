import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:simactivator/SimActivation.dart';
//Start Point of App
void main()=> runApp(MyApp()); 

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //returns Material Design for app
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
     
     theme: ThemeData(
       primaryColor:  Color(0XFF6a1b9a), 

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
          title: Text("Sim Activator App"),

        ),
        //body of app 
        body:  SimActivation()

      );
  }
}